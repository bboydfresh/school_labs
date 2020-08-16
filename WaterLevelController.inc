#include <p16f917.inc>

    __CONFIG    _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
    errorlevel -302		; supress "register not in bank0, check page bits" message

; Pin Declarations

;--- Student Complete Section below
#define SW2	PORTD,4	;RD4 (Sensor LOW)
#define SW3	PORTD,5	;RD5 (Sensor HIGH)
#define LED_D1	PORTD,1 ;RD1 -> LED D1 reflects the Sensor LOW value
#define LED_D2	PORTD,2 ;RD2 -> LED D2 reflects the Sensor HIGH value
#define LED_D7	PORTD,3 ;RD3 -> LED D7 reflects the pump status
;--- Student Complete Section above
; Variable Declarations
	cblock	0x20
		Temp
	endc






