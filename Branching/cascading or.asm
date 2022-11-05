; CHAIN OR: IF(X ==0 OR Y == 1 OR Y > 5) ELSE IF(X = 1 AND Y = 0) ELSE ...
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER TWO NUMBERS (SINGLE DIGIT): $' 
MSG5 DB CR, LF, 'RESULT IS: $'
MSG2 DB CR, LF, 'ENTERED IF BLOCK$' 
MSG3 DB CR, LF, 'ENTERED ELSE IF BLOCK$'
MSG4 DB CR, LF, 'ENTERED ELSE BLOCK$'

X DB ?
Y DB ?
   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
        
                 
        ;INPUT CHAR
        LEA DX, MSG1
        MOV AH, 9              
        INT 21H
        MOV AH, 1
        INT 21H              
        MOV X, AL
        SUB X, '0'
        
        MOV AH, 1
        INT 21H              
        MOV Y, AL
        SUB Y, '0'
           ; CHAIN OR: IF(X ==0 OR Y == 1 OR Y > 5) ELSE IF(X = 1 AND Y = 0) ELSE ...
        CMP X, 0
        JE IF_BLOCK 
        CMP Y, 1
        JE IF_BLOCK
        CMP Y, 5
        JG IF_BLOCK
        JMP ELSE_IF

        IF_BLOCK:
        LEA DX, MSG2
        MOV AH, 9              
        INT 21H
        
        JMP END_IF
        
        ELSE_IF:
        CMP X, 1
        JNE ELSE_BLOCK
        CMP Y, 0
        JNE ELSE_BLOCK
        
        LEA DX, MSG3
        MOV AH, 9              
        INT 21H
        
        JMP END_IF
        
        ELSE_BLOCK:
        LEA DX, MSG4
        MOV AH, 9              
        INT 21H         
        
        END_IF:
                
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H            
        
MAIN ENDP
END MAIN