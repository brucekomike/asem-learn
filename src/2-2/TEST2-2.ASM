ORG 0001H

MAIN:
   ACALL INIT
   ACALL INIT1
   ACALL MULTFUNC
   ACALL INIT
   ACALL INIT2
   ACALL MULTFUNC
   ACALL INIT
   ACALL INIT3
   ACALL MULTFUNC
   ACALL INIT
   ACALL INIT4
   ACALL MULTFUNC
   ACALL INIT
   ACALL INIT5
   ACALL MULTFUNC
   ACALL INIT
   SJMP MAIN



MULTFUNC:
    MOV A, R4
    MOV B, R2
    MUL AB
    MOV 26H, A
    MOV 25H, B

    MOV A, R4
    MOV B, R3
    MUL AB
    ADD A, 25H
    MOV 25H, A
    MOV A, 24H
    ADDC A, #00H
    MOV 24H, A
    MOV A, B
    ADD A, 24H
    MOV 24H, A
    MOV A, 23H
    ADDC A, #00H
    MOV 23H, A

    MOV A, R5
    MOV B, R2
    MUL AB
    ADD A, 25H
    MOV 25H, A
    MOV A, 24H
    ADDC A, #00H
    MOV 24H, A
    MOV A, B
    ADD A, 24H
    MOV 24H, A
    MOV A, 23H
    ADDC A, #00H
    MOV 23H, A

    MOV A, R5
    MOV B, R3
    MUL AB
    ADD A, 24H
    MOV 24H, A
    MOV A, 23H
    ADDC A, #00H
    MOV 23H, A
    MOV A, B
    ADD A, 23H
    MOV 23H, A

    RET

INIT:
    MOV 23H, #00H
    MOV 24H, #00H
    MOV 25H, #00H
    MOV 26H, #00H
    RET
INIT1:
    MOV R5, #0FFH
    MOV R4, #0FFH
    MOV R3, #0FFH
    MOV R2, #0FFH
    RET
INIT2:
    MOV R5, #00H
    MOV R4, #0FFH
    MOV R3, #00H
    MOV R2, #0FFH
    RET
INIT3:
    MOV R5, #0FFH
    MOV R4, #00H
    MOV R3, #0FFH
    MOV R2, #00H
    RET
INIT4:
    MOV R5, #0F0H
    MOV R4, #0F0H
    MOV R3, #0F0H
    MOV R2, #0F0H
    RET
INIT5:
    MOV R5, #0FH
    MOV R4, #0F0H
    MOV R3, #0FH
    MOV R2, #0F0H
    RET
