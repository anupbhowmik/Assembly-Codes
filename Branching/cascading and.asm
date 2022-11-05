; CHAIN AND: IF(X == 2 AND Y > 6 AND Y == 9) ELSE IF(X < 2 AND Y >= 5) ELSE ...
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER TWO NUMBERS: $' 
MSG2 DB CR, LF, 'ENTERED IN FIRST IF$'
MSG3 DB CR, LF, 'ENTERED IN FIRST ELSE IF$'
MSG4 DB CR, LF, 'ENTERED IN ELSE$'

X DB ?
Y DB ?

   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
        
                 
        ;INPUT NUMBERS
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
        
        ; IF(X == 2 AND Y > 6 AND Y == 9) ELSE IF(X < 2 AND Y >= 5) ELSE ...
        CMP X, 2
        JNE ELSE_IF1
        CMP Y, 6
        JNG ELSE_IF1
        CMP Y, 9
        JNE ELSE_IF1
        ;IF WE REACH HERE, THEN ALL THE CONDITIONS OF THE IF ARE TRUE
        LEA DX, MSG2
        MOV AH, 9              
        INT 21H
        JMP END_IF 
        
         
        
        ELSE_IF1:
        CMP X, 2
        JNL ELSE
        CMP Y, 5
        JNGE ELSE
        
        LEA DX, MSG3
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        
        ELSE:
        LEA DX, MSG4
        MOV AH, 9              
        INT 21H
        
        END_IF:        
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H            
        
MAIN ENDP
END MAIN