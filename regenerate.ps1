param(
    [string]$RepoPath  = (Split-Path $PSScriptRoot -Parent),
    [string]$GitUser   = "MyakuDev",
    [string]$RepoName  = "Vigil",
    [string]$CommitMsg = "update",
    [switch]$SkipPush
)
$ErrorActionPreference = "Stop"
if ($PSScriptRoot -notmatch 'regenerate$') { $RepoPath = $PSScriptRoot }
$vigil = Join-Path $RepoPath "vigil"
if (-not (Test-Path $vigil)) { Write-Error "missing vigil/"; exit 1 }
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Write-Host ""
Write-Host "Regenerating manifest..."
$files = Get-ChildItem -Path $vigil -Recurse -File -Filter *.lua
$manifestPath = Join-Path $vigil "manifest.json"
$version = 1
if (Test-Path $manifestPath) {
    try {
        $raw = [System.IO.File]::ReadAllText($manifestPath, $utf8NoBom)
        $prev = $raw | ConvertFrom-Json
        if ($prev.version) { $version = [int]$prev.version + 1 }
    } catch { }
}
$entries = [ordered]@{}
foreach ($f in $files) {
    $rel = $f.FullName.Substring($vigil.Length + 1) -replace '\\','/'
    $entries[$rel] = [ordered]@{ size = $f.Length }
}
$manifest = [ordered]@{
    version = $version
    updated = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    files   = $entries
} | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText($manifestPath, $manifest, $utf8NoBom)
Write-Host "  manifest v$version ($($entries.Count) files)"
Push-Location $RepoPath
try {
    $existing = git config --get remote.origin.url 2>$null
    if (-not $existing) {
        git remote add origin "git@github.com:$GitUser/$RepoName.git"
    } elseif ($existing -match "^https://") {
        Write-Host "  converting remote to SSH..."
        git remote set-url origin "git@github.com:$GitUser/$RepoName.git"
    }
    git add . | Out-Null
    $status = git status --porcelain
    if ($status) { git commit -m $CommitMsg | Out-Null; Write-Host "  committed" }
    else { Write-Host "  no changes" }
    if ($SkipPush) { exit 0 }
    git branch -M main | Out-Null
    git push origin main --force
    if ($LASTEXITCODE -eq 0) { Write-Host "  pushed" } else { Write-Host "  push failed" }
} finally { Pop-Location }