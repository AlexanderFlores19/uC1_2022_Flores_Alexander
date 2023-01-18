;--------------------------------------------------------------
; @file	  =P1_Corrimiento_Leds.s
; @brief  = Este programa esta diseñado para hacer un corriento Par con un 
;           tiempo de 500ms y un corriento Impar de 250ms, el corriento va
;           empezar cuando se presione le pulsador comenzando con los Pares
;           y se detenga cuando se vuelva a presionar el pulsador .
; @date   = 13/01/23
; @author = Alexander Arturo Flores Juarez
; Tarjeta = Curiosity Nano PIC18F57Q84
; Entorno = MPLAB X IDE
; Idioma  = AMS 
; Frecuencia del oscilador = 4Mhz   
;------------------------------------------------------------------
    
 PROCESSOR 18F57Q84
#include "Bit_config.inc"  // config statements should precede project file includes.
#include <xc.inc>  
#include "Retardos.inc" 

PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
     
PSECT CODE
 
Main:
     CALL Config_OSC,1
     CALL Config_Port,1

BUTTON:
    BANKSEL   LATA       ;seleeccionar el banco.
    CLRF      LATC,b     ;LATC<7:0> = 0 
    BCF       LATE,1,b   ;Puerto RE1 = 0
    BCF       LATE,0,b   ;Puerto RE0 = 0    
    BTFSC     PORTA,3,b  ;PORTA<3> = 0? - Button press?
    goto      BUTTON
    goto      PAR
     
PAR:
    CLRF  LATC,b         ;Puerto C = 0
    BCF   LATE,0,b       ;Puerto RE0 = 0
    BSF   LATE,1,b       ;Puerto RE1 = 1
    MOVLW 00000010B      ;w--> combinacion para encender led (2)
    MOVWF LATC,1         ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1  ;Retardo de 250ms
    CALL  Delay_250ms,1  ;Retardo de 250ms
    BTFSS PORTA,3,0      ;skip, PORTA<3> = 1? 
    GOTO  BUTTON1
    
    BSF   LATE,1,b        ;Puerto RE1 = 1
    BCF   LATE,0,b        ;Puerto RE0 = 0
    MOVLW 00001000B       ;w--> combinacion para encender led (4)
    MOVWF LATC,1          ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1   ;Retardo de 250ms
    CALL  Delay_250ms,1   ;Retardo de 250ms
    BTFSS PORTA,3,0       ;skip, PORTA<3> = 1
    GOTO  BUTTON1
    
    BSF   LATE,1,b        ;Puerto RE1 = 1
    BCF   LATE,0,b        ;Puerto RE0 = 0
    MOVLW 00100000B       ;w--> combinacion para encender led (6)
    MOVWF LATC,1          ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1   ;Retardo de 250ms
    CALL  Delay_250ms,1   ;Retardo de 250ms
    BTFSS PORTA,3,0       ;skip, PORTA<3> = 1
    GOTO  BUTTON1
    
    
    BSF   LATE,1,b        ;Puerto RE1 = 1
    BCF   LATE,0,b        ;Puerto RE0 = 0
    MOVLW 10000000B       ;w--> combinacion para encender led (8)
    MOVWF LATC,1          ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1   ;Retardo de 250ms
    CALL  Delay_250ms,1   ;Retardo de 250ms
    BTFSS PORTA,3,0       ;skip, PORTA<3> = 1
    GOTO  BUTTON1
    
 IMPAR:
    CLRF  LATC,b           ;Puerto C = 0
    BCF   LATE,1,b         ;Puerto RE1 = 0
    BSF   LATE,0,b         ;Puerto RE0 = 1
    MOVLW 00000001B        ;w--> combinacion para encender led (1)
    MOVWF LATC,1           ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1    ;Retardo de 250ms
    BTFSS PORTA,3,0        ;skip, PORTA<3> = 1
    GOTO  BUTTON2
    
    BCF   LATE,1,b         ;Puerto RE1 = 0
    BSF   LATE,0,b         ;Puerto RE0 = 1
    MOVLW 00000100B        ;w--> combinacion para encender led (3)
    MOVWF LATC,1           ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1    ;Retardo de 250ms
    BTFSS PORTA,3,0        ;skip, PORTA<3> = 1
    GOTO  BUTTON2
    
    BCF   LATE,1,b         ;Puerto RE1 = 0
    BSF   LATE,0,b         ;Puerto RE0 = 1
    MOVLW 00010000B        ;w--> combinacion para encender led (5)
    MOVWF LATC,1           ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1    ;Retardo de 250ms
    BTFSS PORTA,3,0        ;skip, PORTA<3> = 1
    GOTO  BUTTON2
    
     
    BCF   LATE,1,b         ;Puerto RE1 = 0
    BSF   LATE,0,b         ;Puerto RE0 = 1
    MOVLW 01000000B        ;w--> combinacion para encender led (7)
    MOVWF LATC,1           ;(w)-->LATC<7:0>
    CALL  Delay_250ms,1    ;Retardo de 250ms
    BTFSS PORTA,3,0        ;skip, PORTA<3> = 1
    GOTO  BUTTON2
    GOTO  PAR
    
BUTTON1:
    CALL   Delay_250ms,1
    CALL   Delay_250ms,1
    CALL   Delay_250ms,1    ;Retardo de 250ms  
    BTFSC   PORTA,3,0       ;PORTA<3> = 0? - Button press?
    GOTO    BUTTON1
    GOTO    PAR
    
BUTTON2:
    CALL    Delay_250ms,1 
    CALL  Delay_250ms,1
    CALL  Delay_250ms,1     ;Retardo de 250ms
    BTFSC   PORTA,3,0       ;PORTA<3> = 0? - Button press?
    GOTO    BUTTON1
    GOTO    IMPAR
   
    
    
Config_OSC:
        ;Configuracion del Oscilador interno a una frecuencia interna de 4Mhz 
         BANKSEL OSCCON1
	 MOVLW 0X60     ;Seleccionamos el bloque del osc con un Div:1
	 MOVWF OSCCON1,1
	 MOVLW 0X02     ;Seleccionamos una Frecuencia de 4Mhz
	 MOVWF OSCFRQ ,1
         RETURN

Config_Port:   ;PORT-LAT-ANSEL-TRIS  LED:RF3,  BUTTON:RA3
    ;Config Led
    BANKSEL  PORTC
    CLRF     TRISC,b    ;TRISC = 0 Como salida
    CLRF     ANSELC,b   ;ANSELC<7:0> = 0 - Port C digital
    BCF      TRISE,1,b  ;TRISF<1> = 0  RE1 como SALIDA
    BCF      TRISE,0,b  ;TRISF<0> = 0  RF0 como SALIDA
    BCF      ANSELE,1,b  ;TRISF<1> = 0  RE1 como Digital
    BCF      ANSELE,0,b  ;TRISF<0> = 0  RE0 como Digital
    
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,b     ;PortA<7:0> = 0 
    CLRF    ANSELA,b    ;PortA Digital
    BSF     TRISA,3,b   ;RA3 como entrada
    BSF     WPUA,3,b    ;Activamos la resistencia Pull-up del pin RA3
    RETURN   

END resetVect


