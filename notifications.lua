-- notifications

_G.Notify = function(title, text, duration)
    if gui and gui.Notification then
        local ok = pcall(function()
            gui:Notification{Title = title or "Vigil", Text = text or "", Duration = duration or 3}
        end)
        if ok then return end
    end
    if gui and gui.set_status then
        gui:set_status("[" .. tostring(title) .. "] " .. tostring(text))
    end
end

_G.NotifySuccess = function(text) Notify("Success", text, 2) end
_G.NotifyError   = function(text) Notify("Error", text, 3) end
_G.NotifyInfo    = function(text) Notify("Info", text, 2) end
