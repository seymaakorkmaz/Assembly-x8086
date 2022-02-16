SSEG 		SEGMENT PARA STACK 'STACK'
			DW 32 DUP (?)
SSEG 		ENDS

DSEG		SEGMENT PARA 'DATA'
dizi		DW 100 DUP(?)
link 		DW 100 DUP(?)
CR			EQU 13
LF			EQU 10
HATA		DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
M1			DB CR,LF,  '  ---------------MENU-----------------  ',CR,LF,0
M2			DB CR, LF, '       1.Diziyi olustur                 ',0
M3			DB CR, LF, '       2.Diziyi ve linkleri goruntule   ',0
M4			DB CR, LF, '       3.Diziye yeni eleman ekle        ',0
M5 			DB CR, LF, '       4. CIKIS                         ',CR,LF,0
M1_			DB CR, LF, '  ------------------------------------  ',CR,LF,0
isim		DB CR,LF,  '  ------Seymanur Korkmaz/20011055------ ',CR,LF,0
altsatir    DB CR,LF, ' ',CR,LF,0
space		DB ' | ',0
sayilar		DB CR, '   DIZI  : ',0
LINKLEr		DB CR, '   LINK  : ',0
indisler	DB CR, '   INDIS : ',0
mesaj		DB CR,LF, '   Yalnizca 1 kez dizi olusturabilirsiniz.Baska bir islem seciniz!!',0
mesaj2		DB CR,LF, '   Dizinin eleman sayisi 0 dan buyuk olmalidir.',0
mesaj3		DB CR,LF, '   Dizi olusturmadan diger islemleri secemezsiniz. Oncelikle dizi olusturunuz!!!',0
M6			DB CR,LF, '   Islem seciniz ',0
A1			DB CR,LF, '   Eleman sayisini giriniz : ',0
A2			DB  '   Eleman giriniz : ',0
x           DB 0
n			DW ?
head 		DW ?
secim 		DW 0
DSEG 		ENDS 

CSEG 		SEGMENT PARA 'CODE'
			ASSUME CS:CSEG, DS:DSEG, SS:SSEG
ANA 		PROC FAR
			PUSH DS
			XOR AX,AX
			PUSH AX
			MOV AX, DSEG  
			MOV DS, AX
			MOV head,-1			
L1:	   		MOV AX, OFFSET isim
			CALL PUT_STR
			MOV AX, OFFSET M1   
			CALL PUT_STR	
			MOV AX, OFFSET M2
			CALL PUT_STR			        
			MOV AX, OFFSET M3	
			CALL PUT_STR
			MOV AX, OFFSET M4
			CALL PUT_STR
			MOV AX, OFFSET M5
			CALL PUT_STR
			MOV AX, OFFSET M1_
			CALL PUT_STR
			MOV AX, OFFSET M6
			CALL PUT_STR
			
			CALL GETN 
			MOV secim,AX
			CMP secim,1
			JE altmenu1
			CMP secim,2
			JE altmenu2
			CMP secim,3
			JE altmenu3
			CMP secim,4
			JE cikis

altmenu1:   INC x
			CMP x,1
			JG cik
			XOR SI,SI
			CALL OLUSTUR
			JMP L1		  	
			
altmenu2:	CMP x,0
			JE cik2
			CALL GORUNTULE
			JMP L1   	   	
			
altmenu3:   CMP x,0
			JE cik2
			CALL EKLE	
			JMP L1			
			
cik2:		MOV AX, OFFSET mesaj3
			CALL PUT_STR	
			JMP L1
cik:		MOV AX, OFFSET mesaj
			CALL PUT_STR	
			JMP L1
cikis:	    RETF 
ANA 	 	ENDP

OLUSTUR 	PROC NEAR	
			MOV AX, OFFSET isim
			CALL PUT_STR
			MOV AX,OFFSET M2
			CALL PUT_STR
tekrar:		MOV AX,OFFSET mesaj2
			CALL PUT_STR
			MOV AX,OFFSET A1
			CALL PUT_STR
			;XOR SI,SI
			CALL GETN			
			CMP AX,0
			JL tekrar
			MOV n,AX
			MOV CX,AX 		    
dongu:		MOV AX,OFFSET A2
			CALL PUT_STR
			CALL GETN			
			MOV dizi[SI],AX
			CALL LINKLE			
			MOV head,AX	         
			;CALL PUTN					
			ADD SI,2			
			LOOP dongu			
			RET
OLUSTUR		ENDP

GORUNTULE   PROC NEAR		
			MOV AX,OFFSET isim
			CALL PUT_STR
			MOV AX, OFFSET M3
			CALL PUT_STR
			MOV AX,OFFSET altsatir
			CALL PUT_STR
			XOR DI,DI	
			SHR SI,1
			MOV CX,SI
			SHL SI,1
			XOR DX,DX
			MOV AX,OFFSET indisler
			CALL PUT_STR
