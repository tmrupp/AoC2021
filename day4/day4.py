import functools
import operator
import itertools
import re

# class spot:
#     def __init__ (self, value: int, selected=False):
#         self.value = value
#         self.selected = selected

#     def __str__ (self):
#         return str(self.value) + ", " + str(self.selected)

# class board:
#     def __init__ (self, values):
#         self.board = 

#     def __str__(self) -> str:
#         s = ""
#         for xs in self.board:
#             for x in xs:
#                 s = s + "(" + str(x) + ") "
#             s = s + "\n"
#         return s 

def checkWin (bs):
    for x in range(0, len(bs[0])):
        if all([y[1] for y in bs[x]]) or all([y[1] for y in list(map(operator.itemgetter(x), bs))]):
            return True
    return False

def score (b):
    s = 0
    for xs in b.board:
        for x in xs:
            if not x.selected:
                s += x.value
    return s

def mark (n, bs):
    xss = bs
    for xs in xss:
        for x in xs:
            if x[0] == n:
                x = (x[0], True)

    return xss
    
def findWinner (numbers, boards):
    n = numbers[0]
    print (n)
    bs = list(map(functools.partial(mark, n), boards))  

    for b in bs:
        if checkWin(b):
            print(score(b), n, b)
            return score(b)*n
        print(b)

    if len(numbers) == 1:
        return False
    
    return findWinner(numbers[1:], bs)


if __name__ == "__main__":
    f = open("test4.in", "r")
    # f = open("test3.in", "r")
    data = f.readlines()
    numbers = list(map(int, data[0].split(','))) # not a list
    boards = [[[(int(x), False) for x in re.split(r'[ \n]', s) if x.isnumeric()] for s in data[x:x+5]] for x in range(2, len(data), 6)]

    print(findWinner(numbers, boards))

