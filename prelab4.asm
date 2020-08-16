#include <p16f917.inc>
    
      __CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
         errorlevel -302 ; supress "register not in bank0, check page bits" message
ORG 0x00
    GOTO Initialize
    ORG 0x05

Initialize
; Go to bank 1
BSF STATUS, RP0
BCF STATUS, RP1

;disable CCP2
BCF TRISD, 2

;Configure internal Oscillator to 8Mhz
MOVLW b'01110000'
MOVWF OSCCON

MOVLW 0x2F
MOVWF PR2

;Back to Bank 0
BCF STATUS, RP0

;Setting our CCPxCON
MOVLW b'00011100'
MOVWF CCP2CON
MOVLW b'00110011'
MOVWF CCPR2L

;Configuring and Starting TMR2
MOVLW b'0000100'
MOVWF T2CON

;Activate PIN CCP2 by configuring it's outputs
BSF STATUS, RP0
BCF TRISD, 2
	 
NoP
	 
GOTO $-1
	 
END

