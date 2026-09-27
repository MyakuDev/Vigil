-- ui feature: no ragdoll

Antis:toggle({Name = "No Ragdoll",Description = "stay mobile while ragdolled.",Default = false,Callback = function(s)
    NoRagdoll.Enabled = s
    NoRagdoll.State = s and "Enabled" or "Disabled"
end})
