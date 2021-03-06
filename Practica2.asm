list	    p=18f4550        ; list directive to define processor
#include    "p18f4550.inc"

;******Configuration Bits***********
; PIC18F4550 Configuration Bit Settings

; ASM source line config statements

;#include "p18F4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC3_PLL4    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /3][96 MHz PLL Src: /4])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes from the 96 MHz PLL divided by 2)

; CONFIG1H
  CONFIG  FOSC = HSPLL_HS       ; Oscillator Selection bits (HS oscillator, PLL enabled (HSPLL))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
  CONFIG  PBADEN = ON          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)


;*****Variables Definition************

SPEED			EQU	0x00
BUTTON_2		EQU	0x01
RESULT			EQU	0x02
TEMP			EQU	0X03
DELAY			EQU	0x04
R2			EQU	0x05
R1			EQU	0x06
; 

CONSTANT		MASKA = b'00001111'
CONSTANT		MASKB = b'11110000'
;*****Main code**********
			ORG     0x000             	;reset vector
  			GOTO    MAIN              	;go to the main routine

INITIALIZE:		
    
			;Bits para push buttons
			BSF	TRISB, 0     ;UP
			BSF	TRISB, 1     ;DOWN
			
			
			;Puerto para display 
			BCF	TRISD, 0
			BCF	TRISD, 1
			BCF	TRISD, 2
			BCF	TRISD, 3
			BCF	TRISD, 4
			BCF	TRISD, 5
			BCF	TRISD, 6
			BCF	TRISD, 7
			
			;Bits para salida LEDs
			BCF	TRISB, 2
			BCF	TRISB, 3
			BCF	TRISB, 4
			BCF	TRISB, 5
			BCF	TRISB, 6
			BCF	TRISB, 7
			
			MOVLW	0x0F
			MOVWF	ADCON1
		
			RETURN				

MAIN:
			CALL 	INITIALIZE

LOOP:			CALL	BUTTONS_1

BUTTONS_1:		BTFSC	PORTB, 0   ;SPEED UP
			GOTO	DISPLAY
			GOTO	LOOP
		
BUTTONS:
			BTFSC	PORTB, 0   ;SPEED UP
			CALL	SPEED_UP
			BTFSC	PORTB, 1   ;SPEED DOWN
			CALL	SPEED_DOWN
			
			MOVF	SPEED,0
			CALL	LEDS
			MOVWF	PORTB
			
		        RETURN
			;GOTO	LOOP			
			
SPEED_UP:		
			MOVLW	0x02	
			ADDWF	SPEED,0	    ;AUMENTAR VELOCIDAD
			MOVWF	SPEED
			
			;CALL	LEDS
			;MOVWF	PORTB
			
			RETURN
			
			;CALL	DISPLAY	    ;LLAMAR A TABLE	|
			;GOTO	LOOP

SPEED_DOWN:		
			MOVLW	0x02
			SUBWF	SPEED,0	    ;DISMINUIR VELOCIDAD
			MOVWF	SPEED	    ;GUARDAR EN SPEED
			
			;CALL	LEDS	    ;PRENDER LED CORRESPONDIENTE
			;MOVWF	PORTB	    
			
			
			RETURN
			;CALL	DISPLAY	    ;LLAMAR A TABLE	
			;GOTO	LOOP
CHOOSE_SPEED:		
			BTFSC	PORTB,2
			RETLW	0X01	    ;0.1 segs
			BTFSC	PORTB,3
			RETLW	0X05	    ;0.5 segs
			BTFSC	PORTB,4
			RETLW	0X0A	    ;1 segs
			BTFSC	PORTB,5
			RETLW	0X32	    ;5 segs
			BTFSC	PORTB,6
			RETLW	0x64	    ;10 segs
			
			
LEDS:			
			ADDWF	PCL, 1
			RETURN  
			RETLW	0x04	;led 1
			RETLW	0x08	;led 2
			RETLW	0x10	;led 3
			RETLW	0x20	;led 4	
			RETLW	0x40	;led 5
			
TURN_OFF_LEDS:		BCF	PORTB,2
			BCF	PORTB,3
			BCF	PORTB,4
			BCF	PORTB,5
			BCF	PORTB,6
			RETURN
    
PAUSE:			
			CALL	BUTTONS		
			CALL	CHOOSE_SPEED	;Elegir n?mero de repeticiones
			CALL	TURN_OFF_LEDS
			MOVWF	DELAY
RETARDO3:
			MOVLW	0x50  ;80
			MOVWF	R2
RETARDO2:			
			MOVLW	0xFA  ;250
			MOVWF	R1
RETARDO:		
			NOP
			NOP
			DECFSZ	R1
			GOTO RETARDO
			
			DECFSZ	R2
			GOTO RETARDO2
			
			DECFSZ  DELAY
			GOTO RETARDO3
			
			RETURN
			    
			
DISPLAY:			
			
			MOVLW	0x67	    ;9
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x7F	    ;8
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x07	    ;7
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x7D	    ;6
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x6D	    ;5
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x66	    ;4
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x4F	    ;3
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x5B	    ;2
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVLW	0x06	    ;1
			MOVWF	PORTD
			
			CALL	PAUSE
			
			MOVWF	0x3F	    ;0
			
			GOTO	DISPLAY
			
			
			END                       	;end of the main program