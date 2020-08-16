;************************************************************************************
;   Filename:      WaterLevelController.asm                                          
;   Date:          January 25,2008                                          
;   File Version:  1.00                                                                  
;                                                                      
;************************************************************************************
;                                                                     
;    Files required:                                                  
;          WaterLevelController.inc                                                           
;************************************************************************************
;                                                                     
;    Notes:                                                           
;     This project shows the status of a Water Level Controller
;                                                        
;************************************************************************************
    #include    <WaterLevelController.inc> ; this file includes variable definitions and pin assignments	

;************************************************************************************
  org 0x00
	goto	Initialize

  org 0x05

;************************************************************************************
; Initialize - Initialize comparators, internal oscillator, I/O pins, 
;	analog pins, variables	
;
;************************************************************************************
Initialize
; Configure I/O pins for project	

;---- Student Complete Section below
	bcf	STATUS,RP0  ; Select Bank 0 (RP0 = 0 and RP1 = 0)
	bcf	STATUS,RP1  ; Select Bank 0 (RP0 = 0 and RP1 = 0) 
	clrf	PORTD	    ; Clear PORTD to make all LED off
	bsf	STATUS,RP0  ; we'll set up the bank 1 Special Function Registers first
	bcf	STATUS,RP1  ; (RP0 = 1 and RP1 = 0)
	clrf	TRISD	    ; making PORTD as an output by writing all zero's on TRISD register
	movlw	b'11111111' ; Set RA0-RA7 as input pins as 1 mean input and 0 mean output
	movwf	TRISA	    ; move value of w register to TRISA
;---- Student Complete Section above

; Set internal oscillator frequency
	movlw	b'01110000'		; 8Mhz
	movwf	OSCCON
; Set TMR0 parameters
	movlw	b'10000110'		; PORTB pull-up disabled, TMR0 Prescaler 1:128
	movwf	OPTION_REG		
; Turn off comparators
	movlw	0x07
	movwf	CMCON0			; turn off comparators
; Turn off Analog 
	clrf	ANSEL
	bcf	STATUS,RP0  ; Select Bank 0
	bcf	STATUS,RP1  ;
;************************************************************************************
; Note - When SW2 is pressed, the LED is toggled, and the debounce routine for SW2 is
;        initiated.  Debouncing a switch is necessary to prevent one button press from 
;        being read as more than one button press by the microcontroller.  A 
;        microcontroller can read a button so fast that contact jitter in the switch 
;        may be interpreted as more than one button press.
;
;************************************************************************************

Main
;---- Student Complete Section below
; LED_D1 = SW2
; Move the status of SW2 to LED_D1
; 1) btfss = bit test file skip if bit set 2) bsf is bit set flag 3) bcf is bit clear flag	
    btfsc   SW2	    ; check if SW2 is high if yes it will skip the next line and execuate 72 no line (bsf LED_D1)
    goto    u10	    ; jump to u10 line 74 if SW2 is low
    bsf	    LED_D1  ; high the LED_D1 pin to on the led
    goto    l1325   ; jump to l1325 label which is 76 no line
u10    
    bcf	    LED_D1  ; clear the led pin LED_D1
l1325
; LED_D2 = SW3
; Move the status of SW3 to LED_D2
    btfsc   SW3     ; check if SW3 is high if yes it will skip the next line and execute 81 no line (bsf LED_D2)
    goto    u30	    ; jump to u30 line 83 if SW2 is low
    bsf	    LED_D2  ; high the LED_D2 pin to on the led
    goto    l1331   ; jump to l1331 label which is 85 no line
u30
    bcf	    LED_D2  ; clear the led pin LED_D2
l1331
; if SW2 == 0 and SW3 == 0
; SW2 is below low threshold and SW3 is below high threshold
; it is eqaual to empty tank
    btfsc   SW2	    ; check if SW2 is high if yes then jump to l946 if SW2 is low then check SW3 
    btfsc   SW3	    ; check if SW3 is low then make the pump on as both levels are low means tank is empty
    goto    l946    ; jump to l946 if both inputs are not low
    bsf	    LED_D7  ; make the pump on
l946
; if SW2 == 1 and SW3 == 1
; SW2 is above low threshold and SW3 is above high threshold
; it is eqaual to full tank
    btfsc   SW2	    ; check if SW2 is low if yes then jump to l1341 if SW2 is high then check SW3 
    btfss   SW3	    ; check if SW3 is high then make the pump off as both levels are high means tank is full
    goto    l1341   ; jump to l946 if both inputs are not high
    bcf	    LED_D7  ; make the pump off
l1341
; in between the two levels pump remain on 
; debounce delay of 16 msec
; as here we don't want to stuck a loop to wait for button release
; because there are two buttons if one is press and we keep waiting for relase
; then we can't do other tasks to check the status of other buttons
; thats why we put a fix elay on each loop    
    clrf    TMR0	; Once released clear TMR0 and the TMR0 interrupt flag
    bcf	    INTCON,T0IF	; in preparation to time 16ms
Wait
    btfss   INTCON,T0IF ; continue to count down 16ms
    goto    Wait	; wait here until timer not roll over and make T0IF high
;---- Student Complete Section above
    goto Main

  END