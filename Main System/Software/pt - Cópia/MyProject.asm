
_interrupt:

;MyProject.c,54 :: 		void interrupt()
;MyProject.c,58 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,60 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,62 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,63 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,65 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,66 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,75 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,76 :: 		} //end interrupt
L_end_interrupt:
L__interrupt17:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,80 :: 		void main()
;MyProject.c,83 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,87 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,88 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,89 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,90 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,96 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,97 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,100 :: 		TRISA    = 0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,101 :: 		ADCON0   = 0x01;                                                           //Ligar o conversor A/C
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,102 :: 		ADCON1   = 0x0E;                                                           //Apenas o AN0 como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,103 :: 		ADCON2   = 0x18;
	MOVLW       24
	MOVWF       ADCON2+0 
;MyProject.c,117 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,118 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,119 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,120 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,121 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,125 :: 		byteH  = 0x93;                                                            //90Hz
	MOVLW       147
	MOVWF       _byteH+0 
;MyProject.c,126 :: 		byteL  = 0x9A;
	MOVLW       154
	MOVWF       _byteL+0 
;MyProject.c,142 :: 		dir1 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,143 :: 		dir2 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,151 :: 		while(1)
L_main1:
;MyProject.c,155 :: 		if (sens1)
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main3
;MyProject.c,157 :: 		cont += 1;
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;MyProject.c,158 :: 		parouimpar = par_impar_test();
	CALL        _par_impar_test+0, 0
	MOVF        R0, 0 
	MOVWF       _parouimpar+0 
	MOVF        R1, 0 
	MOVWF       _parouimpar+1 
;MyProject.c,160 :: 		switch(parouimpar)
	GOTO        L_main4
;MyProject.c,162 :: 		case 0:
L_main6:
;MyProject.c,163 :: 		virardireita();
	CALL        _virardireita+0, 0
;MyProject.c,164 :: 		break;
	GOTO        L_main5
;MyProject.c,166 :: 		case 1:
L_main7:
;MyProject.c,167 :: 		viraresquerda();
	CALL        _viraresquerda+0, 0
;MyProject.c,168 :: 		break;
	GOTO        L_main5
;MyProject.c,169 :: 		}
L_main4:
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main19
	MOVLW       0
	XORWF       _parouimpar+0, 0 
L__main19:
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main20
	MOVLW       1
	XORWF       _parouimpar+0, 0 
L__main20:
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
L_main5:
;MyProject.c,171 :: 		}
L_main3:
;MyProject.c,174 :: 		} //end while
	GOTO        L_main1
;MyProject.c,175 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main

_voltmeter:

;MyProject.c,184 :: 		void voltmeter()
;MyProject.c,189 :: 		volts_f = ADC_Read(0)*0.048875;
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,199 :: 		}
L_end_voltmeter:
	RETURN      0
; end of _voltmeter

_par_impar_test:

;MyProject.c,201 :: 		int par_impar_test ()
;MyProject.c,203 :: 		if(cont % 2 == 0)
	MOVLW       1
	ANDWF       _cont+0, 0 
	MOVWF       R1 
	MOVF        _cont+1, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__par_impar_test23
	MOVLW       0
	XORWF       R1, 0 
L__par_impar_test23:
	BTFSS       STATUS+0, 2 
	GOTO        L_par_impar_test8
;MyProject.c,205 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_par_impar_test
;MyProject.c,206 :: 		}
L_par_impar_test8:
;MyProject.c,209 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;MyProject.c,211 :: 		}
L_end_par_impar_test:
	RETURN      0
; end of _par_impar_test

_virardireita:

;MyProject.c,213 :: 		void virardireita()
;MyProject.c,215 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,216 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,217 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,218 :: 		delay_ms(2000);                                                          //Robo STOP
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_virardireita10:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita10
	DECFSZ      R12, 1, 1
	BRA         L_virardireita10
	DECFSZ      R11, 1, 1
	BRA         L_virardireita10
	NOP
	NOP
;MyProject.c,219 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,220 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,221 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,222 :: 		delay_ms(1200);                                                          //Robo anda para trás
	MOVLW       31
	MOVWF       R11, 0
	MOVLW       113
	MOVWF       R12, 0
	MOVLW       30
	MOVWF       R13, 0
L_virardireita11:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita11
	DECFSZ      R12, 1, 1
	BRA         L_virardireita11
	DECFSZ      R11, 1, 1
	BRA         L_virardireita11
	NOP
;MyProject.c,223 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,224 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,225 :: 		delay_ms (4000);                                                         //Desvio Robo
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_virardireita12:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita12
	DECFSZ      R12, 1, 1
	BRA         L_virardireita12
	DECFSZ      R11, 1, 1
	BRA         L_virardireita12
;MyProject.c,226 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,227 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,228 :: 		}
L_end_virardireita:
	RETURN      0
; end of _virardireita

_viraresquerda:

;MyProject.c,230 :: 		void viraresquerda()
;MyProject.c,232 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,233 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,234 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,235 :: 		delay_ms(2000);                                                          //Robo STOP
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_viraresquerda13:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda13
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda13
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda13
	NOP
	NOP
;MyProject.c,236 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,237 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,238 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,239 :: 		delay_ms(1200);                                                          //Robo anda para trás
	MOVLW       31
	MOVWF       R11, 0
	MOVLW       113
	MOVWF       R12, 0
	MOVLW       30
	MOVWF       R13, 0
L_viraresquerda14:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda14
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda14
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda14
	NOP
;MyProject.c,240 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,241 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,242 :: 		delay_ms (4000);                                                         //Desvio Robo
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_viraresquerda15:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda15
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda15
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda15
;MyProject.c,243 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,244 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,245 :: 		}
L_end_viraresquerda:
	RETURN      0
; end of _viraresquerda
