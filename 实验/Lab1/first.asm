MYSTACK SEGMENT STACK
DW	  100 DUP(?)	  
MYSTACK  ENDS 

DATA  SEGMENT
	data1 DB 'hello world ','$'
	data2 DB 'enter name ','$'
	data3 DB 'enter number ','$'
	data4 DB 'enter little ','$'
	CHAR DB ?
	buffer DB 60
	       DB ?
	       DB 60 dup(?)
	changeline DB 13,10,'$'
DATA  ENDS

CODE  SEGMENT
      ASSUME DS:DATA,SS:MYSTACK,CS:CODE
START:
	;输出helloworld
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET data1
	MOV AH,09H
	INT 21H
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;输出提示
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET data2
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;输入姓名
	MOV AX,DATA
	MOV DS,AX
	
	MOV AH,0AH
	MOV AL,00H
	LEA DX,buffer
	INT 21H
	
	;输出姓名
	MOV AH,09H
	INT 21H

	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;输出提示
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET data3
	MOV AH,09H
	INT 21H
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;输入学号
	MOV AX,DATA
	MOV DS,AX
	
	MOV AH,0AH
	MOV AL,00H
	LEA DX,buffer
	INT 21H
	
	;输出学号
	MOV AH,09H
	INT 21H
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H

again:
	
	;输出提示
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET data4
	MOV AH,09H
	INT 21H
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;输入little
	MOV AX,DATA
	MOV DS,AX
	
	MOV AH,01H
	MOV AL,00H
	INT 21H
	MOV CHAR,AL
	
	CMP CHAR,'Q'
	JZ LOOP_END
	CMP CHAR,'q'
	JZ LOOP_END


	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	;little->ascii
	
	
	AND CHAR,0F0H
	CMP CHAR,'A'
	JL label1
	
	ADD CHAR,07H
label1:
	
	
	;changeline
	MOV AX,DATA
	MOV DS,AX
	
	MOV DX,OFFSET changeline
	MOV AH,09H
	MOV AL,00H
	INT 21H
	
	LOOP again

LOOP_END:	
	
	
	MOV AH,4CH
	INT 21H
	
CODE  ENDS
END START

