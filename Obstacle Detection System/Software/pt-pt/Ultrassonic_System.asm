
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Ultrassonic_System.c,75 :: 		void interrupt()
;Ultrassonic_System.c,79 :: 		if(INTF_bit)                                //houve interrupção externa?
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;Ultrassonic_System.c,81 :: 		INTF_bit = 0x00;                         //limpa a flag
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;Ultrassonic_System.c,83 :: 		if(!TMR1ON_bit)                          //timer1 desligado?
	BTFSC      TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
	GOTO       L_interrupt1
;Ultrassonic_System.c,85 :: 		TMR1ON_bit = 0x01;                    //liga timer1
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Ultrassonic_System.c,86 :: 		INTEDG_bit = 0x00;                    //configura int externa para borda de descida
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;Ultrassonic_System.c,88 :: 		} //end if TMR1ON_bit
	GOTO       L_interrupt2
L_interrupt1:
;Ultrassonic_System.c,92 :: 		TMR1ON_bit = 0x00;                    //desliga timer1
	BCF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Ultrassonic_System.c,93 :: 		pulseEcho = (TMR1H << 8) + TMR1L;     //salva largura do pulso em µs
	MOVF       TMR1H+0, 0
	MOVWF      _pulseEcho+1
	CLRF       _pulseEcho+0
	MOVF       TMR1L+0, 0
	ADDWF      _pulseEcho+0, 1
	BTFSC      STATUS+0, 0
	INCF       _pulseEcho+1, 1
;Ultrassonic_System.c,94 :: 		TMR1H  = 0x00;                        //reinicia TMR1H
	CLRF       TMR1H+0
;Ultrassonic_System.c,95 :: 		TMR1L  = 0x00;                        //reinicia TMR1L
	CLRF       TMR1L+0
;Ultrassonic_System.c,96 :: 		INTEDG_bit = 0x01;                    //configura int externa para borda de subida
	BSF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;Ultrassonic_System.c,98 :: 		} //end else TMR1ON_bit
L_interrupt2:
;Ultrassonic_System.c,100 :: 		} //end INTF_bit
L_interrupt0:
;Ultrassonic_System.c,105 :: 		if(T0IF_bit)                                //houve interrupção do timer0?
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_interrupt3
;Ultrassonic_System.c,107 :: 		T0IF_bit = 0x00;                         //limpa a flag
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;Ultrassonic_System.c,108 :: 		TMR0     =   21;                         //reinicia timer0
	MOVLW      21
	MOVWF      TMR0+0
;Ultrassonic_System.c,111 :: 		trig_pulse;                              //gera pulso de trigger
	BSF        GPIO+0, 1
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BCF        GPIO+0, 1
;Ultrassonic_System.c,113 :: 		} //end T0IF_bit
L_interrupt3:
;Ultrassonic_System.c,115 :: 		} //end interrupt
L_end_interrupt:
L__interrupt59:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Ultrassonic_System.c,120 :: 		void main()
;Ultrassonic_System.c,122 :: 		CMCON      = 0x07;                          //desabilita comparadores internos
	MOVLW      7
	MOVWF      CMCON+0
;Ultrassonic_System.c,123 :: 		OPTION_REG = 0xC7;                          //interrupção externa por borda de subida
	MOVLW      199
	MOVWF      OPTION_REG+0
;Ultrassonic_System.c,125 :: 		INTCON     = 0xB0;                          //habilita interrupção global, do timer0 e externa
	MOVLW      176
	MOVWF      INTCON+0
;Ultrassonic_System.c,126 :: 		TMR0       =   21;                          //inicializa Timer0 em 21
	MOVLW      21
	MOVWF      TMR0+0
;Ultrassonic_System.c,127 :: 		TRISIO     = 0x0C;                          //configura I/Os
	MOVLW      12
	MOVWF      TRISIO+0
;Ultrassonic_System.c,128 :: 		GPIO       = 0x0C;                          //inicializa I/Os
	MOVLW      12
	MOVWF      GPIO+0
;Ultrassonic_System.c,129 :: 		T1CON      = 0x00;                          //timer1 inicia desligado com prescaler 1:1
	CLRF       T1CON+0
;Ultrassonic_System.c,132 :: 		while(1)                                    //loop infinito
L_main4:
;Ultrassonic_System.c,134 :: 		pulseL = moving_average(pulseEcho);      //filtra pulso de echo e armazena em pulseL
	MOVF       _pulseEcho+0, 0
	MOVWF      FARG_moving_average_pulseIn+0
	MOVF       _pulseEcho+1, 0
	MOVWF      FARG_moving_average_pulseIn+1
	CALL       _moving_average+0
	MOVF       R0+0, 0
	MOVWF      _pulseL+0
	MOVF       R0+1, 0
	MOVWF      _pulseL+1
