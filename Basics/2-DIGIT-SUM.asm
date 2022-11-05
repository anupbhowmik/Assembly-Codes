.MODEL SMALL
.STACK 100H

.DATA
X DB ?
MSG1 DB 'ENTER A SINGLE DIGIT NUMBER $'
MSG2 DB 0DH, 0AH, 'ENTER ANOTHER SECOND DIGIT NUMBER $'
MSG3 DB 0DH, 0AH, 'SUM IS '
ANS1 DB ?
ANS2 DB ?
FINISH DB '$'

.CODE

MAIN PROC
    ;initializing data segment
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, MSG1
    MOV AH,9
    INT 21H
    
    MOV AH, 1
    INT 21H 
    
    SUB AL, 48
    MOV X, AL
    
    LEA DX, MSG2
    MOV AH,9
    INT 21H
    
    MOV AH,1
    INT 21H 
    
    SUB AL, 48
    ADD X, AL
    
    MOV AH, 0
    MOV AL, X
    MOV BL, 10
    
    DIV BL
    
    MOV ANS1, AL
    ADD ANS1, 48
    
    MOV ANS2, AH
    ADD ANS2, 48
       
    LEA DX, MSG3
    MOV AH,9
    INT 21H
    
    MOV AH, 4CH
    INT 21H
    
    MAIN ENDP
END MAIN
    