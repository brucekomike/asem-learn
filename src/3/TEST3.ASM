ORG  000H
MOV  R2, #0AH
MOV  R0, #50H
CLR  A
LOOP:
    MOV  @R0, A
    INC  R0
    INC A
    DJNZ  R2, LOOP
    CLR A
    MOV R2, #0AH
    MOV R0, #50H
    MOV R1, #40H
    SJMP  LOOP2
LOOP2:
    MOV A, @R0
    MOV  @R1, A
    INC  R0
    INC R1
    DJNZ  R2, LOOP2
    SJMP  $
