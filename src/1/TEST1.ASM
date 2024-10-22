
ORG   1000H
FAKE: MOV  A, #35H
        MOV  R0, #6FH
        MOV  SP, #07H
        MOV  R6, A
        MOV  A, #90H
        MOV  @R0, A
        MOV  60H, #41H
        MOV  41H, 60H
        MOV  DPTR, #0650H
        PUSH  60H
        PUSH  DPH
        PUSH  DPL
        POP    01H
        POP    02H
        POP    A
        XCH   A, 01H
        SJMP  $
