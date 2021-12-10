import functools
import operator
import itertools
import re

def allIn (xs, ys):
    return all([(x in ys) for x in xs])

def createRule (xs):
    ys = ['' for x in range(10)]
    for x in xs:
        if len(x) == 2:
            ys[1] = x
        if len(x) == 4:
            ys[4] = x
        if len(x) == 3:
            ys[7] = x
        if len(x) == 7:
            ys[8] = x

    for x in xs:
        if len(x) == 6:
            if allIn(ys[1], x):
                if allIn(ys[4], x):
                    ys[9] = x
                else:
                    ys[0] = x
            else:
                ys[6] = x
        if len(x) == 5:
            if allIn(ys[1], x):
                ys[3] = x

    for x in xs:
        if len(x) == 5 and not allIn(x, ys[3]):
            if allIn(x, ys[6]):
                ys[5] = x
            else:
                ys[2] = x

    return ys

def findDigit (rule, x):
    for i in range(10):
        if allIn(x, rule[i]) and (len(x) == len(rule[i])):
            return str(i)
    print("x=", x, "not found in rule=", rule)

if __name__ == "__main__":
    # f = open("test8.in", "r")
    f = open("day8.in", "r")
    data = f.readlines()
    # part 1
    datap1 = [[[y for y in re.split(r' |\n', x) if y != ''] for x in z.split('|')][1] for z in data]
    print(functools.reduce(lambda a, b: a + (len(b) in [2,3,4,7]),[x for xs in datap1 for x in xs], 0))
    # part 2
    # print(functools.reduce(operator.add, []))
    datap2 = [[[y for y in re.split(r' |\n', x) if y != ''] for x in z.split('|')] for z in data]
    print(functools.reduce(operator.add, [int(functools.reduce(operator.add, map(functools.partial(findDigit, createRule(xss[0])), xss[1]))) for xss in datap2]))


    

