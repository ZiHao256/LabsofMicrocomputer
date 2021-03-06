MYSTACK SEGMENT STACK
    DB 20 DUP(?)
MYSTACK ENDS

DATA SEGMENT
magInput    DB  'input the numbers(no more than 5), q or Q to quit:  ','$'
msgError    DB  0DH,0AH,'input error!','$'
msgOutput    DB  0DH,0AH,'binary:','$'
msgQuit    DB  0DH,0AH,'byebye','$'
msgcount    DB  'countferring...','$'

CRLF    DB  0DH,0AH,'$'


DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:MYSTACK
START:

    MOV AX,DATA
    MOV DS,AX    
    
again:
    LEA DX,magInput     ;输出提示信息1
    MOV AH,09H
    INT 21H

    MOV CL,5		;最多输入5位
    MOV AX,0
    MOV DX,0
    ;MOV SI,0
    MOV DI,0

inputNum:           ;输入不超过五位的十进制数
    MOV AH,01H      ;输入一个字符
    MOV AL,00H
    INT 21H


    CMP AL,' '      ;是否结束输入
    JZ  translate

    CMP AL,'q'      ;是否退出程序   
    JZ  quit

    CMP AL,'Q'      
    JZ  quit

    CMP AL,'0'	     ;输入是否合法
    JL  error

    CMP AL,'9'		;输入是否合法
    JG  error

    JMP count

error:
    CALL pError

count:                  ;按照流程图做乘10加次位操作
    SUB AL,'0'
    MOV BH,0
    MOV BL,AL
    MOV AX,DI
    PUSH BX
    MOV BX,10
    MUL BX		;BX和AX乘积：存储在DX:AX
    POP BX
    ADD AX,BX
    ;ADC DX,0
    ;MOV SI,DX
    MOV DI,AX		;将计算结果存入DI

    LOOP    inputNum

translate:              ;转换二进制形式
    LEA DX,msgOutput    ;输出提示信息
    MOV AH,09H
    INT 21H

    LEA DX,CRLF         ;换行
    MOV AH,09H
    INT 21H

    ;MOV BX,SI           ;调用10进制转换成2进制的函数转为换高16位
    ;CALL I2B
    MOV BX,DI		;转换为低16位二进制
    CALL I2B

    MOV DL,'B'		;二进制数字最后添加B
    MOV AH,02H
    INT 21H

    LEA DX,CRLF         ;换行
    MOV AH,09H
    INT 21H

    JMP again

quit:                  ;退出程序

    LEA DX,msgQuit     ;输出提示信息4
    MOV AH,09H
    INT 21H

    LEA DX,CRLF         ;换行
    MOV AH,09H
    INT 21H

    MOV AH,4CH          ;返回DOS操作系统
    INT 21H

I2B:                    
    MOV CX,16
RS:                     ;对于BX中处理好的数据的每一位,将其转换为字符并从低位开始压栈
    MOV AX,BX           
    AND AX,01H          
    MOV DL,AL
    ADD DL,'0'		;将01转换为字符输出
    PUSH DX             ;因为输出顺序是高位二进制先输出，所以压栈
    SHR BX,1            ;对于ASCII的每一位
    LOOP RS
    
    MOV CX,16
outputBnum:  		;将栈中的数据从高位开始pop
    POP DX
    MOV AH,02H		;输出到屏幕
    INT 21H
    LOOP outputBnum
    RET


pError:
    LEA DX,msgError ;输出提示信息
    MOV AH,09H
    INT 21H

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    RET

CODE ENDS
END START
