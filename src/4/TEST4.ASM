ORG 0000H          ; 程序起始地址
SJMP START         ; 跳转到程序开始位置

ORG 000BH          ; 定时器0中断向量地址
AJMP TIMER0_ISR    ; 定时器0中断服务程序入口

START:
    MOV P1, #0FFH  ; 配置P1端口为输入（如果需要）
    MOV P2, #0FFH  ; 配置P2端口为输入（如果需要）
    MOV P3, #0FFH  ; 配置P3端口为输入（如果需要）

    ; 初始化时间为 00:00:00
    MOV R0, #0     ; 小时的十位
    MOV R1, #0     ; 小时的个位
    MOV R2, #0     ; 分钟的十位
    MOV R3, #0     ; 分钟的个位
    MOV R4, #0     ; 秒的十位
    MOV R5, #0     ; 秒的个位

    ; 初始化定时器0
    MOV TMOD, #01H ; 设置定时器0为模式1（16位定时器）
    MOV TH0, #04FH ; 定时器高字节初值
    MOV TL0, #0C0H ; 定时器低字节初值
    SETB TR0       ; 启动定时器0
    SETB ET0       ; 使能定时器0中断
    SETB EA        ; 使能全局中断

MAIN_LOOP:
    ; 显示秒的个位
    MOV DPTR, #08002H
    MOV A, #01H        ; 选择第6位数码管（Q7）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R5
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    ; 显示秒的十位
    MOV DPTR, #08002H
    MOV A, #02H        ; 选择第5位数码管（Q6）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R4
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    ; 显示分钟的个位
    MOV DPTR, #08002H
    MOV A, #04H        ; 选择第4位数码管（Q5）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R3
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    ; 显示分钟的十位
    MOV DPTR, #08002H
    MOV A, #08H        ; 选择第3位数码管（Q4）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R2
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    ; 显示小时的个位
    MOV DPTR, #08002H
    MOV A, #10H        ; 选择第2位数码管（Q3）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R1
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    ; 显示小时的十位
    MOV DPTR, #08002H
    MOV A, #20H        ; 选择第1位数码管（Q2）
    MOVX @DPTR, A
    MOV DPTR, #08004H
    MOV A, R0
    ACALL CONVERT      ; 转换为段码
    MOVX @DPTR, A
    ACALL DELAY        ; 延时

    SJMP MAIN_LOOP     ; 循环刷新显示

TIMER0_ISR:
    ; 定时器0中断服务程序
    ; 每50ms进一次中断，累积10次为1秒
    PUSH ACC
    PUSH PSW

    MOV A, COUNTER
    INC A
    CJNE A, #20, NOT_ONE_SECOND
    MOV A, #0
    MOV COUNTER, A
    ACALL UPDATE_TIME
    SJMP END_ISR

NOT_ONE_SECOND:
    MOV COUNTER, A

END_ISR:
    MOV TH0, #3CH      ; 重装定时器初值
    MOV TL0, #0B0H
    ;MOV TH0, #0FFH      ; 重装定时器初值
    ;MOV TL0, #0F0H       ; test
    CLR TF0            ; 清除定时器0溢出标志

    POP PSW
    POP ACC
    RETI

UPDATE_TIME:
    ; 更新时间
    INC R5
    CJNE R5, #0AH, END_UPDATE

    ; 秒个位进位到十位
    MOV R5, #00H
    INC R4
    CJNE R4, #06H, END_UPDATE

    ; 秒十位进位到分钟个位
    MOV R4, #00H
    INC R3
    CJNE R3, #0AH, END_UPDATE

    ; 分钟个位进位到十位
    MOV R3, #00H
    INC R2
    CJNE R2, #06H, END_UPDATE

    ; 分钟十位进位到小时个位
    MOV R2, #00H
    INC R1
    CJNE R0, #02H, TIME2 ; 小时十位进位后检查是否超过24小时
    CJNE R1, #04H, TIME2
    MOV R0, #00H
    MOV R1, #00H
TIME2:    
    CJNE R1, #0AH, END_UPDATE

    ; 小时个位进位到十位
    MOV R1, #00H
    INC R0



END_UPDATE:
    RET


CONVERT:
    ; 数码管段码转换子程序
    ; 输入: A = 0-9
    ; 输出: A = 对应的段码
    CJNE A, #00H, DIGIT_1
    MOV A, #3FH         ; 段码 0
    RET
DIGIT_1:
    CJNE A, #01H, DIGIT_2
    MOV A, #06H         ; 段码 1
    RET
DIGIT_2:
    CJNE A, #02H, DIGIT_3
    MOV A, #5BH         ; 段码 2
    RET
DIGIT_3:
    CJNE A, #03H, DIGIT_4
    MOV A, #4FH         ; 段码 3
    RET
DIGIT_4:
    CJNE A, #04H, DIGIT_5
    MOV A, #66H         ; 段码 4
    RET
DIGIT_5:
    CJNE A, #05H, DIGIT_6
    MOV A, #6DH         ; 段码 5
    RET
DIGIT_6:
    CJNE A, #06H, DIGIT_7
    MOV A, #7DH         ; 段码 6
    RET
DIGIT_7:
    CJNE A, #07H, DIGIT_8
    MOV A, #07H         ; 段码 7
    RET
DIGIT_8:
    CJNE A, #08H, DIGIT_9
    MOV A, #7FH         ; 段码 8
    RET
DIGIT_9:
    CJNE A, #09H, DIGIT_END
    MOV A, #6FH         ; 段码 9
    RET
DIGIT_END:
    MOV A, #00H         ; 默认段码
    RET

DELAY:
    ; 简单延时子程序
    MOV R6, #2        ; 调整延时长度
DELAY_LOOP1:
    MOV R7, #250        ; 调整延时长度
DELAY_LOOP2:
    DJNZ R7, DELAY_LOOP2
    DJNZ R6, DELAY_LOOP1
    RET

COUNTER: DB 0           ; 定时器中断计数器

END
