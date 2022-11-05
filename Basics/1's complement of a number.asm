;.TITLE '1'S COMPLEMENT   '
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER A LETTER: $'
MSG2 DB CR, LF, 'ENTER Y: $'  
GREET DB 'HELLO WORLD $'
MSG3 DB CR, LF, '1 S COMPLEMENT IS: $'

CHAR DB ?
Y DB ?
Z DB ?

   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
        
                   
                 
        ;INPUT X
        LEA DX, MSG1
        MOV AH, 9               
        INT 21H
        MOV AH, 1
        INT 21H                 
        MOV CHAR, AL              
        
        XOR CHAR, 0000FFH
        
        ;PRINT RESULT
        LEA DX, MSG3
        MOV AH, 9
        INT 21H
        
        MOV DL, CHAR
        MOV AH, 2
        INT 21H

                
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H                
        
MAIN ENDP
END MAIN