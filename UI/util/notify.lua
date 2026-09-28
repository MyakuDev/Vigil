-- util: notify

_G.UINotify = function(msg)
    if gui and gui.set_status then
        gui:set_status(tostring(msg))
    end
<<<<<<< HEAD
end
=======
end
>>>>>>> 56227c581261dfd7db93f9fb6056a16976bc89e9
