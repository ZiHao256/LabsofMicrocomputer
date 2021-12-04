MYSTACK   SEGMENT 
        DB 10   DUP(?)
MYSTACK   ENDS

DATA    SEGMENT

msg2     DB  'hello, please enter a letter','$'
msg3    DB  ' ASCII is:','$'
char    DB  ?
CRLF    DB  0DH,0AH,'$'


DATA    ENDS


CODE    SEGMENT
    ASSUME  CS:CODE, DS:DATA, SS:MYSTACK
START:
    MOV AX,DATA
    MOV DS,AX



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


    MOV AH,4CH
    INT 21H

CODE    ENDS
END START