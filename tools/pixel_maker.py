f = open("input.txt", "r")

for l in f:
    n = int(l, base=2)
    print(hex(n).replace("0x", ""))
f.close()