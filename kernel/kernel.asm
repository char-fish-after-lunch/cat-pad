    ADDSP3 R0 0x0000
    ADDSP3 R0 0x0000
    NOP
    B START
    NOP
DELINT:
    NOP
    NOP
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x0010
    SW R6 R0 0x0000
    SW R6 R1 0x0001
    SW R6 R2 0x0002
    SW R6 R4 0x0004
    SW R6 R5 0x0005
    LW_SP R1 0x0000
    ADDSP 0x0001
    LI R0 0x00ff
    AND R1 R0
    LW_SP R2 0x0000
    ADDSP 0x0001
    ADDSP 0xffff
    SW_SP R3 0x0000
    ADDSP 0xffff
    SW_SP R7 0x0000
    LI R3 0x000f
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x0010
    LI R0 0x0000
    CMP R0 R1
    BTNEZ L2
    NOP
    LW R6 R4 0x0007
L2:
    LI R0 0x0020
    CMP R0 R1
    BTNEZ L3
    NOP
    LW R6 R4 0x0008
L3:
    LI R0 0x0010
    CMP R0 R1
    BTNEZ L4
    NOP
    LW R6 R4 0x0009
L4:
    NOP
    LW R6 R5 0x0006
    SLT R4 R5
    BTNEZ L5
    NOP
    SW R6 R4 0x0006
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R1 0x0000
    NOP
L5:
    NOP
    LI R3 0x000f
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    NOP
    ADDIU3 R2 R6 0x0000
    MFIH R3
    LI R0 0x0080
    SLL R0 R0 0x0000
    OR R3 R0
    LI R7 0x00bf
    SLL R7 R7 0x0000
    ADDIU R7 0x0010
    LW R7 R0 0x0000
    LW R7 R1 0x0001
    LW R7 R2 0x0002
    LW R7 R4 0x0004
    LW R7 R5 0x0005
    LW_SP R7 0x0000
    ADDSP 0x0001
    ADDSP 0x0001
    NOP
    MTIH R3
    JR R6
    LW_SP R3 0x00ff
    NOP
START:
    LI R0 0x0007
    MTIH R0
    LI R0 0x00bf
    SLL R0 R0 0x0000
    ADDIU R0 0x0010
    MTSP R0
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x0010
    LI R0 0x0000
    SW R6 R0 0x0000
    SW R6 R0 0x0001
    SW R6 R0 0x0002
    SW R6 R0 0x0003
    SW R6 R0 0x0004
    SW R6 R0 0x0005
    SW R6 R0 0x0006
    ADDIU R0 0x0001
    SW R6 R0 0x0007
    ADDIU R0 0x0001
    SW R6 R0 0x0008
    ADDIU R0 0x0001
    SW R6 R0 0x0009
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LI R0 0x004f
    SW R6 R0 0x0000
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LI R0 0x004b
    SW R6 R0 0x0000
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LI R0 0x000a
    SW R6 R0 0x0000
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LI R0 0x000d
    SW R6 R0 0x0000
    NOP
BEGIN:
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R1 0x0000
    LI R6 0x00ff
    AND R1 R6
    NOP
    LI R0 0x0052
    CMP R0 R1
    BTEQZ SHOWREGS
    NOP
    LI R0 0x0044
    CMP R0 R1
    BTEQZ SHOWMEM
    NOP
    LI R0 0x0041
    CMP R0 R1
    BTEQZ GOTOASM
    NOP
    LI R0 0x0055
    CMP R0 R1
    BTEQZ GOTOUASM
    NOP
    LI R0 0x0047
    CMP R0 R1
    BTEQZ GOTOCOMPILE
    NOP
    B BEGIN
    NOP
GOTOUASM:
    NOP
    B USAM
    NOP
GOTOASM:
    NOP
    B ASM
    NOP
GOTOCOMPILE:
    NOP
    B COMPILE
    NOP
TESTW:
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x0001
    LW R6 R0 0x0000
    LI R6 0x0001
    AND R0 R6
    BEQZ R0 TESTW
    NOP
    JR R7
    NOP
