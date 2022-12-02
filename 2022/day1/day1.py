import functools
import operator


if __name__ == "__main__":
    f = open("day1.in", "r")
    # f = open("test1.in", "r")

    max = 0
    current = 0
    elves = []
    for x in f.readlines():
        if x == "\n":
            elves.append(current)
            if (current > max):
                max = current
            current = 0
        else:
            current += int(x)
    
    print(max)

    elves.sort()

    print (len(elves))
    print (elves[-3:])
    print (sum(elves[-3:]))