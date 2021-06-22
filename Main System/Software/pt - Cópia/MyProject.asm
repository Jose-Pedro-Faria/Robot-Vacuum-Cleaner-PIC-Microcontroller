
_interrupt:

;MyProject.c,57 :: 		void interrupt()
;MyProject.c,61 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,63 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,65 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,66 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,68 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,69 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,78 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,79 :: 		} //end interrupt
L_end_interrupt:
L__interrupt32:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,83 :: 		void main()
;MyProject.c,86 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,90 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,91 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,92 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,93 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,99 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,100 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,103 :: 		TRISA    = 0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,104 :: 		ADCON0   = 0x01;                                                           //Ligar o conversor A/C
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,105 :: 		ADCON1   = 0x0E;                                                           //Apenas o AN0 como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,106 :: 		ADCON2   = 0x18;
	MOVLW       24
	MOVWF       ADCON2+0 
;MyProject.c,120 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,121 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,122 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,123 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,124 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,128 :: 		byteH  = 0xB4;                                                            //130Hz
	MOVLW       180
	MOVWF       _byteH+0 
;MyProject.c,129 :: 		byteL  = 0xE1;
	MOVLW       225
	MOVWF       _byteL+0 
;MyProject.c,148 :: 		dir1 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,149 :: 		dir2 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,158 :: 		while(1)
L_main1:
;MyProject.c,162 :: 		if (sens1)                                                                 //Detetou Obstáculo?
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main3
;MyProject.c,164 :: 		cont += 1;                                                            //Incrementa o contador
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;MyProject.c,165 :: 		parouimpar = par_impar_test();                                        //Confirma se o número do contador é par ou impar
	CALL        _par_impar_test+0, 0
	MOVF        R0, 0 
	MOVWF       _parouimpar+0 
	MOVF        R1, 0 
	MOVWF       _parouimpar+1 
;MyProject.c,167 :: 		switch(parouimpar)                                                    //switch
	GOTO        L_main4
;MyProject.c,169 :: 		case 0:                                                              //Se for par
L_main6:
;MyProject.c,170 :: 		viraresquerda();                                                 //Vira para a direita
	CALL        _viraresquerda+0, 0
;MyProject.c,171 :: 		break;
	GOTO        L_main5
;MyProject.c,173 :: 		case 1:                                                              //Se for impar
L_main7:
;MyProject.c,174 :: 		virardireita();                                                //Vira para a esquerda
	CALL        _virardireita+0, 0
;MyProject.c,175 :: 		break;
	GOTO        L_main5
;MyProject.c,177 :: 		default:                                                             //Se não houver retorno não faz nada
L_main8:
;MyProject.c,178 :: 		break;
	GOTO        L_main5
;MyProject.c,179 :: 		} //end switch
L_main4:
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main34
	MOVLW       0
	XORWF       _parouimpar+0, 0 
L__main34:
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
	MOVLW       0
	XORWF       _parouimpar+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main35
	MOVLW       1
	XORWF       _parouimpar+0, 0 
L__main35:
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	GOTO        L_main8
L_main5:
;MyProject.c,180 :: 		} //end if  sens1
L_main3:
;MyProject.c,183 :: 		if (!sens2)                                                                //O sensor deixou de detetar chão?
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main9
;MyProject.c,185 :: 		faltachao();                                                              //chama a função responsável por tratar a falta de chão
	CALL        _faltachao+0, 0
;MyProject.c,187 :: 		}  //end if sens2
L_main9:
;MyProject.c,190 :: 		} //end while
	GOTO        L_main1
;MyProject.c,192 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main

_voltmeter:

;MyProject.c,201 :: 		void voltmeter()
;MyProject.c,206 :: 		volts_f = ADC_Read(0)*0.048875;                                                //Conversão da leitura ADC
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,216 :: 		}
L_end_voltmeter:
	RETURN      0
; end of _voltmeter

_faltachao:

;MyProject.c,222 :: 		void faltachao()
;MyProject.c,224 :: 		cont += 1;                                                                //Incrementa o contador
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;MyProject.c,225 :: 		parouimpar2 = par_impar_test();                                           //Confirma se o número do contador é par ou impar
	CALL        _par_impar_test+0, 0
	MOVF        R0, 0 
	MOVWF       _parouimpar2+0 
	MOVF        R1, 0 
	MOVWF       _parouimpar2+1 
