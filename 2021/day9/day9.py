import functools
import operator
import itertools
import re

import sys
sys.setrecursionlimit(100000)

def getLoc (loc, heightmap):
    return heightmap[loc[1]][loc[0]]

def nextLoc (loc, heightmap):
    x = (loc[0]+1) % len(heightmap[0])
    y = loc[1]
    if (x == 0):
        y = (y+1) # implicitly if y == len(heightmap)
    return (x, y)

def getNeighbors (loc, heightmap):
    bounds = [[-1, len(heightmap[0])], [-1, len(heightmap)]]
    return [x for x in [(loc[0]+1, loc[1]), (loc[0]-1, loc[1]), (loc[0], loc[1]+1), (loc[0], loc[1]-1)] if (x[0] not in bounds[0]) and (x[1] not in bounds[1])]

def getLows (loc, heightmap):
    x = getLoc(loc, heightmap)
    # print ("checking loc=", loc, " value=", x)
    lows = []
    if (all(map(functools.partial(operator.lt, x), map(functools.partial(getLoc, heightmap=heightmap), getNeighbors(loc, heightmap))))):
        lows = [loc]

    if (nextLoc(loc, heightmap)[1] < len(heightmap)):
        lows.extend(getLows(nextLoc(loc, heightmap), heightmap))
        
    return lows


def getChecked (loc, checked):
    return checked[loc[1]][loc[0]]

def setChecked (loc, checked):
    checked[loc[1]][loc[0]] = True

# just consider checked a monad...
def getBasin (heightmap, checked, loc):
    if (loc[1] >= len(heightmap) or getChecked(loc, checked) or getLoc(loc, heightmap) == 9):
        return 0

    setChecked(loc, checked)

    return 1 + sum(map(functools.partial(getBasin, heightmap, checked), getNeighbors(loc, heightmap)))

if __name__ == "__main__":
    # f = open("test9.in", "r")
    f = open("day9.in", "r")
    data = [[int(x) for x in xs if x.isnumeric()] for xs in f.readlines()]
    lows = getLows((0, 0), data)
    # part 1
    print(functools.reduce(operator.add, map(functools.partial(getLoc, heightmap=data), lows), len(lows)))
    # part 2
    checked = [[False for x in range(len(xs))] for xs in data]
    print(functools.reduce(operator.mul, sorted(map(functools.partial(getBasin, data, checked), lows), reverse=True)[:3], 1))
    # print(functools.reduce(operator.mul, , 1))



    

