;Group 53
    ;Fosc = 250kHz
    ;TMR0 Prescaler is 255
    ;A=AN5(RC1),B=AN6(RC2)
    ;Initial Value for delay of 1 second is 12 
    ;Configurations:
    ;LED 0 at RD0
    ;LED 4 at RA0
    ;LED 5 at RA1
    ;LED 6 at RD6
    ;LED 7 at RD7
    
    
    #include <p16f917.inc> 
    __CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
         errorlevel -302 ; supress "register not in bank0, check page bits" message
         ORG 0X00
	 GOTO START
	 ORG 0X05
    RESULTLO EQU 0X21
    RESULTHI EQU 0X20 
START
	 BCF STATUS, RP1
	 BSF STATUS, RP0 ;Select Bank 1
	 
	 BSF TRISC,TRISC1 ;Set the TRIS bit as an Input
	 BSF ANSEL,ANS5 ;Set the TRIS bit as an Analog Input
	 BSF TRISC,TRISC2
	 BSF ANSEL,ANS6
	 
	 BCF PORTD,7 ;Set LEDs as outputs
	 BCF PORTD,6
	 BCF PORTA,1
	 BCF PORTA,0
	 BCF PORTC,3
	 
	 MOVLW B'00010000' ;Fosc is 250kHz Change this to flash led slower/faster
	 MOVWF OSCCON
	 MOVLW B'00000111' ; TMR0 Prescaler is 256 
	 MOVWF OPTION_REG
	 MOVLW B'00000000' ;Fosc/2
	 MOVWF ADCON1
	 BCF STATUS, RP0
	 MOVLW B'10010101' ;Right-justified, VSS, VSS, AN5, A/D not in progress, ADC is enabled
	 MOVWF ADCON0
	 BSF PORTC,3 ; Turn on LED 0 
	 
SampleTime2
	 BCF INTCON, T0IF ; Flag is Set to 0 
	 MOVLW D'12' ; Initial Value of 12 to produce a delay of 1 second
	 MOVWF TMR0 ; Move to TMR0
TimingLoop
	 BTFSC INTCON, T0IF ; Skip if the Flag is still 0, hence cycle not completed
	 GOTO TogglePOTS ; Initiated when 1 second is done.
	 Call SampleTime ; Call subroutine to produce a 2Tad delay
	 BSF ADCON0,GO ; A/D Conversion cycle in progress
LOOP
	 BTFSC ADCON0,GO ; Skip if the A/D Conversion is done
	 GOTO LOOP ; Loop back until the conversion is done
         Call MoveAddresses ; storing the bits into the right ADRESH & ADRESL register
	 Call Bits ; Displaying the bits on the LEDs
	 GOTO TimingLoop ; Producing a continous loop of this
	 
Terminate	 
	 GOTO Terminate
	 
TogglePOTS
	 MOVLW B'00011100' ; Toggle the pots by moving 111 on the bits used for ADCON0
	 XORWF ADCON0
	 MOVLW B'00001000' ; Toggle LED0 with respect to the pot inputs
	 XORWF PORTC
         GOTO SampleTime2

MoveAddresses ; Save the bits into the correct registers
	 MOVF ADRESH,0
	 MOVWF RESULTHI
	 BSF STATUS, RP0
	 MOVF ADRESL,0
	 BCF STATUS,RP0
	 MOVWF RESULTLO
	 RETURN
	 
Bits ; Display output on LEDs 
	 BTFSS RESULTLO,0 ;LED 7
	 BCF PORTD, 7
	 BTFSC RESULTLO,0
	 BSF PORTD, 7
	 
	 BTFSS RESULTLO,1 ; LED 6
	 BCF PORTD, 6
	 BTFSC RESULTLO,1
	 BSF PORTD, 6
	 
	 BTFSS RESULTLO,2 ; LED 5
	 BCF PORTA, 1
	 BTFSC RESULTLO,2
	 BSF PORTA, 1
	 
	 BTFSS RESULTLO,3 ; LED 4
	 BCF PORTA, 0
	 BTFSC RESULTLO,3
	 BSF PORTA, 0
	 RETURN 
	 
 SampleTime ; Produce delay of 2Tad
 NoP
 RETURN
 
 END
	 


