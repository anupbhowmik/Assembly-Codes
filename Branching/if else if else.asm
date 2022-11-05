; if(x=1) then one else if(x=2) two else if(x=3) three, invalid
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER A NUMBER: $' 
MSG3 DB CR, LF, 'RESULT IS: $'
ONE DB CR, LF, 'ONE$'
TWO DB CR, LF, 'TWO$'
THREE DB CR, LF, 'THREE$'
OTHER DB CR, LF, 'OTHER$' 

NUM DB ?

   

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
        MOV NUM, AL         
        
        SUB NUM, '0'
        CMP NUM, 1
        JNE SECOND_COND  
        LEA DX, ONE
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        SECOND_COND:
        CMP NUM, 2
        JNE THIRD_COND
        LEA DX, TWO
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        THIRD_COND: 
        CMP NUM, 3
        JNE ELSE
        LEA DX, THREE
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        ELSE:
        LEA DX, OTHER
        MOV AH, 9              
        INT 21H
        
        END_IF:
        
  
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H            
        
MAIN ENDP
END MAIN