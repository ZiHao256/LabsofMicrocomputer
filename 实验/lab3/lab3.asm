_STACK SEGMENT STACK 
 DW 100 DUP(?) 
_STACK ENDS 

_DATA SEGMENT WORD PUBLIC 'DATA'
IO244 EQU 0230H		 ;244(16位)片选 
IO273 EQU 0230H		 ;273(16位)片选
_DATA ENDS 

CODE SEGMENT 
START PROC NEAR 
	ASSUME CS:CODE, DS:_DATA, SS:_STACK 
	MOV AX,_DATA
	
 	MOV DX,IO244 	;片选244
	IN AX,DX 	;读取开关电平
	CMP AX,0FFFFH	;是否全高电平
	JZ  L
	
	CMP AX,0	;是否全低电平
	JZ  R
	
	
	CMP AX,870FH	;拓展
	JZ  X

	
	MOV DX,IO273	;片选273
 	OUT DX,AX	;数据输出到273的输入端口
 	
 	JMP START 	;到开头重新判断开关的电平
 	
 	
R: 	;从左向右轮流亮起
	MOV DX,IO273 	;片选273
 	MOV AX,0FFFEH	;初始化最右边led亮起 
 	
START1: ;开始轮流
	OUT DX,AX 
	
 	CALL Delay 
 	
 	TEST AX,8000H 	;此时是否最左变亮起
 	JZ START 	;若是，则到程序开头判断开关的电平
 	ROL AX,1 	;循环左移一位实现从左向右循环亮起
 	JMP START1 
 	
L: 	;从右向左轮流亮起同上
	MOV DX,IO273 
 	MOV AX,7FFFH 
 	
START2: OUT DX,AX 
 	CALL Delay 
 	CMP AX,0FFFEH 
 	JZ START 
 	ROR AX,1 	;循环右移数据实现轮流亮起
 	JMP START2 
 	
	
X:	;左右同时向中间
	MOV DX,IO273
	MOV AX,07FFEH
	
START3:	OUT DX,AX
        CALL Delay
        
	TEST AX,0180H
	JZ START
	
	;开始下一个变换
	MOV BX,AX
	MOV CX,AX
	ROL BX,1
	ROR CX,1
	
	MOV AL,BL
	MOV AH,CH
	
	JMP START3
	
Delay PROC NEAR ;延时 
Delay1: XOR CX,CX 
 	LOOP $ 
 	RET 
Delay ENDP 

START ENDP 
CODE ENDS 
 	END START


