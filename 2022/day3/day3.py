import functools
import operator

items = {}
items2 = {}
def add_item (x, end=0, its=items):
    if x in its:
        its[x] |= 1<<end
    else:
        its[x] = 1<<end

def char_value (c):
    if (c.isupper()):
        value = ord(c)-ord('A')+27
    else:
        value = ord(c)-ord('a')+1
    return value

if __name__ == "__main__":
    f = open("day.in", "r")
    # f = open("test.in", "r")

    lines = f.readlines()

    sum = 0
    sum2 = 0
    for line in lines:
        half = int(len(line)/2)
        # print (line[:half] + " " + line[half:])
        for i in range(half):
            add_item(line[i])
            add_item(line[i+half], 1)

        for item, count in items.items():
            if count == 3:
                sum += char_value(item)

        items.clear()

    for i in range(0, len(lines), 3):
        for j in range(3):
            for c in lines[i+j].replace('\n',''):
                add_item(c, j, items2)
        
        for item, count in items2.items():
            if count == 7:
                print(item + str(char_value(item)))
                sum2 += char_value(item)

        items2.clear()


    print (sum)
    print(sum2)