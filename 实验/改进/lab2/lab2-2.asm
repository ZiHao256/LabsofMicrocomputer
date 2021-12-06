MYSTACK SEGMENT STACK
    DB	10 DUP(0)
MYSTACK ENDS

DATA SEGMENT
    msgInput    DB  0DH,0AH,'Please input the string(no more than 255):',0DH,0AH,'$'
    msgOutput   DB  0DH,0AH,'The number of digits in the string: ',0DH,0AH,'$'
    buff        DB  255, 0, 256 DUP('$') ; 包括一个回车符号 同时保证结尾一定是'$'
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:MYSTACK

START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX

    LEA DX,msgInput
    MOV AH,09H
    INT 21H

inputString:    ; input string
    LEA DX, buff
    MOV AH,0AH
    MOV AL,00H
    INT 21H

prepare:
    LEA SI,buff
    INC SI		;buffer[1]

    ; CL: store the count of input, used for loop in the future
    MOV CL,[SI]
    INC SI
    
    ;clear BX
    XOR BX, BX      ;store the number of digits

again:
    ; Check if end
    CMP BYTE PTR [SI], ' '
    JE outResult

    ; Check IF NUM
    CMP BYTE PTR [SI], '9'
    JA next
then:
    CMP BYTE PTR [SI], '0'
    JB next

isDigit:
    INC BX

next:   ; next char
    INC SI
    LOOP again

outResult:  ; OUTPUT "RESULT IS: "

    PUSH AX
    LEA DX,msgOutput
    MOV AH, 09H
    INT 21H 
    POP AX

    ; CLEAR RESISTER FOR LATER USE
    XOR CX, CX

L1: 
    SHR BX,1        ;右移1位，将最低位放入标志寄存器的CF位（最低位）
    PUSHF           ;将标志寄存器中的值压栈
    POP DX          ;标志寄存器中的值给到DX
    AND DL,1        ;高位清零，保留最低位CF
    ADD DL,30H      ;从数字转换为字符
    PUSH DX         ;因为从最低位开始读的，所以要利用先读入后输出的机制
    INC CX          ;CX记录要输出的二进制数位的数量
    CMP BX,0        ;看是否数字全部转换了
    JNE L1

    ; 以上实现了到二进制的转换，和到字符的转换，现在我们把它输出
    MOV AH,02H
L2:
    POP DX
    INT 21H
    LOOP L2 ;这里要用到上面的CX

    MOV DL,'B'
    MOV AH,02H
    INT 21H

quit:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START
