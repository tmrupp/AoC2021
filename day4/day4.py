import functools
import operator
import itertools
import re

class spot:
    def __init__ (self, value: int, selected=False):
        self.value = value
        self.selected = selected

    def __str__ (self):
        return str(self.value) + ", " + str(self.selected)

class board:
    def __init__ (self, values):
        # for s in values:
        #     print (s.split(' '))

        self.board = [[spot(int(x)) for x in re.split(r'[ \n]', s) if x.isnumeric()] for s in values]

    def __str__(self) -> str:
        s = ""
        for xs in self.board:
            for x in xs:
                s = s + "(" + str(x) + ") "
            s = s + "\n"
        return s 

def checkWin (b):
    

# def generateBoards (xs):
    

if __name__ == "__main__":
    f = open("test4.in", "r")
    # f = open("test3.in", "r")
    data = f.readlines()
    numbers = map(int, data[0].split(',')) # not a list
    boards = [board(data[x:x+5]) for x in range(2, len(data), 6)]

    # for b in boards:
    #     print (b)

