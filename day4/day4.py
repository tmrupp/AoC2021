import functools
import operator
import itertools
import re

def checkWin (bs):
    for x in range(0, len(bs[0])):
        if all([y[1] for y in bs[x]]) or all([y[1] for y in list(map(operator.itemgetter(x), bs))]):
            return True
    return False

def score (xss):
    s = 0
    for xs in xss:
        for x in xs:
            if not x[1]:
                s += x[0]
    return s

def mark (n, xss):
    yss = []
    for xs in xss:
        ys = []
        for x in xs:
            if x[0] == n:
                ys.append((x[0], True))
            else:
                ys.append(x)
        yss.append(ys)
    return yss
    
def findWinner (numbers, boards):
    n = numbers[0]
    # print (n)
    bs = list(map(functools.partial(mark, n), boards))
    

    for b in bs:
        if checkWin(b):
            # print(score(b), n, b)
            return score(b)*n
        # print(b)
    
    return findWinner(numbers[1:], bs)

def findLoser (numbers, boards):
    n = numbers[0]
    # print (n)
    bs = list(map(functools.partial(mark, n), boards))

    xss = []
    for b in bs:
        if checkWin(b):
            # print(score(b), n, b)
            if len(bs) == 1:
                return score(b)*n
        else:
            xss.append(b)
        # print(b)
    
    return findLoser(numbers[1:], xss)


if __name__ == "__main__":
    f = open("day4.in", "r")
    # f = open("test3.in", "r")
    data = f.readlines()
    numbers = list(map(int, data[0].split(','))) # not a list
    boards = [[[(int(x), False) for x in re.split(r'[ \n]', s) if x.isnumeric()] for s in data[x:x+5]] for x in range(2, len(data), 6)]

    # part 1
    print(findWinner(numbers, boards))
    # part 2
    print(findLoser(numbers, boards))

