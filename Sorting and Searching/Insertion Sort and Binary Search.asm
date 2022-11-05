.MODEL SMALL 
.STACK 100H 
.DATA

    N DW ?
    CNT DW ?
    CR EQU 0DH
    LF EQU 0AH
    
    SPC DB ', $'
    MSG1 DB CR, LF, 'ENTER ARRAY SIZE: $'
    PRMT DB CR, LF, 'ENTER NUMBERS (SPACE SEPARATELY): $'
    TERMI DB CR, LF, 'PROGRAM TERMINATED$'
    PRI_PRMT DB CR, LF, 'SORTED ARRAY: [ $' 
    INPUT_PRMT DB CR, LF, 'SEARCH AN ELEMENT (PRESS ENTER AFTER INPUT): $'
    NT_FOUND DB CR, LF, 'NOT FOUND$'
    FOUND_PRMT DB CR, LF, 'FOUND AT INDEX: $'
    
    RB DB ']$'
    NEG_SIGN DB '-$'
    i DW ?
    j DW ?
    key DW ?
    isNeg DB ?
    temp DW ?
    
    HI DW ?
    LOW DW ?
    MID DW ?
    SEARCH DW ?
    IS_INDEX DB ?
    
    ARR DW 1000 DUP(?) ;TAKING MAX SIZE OF 1000 ELEMENTS

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, MSG1
    MOV AH, 9              
    INT 21H
    ; fast BX = 0
    XOR BX, BX
    
    CALL INPUT_BASIC
    
    CMP isNeg, 1
        JNE MAKE_POS
        NEG BX
        MOV N, BX
        JMP MAKE_NEG
      
    MAKE_POS:   
        MOV N, BX      ;BX HOLDS THE ENTIRE NUMBER
        MAKE_NEG:
        CMP N, 0       ;IF N <= 0, END THE PROG
        JLE PROG_END   
        MOV CX, N          
        JCXZ PROG_END 
    
    LEA DX, PRMT
    MOV AH, 9              
    INT 21H 
    
    LEA SI, ARR
 
    MOV CX, N
    MOV CNT, CX
    INC CNT 
    
    ARR_INPUT_LOOP:  
        XOR BX, BX
   
        ; TAKING SPACE SEPARATED INTEGERS
        CALL INPUT_ELEMENT
        
    LOOP ARR_INPUT_LOOP
        
    ;INSERTION SORT
    CALL INSERTION_SORT
    
    
    ; PRINT THE SORTED ARRAY
    CALL PRINT_ARR
    
    ;BIN SEARCH LOOP
    BIN_SEARCH_LOOP:
        CALL BIN_SEARCH 
    JMP BIN_SEARCH_LOOP      
    
    PROG_END:
        LEA DX, TERMI
        MOV AH, 9              
        INT 21H  

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP
INPUT_ELEMENT PROC
    MOV isNeg, 0
    INPUT_LOOP:
            
        ; char input 
        MOV AH, 1
        INT 21H
        
        ;if found '-'
        CMP AL, '-'
            JNE POS_NUM_ELEMENT
            MOV isNeg, 1
            JMP NEG_NUM_ELEMENT
        
        POS_NUM_ELEMENT:
        ; if found space, stop taking input
        CMP AL, ' '    
        JE END_INPUT_LOOP
        
        
        ; fast char to digit
        ; also clears AH
        AND AX, 000FH
        
        ; save AX 
        MOV CX, AX
        
        ; BX = BX * 10 + AX
        MOV AX, 10D
        MUL BX
        ADD AX, CX
        MOV BX, AX
        NEG_NUM_ELEMENT:
            JMP INPUT_LOOP
    
        END_INPUT_LOOP:
            CMP isNeg, 1
            JNE MAKE_POS_ELEMENT
            NEG BX
            MOV [SI], BX
            JMP MAKE_NEG_ELEMENT
        
        
        MAKE_POS_ELEMENT: 
            MOV [SI], BX
            MAKE_NEG_ELEMENT:
            ADD SI, 2
            DEC CNT
            MOV CX, CNT
        RET
    
INPUT_ELEMENT ENDP

INPUT_BASIC PROC
    MOV isNeg, 0
    BASIC_INPUT_LOOP:
        ; char input 
        MOV AH, 1
        INT 21H
        
        ;if found '-'
        CMP AL, '-'
        JNE POS_NUM
        MOV isNeg, 1
        JMP NEG_NUM
        
        POS_NUM:        
            ; if \n\r, stop taking input
            CMP AL, CR    
            JE END_BASIC_INPUT_LOOP
            CMP AL, LF
            JE END_BASIC_INPUT_LOOP
        
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
        
        NEG_NUM:
            JMP BASIC_INPUT_LOOP
    
    END_BASIC_INPUT_LOOP:

    RET
     
INPUT_BASIC ENDP  

PRINT_ARR PROC
    LEA DX, PRI_PRMT
    MOV AH, 9              
    INT 21H
    
    MOV CX, N
    MOV CNT, CX
    INC CNT
    
    LEA SI, ARR
    ARR_PRINT_LOOP:
        CALL PRINT_NUMBER
    LOOP ARR_PRINT_LOOP 
    
    END_ARR_PRINT_LOOP:
    LEA DX, RB
    MOV AH, 9              
    INT 21H
    RET
PRINT_ARR ENDP 

