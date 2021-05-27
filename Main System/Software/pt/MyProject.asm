
_interrupt:

;MyProject.c,28 :: 		void interrupt()
;MyProject.c,30 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,32 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,33 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,34 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
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
L__interrupt12:
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
;MyProject.c,59 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,60 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,75 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,76 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,77 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,79 :: 		byteH = 0xA7;
	MOVLW       167
	MOVWF       _byteH+0 
;MyProject.c,80 :: 		byteL = 0x38;                                                              //110Hz
	MOVLW       56
	MOVWF       _byteL+0 
;MyProject.c,93 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,94 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,96 :: 		while(1)
L_main1:
;MyProject.c,98 :: 		if(sens1)
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main3
;MyProject.c,100 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,101 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,102 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,103 :: 		delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
;MyProject.c,104 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,105 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,106 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,107 :: 		delay_ms(1500);
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
;MyProject.c,108 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,109 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,110 :: 		delay_ms (3800);
	MOVLW       97
	MOVWF       R11, 0
	MOVLW       100
	MOVWF       R12, 0
	MOVLW       16
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	DECFSZ      R11, 1, 1
	BRA         L_main6
	NOP
;MyProject.c,111 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,112 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,113 :: 		} //end if sens1
L_main3:
;MyProject.c,115 :: 		if (sens2)
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main7
;MyProject.c,117 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,118 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,119 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,120 :: 		delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
	DECFSZ      R11, 1, 1
	BRA         L_main8
	NOP
;MyProject.c,121 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,122 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,123 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,124 :: 		delay_ms(1500);
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	DECFSZ      R11, 1, 1
	BRA         L_main9
	NOP
;MyProject.c,125 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,126 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,127 :: 		delay_ms (3800);
	MOVLW       97
	MOVWF       R11, 0
	MOVLW       100
	MOVWF       R12, 0
	MOVLW       16
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	NOP
;MyProject.c,128 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,129 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,130 :: 		} //end if sens2
L_main7:
;MyProject.c,132 :: 		} //end while
	GOTO        L_main1
;MyProject.c,133 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main
