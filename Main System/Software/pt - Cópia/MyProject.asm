
_interrupt:

;MyProject.c,56 :: 		void interrupt()
;MyProject.c,60 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,62 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,64 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,65 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,67 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,68 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,77 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,78 :: 		} //end interrupt
L_end_interrupt:
L__interrupt27:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,82 :: 		void main()
;MyProject.c,85 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,89 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,90 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,91 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,92 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,98 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,99 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,102 :: 		TRISA    = 0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,103 :: 		ADCON0   = 0x01;                                                           //Ligar o conversor A/C
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,104 :: 		ADCON1   = 0x0E;                                                           //Apenas o AN0 como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,105 :: 		ADCON2   = 0x18;
	MOVLW       24
	MOVWF       ADCON2+0 
;MyProject.c,119 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,120 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,121 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,122 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,123 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,127 :: 		byteH  = 0xB4;                                                            //130Hz
	MOVLW       180
	MOVWF       _byteH+0 
;MyProject.c,128 :: 		byteL  = 0xE1;
	MOVLW       225
	MOVWF       _byteL+0 
;MyProject.c,144 :: 		dir1 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,145 :: 		dir2 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,153 :: 		while(1)
L_main1:
;MyProject.c,157 :: 		if (sens1)                                                                 //Detetou Obstáculo?
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main3
;MyProject.c,159 :: 		cont += 1;                                                            //Incrementa o contador
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;MyProject.c,160 :: 		parouimpar = par_impar_test();                                        //Confirma se o número do contador é par ou impar
	CALL        _par_impar_test+0, 0
	MOVF        R0, 0 
	MOVWF       _parouimpar+0 
	MOVF        R1, 0 
	MOVWF       _parouimpar+1 
;MyProject.c,162 :: 		switch(parouimpar)                                                    //switch
	GOTO        L_main4
;MyProject.c,164 :: 		case 0:                                                              //Se for par
L_main6:
;MyProject.c,165 :: 		virardireita();                                                 //Vira para a direita
	CALL        _virardireita+0, 0
;MyProject.c,166 :: 		break;
	GOTO        L_main5
;MyProject.c,168 :: 		case 1:                                                              //Se for impar
L_main7:
;MyProject.c,169 :: 		viraresquerda();                                                //Vira para a esquerda
	CALL        _viraresquerda+0, 0
;MyProject.c,170 :: 		break;
	GOTO        L_main5
;MyProject.c,172 :: 		default:
L_main8:
;MyProject.c,173 :: 		break;
	GOTO        L_main5
;MyProject.c,174 :: 		} //end switch
L_main4:
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main29
	MOVLW       0
	XORWF       _parouimpar+0, 0 
L__main29:
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main30
	MOVLW       1
	XORWF       _parouimpar+0, 0 
L__main30:
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	GOTO        L_main8
L_main5:
;MyProject.c,175 :: 		} //end if
L_main3:
;MyProject.c,177 :: 		if (!sens2)                                                                //O sensor deixou de detetar chão?
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main9
;MyProject.c,180 :: 		cont += 1;                                                               //Incrementa o contador
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;MyProject.c,181 :: 		parouimpar2 = par_impar_test();                                           //Confirma se o número do contador é par ou impar
	CALL        _par_impar_test+0, 0
	MOVF        R0, 0 
	MOVWF       _parouimpar2+0 
	MOVF        R1, 0 
	MOVWF       _parouimpar2+1 
;MyProject.c,183 :: 		switch(parouimpar2)                                                       //switch
	GOTO        L_main10
;MyProject.c,185 :: 		case 0:                                                                  //Se for par
L_main12:
;MyProject.c,186 :: 		viraresquerda();                                                    //Vira para a esquerda
	CALL        _viraresquerda+0, 0
;MyProject.c,187 :: 		break;
	GOTO        L_main11
;MyProject.c,189 :: 		case 1:                                                                  //Se for impar
L_main13:
;MyProject.c,190 :: 		virardireita();                                                     //Vira para a direita
	CALL        _virardireita+0, 0
;MyProject.c,191 :: 		break;
	GOTO        L_main11
;MyProject.c,192 :: 		}  //end switch
L_main10:
	MOVLW       0
	XORWF       _parouimpar2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main31
	MOVLW       0
	XORWF       _parouimpar2+0, 0 
L__main31:
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVLW       0
	XORWF       _parouimpar2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main32
	MOVLW       1
	XORWF       _parouimpar2+0, 0 
L__main32:
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
L_main11:
;MyProject.c,193 :: 		}  //end if
L_main9:
;MyProject.c,196 :: 		} //end while
	GOTO        L_main1
;MyProject.c,197 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main

_voltmeter:

;MyProject.c,206 :: 		void voltmeter()
;MyProject.c,211 :: 		volts_f = ADC_Read(0)*0.048875;                                                //Conversão da leitura ADC
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,221 :: 		}
L_end_voltmeter:
	RETURN      0
