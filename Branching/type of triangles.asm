; TRIANGLE CLASSIFY
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER THREE NUMBERS (SIGNLE DIGIT) : $' 
RESULT DB CR, LF, 'RESULT IS: $'
MSG2 DB CR, LF, 'EQUILATERAL$'
MSG3 DB CR, LF, 'ISOCELES$'
MSG4 DB CR, LF, 'SCALENE$'
MSG5 DB CR, LF, 'TRIANGLE$'
MSG6 DB CR, LF, 'NOT A TRIANGLE$'

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
        
        ;IF SUM OF ANY TWO SIDES IS SMALLER THAN THE THIRD THEY DO NOT FORM A TRIANGLE, LET'S TRY OR RELATION
        MOV BH, X
        MOV BL, Y
        MOV CL, Z
        
        ADD X, BL   ;X+Y<Z?        ;KEEPING BH, BL, CL INTACT
        CMP X, CL
        JL NOT_TRIANGLE
        ADD Y, BL   ;Y+Z<X?
        CMP Y, BH
        JL NOT_TRIANGLE 
        ADD Z, BH   ;X+Z<Y?
        CMP Z, BL
        JL NOT_TRIANGLE
        
        ;NOW IT'S A TRIANGLE
        LEA DX, MSG5
        MOV AH, 9              
        INT 21H
        ;CLASSIFY THE TRIANGLE
        CMP BH, BL
        JNE NOT_EQ
        CMP BH, CL
        JNE NOT_EQ
        CMP CL, BL
        JNE NOT_EQ
        
        LEA DX, MSG2
        MOV AH, 9              
        INT 21H
        
        JMP END_IF  
        
        NOT_EQ:
        CMP BH, BL
        JE ISOCELES
        CMP BH, CL
        JE ISOCELES
        CMP CL, BL
        JE ISOCELES
        
        LEA DX, MSG4
        MOV AH, 9              
        INT 21H
        
        JMP END_IF
        
        ISOCELES:
        ;THIS IS THE ELSE BLOCK
        LEA DX, MSG3
        MOV AH, 9              
        INT 21H
        
        JMP END_IF 
        
        NOT_TRIANGLE:
        LEA DX, MSG6
        MOV AH, 9              
        INT 21H
        
        END_IF:
        
                
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H            
        
MAIN ENDP
END MAIN