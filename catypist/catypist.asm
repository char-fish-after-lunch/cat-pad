NOP
NOP
NOP
B START
NOP

B INT ; 0x0005 interrupt here
NOP

; data
DATA:
DATA_READY:
    .word 0x0000
DATA_X:
    .word 0x0000
DATA_Y:
    .word 0x0000
DATA_PS2_LAST:
    .word 0x0000

INT:
; interrupt handler at 0x0005
    SW_SP R0 0xffff  

    LI R0 0x00bf
    SLL R0 R0 0x0000

   
    ADDIU R0 0x0010 ; the bottom of the stack R6=0xbf10

    SW R0 R6 0x0000 ; used to store the registers that might change in the interrupt handler
    SW R0 R1 0x0001
    SW R0 R2 0x0002
    SW R0 R3 0x0003
    SW R0 R4 0x0004
    SW R0 R5 0x0005


    ; cause of the interrupt
    MFCS R6

    ; CMPI R0 0x000a  ; PS/2 ISR
    ; BTEQZ INT_PS2
    B INT_PS2
    NOP
    B INT_FINISH
    NOP

    ; TODO: other interrupt types

INT_PS2:
    ; handles PS/2 ISR 
    LI R1 0x00bf
    SLL R1 R1 0x0000
    ; R1=0xbf04, address of PS/2 data

    ; check whether VGA is ready
    LI R3 @DATA
    LW R3 R5 0x0000
    
    LW R1 R2 0x0004
    ; load the data to R2
    SW R1 R2 0x0000

    CMPI R5 0x0000
    BTEQZ INT_FINISH_J
    NOP
    B INT_FINISH_SKIP
    NOP
    INT_FINISH_J:
    B INT_FINISH
    NOP
    ; not ready (zero) 
    INT_FINISH_SKIP:

    ; check if R2 = E0 or F0
    SRL R4 R2 0x0007
    ; get the most significant bit
    CMPI R4 0x0001
    BTEQZ INT_PS2_FINISH_J
    NOP
    B INT_PS2_FINISH_SKIP
    NOP
    INT_PS2_FINISH_J:
    B INT_PS2_FINISH
    NOP
    INT_PS2_FINISH_SKIP:

    LW R3 R5 0x0003 ; R5 = last PS/2 data
    ; check if it is R5 = E0 or F0
    SRL R4 R5 0x0004
    CMPI R4 0x000f
    BTEQZ INT_PS2_FINISH_J2
    NOP
    B INT_PS2_FINISH_SKIP2
    NOP
    INT_PS2_FINISH_J2:
    B INT_PS2_FINISH
    NOP
    INT_PS2_FINISH_SKIP2:

    ; temporarily does not check 
    ; CMPI R4 0x000e
    CMPI R2 0x29
    BTEQZ INT_PS2_SPACE
    NOP

    CMPI R2 28
    BTEQZ INT_PS2_a
    NOP

    CMPI R2 50
    BTEQZ INT_PS2_b
    NOP

    CMPI R2 33
    BTEQZ INT_PS2_c
    NOP

    CMPI R2 35
    BTEQZ INT_PS2_d
    NOP

    CMPI R2 36
    BTEQZ INT_PS2_e
    NOP

    CMPI R2 43
    BTEQZ INT_PS2_f
    NOP

    CMPI R2 52
    BTEQZ INT_PS2_g
    NOP

    CMPI R2 51
    BTEQZ INT_PS2_h
    NOP

    CMPI R2 67
    BTEQZ INT_PS2_i
    NOP

    CMPI R2 59
    BTEQZ INT_PS2_j
    NOP

    CMPI R2 66
    BTEQZ INT_PS2_k
    NOP

    CMPI R2 75
    BTEQZ INT_PS2_l
    NOP

    CMPI R2 58
    BTEQZ INT_PS2_m
    NOP

    CMPI R2 49
    BTEQZ INT_PS2_n
    NOP

    CMPI R2 68
    BTEQZ INT_PS2_o
    NOP