;MyProject.c,227 :: 		switch(parouimpar2)                                                       //switch
	GOTO        L_faltachao10
;MyProject.c,229 :: 		case 0:                                                                  //Se for par
L_faltachao12:
;MyProject.c,230 :: 		viraresquerda();                                                    //Vira para a direita
	CALL        _viraresquerda+0, 0
;MyProject.c,231 :: 		break;
	GOTO        L_faltachao11
;MyProject.c,233 :: 		case 1:                                                                  //Se for impar
L_faltachao13:
;MyProject.c,234 :: 		virardireita();                                                    //Vira para a esquerda
	CALL        _virardireita+0, 0
;MyProject.c,235 :: 		break;
	GOTO        L_faltachao11
;MyProject.c,236 :: 		default:                                                                 //Se não houver retorno não faz nada
L_faltachao14:
;MyProject.c,237 :: 		break;
	GOTO        L_faltachao11
;MyProject.c,238 :: 		} //end switch
L_faltachao10:
	MOVLW       0
	XORWF       _parouimpar2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__faltachao38
	MOVLW       0
	XORWF       _parouimpar2+0, 0 
L__faltachao38:
	BTFSC       STATUS+0, 2 
	GOTO        L_faltachao12
	MOVLW       0
	XORWF       _parouimpar2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__faltachao39
	MOVLW       1
	XORWF       _parouimpar2+0, 0 
L__faltachao39:
	BTFSC       STATUS+0, 2 
	GOTO        L_faltachao13
	GOTO        L_faltachao14
L_faltachao11:
;MyProject.c,239 :: 		} //end faltachao
L_end_faltachao:
	RETURN      0
; end of _faltachao

_par_impar_test:

;MyProject.c,245 :: 		int par_impar_test ()
;MyProject.c,247 :: 		if(cont % 2 == 0)                                                              //O número é par?
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
	GOTO        L__par_impar_test41
	MOVLW       0
	XORWF       R1, 0 
L__par_impar_test41:
	BTFSS       STATUS+0, 2 
	GOTO        L_par_impar_test15
;MyProject.c,249 :: 		return 0;                                                                     //Retorna 0
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_par_impar_test
;MyProject.c,250 :: 		}
L_par_impar_test15:
;MyProject.c,253 :: 		return 1;                                                                     //Retorna 1
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;MyProject.c,255 :: 		}
L_end_par_impar_test:
	RETURN      0
; end of _par_impar_test

_virardireita:

;MyProject.c,259 :: 		void virardireita()                                                             //Função para virar para a direita
;MyProject.c,261 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,262 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,263 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,264 :: 		delay_ms(1500);                                                          //Robo STOP
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_virardireita17:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita17
	DECFSZ      R12, 1, 1
	BRA         L_virardireita17
	DECFSZ      R11, 1, 1
	BRA         L_virardireita17
	NOP
;MyProject.c,266 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,267 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,268 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,269 :: 		delay_ms(900);                                                          //Robo anda para trás
	MOVLW       23
	MOVWF       R11, 0
	MOVLW       213
	MOVWF       R12, 0
	MOVLW       22
	MOVWF       R13, 0
L_virardireita18:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita18
	DECFSZ      R12, 1, 1
	BRA         L_virardireita18
	DECFSZ      R11, 1, 1
	BRA         L_virardireita18
	NOP
;MyProject.c,271 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,272 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,273 :: 		delay_ms (4300);                                                         //Desvio Robo
	MOVLW       110
	MOVWF       R11, 0
	MOVLW       18
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_virardireita19:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita19
	DECFSZ      R12, 1, 1
	BRA         L_virardireita19
	DECFSZ      R11, 1, 1
	BRA         L_virardireita19
;MyProject.c,275 :: 		if(sens1)                                                                //Mesmo depois do desvio tem obstáculo?
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_virardireita20
;MyProject.c,277 :: 		dir1= 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,278 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,279 :: 		delay_ms (7500);                                                       //Roda 180 graus antes de voltar à normalidade
	MOVLW       191
	MOVWF       R11, 0
	MOVLW       61
	MOVWF       R12, 0
	MOVLW       203
	MOVWF       R13, 0
L_virardireita21:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita21
	DECFSZ      R12, 1, 1
	BRA         L_virardireita21
	DECFSZ      R11, 1, 1
	BRA         L_virardireita21
	NOP
	NOP
