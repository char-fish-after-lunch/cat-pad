NOP
NOP
NOP
B BEGIN
NOP
ERET
NOP
NOP

BEGIN:
    LI R1 0xbf
    SLL R1 R1 0
    ADDIU R1 0x10
    
    LI R2 0x1
    LI R3 0x2

    SW R1 R2 0
    SW R1 R3 1

    LOOP:

    NOP
    NOP
    NOP
    B LOOP
    NOP



