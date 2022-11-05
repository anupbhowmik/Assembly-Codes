.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER X: $'
MSG2 DB CR, LF, 'ENTER Y: $'  
GREET DB 'HELLO WORLD $'
MSG3 DB CR, LF, 'SUM IS: $'
ANS DB CR, LF, 'THE RESULT IS: $'

X DB ?
Y DB ?
Z DB ?

   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
        
        ;PRINTING THE GREETINGS
        LEA DX, GREET         ;LEA=LOAD EFFECTIVE ADDRESS (FOR STRING ADDRESS POINTER)    DX FOR STRING, DL FOR A SINGLE CHAR
        MOV AH, 9             ;9 IS FOR PRINTING            AH E 9 DILE STRING READ
        INT 21H               ;21H IS FOR I/O OPERATION     
                 
        ;INPUT X
        LEA DX, MSG1
        MOV AH, 9
        INT 21H
        
        MOV AH, 1     
        INT 21H
        MOV X, AL  
        
        SUB X, '0'
                
        ;MUL 3, 2
        MOV AL, 3
        MOV BH, X
        MUL BH
        
        ;PRINT THE RESULT  
        MOV DL, AL  
        ADD DL, '0'
        MOV AH, 2   
        INT 21H

                
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H                 ;INT=INTERRUPT
        
MAIN ENDP
END MAIN