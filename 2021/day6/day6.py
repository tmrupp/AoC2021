import functools
import operator
import itertools
import re

def addTimer (timers, timer):
    timers[timer] += 1
    return timers

def stepTime (timers, time):
    xs = [timers[0] if i == 8 else timers[0] + timers[7] if i == 6 else timers[i+1] for i in range(9)]

    if time == 1:
        return xs
    else:
        return stepTime(xs, time-1)

if __name__ == "__main__":
    # f = open("test6.in", "r")
    f = open("day6.in", "r")
    data = f.readlines()
    # part 1
    print(functools.reduce(operator.add, stepTime(functools.reduce(addTimer, [int(x) for x in data[0].split(',')], [0 for x in range(9)]), 80)))
    # part 2
    print(functools.reduce(operator.add, stepTime(functools.reduce(addTimer, [int(x) for x in data[0].split(',')], [0 for x in range(9)]), 256)))
    

