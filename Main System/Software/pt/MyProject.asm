
_interrupt:

;MyProject.c,46 :: 		void interrupt()
;MyProject.c,48 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,50 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,51 :: 		TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
	MOVF        _byteH+0, 0 
	MOVWF       TMR0L+0 
;MyProject.c,52 :: 		TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0
	MOVF        _byteL+0, 0 
	MOVWF       TMR0H+0 
;MyProject.c,54 :: 		vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
	BTG         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,55 :: 		vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
	BTG         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,56 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,57 :: 		} //end interrupt
L_end_interrupt:
L__interrupt12:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,61 :: 		void main()
;MyProject.c,64 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,68 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,69 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,70 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,71 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,77 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,78 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,93 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,94 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,95 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,96 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,97 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,99 :: 		byteH  = 0xB4;                                                            //130Hz
	MOVLW       180
	MOVWF       _byteH+0 
;MyProject.c,100 :: 		byteL  = 0xE1;
	MOVLW       225
	MOVWF       _byteL+0 
;MyProject.c,116 :: 		dir1 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,117 :: 		dir2 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,119 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,120 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,121 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,123 :: 		Lcd_Out(1,1,"TESTE Display");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,125 :: 		while(1)
L_main1:
;MyProject.c,128 :: 		if(sens1)                                                                 //Sensor da Direita
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main3
;MyProject.c,130 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,131 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,132 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,133 :: 		delay_ms(1200);                                                          //Robo STOP
	MOVLW       31
	MOVWF       R11, 0
	MOVLW       113
	MOVWF       R12, 0
	MOVLW       30
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
;MyProject.c,134 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,135 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,136 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,137 :: 		delay_ms(1500);                                                          //Robo anda para trás
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
;MyProject.c,138 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,139 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,140 :: 		delay_ms (3800);                                                         //Desvio Robo
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
;MyProject.c,141 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,142 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,143 :: 		} //end if sens1
L_main3:
;MyProject.c,145 :: 		if (sens2)                                                                //Sensore da Esquerda
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main7
;MyProject.c,147 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,148 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,149 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,150 :: 		delay_ms(1000);                                                          //Robo STOP
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
;MyProject.c,151 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,152 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,153 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,154 :: 		delay_ms(1500);                                                          //Robo anda para trás
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
;MyProject.c,155 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,156 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,157 :: 		delay_ms (3800);                                                         //Desvio Robo
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
;MyProject.c,158 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,159 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,160 :: 		} //end if sens2
L_main7:
;MyProject.c,162 :: 		} //end while
	GOTO        L_main1
;MyProject.c,163 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main