/////
    CMPI R2 77
    BTEQZ INT_PS2_p
    NOP

    CMPI R2 21
    BTEQZ INT_PS2_q
    NOP

    CMPI R2 45
    BTEQZ INT_PS2_r
    NOP

    CMPI R2 27
    BTEQZ INT_PS2_s
    NOP

    CMPI R2 44
    BTEQZ INT_PS2_t
    NOP

    CMPI R2 60
    BTEQZ INT_PS2_u
    NOP

    CMPI R2 42
    BTEQZ INT_PS2_v
    NOP

    CMPI R2 29
    BTEQZ INT_PS2_w
    NOP

    CMPI R2 34
    BTEQZ INT_PS2_x
    NOP

    CMPI R2 53
    BTEQZ INT_PS2_y
    NOP

    CMPI R2 26
    BTEQZ INT_PS2_z
    NOP

    CMPI R2 69
    BTEQZ INT_PS2_0
    NOP

    CMPI R2 22
    BTEQZ INT_PS2_1
    NOP

    CMPI R2 30
    BTEQZ INT_PS2_2
    NOP

    CMPI R2 38
    BTEQZ INT_PS2_3
    NOP

    CMPI R2 37
    BTEQZ INT_PS2_4
    NOP

    CMPI R2 46
    BTEQZ INT_PS2_5
    NOP

    CMPI R2 54
    BTEQZ INT_PS2_6
    NOP

    CMPI R2 61
    BTEQZ INT_PS2_7
    NOP

    CMPI R2 62
    BTEQZ INT_PS2_8
    NOP

    CMPI R2 70
    BTEQZ INT_PS2_9
    NOP

    INT_PS2_SPACE:
    LI R6 0
    B INT_PS2_PRINT
    NOP

    INT_PS2_a:
    LI R6 97
    B INT_PS2_PRINT
    NOP

    INT_PS2_b:
    LI R6 98
    B INT_PS2_PRINT
    NOP

    INT_PS2_c:
    LI R6 99
    B INT_PS2_PRINT
    NOP

    INT_PS2_d:
    LI R6 100
    B INT_PS2_PRINT
    NOP

    INT_PS2_e:
    LI R6 101
    B INT_PS2_PRINT
    NOP

    INT_PS2_f:
    LI R6 102
    B INT_PS2_PRINT
    NOP

    INT_PS2_g:
    LI R6 103
    B INT_PS2_PRINT
    NOP

    INT_PS2_h:
    LI R6 104
    B INT_PS2_PRINT
    NOP

    INT_PS2_i:
    LI R6 105
    B INT_PS2_PRINT
    NOP

    INT_PS2_j:
    LI R6 106
    B INT_PS2_PRINT
    NOP

    INT_PS2_k:
    LI R6 107
    B INT_PS2_PRINT
    NOP

    INT_PS2_l:
    LI R6 108
    B INT_PS2_PRINT
    NOP

    INT_PS2_m:
    LI R6 109
    B INT_PS2_PRINT
    NOP

    INT_PS2_n:
    LI R6 110
    B INT_PS2_PRINT
    NOP/////

    INT_PS2_o:
    LI R6 111
    B INT_PS2_PRINT
    NOP

    INT_PS2_p:
    LI R6 112
    B INT_PS2_PRINT
    NOP

    INT_PS2_q:
    LI R6 113
    B INT_PS2_PRINT
    NOP

    INT_PS2_r:
    LI R6 114
    B INT_PS2_PRINT
    NOP

    INT_PS2_s:
    LI R6 115
    B INT_PS2_PRINT
    NOP

    INT_PS2_t:
    LI R6 116
    B INT_PS2_PRINT
    NOP

    INT_PS2_u:
    LI R6 117
    B INT_PS2_PRINT
    NOP

    INT_PS2_v:
    LI R6 118
    B INT_PS2_PRINT
    NOP

    INT_PS2_w:
    LI R6 119
    B INT_PS2_PRINT
    NOP

    INT_PS2_x:
    LI R6 120
    B INT_PS2_PRINT
    NOP

    INT_PS2_y:
    LI R6 121
    B INT_PS2_PRINT
    NOP

    INT_PS2_z:
    LI R6 122
    B INT_PS2_PRINT
    NOP

    INT_PS2_0:
    LI R6 48
    B INT_PS2_PRINT
    NOP

    INT_PS2_1:
    LI R6 49
    B INT_PS2_PRINT
    NOP

    INT_PS2_2:
    LI R6 50
    B INT_PS2_PRINT
    NOP

    INT_PS2_3:
    LI R6 51
    B INT_PS2_PRINT
    NOP

    INT_PS2_4:
    LI R6 52
    B INT_PS2_PRINT
    NOP

    INT_PS2_5:
    LI R6 53
    B INT_PS2_PRINT
    NOP////

    INT_PS2_6:
    LI R6 54
    B INT_PS2_PRINT
    NOP

    INT_PS2_7:
    LI R6 55
    B INT_PS2_PRINT
    NOP

    INT_PS2_8:
    LI R6 56
    B INT_PS2_PRINT
    NOP

    INT_PS2_9:
    LI R6 57
    B INT_PS2_PRINT
    NOP
    
    B INT_PS2_FINISH
    NOP

