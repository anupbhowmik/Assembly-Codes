.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH    ;CR=CARRIEGE RETURN, 0DH IS ASCII FOR CARRIAGE RETURN            
              ;EQU FOR DEFINING CR AS 0DH (JUST RENAMING)
LF EQU 0AH    ;LF=LINE FEED,  CR AND LF COMBINEDLY CREATES LINE BREAK   
X DB ?        ;? FOR UNINITIALIZED    
Y DB ?
   
PRMP DB 'ENTER TWO SINGLE DIGIT NUMBERS:$'   

.CODE
MAIN PROC
        ;DATA SEGMENT INIT
        MOV AX, @DATA
        MOV DS, AX    
    
        ;PROMPT  
        LEA DX, PRMP
        MOV AH, 9
        INT 21H  
        
        ;INP TWO NUMBERS
        MOV AH, 1
        INT 21H
        MOV X, AL   
        
        SUB X, '0'    ; FOR MAKING IT DECIMAL FROM ASCII
        
        MOV AH, 1
        INT 21H
        MOV Y, AL  
        SUB Y, '0'
        
        ;ADD 
        MOV AL,  Y
        ;ADD X, Y  NOT VALID, CANNOT OPERATE ON TWO MEMORY ELEMENTS
        ADD X, AL  
       
        ADD X, '0'   ;FOR MAKING IT ASCII
     
        
        
        ;PRINT   
        MOV DL, CR
        MOV AH, 2
        INT 21H   
        MOV DL, LF
        MOV AH, 2
        INT 21H
        
        MOV DL, X
        MOV AH, 2
        INT 21H  
        
        ;DOS EXIT
        MOV AH, 4CH
        INT 21H               
        
        
MAIN ENDP
END MAIN