import functools
import operator

def move (a, b):
    x = a[0]
    y = a[1]
    direction = b[0]
    delta = b[1]

    if (direction == "forward"):
        x += delta
    if (direction == "down"):
        y += delta
    if (direction == "up"):
        y -= delta

    return (x, y)

def aimMove (a, b):
    x = a[0]
    y = a[1]
    aim = a[2]
    direction = b[0]
    delta = b[1]

    if (direction == "forward"):
        x += delta
        y += aim * delta
    if (direction == "down"):
        aim += delta
    if (direction == "up"):
        aim -= delta

    return (x, y, aim)

def tupleProduct (a):
    return a[0] * a[1]

if __name__ == "__main__":
    f = open("day2.in", "r")
    data = [(xs[0], int(xs[1])) for xs in [x.split(' ') for x in f.readlines()]]
    # print(data)
    # part 1
    print(tupleProduct(functools.reduce(move, data, (0,0))))
    # part 2
    print(tupleProduct(functools.reduce(aimMove, data, (0,0,0))))