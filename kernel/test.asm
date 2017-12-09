.word 0x0000 0x0001 0x00003
A:
.ascii abc def geh hh
B:
.pad 0x0004
LI R0 @A
LI R1 @B
