import functools
import operator
import itertools

# def add (a):
#     print (a[0], a[1])
#     return a[0] + a[1]

def commonBit (a, b):
    ys = itertools.zip_longest(a,  [x if x else -1 for x in b], fillvalue = 0)
    # print ('ys', list(ys))
    xs = map(lambda x: x[0] + x[1], ys)
    return xs

def isBinaryDigit (a):
    return a == '1' or a == '0'

def convertListToInt (a):
    # print (list(map(lambda x: int(x > 0), a)))
    return int(''.join(map(str, a)), 2)

if __name__ == "__main__":
    f = open("day3.in", "r")
    # f = open("test3.in", "r")
    data = [list(map(int, filter(isBinaryDigit, x))) for x in f.readlines()]
    bits = list(map(lambda x: int(x > 0), functools.reduce(commonBit, data, []))) # must make list here :(
    # print (bits)
    gamma = convertListToInt(bits)
    # print (bin(gamma), 'list', bits)
    epsilon = convertListToInt(map(lambda x: int(not bool(x)), bits))
    # print(bin(epsilon))
    # part 1
    print (gamma * epsilon)
    # part 2
