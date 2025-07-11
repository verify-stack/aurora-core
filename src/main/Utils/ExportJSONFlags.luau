-- converts json into proper fflags
-- by mike
-- v2025.0711

local HttpService = game:GetService("HttpService")
local fflagNames = {
    "FFlag",
    "DFFlag"
}
local fflagValues = {
    ["true"] = true,
    ["false"] = false
}

return function(tbl, json)
    local luaTable = HttpService:JSONDecode(json)
    for name, value in pairs(luaTable) do
        local parsedName = name
        for _, flag in ipairs(fflagNames) do
            local cache = name:split("FFlag")
            if not cache[2] then
                continue
            end

            parsedName = cache[2]
        end

        if tonumber(value) then
            tbl[parsedName] = tonumber(value)
            continue
        end
        local oldValue = value
        value = fflagValues[value:lower()]
        if not value then
            value = oldValue
        end
        tbl[parsedName] = value
    end
end