;Ultrassonic_System.c,136 :: 		if(option) optionA(20,15,10);            //se option em HIGH, opção de funcionamento A
	BTFSS      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L_main6
	MOVLW      20
	MOVWF      FARG_optionA_cm1+0
	MOVLW      15
	MOVWF      FARG_optionA_cm2+0
	MOVLW      10
	MOVWF      FARG_optionA_cm3+0
	CALL       _optionA+0
	GOTO       L_main7
L_main6:
;Ultrassonic_System.c,137 :: 		else       optionB();                    //se option em  LOW, opção de funcionamento B
	CALL       _optionB+0
L_main7:
;Ultrassonic_System.c,141 :: 		} //end while
	GOTO       L_main4
;Ultrassonic_System.c,143 :: 		} //end main
L_end_main:
	GOTO       $+0
; end of _main

_optionA:

;Ultrassonic_System.c,148 :: 		void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3)
;Ultrassonic_System.c,150 :: 		if(pulseL < (cm1*58) && pulseL >= (cm2*58)) //distância menor que cm1 e maior igual a cm2?
	MOVF       FARG_optionA_cm1+0, 0
	MOVWF      R0+0
	MOVLW      58
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+1, 0
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionA62
	MOVF       R0+0, 0
	SUBWF      _pulseL+0, 0
L__optionA62:
	BTFSC      STATUS+0, 0
	GOTO       L_optionA10
	MOVF       FARG_optionA_cm2+0, 0
	MOVWF      R0+0
	MOVLW      58
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+1, 0
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionA63
	MOVF       R0+0, 0
	SUBWF      _pulseL+0, 0
L__optionA63:
	BTFSS      STATUS+0, 0
	GOTO       L_optionA10
L__optionA51:
;Ultrassonic_System.c,152 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,153 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,154 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,156 :: 		} //end pulseL 1160
	GOTO       L_optionA11
L_optionA10:
;Ultrassonic_System.c,158 :: 		else if(pulseL < (cm2*58) && pulseL >= (cm3*58))  //distância menor que cm2 e maior igual a cm2=3?
	MOVF       FARG_optionA_cm2+0, 0
	MOVWF      R0+0
	MOVLW      58
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+1, 0
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionA64
	MOVF       R0+0, 0
	SUBWF      _pulseL+0, 0
L__optionA64:
	BTFSC      STATUS+0, 0
	GOTO       L_optionA14
	MOVF       FARG_optionA_cm3+0, 0
	MOVWF      R0+0
	MOVLW      58
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+1, 0
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionA65
	MOVF       R0+0, 0
	SUBWF      _pulseL+0, 0
L__optionA65:
	BTFSS      STATUS+0, 0
	GOTO       L_optionA14
L__optionA50:
;Ultrassonic_System.c,160 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,161 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,162 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,164 :: 		} //end pulseL 870
	GOTO       L_optionA15
L_optionA14:
;Ultrassonic_System.c,166 :: 		else if(pulseL < (cm3*58))                  //distância menor que cm3?
	MOVF       FARG_optionA_cm3+0, 0
	MOVWF      R0+0
	MOVLW      58
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+1, 0
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionA66
	MOVF       R0+0, 0
	SUBWF      _pulseL+0, 0
L__optionA66:
	BTFSC      STATUS+0, 0
	GOTO       L_optionA16
;Ultrassonic_System.c,168 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,169 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,170 :: 		dist3 = 0x01;                            //dist3 em HIGH
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,172 :: 		} //end pulseL 580
	GOTO       L_optionA17
L_optionA16:
;Ultrassonic_System.c,176 :: 		dist1 = 0x00;                            //dist1 em  LOW
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,177 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,178 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,180 :: 		} //end else
L_optionA17:
L_optionA15:
L_optionA11:
;Ultrassonic_System.c,182 :: 		} //end optionA
L_end_optionA:
	RETURN
; end of _optionA

_optionB:

;Ultrassonic_System.c,185 :: 		void optionB()
;Ultrassonic_System.c,187 :: 		if(pulseL < 2320 && pulseL >= 2030)         //distância menor que 40cm? (2320/58)
	MOVLW      9
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB68
	MOVLW      16
	SUBWF      _pulseL+0, 0
L__optionB68:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB20
	MOVLW      7
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB69
	MOVLW      238
	SUBWF      _pulseL+0, 0
