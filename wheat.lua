function Loop()
    for i = 1, 8 do
        local _, data = turtle.inspectDown()
            if data.state then
                local key, value = next(data.state)
                    if value == 7 then
                        print("nomnom")
                        turtle.digDown()
                        turtle.placeDown()
                    end
            end
        turtle.forward()
    end
end

function zigzag()
    Loop()
    
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    
    Loop()
    
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    
    Loop()
    
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    
    Loop()
    
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    
    Loop()
    
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    
    Loop()
    
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    
    Loop()
    
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    
    Loop()
    
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    
    Loop()
    
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    
    Loop()
end

function maybeRefuel()
    local fl = turtle.getFuelLevel()
    if fl < 250 then
        turtle.select(1)

        while true do
            turtle.refuel(1)
            turtle.suckUp(1)

            if turtle.getFuelLevel() >= 250 then
                break
            end
        end

        turtle.select(2)
    end
end

while true do
    maybeRefuel()
    zigzag()

    turtle.turnRight()
    for i = 1, 9 do
        turtle.forward()
    end
    turtle.turnRight()

    turtle.select(3)
    turtle.dropUp()
    turtle.select(4)
    turtle.dropUp()

    turtle.select(2)

    os.sleep(6000)
end