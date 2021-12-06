import functools
import operator
import itertools
import re

def createPath (x, y):
    xs = list(range(x, y, -1 if x > y else 1))
    xs.append(y)
    return xs

def findPath (a):
    (a0, a1) = a
    xs = createPath(a0[0], a1[0])
    ys = createPath(a0[1], a1[1])

    if len(xs) == 1:
        return zip([xs[0] for x in range(len(ys))], ys)
    elif len(ys) == 1:
        return zip(xs, [ys[0] for x in range(len(xs))])
    else:
        return []

def findAllPath (a):
    (a0, a1) = a
    xs = createPath(a0[0], a1[0])
    ys = createPath(a0[1], a1[1])

    if len(xs) == 1:
        return zip([xs[0] for x in range(len(ys))], ys)
    elif len(ys) == 1:
        return zip(xs, [ys[0] for x in range(len(xs))])
    else:
        return zip(xs, ys)

def addPoint (floor, point):
    # print (point)
    if (point in floor):
        floor[point] += 1
    else:
        floor[point] = 1
    return floor

def addPoints (floor, points):
    return functools.reduce(addPoint, points, floor)

def markPath (floor, paths):
    return functools.reduce(addPoints, map(findPath, paths), floor)

def markAllPath (floor, paths):
    return functools.reduce(addPoints, map(findAllPath, paths), floor)

if __name__ == "__main__":
    # f = open("test5.in", "r")
    f = open("day5.in", "r")
    data = f.readlines()
    paths = [((y[0], y[1]), (y[2], y[3])) for y in [[int(x) for x in re.split(r' |,|->|\n', s) if x.isnumeric()] for s in data]]
    # print (dict(markPath({}, paths)))
    # part 1
    print(functools.reduce(lambda sum, x: sum + (x > 1), markPath({}, paths).values(), 0))
    # part 2
    print(functools.reduce(lambda sum, x: sum + (x > 1), markAllPath({}, paths).values(), 0))

