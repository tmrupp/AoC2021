import functools
import operator


if __name__ == "__main__":
    f = open("day2.in", "r")
    # f = open("test2.in", "r")

    points = {
        "A X": 1+3,
        "A Y": 2+6,
        "A Z": 3+0,
        "B X": 1+0,
        "B Y": 2+3,
        "B Z": 3+6,
        "C X": 1+6,
        "C Y": 2+0,
        "C Z": 3+3,
    }

    points2 = {
        "A X": 0+3,
        "A Y": 3+1,
        "A Z": 6+2,
        "B X": 0+1,
        "B Y": 3+2,
        "B Z": 6+3,
        "C X": 0+2,
        "C Y": 3+3,
        "C Z": 6+1,
    }

    sum = 0
    sum2 = 0
    for x in f.readlines():
        sum += points[x.strip()]
        sum2 += points2[x.strip()]

    print(sum)
    print(sum2)
