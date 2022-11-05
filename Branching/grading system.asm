;GRADING SYSTEM
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    
LF EQU 0AH
NL DB CR, LF    

MSG1 DB CR, LF, 'ENTER MARKS: $' 
RESULT DB CR, LF, 'RESULT IS: $'
INVAL DB CR, LF, 'INVALID$'
A_GRADE DB CR, LF, 'A$'
F_GRADE DB CR, LF, 'F$'
A_PLUS_GRADE DB CR, LF, 'A+$'

X DB ? 
Y DB ?
Z DB ?
N DW ?
   

.CODE
MAIN PROC
    ;DATA SEGMENT INIT
    MOV AX, @DATA
    MOV DS, AX    
    
    
             
    
    LEA DX, MSG1
    MOV AH, 9              
    INT 21H
    
    ; TAKE INPUT    
    ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    
    ; fast char to digit
    ; also clears AH
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    MOV N, BX  ; N HOLDS THE ENTIRE NUMBER
    
    ; 0-60 F, 61-80 A, 81-100 A+, ELSE INVALID
    CMP N, 0
    JL INVALID
    CMP N, 60
    JG A
    JMP F
    
    
    A: 
    ;NOW MARKS>60
    CMP N, 80
    JG A_PLUS
    
    
    
    LEA DX, A_GRADE
    MOV AH, 9              
    INT 21H
    JMP END_CASE
    
    A_PLUS:
    CMP N, 100
    JG INVALID
    LEA DX, A_PLUS_GRADE
    MOV AH, 9              
    INT 21H
    JMP END_CASE
    
    
    
    F:
    LEA DX, F_GRADE
    MOV AH, 9              
    INT 21H
    JMP END_CASE
    
    INVALID:
    LEA DX, INVAL
    MOV AH, 9              
    INT 21H
    
    END_CASE:

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
        
          
        
MAIN ENDP
END MAIN