;--------------------------------------------------------------
; @file	  = Retardos.inc
; @brief  = Este programa tiene una pequeña libreria de retardos 
;           de ciertos tiempos en donde en este caso el led va
;           encender dependiendo el tiempo que utilizemos.
; @date   = 5/01/23
; @author = Alexander Arturo Flores Juarez
; Tarjeta = Curiosity Nano PIC18F57Q84
; Entorno = MPLAB X IDE
; Idioma  = AMS 
; Frecuencia del oscilador = 4Mhz   
;------------------------------------------------------------------    
PSECT udata_acs
contador1: DS 1   
contador2: DS 1            ; reserva 1 byte en access ram
contador3: DS 1    
        
PSECT code
 
;T= (6 + 4k1)us             1Tcy=1us
Delay_10us:                ;2Tcy--call
    MOVLW      1           ;1Tcy--k1
    MOVWF   contador1,0    ;1Tcy
                 
Delay10us_Loop:
    NOP                    ;K1*Tcy
    DECFSZ  contador1,1,0  ;(k1-1)+ 3Tcy           
    GOTO    Delay10us_Loop ;2Tcy
    RETURN                 ;2Tcy     
;------------------------------------------------------------ 
    
;T= (7 + 3k1)us             1Tcy=1us
Delay_25us:                ;2Tcy--call
    NOP                    ;1Tcy
    MOVLW      6           ;1Tcy--k1
    MOVWF   contador1,0    ;1Tcy
    
Delay25us_Loop:
    DECFSZ  contador1,1,0  ;(k1-1)+ 3Tcy           
    GOTO    Delay25us_Loop ;2Tcy
    RETURN                 ;2Tcy  
;------------------------------------------------------------
    
;T= (6 + 4k1)us             1Tcy=1us
Delay_50us:                ;2Tcy--call
    MOVLW      11          ;1Tcy--k1
    MOVWF   contador1,0    ;1Tcy
    
Delay50us_Loop:
    NOP                    ;1Tcy
    DECFSZ  contador1,1,0  ;(k1-1)+ 3Tcy           
    GOTO    Delay50us_Loop ;2Tcy
    RETURN                 ;2Tcy   
;------------------------------------------------------------    
 
;T= (7 + 3k1)us             1Tcy=1us
Delay_100us:               ;2Tcy--call
    NOP                    ;1Tcy
    MOVLW      31          ;1Tcy--k1
    MOVWF   contador1,0    ;1Tcy
    
Delay100us_Loop:
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Delay100us_Loop ;2Tcy
    RETURN                  ;2Tcy 
     

;------------------------------------------------------------    
    
;T= (8 + 4k1)us              1Tcy=1us
Delay_200us:                ;2Tcy--call
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      48           ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Delay200us_Loop:
    NOP                     ;1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Delay200us_Loop ;2Tcy
    RETURN                  ;2Tcy  
;------------------------------------------------------------   
    
;T= (6 + 4k1)us              1Tcy=1us
Delay_250us:                ;2Tcy--call
    MOVLW      61           ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Delay250us_Loop:
    NOP                     ;1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Delay250us_Loop ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
      
;T= (8 + 4k1)us              1Tcy=1us
Delay_500us:                ;2Tcy--call
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      123          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Delay500us_Loop:
    nop
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Delay500us_Loop ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
    
;T= (8 + 4k1)us              1Tcy=1us
Delay_1ms:                  ;2Tcy--call
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      248          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Delay1ms_Loop:
    NOP                     ;1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Delay1ms_Loop   ;2Tcy
    RETURN                  ;2Tcy
;------------------------------------------------------------    
    
 ;T= (8 + 4k1)k2us          1Tcy=1us
Delay_5ms:                 ;2Tcy--call
    MOVLW   5              ;1Tcy--k2
    MOVWF  contador2,0     ;1Tcy 
 
Ext5ms_Loop:               
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      248          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int5ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int5ms_Loop     ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext5ms_Loop     ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
       
;T= (8 + 4k1)k2us           1Tcy=1us
Delay_10ms:                 ;2Tcy--call
    MOVLW   10              ;1Tcy--k2
    MOVWF  contador2,0      ;1Tcy
 
Ext10ms_Loop:               
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      249          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int10ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int10ms_Loop    ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext10ms_Loop    ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
    
;T= (8 + 4k1)k2us           1Tcy=1us
Delay_25ms:                 ;2Tcy--call
    MOVLW   25              ;1Tcy--k2
    MOVWF  contador2,0      ;1Tcy
 
Ext25ms_Loop:               
    NOP                     ;1Tcy
    NOP                     ;1Tcy    
    MOVLW      249          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int25ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int25ms_Loop    ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext25ms_Loop    ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
    
;T= (8 + 4k1)k2us           1Tcy=1us
Delay_50ms:                 ;2Tcy--call
    MOVLW   50              ;1Tcy--k2
    MOVWF  contador2,0      ;1Tcy
 
Ext50ms_Loop:               
    NOP                     ;1Tcy
    NOP                     ;1Tcy 
    MOVLW      249          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int50ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int50ms_Loop    ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext50ms_Loop    ;2Tcy
    RETURN                  ;2Tcy 
;------------------------------------------------------------    
    
;T= (8 + 4k1)k2us           1Tcy=1us
Delay_100ms:                ;2Tcy--call
    MOVLW   100             ;1Tcy--k2
    MOVWF  contador2,0      ;1Tcy
 
Ext100ms_Loop:              
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      249          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int100ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int100ms_Loop   ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext100ms_Loop   ;2Tcy
    RETURN                  ;2Tcy    
;------------------------------------------------------------

;T= (8 + 4k1)k2us           1Tcy=1us
Delay_200ms:                ;2Tcy--call
    MOVLW   200             ;1Tcy--k2
    MOVWF  contador2,0      ;1Tcy
 
Ext200ms_Loop:               
    NOP                     ;1Tcy
    NOP                     ;1Tcy
    MOVLW      249          ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
    
Int200ms_Loop:
    NOP                     ;k1*1Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int200ms_Loop   ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext200ms_Loop   ;2Tcy
    RETURN                  ;2Tcy         
;------------------------------------------------------------    
    
;T= (6 + 4k1)k2us            1Tcy=1us   
Delay_250ms:                ;2Tcy--call
    MOVLW   250             ;1Tcy--k2
    MOVWF   contador2,0     ;1Tcy
    
Ext250ms_Loop:                  
    MOVLW   249             ;1Tcy--k1
    MOVWF   contador1,0     ;1Tcy
Int250ms_Loop:
    NOP                     ;K1*Tcy
    DECFSZ  contador1,1,0   ;(k1-1)+ 3Tcy           
    GOTO    Int250ms_Loop   ;2Tcy
    DECFSZ  contador2,1,0   ;2Tcy
    GOTO    Ext250ms_Loop   ;2Tcy   
    RETURN                  ;2Tcy     
;------------------------------------------------------------ 
    
;T= (6 + 4k1)(k2)(k3)us          1Tcy=1us 
Delay_1s:                  ;2Tcy--call
    MOVLW   4              ;1TCY--k3
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
        
;------------------------------------------------------------
    
    

 
 
 
 
