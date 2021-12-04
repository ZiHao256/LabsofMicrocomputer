MYSTACK SEGMENT STACK
        DW 20 DUP(0)
MYSTACK ENDS

DATA SEGMENT

CRLF    DB  0DH,0AH,'$'                 ;终止并换行 
msg     DB  'Hello World!','$'          ;待输出字符串,$结束符
tip1    DB  'enter your name','$'       ;提示输入姓名
tip2    DB  'enter your number','$'     ;提示输入学号
tip3    DB  'this is your name:','$'    ;提示输出姓名
tip4    DB  'this is your number:','$'  ;提示输出姓名

msg2     DB  'hello, please enter a letter(q or Q to quit)','$'
msg3    DB  ' ASCII is:','$'
char    DB  ?

buffer1 DB  20  ;预定义20字节空间
        DB  ?   ;输入完成后，自动获取字节数
        DB  20  DUP(?)

buffer2 DB  20  
        DB  ?   
        DB  20  DUP(?)

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:MYSTACK
START:
    MOV AX, DATA    ;赋值DATA的段地址给DS寄存器
    MOV DS, AX

    LEA DX, msg     ;输出指定字符串
    MOV AH, 09H     
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX, tip1    ;输出提示
    MOV AH, 09H    
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX,buffer1  ;接收name字符串
    MOV AH,0AH
    INT 21H

    ;对字符串进行处理:在末尾加$表示字符串结束
    MOV AL,buffer1[1]
    ADD AL,2
    MOV AH,0
    MOV SI,AX
    MOV buffer1[SI],'$'

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    LEA DX, tip3    ;输出提示
    MOV AH, 09H     
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX,buffer1[2]  ;输出name字符串
    MOV AH,09H
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX, tip2
    MOV AH, 09H     ;输出提示
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX,buffer2  ;接收number字符串
    MOV AH,0AH
    INT 21H

    ;处理number字符串,在末尾加$表示字符串结束
    MOV AL,buffer2[1]
    ADD AL,2
    MOV AH,0
    MOV SI,AX
    MOV buffer2[SI],'$'

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    LEA DX, tip4
    MOV AH, 09H     ;输出提示
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

    LEA DX,buffer2[2]  ;输出number字符串
    MOV AH,09H
    INT 21H

    LEA DX, CRLF    ;换行
    MOV AH, 09H
    INT 21H

label1:         ;输入字符直到输入字符q或Q   

    LEA DX,msg2      ;输出提示信息
    MOV AH,09H
    INT 21H

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    MOV AH,01H      ;接收一个字符并回显
    INT 21H

    MOV BL,AL       ;将字符保存在BL中,因为后面的功能可能会影响到AL中的值    

    CMP BL,'q'
    JZ  label2

    CMP BL,'Q'
    JZ  label2

    ;将字符转换成ASCII

    LEA DX,msg3
    MOV AH,09H
    INT 21H

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    ;获取字符高四位
    MOV AL,BL
    AND AL,0F0H
    MOV CL,4
    SHR AL,CL

    ;和0AH比较 
    CMP AL,0AH

    JL label3

    ;大于AH则要加07H
    ADD AL,07H

label3: ;将高四位转换成数字字符
    ADD AL,30H

    ;输出第一个数字字符
    MOV DL,AL
    MOV AH,02H
    INT 21H

    ;获取输入字符的低四位
    MOV AL,BL
    AND AL,0FH

    CMP AL,0AH

    JL label4

    ADD AL,07H

label4: ;将低四位转换成数字字符

    ADD AL,30H

    ;输出第二个数字字符
    MOV DL,AL
    MOV AH,02H
    INT 21H

    LEA DX,CRLF     ;换行
    MOV AH,09H
    INT 21H

    LOOP label1

label2:     ;输入字符的出口


    MOV AH,4CH      ;返回DOS系统
    INT 21H

CODE ENDS
END START

