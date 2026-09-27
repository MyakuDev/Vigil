--!nonstrict
local V = _G.Vigil
local Tabs = V.Window.Tabs
local State = V.State.State
local saveState = V.State.save
local Keybinds = V.Keybinds
local function onKB(stateKey)
    local key = tostring(stateKey or "")
    return function(v)
        State[key] = tostring(v or "None")
        saveState()
        if Keybinds and Keybinds.rebuild then pcall(Keybinds.rebuild) end
    end
end
Tabs.Keybinds:AddParagraph({ Title = "Global Actions", Content = "press a key to run the action" })
Tabs.Keybinds:AddKeybind("KB_VoidAll", { Title = "Void Carry Everyone", Mode = "Press", Default = State.keybindVoidAll }):OnChanged(onKB("keybindVoidAll"))
Tabs.Keybinds:AddKeybind("KB_NzAll", { Title = "Nullzone Carry Everyone", Mode = "Press", Default = State.keybindNzAll }):OnChanged(onKB("keybindNzAll"))
Tabs.Keybinds:AddKeybind("KB_KillAll", { Title = "Kill Everyone", Mode = "Press", Default = State.keybindKillAll }):OnChanged(onKB("keybindKillAll"))
Tabs.Keybinds:AddKeybind("KB_CarryNear", { Title = "Carry Nearest Ragdolled", Mode = "Press", Default = State.keybindCarryNear }):OnChanged(onKB("keybindCarryNear"))
Tabs.Keybinds:AddKeybind("KB_Return", { Title = "Return Carry", Mode = "Press", Default = State.keybindReturn }):OnChanged(onKB("keybindReturn"))
Tabs.Keybinds:AddKeybind("KB_Reset", { Title = "Reset Character", Mode = "Press", Default = State.keybindReset }):OnChanged(onKB("keybindReset"))
Tabs.Keybinds:AddKeybind("KB_Fly", { Title = "Toggle Fly", Mode = "Press", Default = State.keybindFly }):OnChanged(onKB("keybindFly"))
Tabs.Keybinds:AddKeybind("KB_Fullbright", { Title = "Toggle Fullbright", Mode = "Press", Default = State.keybindFullbright }):OnChanged(onKB("keybindFullbright"))
Tabs.Keybinds:AddKeybind("KB_NoRagdoll", { Title = "Toggle No-Ragdoll", Mode = "Press", Default = State.keybindNoRagdoll }):OnChanged(onKB("keybindNoRagdoll"))
Tabs.Keybinds:AddKeybind("KB_InfiniteJump", { Title = "Toggle Infinite Jump", Mode = "Press", Default = State.keybindInfiniteJump }):OnChanged(onKB("keybindInfiniteJump"))
Tabs.Keybinds:AddKeybind("KB_AntiFling", { Title = "Toggle Anti-Fling", Mode = "Press", Default = State.keybindAntiFling }):OnChanged(onKB("keybindAntiFling"))
Tabs.Keybinds:AddKeybind("KB_SafePlats", { Title = "Toggle Safe Platforms", Mode = "Press", Default = State.keybindSafePlats }):OnChanged(onKB("keybindSafePlats"))
Tabs.Keybinds:AddParagraph({ Title = "Selected Player Actions", Content = "acts on the target picked in the Player tab" })
Tabs.Keybinds:AddKeybind("KB_GotoSelect", { Title = "Goto Selected", Mode = "Press", Default = State.keybindGotoSelect }):OnChanged(onKB("keybindGotoSelect"))
Tabs.Keybinds:AddKeybind("KB_VoidSelect", { Title = "Void Carry Selected", Mode = "Press", Default = State.keybindVoidSelect }):OnChanged(onKB("keybindVoidSelect"))
Tabs.Keybinds:AddKeybind("KB_NzSelect", { Title = "Nullzone Carry Selected", Mode = "Press", Default = State.keybindNzSelect }):OnChanged(onKB("keybindNzSelect"))
Tabs.Keybinds:AddKeybind("KB_CarrySelect", { Title = "Carry Selected", Mode = "Press", Default = State.keybindCarrySelect }):OnChanged(onKB("keybindCarrySelect"))