INT_PS2_PRINT:
    LI R4 0x00bf
    SLL R4 R4 0x0000

    SW R4 R6 0x0008
    
    LW R3 R5 0x0001 ;X
    SW R4 R5 0x0009

    LW R3 R2 0x0002 ;Y
    SW R4 R2 0x000a

    LI R1 0x0001
    SW R4 R1 0x000b ; ready to write

    LI R6 0b10
    SLL R6 R6 0x0000
    ; boundary R0 = 512

    ADDIU R2 0x0008
    CMP R2 R6
    BTEQZ INT_PS2_CL
    NOP
    B INT_PS2_SKIP_CL
    NOP
    INT_PS2_CL:

    ; change line
    NOP
    LI R2 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADDIU R5 0x0008
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    INT_PS2_SKIP_CL:
    ; write back x and y

    SW R3 R2 0x0002
    SW R3 R5 0x0001
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    

INT_PS2_FINISH:
    
    LI R1 0x00bf
    SLL R1 R1 0x0000


    LW R1 R2 0x0004

    LI R3 @DATA_PS2_LAST
    SW R3 R2 0x0000


    ; TODO: do something with R2 (possibly feed it to VGA or store
    ; it in a buffer for further processing)

    B INT_FINISH
    NOP

INT_FINISH:
    ; restore R0-R5
    LW R0 R6 0x0000
    LW R0 R1 0x0001
    LW R0 R2 0x0002
    LW R0 R3 0x0003
    LW R0 R4 0x0004
    LW R0 R5 0x0005


    ; restore R6
    LW_SP R0 0xffff

    ERET



START:
    ; initialise the stack frame pointer
    LI R0 0x00bf
    SLL R0 R0 0x0000
    ADDIU R0 0x0010
    MTSP R0


    LI R4 0x0000
    LI R5 0x0000
    LI R1 0x0002
    SLL R1 R1 0x0000
    LI R2 0x0001
    SLL R2 R2 0x0000
    LI R3 0x00FF
    ADDU R2 R3 R2

BEGINCLEAR:
    ; clear the screen
    MFPC R7    
    ADDIU R7 0x0003
    NOP
    B TESTPRINT

    NOP
    NOP
    LI R6 0x00BF
    SLL R6 R6 0x0000

    ;SW R6 R6 0x0000

    ADDIU R6 0x0008
    LI R3 0x0000
    SW R6 R3 0x0000
    SW R6 R4 0x0002
    SW R6 R5 0x0001
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
    ;LI R4 0xbf
    ;SLL R4 R4 0x0000
    ;LI R1 0x1
    ;SW R4 R1 0x0000

    LI R1 @DATA_READY
    LI R2 0x0001
    SW R1 R2 0x0000 ; VGA ready

    LOOP:
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
        NOP
        NOP
        NOP
NOP
        NOP
        NOP
        B LOOP
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

