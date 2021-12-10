import functools
import operator
import itertools
import re

import sys
sys.setrecursionlimit(100000)

matches = {
    '(' : ')',
    '[' : ']',
    '{' : '}',
    '<' : '>',
}

pointsp1 = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137
}

pointsp2 = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4
}

def findCorruption (xs, ys):
    if len(xs) == 0:
        return 0

    if xs[0] in ['(', '[', '{', '<']:
        ys.append(xs[0])
        return findCorruption(xs[1:], ys)
    else:
        if (matches[ys[-1]] == xs[0]):
            return findCorruption(xs[1:], ys[:-1])
        else:
            return pointsp1[xs[0]]

def scoreCompletion (xs):
    return functools.reduce(lambda a, b: 5*a + b, map(lambda x: pointsp2[x], xs))

def findCompletion (xs, ys=None):
    if len(xs) == 0:
        return ys

    if ys is None:
        ys = []

    if xs[0] in ['(', '[', '{', '<']:
        ys.append(xs[0])
        return findCompletion(xs[1:], ys)
    else:
        if (matches[ys[-1]] == xs[0]):
            return findCompletion(xs[1:], ys[:-1])


if __name__ == "__main__":
    # f = open("test10.in", "r")
    f = open("day10.in", "r")
    data = [x.replace('\n','') for x in f.readlines()]
    # part 1
    print(sum(map(functools.partial(findCorruption, ys=[]), data)))
    # part 2
    xs = sorted([scoreCompletion(list(map(lambda x: matches[x], reversed(x)))) for x in map(functools.partial(findCompletion), data) if x is not None])
    print(xs[int((len(xs)-1)/2)])



    

