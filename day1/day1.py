import functools
import operator

def lt (a, b):
    return a < b

def menage_a_trois (a, b, c):
    return a + b + c

if __name__ == "__main__":
    f = open("day1.in", "r")
    data = [int(x) for x in f.readlines()]
    # part 1
    print (functools.reduce(operator.add, map(lt, data, data[1:])))
    # part 2
    averagedData = list(map(menage_a_trois, data, data[1:], data[2:]))
    print (functools.reduce(operator.add, map(lt, averagedData, averagedData[1:])))
