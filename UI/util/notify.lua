-- util: notify

_G.UINotify = function(msg)
    if gui and gui.set_status then
        gui:set_status(tostring(msg))
    end
end
