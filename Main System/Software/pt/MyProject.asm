
_interrupt:

;MyProject.c,28 :: 		void interrupt()
;MyProject.c,30 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,32 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,33 :: 		TMR0L      = byteH;                                                     //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,34 :: 		TMR0H      = byteL;                                                     //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,36 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,37 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,38 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,39 :: 		} //end interrupt
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,43 :: 		void main()
;MyProject.c,46 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,50 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,51 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,52 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,53 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,59 :: 		TMR0L    = 0x00;                                                           //byte menos significativo      0x48
	CLRF        TMR0L+0 
;MyProject.c,60 :: 		TMR0H    = 0x00;                                                           //byte mais significativo       0x77
	CLRF        TMR0H+0 
;MyProject.c,75 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,76 :: 		PORTD   = 0x3F;                                                            //Inicializa PORTD
	MOVLW       63
	MOVWF       PORTD+0 
;MyProject.c,77 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,79 :: 		byteH  = 0xA7;                                                            //xHz
	MOVLW       167
	MOVWF       _byteH+0 
;MyProject.c,80 :: 		byteL  = 0x38;
	MOVLW       56
	MOVWF       _byteL+0 
;MyProject.c,82 :: 		while(1)
L_main1:
;MyProject.c,84 :: 		RD0_bit = ~RD0_bit;
	BTG         RD0_bit+0, BitPos(RD0_bit+0) 
;MyProject.c,85 :: 		RD1_bit = ~RD1_bit;
	BTG         RD1_bit+0, BitPos(RD1_bit+0) 
;MyProject.c,87 :: 		delay_ms(4000);
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
;MyProject.c,111 :: 		} //end while
	GOTO        L_main1
;MyProject.c,112 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main
