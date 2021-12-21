MY_STACK SEGMENT PARA 'STACK'
         DB    100 DUP(?)
MY_STACK ENDS

MY_DATA SEGMENT PARA 'DATA'
IO_9054base_address DB 4 DUP(0)
IO_base_address     DB 4 DUP(0)
pciacardbotfind     DB 0DH,OAH,'pci card not find or address/interrupt error!!!',0DH,0AH,'$'
GOOD                DB 0DH,0AH,'The program is Executing!',0DH,0AH,'$'
STR_1               DB 0DH,0AH,'南北红，东西绿',0DH,0AH,'$'
STR_2               DB 0DH,0AH,'南北红，东西黄',0DH,0AH,'$'
STR_3               DB 0DH,0AH,'南北绿，东西红',0DH,0AH,'$'
STR_4               DB 0DH,0AH,'南北黄，东西红',0DH,0AH,'$'
STR_END             DB 0DH,0AH,'模拟结束',0DH,0AH,'$'
p8255a      DW  0000H
P8255b      DW  0001H 
P8255c      DW  0002H 
P8255mode      DW  0003H 

DELAY_SET EQT   0FFFH   ;延时常数
MY_DATA ENDS

MY_CODE SEGMENT PARA 'CODE'
MY_PROC PROC    FAR
        ASSUME  CS:MY_CODE,DS:MY_DATA,SS:MY_STACK

MAIN:
.386
        MOV AX,MY_DATA
        MOV DS,AX
        MOV ES,AX
        MOV AX,MY_STACK
        MOV SS,AX
        CALL FINDPCI
        MOV CX,word ptr IO_base_address

        ADD p8255a,CX
        ADD P8255b,CX
        ADD P8255c,CX
        ADD P8255mode,CX
;插入功能实现
READ1:
        MOV   AX,80H
        MOV   DX,P8255mode
        OUT   DX,AX

        MOV   DX,p8255a
        MOV   AL,11011110b
        OUT   DX,AL
        MOV   AH,09H
        MOV   DX,OFFSET STR_1
        INT   21H
        MOV   CX,2O
    LOP_1   CALL DELAY
        LOOP LOP_1

         MOV   DX,p8255a
        MOV   AL,10111110b
        OUT   DX,AL
        MOV   AH,09H
        MOV   DX,OFFSET STR_2
        INT   21H
        MOV   CX,2O
    LOP_2   CALL DELAY
        LOOP LOP_2
        
         MOV   DX,p8255a
        MOV   AL,11101101b
        OUT   DX,AL
        MOV   AH,09H
        MOV   DX,OFFSET STR_3
        INT   21H
        MOV   CX,2O
    LOP_3   CALL DELAY
        LOOP LOP_3

         MOV   DX,p8255a
        MOV   AL,11011011b
        OUT   DX,AL
        MOV   AH,09H
        MOV   DX,OFFSET STR_4
        INT   21H
        MOV   CX,2O
    LOP_4   CALL DELAY
        LOOP LOP_4
        MOV AH,09H
        MOV DX,OFFSET STR_END
        INT 21H
        JMP READ1
MY_PROC     ENDp