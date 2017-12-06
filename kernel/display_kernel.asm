    ADDSP3 R0 0x0000
    ADDSP3 R0 0x0000
    NOP
    B START
    NOP
DELINT:
    ; handles interrupts (including synchronous interrupts and asynchronous ISRs)
    NOP
    NOP
    NOP

    ; store R6 to the stack before using it
    SW_SP R6 0xffff  

    LI R6 0x00bf
    SLL R6 R6 0x0000


    ADDIU R6 0x0010 ; the bottom of the stack R6=0xbf10

    SW R6 R0 0x0000 ; used to store the registers that might change in the interrupt handler
    SW R6 R1 0x0001
    SW R6 R2 0x0002
    SW R6 R3 0x0003
    SW R6 R4 0x0004
    SW R6 R5 0x0005

    ; cause of the interrupt
    MFCS R0

    CMPI R0 0x000a  ; PS/2 ISR
    BTEQZ DELINT_PS2
    NOP
    B DELINT_FINISH
    NOP

    ; TODO: other interrupt types

DELINT_PS2:
    ; handles PS/2 ISR 

    LI R1 0x00bf
    SLL R1 R1 0x0000
    ADDIU R1 0x0004
    ; R1=0xbf04, address of PS/2 data

    LW R1 R2 0x0000
    ; load the data to R2

    LI R3 0x00bf
    SLL R3 R3 0x0000

    SW R3 R2 0x0000 ; write to the port

    ; TODO: do something with R2 (possibly feed it to VGA or store
    ; it in a buffer for further processing)

    B DELINT_FINISH
    NOP

DELINT_FINISH:
    ; restore R0-R5
    LW R6 R0 0x0000
    LW R6 R1 0x0001
    LW R6 R2 0x0002
    LW R6 R3 0x0003
    LW R6 R4 0x0004
    LW R6 R5 0x0005


    ; restore R6
    LW_SP R6 0xffff

    ERET

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
    LI R4 0x0000
    LI R5 0x0000
    LI R1 0x0002
    SLL R1 R1 0x0000
    LI R2 0x0001
    SLL R2 R2 0x0000
    LI R3 0x00FF
    ADDU R2 R3 R2

BEGINCLEAR:
    
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT

    NOP
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000
    ADDIU R6 0x0008
    LI R3 0x0000
    SW R6 R3 0x0000
    SW R6 R4 0x0001
    SW R6 R5 0x0002
    LI R3 0x0001
    SW R6 R3 0x0003

    ADDIU R4 0x0008
    CMP R4 R1
    BTEQZ CLEARTOZERO
    NOP
    B NONEEDRETURNZERO
    NOP

CLEARTOZERO:
    NOP
    LI R4 0x0000
    ADDIU R5 0x0008
    AND R5 R2
    BEQZ R5 TESTSHOWTEXT
    NOP

NONEEDRETURNZERO:

    NOP
    B BEGINCLEAR
    NOP


TESTSHOWTEXT:

    NOP
    NOP
    LI R4 0x0000
    LI R5 0x0000
    LI R1 0x0002
    SLL R1 R1 0x0000
    LI R2 0x0001
    SLL R2 R2 0x0000
    LI R3 0x00FF
    ADDU R2 R3 R2
    
    LI R3 0x0021

BEGINSHOWTEXT:
    
    MFPC R7
    ADDIU R7 0x0003
    NOP
    B TESTPRINT

    NOP
    NOP
    LI R6 0x00BF
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SLL R6 R6 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADDIU R6 0x0008
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADDIU R3 0x0001
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SW R6 R3 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SW R6 R4 0x0002
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SW R6 R5 0x0001
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LI R7 0x0001
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SW R6 R7 0x0003
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADDIU R4 0x0008
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    SLT R4 R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BTEQZ TEXTCLEARTOZERO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    B TEXTNONEEDRETURNZERO
    NOP


TEXTCLEARTOZERO:
    NOP
    LI R4 0x0000
    ADDIU R5 0x0008
    AND R5 R2
    BEQZ R5 ENDLOOP
    NOP

TEXTNONEEDRETURNZERO:

    NOP
    B BEGINSHOWTEXT
    NOP

ENDLOOP:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    B ENDLOOP
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

TESTPRINT:
    NOP
    LI R6 0x00bf
    SLL R6 R6 0x0000
    ADDIU R6 0x000b
    LW R6 R0 0x0000
    LI R6 0x0001
    AND R0 R6
    BEQZ R0 TESTPRINT
    NOP
    JR R7
    NOP