TESTR:
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x0001
    LW R6 R0 0x0000
    LI R6 0x0002
    AND R0 R6
    BEQZ R0 TESTR
    NOP
    JR R7
    NOP
SHOWREGS:
    LI R1 0x0006
    LI R2 0x0006
LOOP:
    LI R0 0x00bf
    SLL R0 R0 0x0000
    ADDIU R0 0x0010
    SUBU R2 R1 R3
    ADDU R0 R3 R0
    LW R0 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    SRA R3 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    ADDIU R1 0xffff
    NOP
    BNEZ R1 LOOP
    NOP
    B BEGIN
    NOP
SHOWMEM:
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R1 0x0000
    LI R6 0x00ff
    AND R1 R6
    NOP
    SLL R1 R1 0x0000
    OR R1 R5
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R2 0x0000
    LI R6 0x00ff
    AND R2 R6
    NOP
    SLL R2 R2 0x0000
    OR R2 R5
MEMLOOP:
    LW R1 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    SRA R3 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    ADDIU R1 0x0001
    ADDIU R2 0xffff
    NOP
    BNEZ R2 MEMLOOP
    NOP
    B BEGIN
    NOP
ASM:
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R1 0x0000
    LI R6 0x00ff
    AND R1 R6
    NOP
    SLL R1 R1 0x0000
    OR R1 R5
    LI R0 0x0000
    CMP R0 R1
    BTEQZ GOTOBEGIN
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R2 0x0000
    LI R6 0x00ff
    AND R2 R6
    NOP
    SLL R2 R2 0x0000
    OR R2 R5
    SW R1 R2 0x0000
    NOP
    B ASM
    NOP
GOTOBEGIN:
    NOP
    B BEGIN
    NOP
USAM:
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R1 0x0000
    LI R6 0x00ff
    AND R1 R6
    NOP
    SLL R1 R1 0x0000
    OR R1 R5
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R2 0x0000
    LI R6 0x00ff
    AND R2 R6
    NOP
    SLL R2 R2 0x0000
    OR R2 R5
USAMLOOP:
    LW R1 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    SRA R3 R3 0x0000
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R3 0x0000
    ADDIU R1 0x0001
    ADDIU R2 0xffff
    NOP
    BNEZ R2 USAMLOOP
    NOP
    B BEGIN
    NOP
COMPILE:
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R5 0x0000
    LI R6 0x00ff
    AND R5 R6
    NOP
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTR
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    LW R6 R2 0x0000
    LI R6 0x00ff
    AND R2 R6
    NOP
    SLL R2 R2 0x0000
    OR R2 R5
    ADDIU3 R2 R6 0x0000
    LI R7 0x00bf
    SLL R7 R7 0x0000
    ADDIU R7 0x0010
    LW R7 R5 0x0005
    ADDSP 0xffff
    SW_SP R5 0x0000
    MFIH R5
    LI R1 0x0080
    SLL R1 R1 0x0000
    OR R5 R1
    LW R7 R0 0x0000
    LW R7 R1 0x0001
    LW R7 R2 0x0002
    LW R7 R3 0x0003
    LW R7 R4 0x0004
    MFPC R7
    ADDIU R7 0x0004
    MTIH R5
    JR R6
    LW_SP R5 0x0000
    NOP
    NOP
    ADDSP 0x0001
    LI R7 0x00bf
    SLL R7 R7 0x0000
    ADDIU R7 0x0010
    SW R7 R0 0x0000
    SW R7 R1 0x0001
    SW R7 R2 0x0002
    SW R7 R3 0x0003
    SW R7 R4 0x0004
    SW R7 R5 0x0005
    MFIH R0
    LI R1 0x007f
    SLL R1 R1 0x0000
    LI R2 0x00ff
    OR R1 R2
    AND R0 R1
    MTIH R0
    LI R1 0x0007
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTW
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    SW R6 R1 0x0000
    B BEGIN
    NOP
