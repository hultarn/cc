-- https://pastebin.com/gDtQKmtA

function isInList(list, str)
    if type(list) ~= "table" then
        return
    end
    
    for _, value in ipairs(list) do
        if value == str then
            return true
        end
    end
    return false
end

function splitFirst(input, delimiter)
    return input:match("([^" .. delimiter .. "]+)")
end

local filter = dofile("filter.lua")
local filter_modname = dofile("filter_modname.lua")

for _, value in ipairs(filter) do
    print(value)
end

while true do
    local peripheralLeft = peripheral.wrap("front")
    local item = peripheralLeft.getItemDetail(1)

    if item then
        local prefix = splitFirst(item.name, ":")
        if isInList(filter, item.name) or isInList(filter_modname, prefix) then
            peripheralLeft.pushItems("back", 1)
        end
    end
    os.sleep(1)
end