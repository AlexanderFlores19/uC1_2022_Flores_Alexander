;--------------------------------------------------------------
; @file	  =EJERCICIO_2.s
; @brief  = Este programa muestra como se comportan las interrupciones de alta y baja
;	    prioridad mediante una secuencia de leds que se interrumpe cada vez que se 
;           presiona uno de los tres pulsadores, para este caso hemos ultilizado
;           el INT0 para baja prioridad y el INT1 con el INT2 para alta prioridad.
; @date   = 26/01/23
; @author = Alexander Arturo Flores Juarez
; Tarjeta = Curiosity Nano PIC18F57Q84
; Entorno = MPLAB X IDE
; Idioma  = AMS 
; Frecuencia del oscilador = 4Mhz   
;------------------------------------------------------------------
        
PROCESSOR 18F57Q84
#include "Bit_config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit0
Leds_Off:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO   Repeticiones  
   
Exit0:
    RETFIE
    
    
PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT12?
    GOTO BUTTONRB4      
    GOTO BUTTONRF2
    RETFIE
         
PSECT udata_acs
contador1:  DS 1        ; reserva 1 byte en access ram
contador2:  DS 1
contador3:  DS 1
offset:	    DS 1
counter:    DS 1
counter1:   DS 1 
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    GOTO    toggle
    
    
toggle:
   BTG	   LATF,3,0         ;Complemento al LATF3
   CALL    Delay_500ms,1
   BTG	   LATF,3,0         ;Complemento al LATF3
   CALL    Delay_500ms,1
   goto	   toggle
   
;Implementamos el Computed Goto 
Loop1:
    BANKSEL PCLATU
    MOVLW   low highword(Table1)
    MOVWF   PCLATU,1
    MOVLW   high(Table1)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    Table1
    MOVWF   LATC,1
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0
    GOTO    Next_Seq
    GOTO    Reload1
Next_Seq:
    INCF    offset,1,0
    GOTO    Loop1
Reload1:
    MOVLW   0x05	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial  
    GOTO   Loop2
    
Loop2:
    BANKSEL PCLATU
    MOVLW   low highword(Table2)
    MOVWF   PCLATU,1
    MOVLW   high(Table2)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    Table2
    MOVWF   LATC,1
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0
    GOTO    Next_Seq2
   
Cinco_veces:
    DECFSZ  counter1,1,0
    GOTO    Reload2
    RETFIE  
Next_Seq2:
    INCF    offset,1,0
    GOTO    Loop2     
    
Repeticiones:   
    MOVLW   0x05	
    MOVWF   counter1,0	; carga del contador con el numero de offsets
    
Reload2:
    MOVLW   0x05	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    GOTO    Loop1 
    
;-----------------------------------------------      
; Se producio la INT2
BUTTONRF2: 
    BCF	    PIR10,0,0	; limpiamos el flag de INT2
    SETF    LATC,1      ;Puerto C = 1 (OFF)
    GOTO   ExtiRF2
    RETFIE

;--------------------------------------------   
; Se producio la INT1
BUTTONRB4: 
    BCF	    PIR6,0,0	; limpiamos el flag de INT1
    CALL    Delay_2s
    RETFIE
;--------------------------------------------   
    
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;Config Ext Button1
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    
    ;Config Ext Button2
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1	
    BSF	    WPUF,2,1
    
    ;Config PORTC
    BANKSEL PORTC
    SETF    PORTC,1	
    SETF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
   ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT1PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	; INT2 --> RF2
    
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos los niveles de prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 1 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 0 -- INT1 de alta prioridad
    BSF	IPR10,0,1    ; IPR6<INT2IP> = 1 -- INT1 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT2EDG> = 0 -- INT2 por flanco de bajada
    BCF	PIR10,0,0    ; PIR6<INT2IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE6<INT2IE> = 1 -- habilitamos la interrupcion ext1
    
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    BSF INTCON0,5,0 ; Habilitar niveles de prioridad en las interrupciones
    RETURN

Table1:
    ADDWF   PCL,1,0
    RETLW   01111110B	; offset: 0
    RETLW   10111101B	; offset: 1
    RETLW   11011011B	; offset: 2
    RETLW   11100111B	; offset: 3 
    RETLW   11111111B	; offset: 4
    
Table2:
    ADDWF   PCL,1,0
    RETLW   11100111B	; offset: 0
    RETLW   11011011B	; offset: 1
    RETLW   10111101B	; offset: 2
    RETLW   01111110B	; offset: 3
    RETLW   11111111B	; offset: 4
;----------------------------------------------------    
    
Delay_250ms:		    ; 2Tcy -- Call
    MOVLW   250		    ; 1Tcy -- k2
    MOVWF   contador2,0	    ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		    ; 1Tcy -- k1
    MOVWF   contador1,0	    ; 1Tcy
Int_Loop:
    NOP			    ; k1*Tcy
    DECFSZ  contador1,1,0   ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	    ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN		    ; 2Tcy
;-----------------------------------------------------------

Delay_500ms:
    MOVLW 2
    MOVWF contador3,0
    Loop_250ms:				    ;2tcy
    MOVLW 250				    ;1tcy
    MOVWF contador2,0			    ;1tcy
    Loop_1ms8:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
    INT_LOOP8:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		     ;251k TCY 
    Goto    INT_LOOP8			;496k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    Loop_1ms8			    ;(k-1)*2tcy
    DECFSZ  contador3,1,0
    GOTO Loop_250ms
    RETURN  
;------------------------------------------------------------    
;T= (6 + 4k1)(k2)(k3)us          1Tcy=1us 
Delay_2s:                  ;2Tcy--call
    MOVLW   8              ;1TCY--k3
    MOVWF   contador3,0    ;1TCY
       
D_1s:                 
    MOVLW   250             ;1Tcy--k2
    MOVWF   contador2,0     ;1Tcy
    
Ext1s_Loop:                  
    MOVLW   249             ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
Int1s_Loop:
    NOP                     ;K1*Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int1s_Loop      ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext1s_Loop      ;2Tcy  
    DECFSZ  contador3,1,0   ;2TCY
    GOTO    D_1s
    RETURN                  ;2Tcy
    
ExtiRF2:    
End resetVect


    
    
 