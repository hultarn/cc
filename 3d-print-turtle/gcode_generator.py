def trimPreAndPost():
    moveActions = []
    
    start = False
    for r in f:
        r = r.replace("\n", "")
        if "; Filament-specific end gcode" in r:
            break
        if r == "G1 Z1" or start:
           start = True
           moveActions.append(r)
    return moveActions

def trimAllNoneMovement(row_list):
    rows = []
    for r in row_list:
        if "G1" in r and ("Z" in r or "X" in r or "Y" in r):
            rows.append(r)
    return rows

def makeExtrusionBinary(row_list):
    rows = []
    for r in row_list:
        if "E" in r:
            s = r.split(" ")
            rows.append(s[0] + " " + s[1] + " " + s[2] + " E" if float(s[3][1:]) > 0 else "")
        else:
            rows.append(r)
    return rows

import math

def removeUnneeded(row_list):
    rows = []
    for r in row_list:
        rows.append(r.replace("G1", "").replace("X", "").replace("Y", "").replace("Z", ""))
    return rows

def removeFCommands(row_list):
    rows = []
    for r in row_list:
        r = r.strip()
        if "F" in r:
            r = r.split(" ")
            rows.append(" ".join(r[:-1]))
        else:
            rows.append(r)
    return rows

def makeToCoords(row_list):
    rows = []
    for r in row_list:
        if r == "":
            pass
        else:
            rows.append(r.split(" "))
    return rows
    
def roundToIntegers(row_list):
    rows = []
    for r in row_list:
        if len(r) > 1:
            x, y = float(r[0]), float(r[1])                
            rows.append([round(x), round(y), r[2] if len(r) > 2 else ""])
        else:
            rows.append([r[0]])
    return rows

def minimizeIntegers(row_list):
    xs = []
    ys = []
    for r in row_list:
        if len(r) > 1:
            x = int(r[0])
            y = int(r[1])
            xs.append(x)
            ys.append(y)

    min_x = min(xs)
    min_y = min(ys)

    rows = []
    for r in row_list:
        if len(r) > 1:
            x = int(r[0])
            y = int(r[1])
            rows.append([x - min_x, y - min_y, r[2] if len(r) > 2 else ""])
        else:
            rows.append([r[0]])
    
    return rows

def generateMiddleMoves(row_list):
    rows = []
    for i in range(0, len(row_list) - 1):
        if len(row_list[i]) == 3 and len(row_list[i + 1]) == 3:
            m1 = row_list[i]
            m2 = row_list[i + 1]   
            
            path = list(bresenham(m1[0], m1[1], m2[0], m2[1]))
            split_path = split_moves(path)
            
            if row_list[i + 1][2]  == '':
                for sp in split_path:
                    rows.append([sp[0], sp[1], "NE"])
            else:         
                for sp in split_path:
                    rows.append([sp[0], sp[1], sp[2] if len(sp) > 2 else ""])
        else:
            rows.append(row_list[i])

    return rows

def split_moves(path):
    split_path = []
    for i in range(len(path) - 1):
        x1, y1 = path[i]
        x2, y2 = path[i + 1]

        split_path.append((x1, y1))

        if x1 != x2 and y1 != y2:
            split_path.append([x1, y2, "NE"])

    split_path.append(path[-1])
    
    return split_path

def generateZlvlChangeWalks(row_list):
    rows = []
    for i in range(0, len(row_list) - 1):
        if len(row_list[i + 1]) == 1:
            path = list(bresenham(row_list[i][0], row_list[i][1], row_list[i + 2][0], row_list[i + 2][1]))
            sp = split_moves(path)
            for p in sp:
                rows.append([str(p[0]), str(p[1]), "NE"])
        else:
            rows.append(row_list[i])
    return rows

def bresenham(x0, y0, x1, y1):
    dx = x1 - x0
    dy = y1 - y0

    xsign = 1 if dx > 0 else -1
    ysign = 1 if dy > 0 else -1

    dx = abs(dx)
    dy = abs(dy)

    if dx > dy:
        xx, xy, yx, yy = xsign, 0, 0, ysign
    else:
        dx, dy = dy, dx
        xx, xy, yx, yy = 0, ysign, xsign, 0

    D = 2*dy - dx
    y = 0

    for x in range(dx + 1):
        yield x0 + x*xx + y*yx, y0 + x*xy + y*yy
        if D >= 0:
            y += 1
            D -= 2*dx
        D += 2*dy

file_name = "3DBenchy.gcode"
with open(file_name, "r") as f:
    row_list = trimPreAndPost()
    row_list = trimAllNoneMovement(row_list)
    row_list = makeExtrusionBinary(row_list)
    row_list = removeUnneeded(row_list)
    row_list = removeFCommands(row_list)
    row_list = makeToCoords(row_list)
    row_list = roundToIntegers(row_list)
    row_list = minimizeIntegers(row_list)
    row_list = generateMiddleMoves(row_list)
    row_list = generateZlvlChangeWalks(row_list)
    
    print("return {")
    firstPos = row_list[1]
    path = list(bresenham(0,0,int(firstPos[0]),int(firstPos[1])))
    sp = split_moves(path)
    for p in sp:
        print('\t"', p[0], " ", p[1], ' NE",', sep="")
    for r in row_list:
        if len(r) == 1:
            print('\t"Y",')
        else:
            print('\t"', r[0], " ", r[1], (" " + r[2]) if len(r) > 2 and r[2] != "" else "", '",', sep="")
    print("}")