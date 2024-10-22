ORG 0001H
MOV R2, #04H
MOV R3, #04H
MAIN:
    ACALL INIT
    DJNZ R2, SUBLOOP
    DJNZ R3, ADDLOOP
SUBLOOP:
    ACALL SUBFUNC
    INC R0
    INC R1
    DJNZ R2, SUBLOOP
    INC R2
    SJMP MAIN
ADDLOOP:
    ACALL ADDFUNC
    INC R0
    INC R1
    DJNZ R3, ADDLOOP
    INC R3
    ACALL INITINIT
    SJMP MAIN
    
INITINIT:
    MOV R2, #04H
    MOV R3, #04H
    RET
INIT:
    MOV R0, #30H
    MOV R1, #40H
    MOV 30H, #60H
    MOV 31H, #5CH
    MOV 32H, #32H
    MOV 40H, #8BH
    MOV 41H, #7FH
    MOV 42H, #21H
    RET
SUBFUNC:
    MOV A, @R0
    SUBB A, @R1
    MOV @R0, A
    RET
ADDFUNC:
    MOV A, @R0
    ADDC A, @R1
    MOV @R1, A
    RET


