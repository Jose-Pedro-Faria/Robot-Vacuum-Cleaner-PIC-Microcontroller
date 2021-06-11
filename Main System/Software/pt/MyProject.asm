
_interrupt:

;MyProject.c,48 :: 		void interrupt()
;MyProject.c,52 :: 		if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;MyProject.c,54 :: 		TMR0IF_bit = 0x00;                                                     //Limpa Flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;MyProject.c,55 :: 		lcd_upt   += 1;                                                        //incrementa 1
	INFSNZ      interrupt_lcd_upt_L0+0, 1 
	INCF        interrupt_lcd_upt_L0+1, 1 
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
;MyProject.c,62 :: 		if(lcd_upt == 333)                                                     //Lcd_upt = 333 (numero de incrementos do timer0 necessários para contar 1s)
	MOVF        interrupt_lcd_upt_L0+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt15
	MOVLW       77
	XORWF       interrupt_lcd_upt_L0+0, 0 
L__interrupt15:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;MyProject.c,64 :: 		lcd_upt   = 0;                                                        //reseta a variável
	CLRF        interrupt_lcd_upt_L0+0 
	CLRF        interrupt_lcd_upt_L0+1 
;MyProject.c,65 :: 		flags     = ~flags;                                                   //Inverte o estado de flags (o registador inteiro)
	COMF        _flags+0, 1 
;MyProject.c,66 :: 		} //end if lcd_upt
L_interrupt1:
;MyProject.c,67 :: 		} //end if TMR0IF
L_interrupt0:
;MyProject.c,68 :: 		} //end interrupt
L_end_interrupt:
L__interrupt14:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,72 :: 		void main()
;MyProject.c,75 :: 		INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
	MOVLW       160
	MOVWF       INTCON+0 
;MyProject.c,79 :: 		TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,80 :: 		T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
	BCF         T08BIT_bit+0, BitPos(T08BIT_bit+0) 
;MyProject.c,81 :: 		T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
	BCF         T0CS_bit+0, BitPos(T0CS_bit+0) 
;MyProject.c,82 :: 		PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
	BSF         PSA_bit+0, BitPos(PSA_bit+0) 
;MyProject.c,88 :: 		TMR0L    = 0x48;                                                           //byte menos significativo      0x48
	MOVLW       72
	MOVWF       TMR0L+0 
;MyProject.c,89 :: 		TMR0H    = 0x77;                                                           //byte mais significativo       0x77
	MOVLW       119
	MOVWF       TMR0H+0 
;MyProject.c,92 :: 		TRISA    = 0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,93 :: 		ADCON0   = 0x01;                                                           //Ligar o conversor A/C
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,94 :: 		ADCON1   = 0x0E;                                                           //Apenas o AN0 como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,95 :: 		ADCON2   = 0x18;
	MOVLW       24
	MOVWF       ADCON2+0 
;MyProject.c,109 :: 		TRISB   = 0xC0;                                                            //Configura IOs no PORTB
	MOVLW       192
	MOVWF       TRISB+0 
;MyProject.c,110 :: 		PORTB   = 0xC0;                                                            //Inicializa PORTB
	MOVLW       192
	MOVWF       PORTB+0 
;MyProject.c,111 :: 		TRISD   = 0x3C;                                                            //Configura IOs no PORTD
	MOVLW       60
	MOVWF       TRISD+0 
;MyProject.c,112 :: 		PORTD   = 0x3C;                                                            //Inicializa PORTD
	MOVLW       60
	MOVWF       PORTD+0 
;MyProject.c,113 :: 		ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,115 :: 		byteH  = 0xB4;                                                            //130Hz
	MOVLW       180
	MOVWF       _byteH+0 
;MyProject.c,116 :: 		byteL  = 0xE1;
	MOVLW       225
	MOVWF       _byteL+0 
;MyProject.c,132 :: 		dir1 = 0x01;                                                              //Define o bit de direção inicial
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,133 :: 		dir2 = 0x00;                                                              //Define o bit de direção inicial
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,135 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,137 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,139 :: 		Lcd_Out(1,1,"Jose Faria");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,141 :: 		while(1)
L_main2:
;MyProject.c,143 :: 		if(flags) voltmeter();
	MOVF        _flags+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	CALL        _voltmeter+0, 0
