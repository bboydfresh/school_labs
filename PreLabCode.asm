#include <p16f917.inc>
    
__CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
errorlevel -302 ; supress "register not in bank0, check page bits" message
    
ORG 0x00
GOTO START
ORG 0x05

RESULTHI EQU 0x21
RESULTLO EQU 0x20
RESULTH2 EQU 0x22
RESULTL2 EQU 0x23

BSF STATUS, RP0
BCF STATUS, RP1

START 
BSF TRISA, 5
BSF TRISA, 6
BSF ANSEL, 5
BSF ANSEL, 6

MOVLW b'01110001'
MOVWF OSCCON 

MOVLW b'01010000' ;Prescalar Set
MOVWF ADCON1

BCF STATUS, RP0
MOVLW b'10010101' ; THIS TURNS ADC ON, Select AN5
MOVWF ADCON0

Main
GOTO SampleTime
BSF ADCON0, GO ; start conversion, select GO/DONE
BTFSC ADCON0, GO; conversion done, select GO/DONE
GOTO $-1 ; this means to go back to one line

MOVF  ADRESH, W
MOVWF RESULTHI

BSF STATUS, RP0
MOVF ADRESL, W
MOVWF RESULTLO
 
BSF STATUS, RP0
MOVF  ADRESH, W
MOVWF RESULTH2
 
BSF STATUS, RP0
MOVF  ADRESL, W
MOVWF RESULTL2

NoP
GOTO $-1

SampleTime

    BTFSS   INTCON,T0IF     ; Has 1sec. passed?
    GOTO    SampleTime      ; No, Continue waiting
    GOTO    Main            


END

    
; 7747085 Donald Dang
; Group 53
; 53 mod 8 = 5
; 54 mod 8 = 6