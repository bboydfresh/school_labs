; Donald Dang 7747085 Group 53
; No lab partner
    
    
    #include <p16f917.inc>
    
    __CONFIG    _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF

    errorlevel -302		; supress "register not in bank0, check page bits" message

    ORG 0x00
    GOTO Initialize
    ORG 0x05

Initialize
; Configure I/O pins
    BSF     STATUS,RP0      ; Select Bank1
    BCF     TRISD,4         ; RD4 is Output

; Set internal oscillator frequency
    MOVLW	b'00010000'		; 128 KHz
    MOVWF	OSCCON

; Set TMR0 prescaler 
    MOVLW	b'10000110'		; TMR0 Prescaler 1:128
    MOVWF	OPTION_REG

; Turn off comparators
    MOVLW 0x07
    MOVWF CMCON0  

    BCF	    STATUS,RP0      ; Back to Bank0
    BCF     PORTD,4        ;  connected to RD4

Main
; Initialize TMR0 interrupt flag (T0IF) and
;  the timer's initial value 
    BCF	    INTCON,T0IF
    MOVLW   D'114'
    MOVWF   TMR0            ; TMR0 Initial Value = 114
 
    MOVLW   B'00010000'
    XORWF   PORTD,1 

TimingLoop
; A loop to wait for the necessary time delay before
;  branching back to the appropriate line in the
;  program 
    BTFSS   INTCON,T0IF     ; Has 1 sec. passed?
    GOTO    TimingLoop      ; No, Continue waiting
    GOTO    Main            

    END                     
 