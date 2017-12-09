NOP
NOP
B START
NOP
NOP

B INT
NOP

TRAP:
    LOOP2:
        NOP
        LI R5 0xbf
        SLL R5 R5 0
        LI R6 2
        SW R5 R6 0x10

        B LOOP2
        NOP


INT:
    LI R1 0xbf
    SLL R1 R1 0
    
    MFEPC R2

    SW R1 R2 0 ; to uart

    ERET

START:
    LOOP1:
        NOP
        LI R3 0xbf
        SLL R3 R3 0
        LI R4 1
        SW R3 R4 0x10

        B LOOP1
        NOP

