#include <p16f690.inc> 
    
   __config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF)
   
    org 0
    goto setup //go to setup function
    nop //no operation
    nop  
    nop
    goto ISR //go to ISR function 
    
setup
    bsf	    STATUS, RP0  //Switch to bank 1 
    bcf	    STATUS, RP1
   
    movlw   0x0	//move literal value 0 to w register
    movwf   TRISC //Set pins of port C to output 
    bsf	    INTCON, GIE //turn on global interrupts
    bsf	    INTCON, RABIE //Enable PORTA change interrupt bit
    bsf	    IOCA, 5 //Set pin 5 on PORT A as interrupt on change
    
    movlw   B'11111111' 
    movwf   WPUA //turn on pull up on PORT A
    
    bsf	    STATUS, RP1  //Switch to bank 2
    bcf	    STATUS, RP0
    
    CLRF    ANSELH //Set all ports as digital I/O
    CLRF    ANSEL //Set all ports as digital I/O

    bsf	    STATUS, RP0 //Switch to bank 1  
    bcf	    STATUS, RP1
    movlw   0xFF //Move literal value 256 to w register	
    movwf   TRISA //Set pins of PORT A as inputs
    movlw   0x71 //Move literal value 0x71 to w register
    movwf   OSCCON //set the internal clock speed to 8 Mhz
    
    bcf	    STATUS, RP0 //bit clear
    call flash //execute flash function 
    
ISR
    //LED LIGHT SEQUENCE
    movlw   B'10000001'
    movwf   PORTC
    call    delay
    movlw   B'01000010'
    movwf   PORTC
    call    delay
    movlw   B'00100100'
    movwf   PORTC
    call    delay
    movlw   B'00011000'
    movwf   PORTC
    call    delay
    movlw   B'00100100'
    movwf   PORTC
    call    delay
    movlw   B'01000010'
    movwf   PORTC
    call    delay
    movlw   B'10000001'
    
    bcf INTCON, RABIF //clear RABIF bit (drop flag) 
RETFIE //return from interupt function (ISR) and set GIE bit
    
flash
    //LED LIGHT SEQUENCE
    call    delay
    movlw   B'11111111'
    movwf   PORTC
    call    delay
    movlw   B'01111111'
    movwf   PORTC
    call    delay
    movlw   B'00111111'
    movwf   PORTC
    call    delay
    movlw   B'00011111'
    movwf   PORTC
    call    delay
    movlw   B'00001111'
    movwf   PORTC
    call    delay
    movlw   B'00000111'
    movwf   PORTC
    call    delay
    movlw   B'00000011'
    movwf   PORTC
    call    delay
    movlw   B'00000001'
    movwf   PORTC
    call    delay
    movlw   B'00000000'
    movwf   PORTC
    call    delay
    movlw   B'00000001'
    movwf   PORTC
    call    delay
    movlw   B'00000011'
    movwf   PORTC
    call    delay
    movlw   B'00000111'
    movwf   PORTC
    call    delay
    movlw   B'00001111'
    movwf   PORTC
    call    delay
    movlw   B'00011111'
    movwf   PORTC
    call    delay
    movlw   B'00111111'
    movwf   PORTC
    call    delay
    movlw   B'01111111'
    movwf   PORTC
    call    delay
    movlw   B'11111111'
    goto    flash
return 
 
delay
    movlw   0x0 //set the internal clock speed to 8 Mhz
    movwf   0x20 //Move data from w register to 20h
    movwf   0x21 //Move data from w register to 21h
delay1
    decfsz  0x20,1 //Decrement data from 20h register and place into file register 
    goto    delay1 //go to delay1 (executes if 20h register has value of 1)
delay2
    decfsz  0x21,1 //Decrement data from 21h register and place into file register 
    goto    delay1 //go to delay1 (executes if 21h register has value of 1)
enddelay
    return
end 