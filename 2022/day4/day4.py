import functools
import operator

def maskify (a, b):
    return ((1<<(b-a+1))-1)<<a

if __name__ == "__main__":
    f = open("day.in", "r")
    # f = open("test.in", "r")

    data = [list(map(int, x.replace('\n','').replace('-',',').split(','))) for x in f.readlines()]
    sum = 0
    sum2 = 0
    for xs in data:
        if (maskify(xs[0], xs[1]) & maskify(xs[2], xs[3]) != 0):
            sum2 += 1

        # part 1
        if (xs[0] <= xs[2]):
            if (xs[1] >= xs[3]):
                sum += 1
                continue

        if (xs[0] >= xs[2]):
            if (xs[1] <= xs[3]):
                sum += 1

        

        

    print(sum)
    print(sum2)