L__optionB69:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB20
L__optionB57:
;Ultrassonic_System.c,189 :: 		dist1 = 0x00;                            //dist1 em  LOW
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,190 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,191 :: 		dist3 = 0x01;                            //dist3 em HIGH
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,193 :: 		} //end pulseL 2320
	GOTO       L_optionB21
L_optionB20:
;Ultrassonic_System.c,195 :: 		else if(pulseL < 2030 && pulseL >= 1740)    //distância menor que 35cm? (2030/58)
	MOVLW      7
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB70
	MOVLW      238
	SUBWF      _pulseL+0, 0
L__optionB70:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB24
	MOVLW      6
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB71
	MOVLW      204
	SUBWF      _pulseL+0, 0
L__optionB71:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB24
L__optionB56:
;Ultrassonic_System.c,197 :: 		dist1 = 0x00;                            //dist1 em  LOW
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,198 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,199 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,201 :: 		} //end pulseL 2030
	GOTO       L_optionB25
L_optionB24:
;Ultrassonic_System.c,203 :: 		else if(pulseL < 1740 && pulseL >= 1450)    //distância menor que 30cm? (1740/58)
	MOVLW      6
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB72
	MOVLW      204
	SUBWF      _pulseL+0, 0
L__optionB72:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB28
	MOVLW      5
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB73
	MOVLW      170
	SUBWF      _pulseL+0, 0
L__optionB73:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB28
L__optionB55:
;Ultrassonic_System.c,205 :: 		dist1 = 0x00;                            //dist1 em  LOW
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,206 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,207 :: 		dist3 = 0x01;                            //dist3 em HIGH
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,209 :: 		} //end pulseL 1740
	GOTO       L_optionB29
L_optionB28:
;Ultrassonic_System.c,211 :: 		else if(pulseL < 1450 && pulseL >= 1160)    //distância menor que 25cm? (1450/58)
	MOVLW      5
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB74
	MOVLW      170
	SUBWF      _pulseL+0, 0
L__optionB74:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB32
	MOVLW      4
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB75
	MOVLW      136
	SUBWF      _pulseL+0, 0
L__optionB75:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB32
L__optionB54:
;Ultrassonic_System.c,213 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,214 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,215 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,217 :: 		} //end pulseL 1450
	GOTO       L_optionB33
L_optionB32:
;Ultrassonic_System.c,219 :: 		else if(pulseL < 1160 && pulseL >= 870)     //distância menor que 20cm? (1160/58)
	MOVLW      4
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB76
	MOVLW      136
	SUBWF      _pulseL+0, 0
L__optionB76:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB36
	MOVLW      3
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB77
	MOVLW      102
	SUBWF      _pulseL+0, 0
L__optionB77:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB36
L__optionB53:
;Ultrassonic_System.c,221 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,222 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,223 :: 		dist3 = 0x01;                            //dist3 em HIGH
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,225 :: 		} //end pulseL 1160
	GOTO       L_optionB37
L_optionB36:
;Ultrassonic_System.c,227 :: 		else if(pulseL < 870 && pulseL >= 580)      //distância menor que 15cm? (870/58)
	MOVLW      3
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB78
	MOVLW      102
	SUBWF      _pulseL+0, 0
L__optionB78:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB40
	MOVLW      2
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB79
	MOVLW      68
	SUBWF      _pulseL+0, 0
L__optionB79:
	BTFSS      STATUS+0, 0
	GOTO       L_optionB40
L__optionB52:
;Ultrassonic_System.c,229 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,230 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,231 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,233 :: 		} //end pulseL 870
	GOTO       L_optionB41
L_optionB40:
;Ultrassonic_System.c,235 :: 		else if(pulseL < 580)                       //distância menor que 10cm? (580/58)
	MOVLW      2
	SUBWF      _pulseL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__optionB80
	MOVLW      68
	SUBWF      _pulseL+0, 0
L__optionB80:
	BTFSC      STATUS+0, 0
	GOTO       L_optionB42
;Ultrassonic_System.c,237 :: 		dist1 = 0x01;                            //dist1 em HIGH
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,238 :: 		dist2 = 0x01;                            //dist2 em HIGH
	BSF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,239 :: 		dist3 = 0x01;                            //dist3 em HIGH
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,241 :: 		} //end pulseL 580
	GOTO       L_optionB43
L_optionB42:
;Ultrassonic_System.c,245 :: 		dist1 = 0x00;                            //dist1 em  LOW
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;Ultrassonic_System.c,246 :: 		dist2 = 0x00;                            //dist2 em  LOW
	BCF        GP4_bit+0, BitPos(GP4_bit+0)
