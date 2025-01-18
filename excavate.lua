local chest = peripheral.wrap("top")

while true do
    local turtle = peripheral.wrap("left")
    print(turtle)
    if turtle then
        chest.pushItems("left", 1, nil, 1)
    end

    for i = 1, 10 do 
        redstone.setOutput("right", true)
        os.sleep(0.1) 
        redstone.setOutput("right", false)
    end 

    os.sleep(1) 
end