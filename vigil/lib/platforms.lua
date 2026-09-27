--!nonstrict
local SVC = _G.Vigil.Services
local State = _G.Vigil.State.State
local M = {}
local VOID_POS = Vector3.new(100, 4500000, 100)
local NULLZONE_POS = Vector3.new(9e8, 9e8, 9e8)
local cache = {}
local function createInvisiblePlatform(pos)
    local p = Instance.new("Part")
    p.Name = "VigilSafePlatform"
    p.Size = Vector3.new(20, 1, 20)
    p.Anchored = true
    p.CanCollide = true
    p.CanQuery = false
    p.CanTouch = false
    p.CastShadow = false
    p.Massless = true
    p.Transparency = 1
    p.Reflectance = 0
    p.Color = Color3.new(0, 0, 0)
    p.Material = Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.CFrame = CFrame.new(pos)
    p.Parent = SVC.WS
    for _, child in ipairs(p:GetChildren()) do
        if child:IsA("Decal") or child:IsA("Texture") then child:Destroy() end
    end
    return p
end
function M.get(key)
    if not State.useSafePlatforms then return nil end
    if cache[key] and cache[key].Parent then return cache[key] end
    local pos = key == "void" and VOID_POS or NULLZONE_POS
    local p = createInvisiblePlatform(pos)
    cache[key] = p
    return p
end
function M.clear()
    for k, p in pairs(cache) do
        if p and p.Parent then p:Destroy() end
        cache[k] = nil
    end
end
function M.reapply()
    if State.useSafePlatforms then
        pcall(M.get, "void")
        pcall(M.get, "nullzone")
    end
end
return M