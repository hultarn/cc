function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local curr_x = 0
local curr_z = 0
local curr_y = 0
local r = 0
local selectedSlot = 1

-- 0 is F, 2 is B, 1 is R and 3 is L
function rotate(to)
    if r == to then
        return
    elseif (r - 2) % 4 == to or (r + 2) % 4 == to then
        turtle.turnRight()
        turtle.turnRight()
        r = r + 2
    elseif (r + 1) % 4== to then
        turtle.turnRight()
        r = r + 1
    elseif (r - 1) % 4 == to then
        turtle.turnLeft()
        r = r - 1
    end

    r = r % 4
end

function moveUntill(x, z)
    while true do
        print("current pos is", curr_x, curr_z)
        if x == curr_x and z == curr_z then
            break
        elseif x > curr_x then
            rotate(0)
            move("+x", 0)
        elseif x < curr_x then
            rotate(2)
        elseif z > curr_z then
            rotate(1)
            move("+z", 0)
        elseif z < curr_z then
            rotate(3)
            move("-z", 0)
        end
    end
end

function replace()
    if turtle.getItemCount() == 0 then
            while true do
                selectedSlot = selectedSlot + 1
                if selectedSlot == 16 then
                    selectedSlot = 1

                    start_x = curr_x
                    start_z = curr_z
                    start_r = r

                    moveUntill(0, 0)
                    
                    start_y = curr_y
                    while curr_y > 0 do
                        turtle.down()
                        curr_y = curr_y - 1
                    end

                    for slot = 1, 15 do
                        turtle.select(slot)
                        turtle.suck()
                    end

                    while curr_y < start_y do
                        turtle.up()
                        curr_y = curr_y + 1
                    end

                    moveUntill(start_x, start_z)
                    rotate(start_r)
                end
                turtle.select(selectedSlot)

                if turtle.getItemCount() ~= 0 then
                    break
                end
            os.sleep(1)
        end
    end
end

function refuel()
    if turtle.getFuelLevel() < 10 then
        turtle.select(16)
        while true do
            local succ = turtle.refuel()
            if succ then
                break
            end
            print("waiting for fuel")
            os.sleep(1)
        end
        turtle.select(selectedSlot)
    end
end

function move(dir, extrudeIsActive)
    if extrudeIsActive == 1  then
        replace()
    end
    turtle.forward()
    if extrudeIsActive == 1 then
        turtle.placeDown()
    end
    
    if dir == "+x" then
        curr_x = curr_x + 1
    elseif dir == "-x" then
        curr_x = curr_x - 1
    elseif dir == "+z" then
        curr_z = curr_z + 1
    elseif dir == "-z" then
        curr_z = curr_z - 1
    end

    refuel()
end

if not arg[1] then
    print("arg[1] must be gcode filename")
    return
end

local gcode = dofile(arg[1])

for _, v in ipairs(gcode) do
    local extrudeIsActive = 0
    if v == "Y" then
        turtle.up()
        curr_y = curr_y + 1
    else 
        local r = split(v, " ")
        if #r < 3 then
            extrudeIsActive = 1
        end
        x = tonumber(r[1])
        z = tonumber(r[2])

        if x > curr_x then
            rotate(0)
            move("+x", extrudeIsActive)
        elseif x < curr_x then
            rotate(2)
            move("-x", extrudeIsActive)
        elseif z > curr_z then
            rotate(1)
            move("+z", extrudeIsActive)
        elseif z < curr_z then
            rotate(3)
            move("-z", extrudeIsActive)
        end
    end
end