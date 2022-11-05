; IF (X==2 AND (Y>2 OR Z >1)) ELSE IF(X >2 OR (Y == 2 AND Z ==4) ELSE...
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER THREE NUMBERS (SIGNLE DIGIT) : $' 
RESULT DB CR, LF, 'RESULT IS: $'
MSG2 DB CR, LF, 'IF$'
MSG3 DB CR, LF, 'ELSE IF$'
MSG4 DB CR, LF, 'ELSE$'

X DB ? 
Y DB ?
Z DB ?

   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
        
                 
        ;INPUT 
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
        
        MOV AH, 1
        INT 21H              
        MOV Z, AL
        SUB Z, '0'          
        
        ;IF (X==2 AND (Y>2 OR Z >1)) ELSE IF(X >2 OR (Y == 2 AND Z ==4) ELSE...
        CMP X, 2
        JNE ELSE_IF
        ; IF WE REACH HERE, THAT MEANS X==2, NOW CHECK THE NEXT CONDITION
        CMP Y, 2
        JG FIRST_IF
        ; REACHING HERE MEANS Y IS NOT GREATER THAN 2, TEST THE REST OF THE OR LOGIC
        CMP Z, 1
        JG FIRST_IF
        JMP ELSE_IF
        
        FIRST_IF:
        LEA DX, MSG2
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        
        ELSE_IF:
        CMP X, 2
        JG ELSE_IF_BLOCK
        CMP Y, 2
        JNE ELSE
        CMP Z, 4
        JNE ELSE
        
        ELSE_IF_BLOCK:
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