;MyProject.c,280 :: 		cont2 += 1;                                                             //Incrementa 1 no contador 2
	INFSNZ      _cont2+0, 1 
	INCF        _cont2+1, 1 
;MyProject.c,281 :: 		}  //end if sens1
L_virardireita20:
;MyProject.c,283 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,284 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,285 :: 		delay_ms(5000);                                                          //Anda em frente
	MOVLW       127
	MOVWF       R11, 0
	MOVLW       212
	MOVWF       R12, 0
	MOVLW       49
	MOVWF       R13, 0
L_virardireita22:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita22
	DECFSZ      R12, 1, 1
	BRA         L_virardireita22
	DECFSZ      R11, 1, 1
	BRA         L_virardireita22
	NOP
	NOP
;MyProject.c,288 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,289 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,290 :: 		delay_ms (4300);                                                         //Desvio Robo
	MOVLW       110
	MOVWF       R11, 0
	MOVLW       18
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_virardireita23:
	DECFSZ      R13, 1, 1
	BRA         L_virardireita23
	DECFSZ      R12, 1, 1
	BRA         L_virardireita23
	DECFSZ      R11, 1, 1
	BRA         L_virardireita23
;MyProject.c,302 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,303 :: 		dir2 = 0x01;                                                             //Anda em frente
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,305 :: 		}  // end virar direita
L_end_virardireita:
	RETURN      0
; end of _virardireita

_viraresquerda:

;MyProject.c,311 :: 		void viraresquerda()                                                            //Função para virar para a esquerda
;MyProject.c,313 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,314 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,315 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,316 :: 		delay_ms(1500);                                                          //Robo STOP
	MOVLW       39
	MOVWF       R11, 0
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       38
	MOVWF       R13, 0
L_viraresquerda24:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda24
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda24
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda24
	NOP
;MyProject.c,318 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,319 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,320 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,321 :: 		delay_ms(900);                                                          //Robo anda para trás
	MOVLW       23
	MOVWF       R11, 0
	MOVLW       213
	MOVWF       R12, 0
	MOVLW       22
	MOVWF       R13, 0
L_viraresquerda25:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda25
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda25
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda25
	NOP
;MyProject.c,323 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,324 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,325 :: 		delay_ms (4200);                                                         //Desvio Robo
	MOVLW       107
	MOVWF       R11, 0
	MOVLW       137
	MOVWF       R12, 0
	MOVLW       113
	MOVWF       R13, 0
L_viraresquerda26:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda26
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda26
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda26
;MyProject.c,327 :: 		if(sens1)                                                                //Mesmo depois do desvio tem obstáculo?
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_viraresquerda27
;MyProject.c,329 :: 		dir1= 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,330 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,331 :: 		delay_ms (7500);                                                       //Roda 180 graus antes de voltar à normalidade
	MOVLW       191
	MOVWF       R11, 0
	MOVLW       61
	MOVWF       R12, 0
	MOVLW       203
	MOVWF       R13, 0
L_viraresquerda28:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda28
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda28
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda28
	NOP
	NOP
;MyProject.c,332 :: 		cont2 += 1;                                                             //Incrementa 1 no contador 2
	INFSNZ      _cont2+0, 1 
	INCF        _cont2+1, 1 
;MyProject.c,333 :: 		}    //end if sens1
L_viraresquerda27:
;MyProject.c,335 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,336 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,337 :: 		delay_ms(5000);                                                          //Anda em frente
	MOVLW       127
	MOVWF       R11, 0
	MOVLW       212
	MOVWF       R12, 0
	MOVLW       49
	MOVWF       R13, 0
L_viraresquerda29:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda29
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda29
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda29
	NOP
	NOP
;MyProject.c,340 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,341 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,342 :: 		delay_ms (4200);                                                         //Desvio Robo
	MOVLW       107
	MOVWF       R11, 0
	MOVLW       137
	MOVWF       R12, 0
	MOVLW       113
	MOVWF       R13, 0
L_viraresquerda30:
	DECFSZ      R13, 1, 1
	BRA         L_viraresquerda30
	DECFSZ      R12, 1, 1
	BRA         L_viraresquerda30
	DECFSZ      R11, 1, 1
	BRA         L_viraresquerda30
;MyProject.c,354 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,355 :: 		dir2 = 0x01;                                                             //Anda em frente
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,358 :: 		}    //end virar esquerda
L_end_viraresquerda:
	RETURN      0
; end of _viraresquerda
