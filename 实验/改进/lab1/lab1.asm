MYSTACK SEGMENT STACK
        DW 20 DUP(0)
MYSTACK ENDS

DATA SEGMENT

CRLF       DB  0DH,0AH,'$'                 ;��ֹ������ 
msgHel     DB  'Hello World!','$'          ;������ַ���,$������
tipINam    DB  'Input your name','$'       ;��ʾ��������
tipINum    DB  'Input your number','$'     ;��ʾ����ѧ��
tipONam    DB  'this is your name:','$'    ;��ʾ�������
tipONum    DB  'this is your number:','$'  ;��ʾ�������
tipQuit    DB	0DH,0AH,'byebye','$'		  ;quit

msg2    DB  'hello, please enter a letter(q or Q to quit)','$'
msg3    DB  ' ASCII is:','$'
char    DB  ?

buffer1 DB  20  ;Ԥ����20�ֽڿռ�
        DB  ?   ;������ɺ��Զ���ȡ�ֽ���
        DB  20  DUP(?)

buffer2 DB  20  
        DB  ?   
        DB  20  DUP(?)

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:MYSTACK
START:
    MOV AX, DATA    ;��ֵDATA�Ķε�ַ��DS�Ĵ���
    MOV DS, AX

    LEA DX, msgHel     ;���ָ���ַ���
    MOV AH, 09H     
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX, tipINam    ;�����ʾ
    MOV AH, 09H    
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX,buffer1  ;����name�ַ���
    MOV AH,0AH
    MOV AL,00H
    INT 21H

    ;���ַ������д���:��ĩβ��$��ʾ�ַ�������
    MOV AL,buffer1[1]
    ADD AL,2
    MOV AH,0
    MOV SI,AX
    MOV buffer1[SI],'$'

    LEA DX,CRLF     ;����
    MOV AH,09H
    INT 21H

    LEA DX, tipONam    ;�����ʾ
    MOV AH, 09H     
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX,buffer1[2]  ;���name�ַ���
    MOV AH,09H
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX, tipINum
    MOV AH, 09H     ;�����ʾ
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX,buffer2  ;����number�ַ���
    MOV AH,0AH
    MOV AL,00H
    INT 21H

    ;����number�ַ���,��ĩβ��$��ʾ�ַ�������
    MOV AL,buffer2[1]
    ADD AL,2
    MOV AH,0
    MOV SI,AX
    MOV buffer2[SI],'$'

    LEA DX,CRLF     ;����
    MOV AH,09H
    INT 21H

    LEA DX, tipONum
    MOV AH, 09H     ;�����ʾ
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

    LEA DX,buffer2[2]  ;���number�ַ���
    MOV AH,09H
    INT 21H

    LEA DX, CRLF    ;����
    MOV AH, 09H
    INT 21H

label1:         ;�����ַ�ֱ�������ַ�q��Q   

    LEA DX,msg2      ;�����ʾ��Ϣ
    MOV AH,09H
    INT 21H

    LEA DX,CRLF     ;����
    MOV AH,09H
    INT 21H

    MOV AH,01H      ;����һ���ַ�������
    MOV AL,00H
    INT 21H

    MOV BL,AL       ;���ַ�������BL��,��Ϊ����Ĺ��ܿ��ܻ�Ӱ�쵽AL�е�ֵ    

    CMP BL,'q'
    JZ  label2

    CMP BL,'Q'
    JZ  label2

    ;���ַ�ת����ASCII

    LEA DX,msg3
    MOV AH,09H
    INT 21H

    LEA DX,CRLF     ;����
    MOV AH,09H
    INT 21H

    ;��ȡ�ַ�����λ
    MOV AL,BL
    AND AL,0F0H
    MOV CL,4
    SHR AL,CL

    ;��0AH�Ƚ� 
    CMP AL,0AH

    JL label3

    ;����AH��Ҫ��07H
    ADD AL,07H

label3: ;������λת���������ַ�
    ADD AL,30H

    ;�����һ�������ַ�
    MOV DL,AL
    MOV AH,02H
    INT 21H

    ;��ȡ�����ַ��ĵ���λ
    MOV AL,BL
    AND AL,0FH

    CMP AL,0AH

    JL label4

    ADD AL,07H

label4: ;������λת���������ַ�

    ADD AL,30H

    ;����ڶ��������ַ�
    MOV DL,AL
    MOV AH,02H
    INT 21H
    
    MOV DL,'H'
    MOV AH,02H
    INT 21H

    LEA DX,CRLF     ;����
    MOV AH,09H
    INT 21H

    LOOP label1

label2:     ;�����ַ��ĳ���
    LEA DX,tipQuit
    MOV AH,09H
    INT 21H
    

    MOV AH,4CH      ;����DOSϵͳ
    INT 21H

CODE ENDS
END START


