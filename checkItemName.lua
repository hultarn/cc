
local chest = peripheral.wrap("top")
local monitor = peripheral.wrap("left")

while true do
    if redstone.getInput("right") then
        monitor.clear()
        monitor.setCursorPos(1, 1)
        
        local d = c.getItemDetail(1)
        monitor.write(d.name)
    end
    os.sleep(1) 
end