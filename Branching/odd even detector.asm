; odd even
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER A NUMBER: $'
EVEN DB CR, LF, 'EVEN$'
ODDMSG DB CR, LF, 'ODD$' 

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
        

        AND NUM, 1
        CMP NUM, 1
        JE ODD
        LEA DX, EVEN
        MOV AH, 9              
        INT 21H
        JMP END_IF
        
        ODD:
        LEA DX, ODDMSG
        MOV AH, 9              
        INT 21H
        
        END_IF:
        
        
        
        
        
                
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H            
        
MAIN ENDP
END MAIN