L_main4:
;MyProject.c,145 :: 		if(sens1)                                                                 //Sensor da Direita
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main5
;MyProject.c,147 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,148 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,149 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,150 :: 		delay_ms(2000);                                                          //Robo STOP
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	DECFSZ      R11, 1, 1
	BRA         L_main6
	NOP
	NOP
;MyProject.c,151 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,152 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,153 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,154 :: 		delay_ms(2000);                                                          //Robo anda para trás
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_main7:
	DECFSZ      R13, 1, 1
	BRA         L_main7
	DECFSZ      R12, 1, 1
	BRA         L_main7
	DECFSZ      R11, 1, 1
	BRA         L_main7
	NOP
	NOP
;MyProject.c,155 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,156 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,157 :: 		delay_ms (4000);                                                         //Desvio Robo
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
	DECFSZ      R11, 1, 1
	BRA         L_main8
;MyProject.c,158 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,159 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,160 :: 		} //end if sens1
L_main5:
;MyProject.c,162 :: 		if (sens2)                                                                //Sensore da Esquerda
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main9
;MyProject.c,164 :: 		TMR0ON_bit = 0x00;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,165 :: 		vel1 = 0x00;
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
;MyProject.c,166 :: 		vel2 = 0x00;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;MyProject.c,167 :: 		delay_ms(2000);                                                          //Robo STOP
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	NOP
	NOP
;MyProject.c,168 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,169 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,170 :: 		TMR0ON_bit = 0x01;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;MyProject.c,171 :: 		delay_ms(2000);                                                          //Robo anda para trás
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	DECFSZ      R11, 1, 1
	BRA         L_main11
	NOP
	NOP
;MyProject.c,172 :: 		dir1 = 0x00;
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,173 :: 		dir2 = 0x01;
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,174 :: 		delay_ms (4000);                                                         //Desvio Robo
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	DECFSZ      R12, 1, 1
	BRA         L_main12
	DECFSZ      R11, 1, 1
	BRA         L_main12
;MyProject.c,175 :: 		dir1 = 0x01;
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;MyProject.c,176 :: 		dir2 = 0x00;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;MyProject.c,177 :: 		} //end if sens2
L_main9:
;MyProject.c,179 :: 		} //end while
	GOTO        L_main2
;MyProject.c,180 :: 		} //end main
L_end_main:
	GOTO        $+0
; end of _main

_voltmeter:

;MyProject.c,189 :: 		void voltmeter()
;MyProject.c,194 :: 		volts_f = ADC_Read(0)*0.048875;
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVLW       39
	MOVWF       R4 
	MOVLW       49
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       122
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
;MyProject.c,195 :: 		volts_f *=2.8;
	MOVLW       51
	MOVWF       R4 
	MOVLW       51
	MOVWF       R5 
	MOVLW       51
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
;MyProject.c,196 :: 		volts = (int)volts_f;
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       voltmeter_volts_L0+0 
	MOVF        R1, 0 
	MOVWF       voltmeter_volts_L0+1 
;MyProject.c,198 :: 		Lcd_Chr(2,1,((char)volts/100)+0x30);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,199 :: 		Lcd_Chr_cp( ((char)volts&100/10)+0x30);
	MOVLW       10
	ANDWF       voltmeter_volts_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	MOVLW       48
	ADDWF       FARG_Lcd_Chr_CP_out_char+0, 1 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,200 :: 		Lcd_Chr_cp('.');
	MOVLW       46
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,201 :: 		Lcd_Chr_cp( ((char)volts&10)+0x30);
	MOVLW       10
	ANDWF       voltmeter_volts_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	MOVLW       48
	ADDWF       FARG_Lcd_Chr_CP_out_char+0, 1 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,202 :: 		Lcd_Chr_cp('V');
	MOVLW       86
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,203 :: 		}
L_end_voltmeter:
	RETURN      0
; end of _voltmeter