; end of _voltmeter

_par_impar_test:

;MyProject.c,227 :: 		int par_impar_test ()
;MyProject.c,229 :: 		if(cont % 2 == 0)                                                              //O número é par?
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
	GOTO        L__par_impar_test35
	MOVLW       0
	XORWF       R1, 0 
L__par_impar_test35:
	BTFSS       STATUS+0, 2 
	GOTO        L_par_impar_test14
;MyProject.c,231 :: 		return 0;                                                                     //Retorna 0
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_par_impar_test
;MyProject.c,232 :: 		}
L_par_impar_test14:
;MyProject.c,235 :: 		return 1;                                                                     //Retorna 1
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;MyProject.c,237 :: 		}
L_end_par_impar_test:
	RETURN      0
; end of _par_impar_test

_virardireita:

;MyProject.c,241 :: 		void virardireita()                                                             //Função para virar para a direita
;MyProject.c,243 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,244 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,245 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,246 :: 		delay_ms(1500);                                                          //Robo STOP
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_virardireita16:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita16
	DECFSZ      R12, 1, 1
	BRA         L_virardireita16
	DECFSZ      R11, 1, 1
	BRA         L_virardireita16
	NOP
;MyProject.c,248 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,249 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,250 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,251 :: 		delay_ms(1200);                                                          //Robo anda para trás
	MOVLW       31
	MOVWF       R11, 0
	MOVLW       113
	MOVWF       R12, 0
	MOVLW       30
	MOVWF       R13, 0
L_virardireita17:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita17
	DECFSZ      R12, 1, 1
	BRA         L_virardireita17
	DECFSZ      R11, 1, 1
	BRA         L_virardireita17
	NOP
;MyProject.c,253 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,254 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,255 :: 		delay_ms (4400);                                                         //Desvio Robo
	MOVLW       112
	MOVWF       R11, 0
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       33
	MOVWF       R13, 0
L_virardireita18:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita18
	DECFSZ      R12, 1, 1
	BRA         L_virardireita18
	DECFSZ      R11, 1, 1
	BRA         L_virardireita18
;MyProject.c,257 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,258 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,259 :: 		delay_ms(4000);                                                          //Anda em frente
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_virardireita19:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita19
	DECFSZ      R12, 1, 1
	BRA         L_virardireita19
	DECFSZ      R11, 1, 1
	BRA         L_virardireita19
;MyProject.c,261 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,262 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,263 :: 		delay_ms (4400);                                                         //Desvio Robo
	MOVLW       112
	MOVWF       R11, 0
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       33
	MOVWF       R13, 0
L_virardireita20:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita20
	DECFSZ      R12, 1, 1
	BRA         L_virardireita20
	DECFSZ      R11, 1, 1
	BRA         L_virardireita20
;MyProject.c,265 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,266 :: 		dir2 = 0x01;                                                             //Anda em frente
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,267 :: 		}
L_end_virardireita:
	RETURN      0
; end of _virardireita

_viraresquerda:

;MyProject.c,271 :: 		void viraresquerda()                                                            //Função para virar para a esquerda
;MyProject.c,273 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,274 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,275 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,276 :: 		delay_ms(1500);                                                          //Robo STOP
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_viraresquerda21:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda21
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda21
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda21
	NOP
;MyProject.c,278 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,279 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,280 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,281 :: 		delay_ms(1200);                                                          //Robo anda para trás
	MOVLW       31
	MOVWF       R11, 0
	MOVLW       113
	MOVWF       R12, 0
	MOVLW       30
	MOVWF       R13, 0
L_viraresquerda22:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda22
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda22
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda22
	NOP
;MyProject.c,283 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,284 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,285 :: 		delay_ms (4400);                                                         //Desvio Robo
	MOVLW       112
	MOVWF       R11, 0
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       33
	MOVWF       R13, 0
L_viraresquerda23:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda23
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda23
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda23
;MyProject.c,287 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,288 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,289 :: 		delay_ms(4000);                                                          //Anda em frente
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_viraresquerda24:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda24
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda24
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda24
;MyProject.c,291 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,292 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,293 :: 		delay_ms (4400);                                                         //Desvio Robo
	MOVLW       112
	MOVWF       R11, 0
	MOVLW       156
	MOVWF       R12, 0
	MOVLW       33
	MOVWF       R13, 0
L_viraresquerda25:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda25
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda25
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda25
;MyProject.c,295 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,296 :: 		dir2 = 0x01;                                                             //Anda em frente
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,297 :: 		}
L_end_viraresquerda:
	RETURN      0
; end of _viraresquerda

_semchao:

;MyProject.c,299 :: 		void semchao()
;MyProject.c,302 :: 		}
L_end_semchao:
	RETURN      0
; end of _semchao