PRINT_NUMBER PROC
    
        MOV isNeg, 0
        ;OUTPUT NUMBER
        
        CMP IS_INDEX, 1
            JNE NOT_IDX 
            JMP END_IF  ;FOR PRINTING INDEX, AX WILL BE SET FROM THE PROC THAT CALLS
            
        NOT_IDX:
        MOV AX, [SI] 
        END_IF:
        ;IF THE NUMBER IS NEGATIVE
        CMP AX,  0
            JGE POS_SHOW
            MOV isNeg, 1 
            NEG AX
        
        POS_SHOW:
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
        CMP isNeg, 0
        JE NO_NEG_SIGN_SHOW
            LEA DX, NEG_SIGN
            MOV AH, 9              
            INT 21H  
                
        NO_NEG_SIGN_SHOW:
        OUT_LOOP2:
        	POP DX ;Pops from stack to DX
        	ADD DX, 30H ;Converts to its ASCII equivalent
        	MOV AH, 2
        	INT 21H
        	LOOP OUT_LOOP2 ;Loops till CX equals zero
        
        ADD SI, 2
        DEC CNT
        MOV CX, CNT
        LEA DX, SPC
        MOV AH, 9              
        INT 21H
     RET
PRINT_NUMBER ENDP

INSERTION_SORT PROC
    LEA SI, ARR
    MOV CX, N
    DEC CX      ; starting loop for 1 to n-1   
    MOV i, 2    ;TO GET THE 1ST(0 INDEXING) WORD IN THE ARRAY
    
    FOR_LOOP:
        LEA SI, ARR  
        ADD SI, i
        MOV BX, [SI]
        MOV key, BX
        MOV BX, i
        MOV j, BX
        SUB j, 2     ; word size = 2bytes
        
        SWAP_LOOP:
            CMP j, 0
                JNGE END_SWAP_LOOP
                MOV BX, key 
                LEA SI, ARR
                ADD SI, j
                CMP [SI], BX
                    JNG END_SWAP_LOOP
            
            ; ENTERING THE SWAP
            MOV BX, j
            MOV temp, BX
            ADD temp, 2
            LEA SI, ARR
            ADD SI, j
            MOV BX, [SI]
            LEA SI, ARR
            ADD SI, temp 
            MOV [SI], BX
            SUB J, 2    ; j=j-1    
            JMP SWAP_LOOP
                
        END_SWAP_LOOP:
        MOV BX, j
        MOV temp, BX
        ADD temp, 2
        MOV BX, key 
        LEA SI, ARR
        ADD SI, temp
        MOV [SI], BX 
        
        ADD i, 2
   
    LOOP FOR_LOOP
    
    RET
INSERTION_SORT ENDP

BIN_SEARCH PROC
    
    LEA DX, INPUT_PRMT
    MOV AH, 9              
    INT 21H
    
    XOR BX, BX
    CALL INPUT_BASIC
    CMP isNeg, 1
        JNE MAKE_POS2
        NEG BX
        MOV SEARCH, BX
        JMP MAKE_NEG2
      
    MAKE_POS2:   
        MOV SEARCH, BX      ;BX HOLDS THE ENTIRE NUMBER
        MAKE_NEG2:
        MOV CX, N                  
        
    MOV LOW, 0
    MOV AX, 0
    ADD AX, N
    ADD AX, N
    SUB AX, 2   ;HI = 2N-2
    MOV HI, AX  
    
    LEA SI, ARR
    BIN_S_LOOP:
        MOV BX, HI
        CMP LOW, BX
            JNLE END_BIN_S_LOOP
        
        MOV AX, HI
        ADD AX, LOW 
        MOV BX, 2
        DIV BX    
        AND AX, 0000000011111111B   ;CLEARING AH AND SAVING ONLY AL   
        CALL FIX_INDEX   ;THIS WILL FIX AX 
        LEA SI, ARR      ; 2 DIYE DIV KORAR PORE ODD NUMBER ASHLE PABE NA KISU
        ADD SI, AX    ;AX IS THE MID INDEX  
        MOV MID, AX   
        
        MOV BX, SEARCH
        CMP [SI], BX
            JL BIGGER
        ;ELSE IF 
        MOV BX, SEARCH
        CMP [SI], BX
            JE FOUND 
            JMP ELSE
            
        BIGGER: 
            MOV LOW, AX
            ADD LOW, 2 
            JMP BIN_S_LOOP
        
        FOUND:
            LEA DX, FOUND_PRMT
            MOV AH, 9              
            INT 21H 
            
            MOV IS_INDEX, 1  
            MOV AX, MID
            MOV BX, 2   
            xor dx, dx
            DIV BX ;DIV BY 2 TO GET INDEX IN THE ARRAY, NOT THE BYTE POSITION   
            INC AX ;INDEXING STARTS FROM 1
                
            CALL PRINT_NUMBER  
            RET
            
        ELSE:
            MOV HI, AX
            SUB HI, 2
            JMP BIN_S_LOOP    
        
    END_BIN_S_LOOP:
        MOV BX, HI
        CMP LOW, BX
            JG NOT_FOUND:
            RET
    
    NOT_FOUND:
        LEA DX, NT_FOUND
        MOV AH, 9              
        INT 21H
    
    RET
BIN_SEARCH ENDP 

FIX_INDEX PROC
    ;SUB 1 FROM AX IF ODD
    MOV temp, AX
    AND temp, 1B
    CMP temp, 1
    JE ODD
    
    JMP EVEN
    
    ODD:
        SUB AX, 1
    
    EVEN:
    
    RET
    
FIX_INDEX ENDP

END MAIN 


