import functools
import operator
import itertools
import re

def gauss (x):
    return int((x * (1 + x)) / 2)

if __name__ == "__main__":
    # f = open("test7.in", "r")
    f = open("day7.in", "r")
    data = [int(x) for x in f.readlines()[0].split(',')]
    # part 1
    print(min([sum([abs(y-x) for y in data]) for x in range(max(data)+1)]))
    # part 2
    print(min([sum([gauss(abs(y-x)) for y in data]) for x in range(max(data)+1)]))

    