indis:		MOV AX,DX
			CALL PUTN
			INC DX
			MOV AL,' '
			CALL PUTC
			MOV AX,OFFSET space
			CALL PUT_STR
			LOOP indis 
			MOV AX,OFFSET altsatir
			CALL PUT_STR
			XOR DI,DI			
			SHR SI,1	
			MOV CX,SI			
			SHL SI,1
			MOV AX,OFFSET sayilar
			CALL PUT_STR
yazdizi:	MOV AX,dizi[DI]		
			CALL PUTN
			MOV AX,' '
			CALL PUTC
			MOV AX,OFFSET space
			CALL PUT_STR
			ADD DI,2
			LOOP yazdizi
			MOV AX,OFFSET altsatir
			CALL PUT_STR
			XOR DI,DI	
			SHR SI,1
			MOV CX,SI
			SHL SI,1
			MOV AX,OFFSET LINKLEr
			CALL PUT_STR
yazlink:	MOV AX,link[DI]
			CMP AX,-1			
			JE bol
		    SAR AX,1             
bol:		CALL PUTN
			MOV AL,' '
			CALL PUTC
			MOV AX,OFFSET space
			CALL PUT_STR
			ADD DI,2
			LOOP yazlink
			MOV AX,OFFSET altsatir
			CALL PUT_STR
			RET
GORUNTULE 	ENDP

EKLE 		PROC NEAR
			MOV AX,OFFSET isim
			CALL PUT_STR
			MOV AX, OFFSET M4
			CALL PUT_STR
			MOV AX, OFFSET altsatir
			CALL PUT_STR
			MOV AX, OFFSET A2
			CALL PUT_STR
			CALL GETN           
			MOV dizi[SI],AX		
			CALL LINKLE			
			MOV head,AX			
			ADD SI,2			
			RET
EKLE 		ENDP			

LINKLE PROC NEAR
			PUSH CX
			PUSH DI
			MOV AX,head		
			CMP AX,-1		    
			JNE else_0
			MOV AX,0	        
			MOV BX,0  	       
			MOV link[0],-1     
			JMP son 
else_0:		PUSH BX             
			MOV BX,AX   
			MOV DI,dizi[BX]		
			POP BX					
			CMP dizi[SI],DI
			JGE else_1			
			MOV link[SI],AX		
			MOV AX,SI			
			MOV head,AX			
			JMP son	
else_1:		MOV BX,AX          
while_1:	MOV DI,dizi[BX]      
			CMP	dizi[SI],DI				
			JL if_1				 		
			CMP link[BX],-1		
			JE if_1
			MOV CX,BX           
			MOV BX,link[BX]
			JMP while_1
if_1:		CMP link[BX],-1    
			JNE else_2		
			MOV DI,dizi[BX]     
			CMP dizi[SI],DI			
			JL else_2				
			MOV link[BX],SI		
			MOV link[SI],-1		
			JMP son	
else_2:		MOV DI,CX			
			MOV DX,link[DI]		
			MOV link[SI],DX		
			MOV link[DI],SI		
		
son:		POP DI	
			POP CX			
			RET
LINKLE		ENDP
        
PUTC	PROC NEAR

        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR

        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                      
        XOR BX, BX 	                        
        XOR CX,CX	                       
NEW:
        CALL GETC	                        
        CMP AL,CR 
        JE FIN_READ	                        
        CMP  AL, '-'	                       
        JNE  CTRL_NUM	                       
NEGATIVE:
        MOV DX, -1	                        
        JMP NEW		                       
CTRL_NUM:
        CMP AL, '0'	                        
        JB error 
        CMP AL, '9'
        JA error		                
        SUB AL,'0'	                        
        MOV BL, AL	                        
        MOV AX, 10 	                       
        PUSH DX		                        
        MUL CX		                       
        POP DX		                        
        MOV CX, AX	                       
        ADD CX, BX 	                        
        JMP NEW 		               
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                       
        JMP GETN_START                         
FIN_READ:
        MOV AX, CX	                    
        CMP DX, 1	                        
        JE FIN_GETN
        NEG AX		                        
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP  

PUTN 	PROC NEAR

        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        
        PUSH DX		                        
                                            
                                           
        MOV CX, 10	                        
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                       
        PUSH AX		                       
        MOV AL, '-'	                       
        CALL PUTC
        POP AX		                       
        
CALC_DIGITS:
        DIV CX  		                    
        ADD DX, '0'	                         
        PUSH DX		                         
        XOR DX,DX	                        
        CMP AX, 0	                       
        JNE CALC_DIGITS	                    
        
DISP_LOOP:
                                           
                                            
        POP AX		                        
        CMP AX, 0 	                        
        JE END_DISP_LOOP 
        CALL PUTC 	                        
        JMP DISP_LOOP                       
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR

	PUSH BX 
        MOV BX,	AX			               
        MOV AL, BYTE PTR [BX]	            
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			           
        CALL PUTC 			               
        INC BX 				               
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			           
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP
GETC	PROC NEAR
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

CSEG 	ENDS 
	    END ANA