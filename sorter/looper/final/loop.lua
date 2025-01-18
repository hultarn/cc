-- https://pastebin.com/gVBDqXz6

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

local filter1 = dofile("filter_1.lua")
local filter2 = dofile("filter_2.lua")

local combinedFilter = {}

for _, item in ipairs(filter1) do
    table.insert(combinedFilter, item)
end

for _, item in ipairs(filter2) do
    table.insert(combinedFilter, item)
end

for _, value in ipairs(combinedFilter) do
    print(value)
end

local filter_modname = dofile("filter_modname.lua")

while true do
    local peripheralLeft = peripheral.wrap("left")
    local item = peripheralLeft.getItemDetail(1)

    if item then
        local prefix = splitFirst(item.name, ":")
        if isInList(combinedFilter, item.name) or isInList(filter_modname, prefix) then
            peripheralLeft.pushItems("back", 1, nil, 1)
        else
            peripheralLeft.pushItems("right", 1)
        end
    end

    os.sleep(1)
end