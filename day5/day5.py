import functools
import operator
import itertools
import re

# def findPath (a):


if __name__ == "__main__":
    f = open("test5.in", "r")
    # f = open("day5.in", "r")
    data = f.readlines()
    paths = [((y[0], y[1]), (y[2], y[3])) for y in [[int(x) for x in re.split(r' |,|->|\n', s) if x.isnumeric()] for s in data]]


