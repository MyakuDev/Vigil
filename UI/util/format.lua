-- util: format helpers

_G.UIFormat = {}

_G.UIFormat.Number = function(n, decimals)
    decimals = decimals or 2
    return string.format("%." .. decimals .. "f", n)
end

_G.UIFormat.Distance = function(vec)
    return string.format("%.1f", vec.Magnitude)
end

_G.UIFormat.Position = function(vec)
    return string.format("%.1f, %.1f, %.1f", vec.X, vec.Y, vec.Z)
end

_G.UIFormat.Truncate = function(str, len)
    len = len or 30
    if #str > len then return str:sub(1, len - 3) .. "..." end
    return str
end
