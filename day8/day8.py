import functools
import operator
import itertools
import re

decoder = {
    "acedgfb": '8',
    "cdfbe": '5',
    "gcdfa": '2',
    "fbcad": '3',
    "dab": '7',
    "cefabd": '9',
    "cdfgeb": '6',
    "eafb": '4',
    "cagedb": '0',
    "ab": '1'
}

def composeNum (xs):
    return int([decoder[x] for x in xs])

if __name__ == "__main__":
    f = open("test8.in", "r")
    # f = open("day8.in", "r")
    data = [[[y for y in re.split(r' |\n', x) if y != ''] for x in z.split('|')][1] for z in f.readlines()]
    print(data)
    # part 1
    print(functools.reduce(lambda a, b: a + (len(b) in [2,3,4,7]),[x for xs in data for x in xs], 0))
    # part 2
    # print(functools.reduce(operator.add, []))
    data = [[[y for y in re.split(r' |\n', x) if y != ''] for x in z.split('|')] for z in f.readlines()]


    

