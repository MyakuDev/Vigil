-- ui feature: no ragdoll

Antis:toggle({Name = "No Ragdoll",Description = "stay mobile while ragdolled.",Default = false,Callback = function(s)
    NoRagdoll.Enabled = s
    NoRagdoll.State = s and "Enabled" or "Disabled"
<<<<<<< HEAD
end})
=======
end})
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
