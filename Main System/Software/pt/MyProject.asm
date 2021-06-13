
_interrupt:

;MyProject.c,48 :: 		void interrupt()
;MyProject.c,52 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,54 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,56 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,57 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,59 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,60 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,69 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,70 :: 		} //end interrupt
L_end_interrupt:
L__interrupt4:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,74 :: 		void main()
;MyProject.c,77 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,81 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,82 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,83 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,84 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,90 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,91 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,94 :: 		TRISA    = 0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,95 :: 		ADCON0   = 0x01;                                                           //Ligar o conversor A/C
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,96 :: 		ADCON1   = 0x0E;                                                           //Apenas o AN0 como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,97 :: 		ADCON2   = 0x18;
	MOVLW       24
	MOVWF       ADCON2+0 
;MyProject.c,111 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,112 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,113 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,114 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,115 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,117 :: 		byteH  = 0x93;                                                            //90Hz
	MOVLW       147
	MOVWF       _byteH+0 
;MyProject.c,118 :: 		byteL  = 0x9A;
	MOVLW       154
	MOVWF       _byteL+0 
;MyProject.c,134 :: 		dir1 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,135 :: 		dir2 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,143 :: 		while(1)
L_main1:
;MyProject.c,183 :: 		} //end while
	GOTO        L_main1
;MyProject.c,184 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main

_voltmeter:

;MyProject.c,193 :: 		void voltmeter()
;MyProject.c,198 :: 		volts_f = ADC_Read(0)*0.048875;
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,208 :: 		}
L_end_voltmeter:
	RETURN      0
; end of _voltmeter
