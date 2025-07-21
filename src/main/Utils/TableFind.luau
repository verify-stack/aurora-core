-- finds variables in a table even if its false
-- by mike
-- v2025.0715

tableFind = function(tbl, variableName)
    if tbl[variableName] then -- already found, dont flood the memory lol
        return tbl[variableName]
    end

    for name, value in pairs(tbl) do
        if type(value) == "table" then
            return tableFind(value, variableName)
        end
        if name ~= variableName then
            continue
        end

        return true
    end

    return false
end

return tableFind