;Ultrassonic_System.c,247 :: 		dist3 = 0x00;                            //dist3 em  LOW
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Ultrassonic_System.c,249 :: 		} //end else
L_optionB43:
L_optionB41:
L_optionB37:
L_optionB33:
L_optionB29:
L_optionB25:
L_optionB21:
;Ultrassonic_System.c,251 :: 		} //end optionB
L_end_optionB:
	RETURN
; end of _optionB

_moving_average:

;Ultrassonic_System.c,254 :: 		long moving_average(unsigned pulseIn)          //retorna a média móvel de acordo com a resolução designada
;Ultrassonic_System.c,257 :: 		long adder = 0;                             //variável para somatório
	CLRF       moving_average_adder_L0+0
	CLRF       moving_average_adder_L0+1
	CLRF       moving_average_adder_L0+2
	CLRF       moving_average_adder_L0+3
;Ultrassonic_System.c,259 :: 		for(i = N; i > 0; i--)                      //desloca todo vetor descartando o elemento mais antigo
	MOVLW      10
	MOVWF      moving_average_i_L0+0
	MOVLW      0
	MOVWF      moving_average_i_L0+1
L_moving_average44:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      moving_average_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__moving_average82
	MOVF       moving_average_i_L0+0, 0
	SUBLW      0
L__moving_average82:
	BTFSC      STATUS+0, 0
	GOTO       L_moving_average45
;Ultrassonic_System.c,260 :: 		values[i] = values[i-1];
	MOVF       moving_average_i_L0+0, 0
	MOVWF      R0+0
	MOVF       moving_average_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _values+0
	MOVWF      R5+0
	MOVLW      1
	SUBWF      moving_average_i_L0+0, 0
	MOVWF      R3+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      moving_average_i_L0+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _values+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	MOVF       R5+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R0+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
;Ultrassonic_System.c,259 :: 		for(i = N; i > 0; i--)                      //desloca todo vetor descartando o elemento mais antigo
	MOVLW      1
	SUBWF      moving_average_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       moving_average_i_L0+1, 1
;Ultrassonic_System.c,260 :: 		values[i] = values[i-1];
	GOTO       L_moving_average44
L_moving_average45:
;Ultrassonic_System.c,262 :: 		values[0] = pulseIn;                        //o primeiro elemento do vetor recebe o valor do pulso
	MOVF       FARG_moving_average_pulseIn+0, 0
	MOVWF      _values+0
	MOVF       FARG_moving_average_pulseIn+1, 0
	MOVWF      _values+1
;Ultrassonic_System.c,264 :: 		for(i = 0; i < N; i++)                      //faz a somatória
	CLRF       moving_average_i_L0+0
	CLRF       moving_average_i_L0+1
L_moving_average47:
	MOVLW      128
	XORWF      moving_average_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__moving_average83
	MOVLW      10
	SUBWF      moving_average_i_L0+0, 0
L__moving_average83:
	BTFSC      STATUS+0, 0
	GOTO       L_moving_average48
;Ultrassonic_System.c,265 :: 		adder = adder + values[i];
	MOVF       moving_average_i_L0+0, 0
	MOVWF      R0+0
	MOVF       moving_average_i_L0+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _values+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       moving_average_adder_L0+0, 0
	ADDWF      R0+0, 1
	MOVF       moving_average_adder_L0+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     moving_average_adder_L0+1, 0
	ADDWF      R0+1, 1
	MOVF       moving_average_adder_L0+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     moving_average_adder_L0+2, 0
	ADDWF      R0+2, 1
	MOVF       moving_average_adder_L0+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     moving_average_adder_L0+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      moving_average_adder_L0+0
	MOVF       R0+1, 0
	MOVWF      moving_average_adder_L0+1
	MOVF       R0+2, 0
	MOVWF      moving_average_adder_L0+2
	MOVF       R0+3, 0
	MOVWF      moving_average_adder_L0+3
;Ultrassonic_System.c,264 :: 		for(i = 0; i < N; i++)                      //faz a somatória
	INCF       moving_average_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       moving_average_i_L0+1, 1
;Ultrassonic_System.c,265 :: 		adder = adder + values[i];
	GOTO       L_moving_average47
L_moving_average48:
;Ultrassonic_System.c,267 :: 		return adder / N;                           //retorna a média
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       moving_average_adder_L0+0, 0
	MOVWF      R0+0
	MOVF       moving_average_adder_L0+1, 0
	MOVWF      R0+1
	MOVF       moving_average_adder_L0+2, 0
	MOVWF      R0+2
	MOVF       moving_average_adder_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_S+0
;Ultrassonic_System.c,269 :: 		} //end moving_average
L_end_moving_average:
	RETURN
; end of _moving_average
