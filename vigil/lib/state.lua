--!nonstrict
local Storage = _G.Vigil.Storage
local Defaults = {
    omni = false, omniSpeed = 5,
    noRagdoll = true, btw = true, fly = false, flySpeed = 50,
    fov = 120, fullbright = false, infiniteJump = false, antiAFK = true,
    crateNotifier = true, autoKick = false,
    autoCarry = false, voidCarry = false, nzCarry = false,
    autoCarryV2 = true, autoCarryV2Range = 500,
    autoCarryDummy = false, autoVoidDummy = false, autoNzDummy = false,
    autoReviveDummy = false, autoFollowDummy = false,
    antiFling = false, watchlistActive = true, moderatorAction = "Server Hop",
    useSafePlatforms = true,
    disableFog = false, disableParticles = false, disableTrails = false,
    disableBeams = false, disableDecals = false, disableTextures = false,
    reduceLighting = false, performanceMode = false,
    autoHeal = true, autoHealThreshold = 20,
    keybindVoidAll = "None", keybindNzAll = "None", keybindKillAll = "None",
    keybindCarryNear = "None", keybindReturn = "None", keybindReset = "None",
    keybindFly = "None", keybindFullbright = "None", keybindNoRagdoll = "None",
    keybindInfiniteJump = "None", keybindAntiFling = "None", keybindSafePlats = "None",
    keybindGotoSelect = "None", keybindVoidSelect = "None", keybindNzSelect = "None",
    keybindCarrySelect = "None",
}
local State = Storage.readJson(Storage.PATHS.settings, Defaults)
for k, v in pairs(Defaults) do
    if State[k] == nil then State[k] = v end
end
local M = { State = State, Defaults = Defaults }
function M.save()
    Storage.writeJson(Storage.PATHS.settings, State)
end
return M