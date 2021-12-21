
MY_STACK	SEGMENT	PARA 'STACK' 
			DB		100 DUP(?)
MY_STACK	ENDS
;
MY_DATA 	SEGMENT	PARA 'DATA'
IO_9054base_address DB 4 DUP(0)						;PCI卡9054芯片I/O基地址暂存空间
IO_base_address     DB 4 DUP(0)						;PCI卡I/O基地址暂存空间
pcicardnotfind		DB 0DH,0AH,'pci card not find or address/interrupt error !!!',0DH,0AH,'$'
GOOD				DB 0DH,0AH,'The Program is Executing !',0DH,0AH,'$'
LB			DB		?
LC			DB 		?
P8255_A    	DW		0000H    		
P8255_B    	DW		0001H
P8255_C    	DW		0002H
P8255_MODE 	DW		0003H

DELAY_SET	EQU	 	0FFFH	
MES2		DB '	PCI CONFIG READ ERROR!		$'
MY_DATA 	ENDs

MY_CODE 	SEGMENT PARA 'CODE'

MY_PROC		PROC	FAR		
			ASSUME 	CS:MY_CODE,	DS:MY_DATA,	SS:MY_STACK
			
START:	
.386	;386模式编译
			MOV		AX,MY_DATA
			MOV		DS,AX
			MOV		ES,AX
			MOV		AX,MY_STACK
			MOV		SS,AX
			CALL	FINDPCI					;自动查找PCI卡资源及IO口基址
			MOV		CX,word ptr IO_base_address
			ADD		P8255_A,CX				;PCI卡IO基址+偏移
        	ADD		P8255_B,CX
        	ADD		P8255_C,CX
        	ADD		P8255_MODE,CX
      		MOV 	DX,P8255_MODE           ;8255初始化，三个口全为输出  
       		MOV 	AL,90H
       		OUT 	DX,AL
       		MOV 	AL,0FFH
       		MOV 	DX,P8255_C				;B口输出
       		OUT 	DX,AL

GET:
			MOV 	DX,P8255_A				;PA口赋初值
	     	IN		AL,DX
	    	;MOV 	AL,7FH
       		TEST	AL, 01H
       		JZ 		ROLEFT
RORIGHT:       		
       		MOV 	DX,P8255_B				;PB口赋初值
       		MOV 	AL,07FH
       		OUT 	DX,AL
       		MOV 	LB,AL
       		CALL	DELAY
			MOV CX,7
LOPR:
       		MOV 	AL,LB
       		ROR 	AL,1
       		MOV 	LB,AL
       		OUT 	DX,AL
       		CALL 	DELAY
       		LOOP 	LOPR
			MOV 	AL,0FFH
			OUT 	DX,AL
			
LINE2:
			MOV 	DX,P8255_C				;PB口赋初值
       		MOV 	AL,0FEH
       		OUT 	DX,AL
       		MOV 	LC,AL
       		CALL	DELAY	
			MOV CX,7
LOPL:
       		MOV 	AL,LC
       		ROL 	AL,1
       		MOV 	LC,AL
       		OUT 	DX,AL
       		CALL 	DELAY
       		LOOP 	LOPL
			MOV 	AL,0FFH
			OUT 	DX,AL
			JMP GET


ROLEFT:       		
       		MOV 	DX,P8255_B				;PB口赋初值
       		MOV 	AL,0FEH
       		OUT 	DX,AL
       		MOV 	LB,AL
       		CALL	DELAY
			MOV CX,7
LOPR1:
       		MOV 	AL,LB
       		ROL 	AL,1
       		MOV 	LB,AL
       		OUT 	DX,AL
       		CALL 	DELAY
       		LOOP 	LOPR1
			MOV 	AL,0FFH
			OUT 	DX,AL
			
LINE21:
			MOV 	DX,P8255_C				;PB口赋初值
       		MOV 	AL,07FH
       		OUT 	DX,AL
       		MOV 	LC,AL
       		CALL	DELAY
			MOV CX,7
LOPL1:
       		MOV 	AL,LC
       		ROR 	AL,1
       		MOV 	LC,AL
       		OUT 	DX,AL
       		CALL 	DELAY
       		LOOP 	LOPL1
			MOV 	AL,0FFH
			OUT 	DX,AL
			JMP GET

MY_PROC		ENDp				
