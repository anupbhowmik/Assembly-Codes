.MODEL SMALL 
.STACK 100H 
.DATA

N DW ?
CR EQU 0DH
LF EQU 0AH

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INPUT_NUM
    
    CALL OUTPUT_NUM
     
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP  

INPUT_NUM PROC
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
    MOV N, BX 
      
INPUT_NUM ENDP 

OUTPUT_NUM PROC
    
    MOV AX, N
    MOV BX, 10D ;we divide by 10 each time
    XOR DX, DX ;Clears DX
    XOR CX, CX ;Clears CX
    
    ;Splitting process starts here
    OUT_LOOP1:
    	XOR DX, DX ;Clears DX during jump
    	DIV BX ;Divides AX by BX
    	PUSH DX ;Pushes DX(remainder) to stack
    	INC CX ;Increments counter to track the number of digits
    	CMP AX, 0 ;Checks if there is still something in AX to divide
    	JNE OUT_LOOP1 ;Jumps if AX is not zero
    
    ;Printing process starts here     
    ; printing NEWLINE
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H  
    OUT_LOOP2:
    	POP DX ;Pops from stack to DX
    	ADD DX, 30H ;Converts to it's ASCII equivalent
    	MOV AH, 2
    	INT 21H
    	LOOP OUT_LOOP2 ;Loops till CX equals zero   
    	
OUTPUT_NUM ENDP

END MAIN 


