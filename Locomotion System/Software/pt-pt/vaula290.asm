; =================================================================================================
; Source Code for Unipolar Stepper Motor Control
;
; Processor: PIC12F629   Clock: Intern 4MHz  Machine Cycle: 1�s
;
;
; Outputs:
;
; out3 -> most significant bit of control
; out0 -> least significant bit of control
;
; Date: 2021
; =================================================================================================


; =================================================================================================
; --- Listagens e Inclus�es de Arquivos

	list		p=12f629					;Microcontrolador utilizado no projeto
	#include	<p12f629.inc>				;Inclui arquivo com registradores do PIC12F629
	

; =================================================================================================
; --- FUSE Bits ---
; -> Oscilador Interno 4MHz sem clock externo;
; -> Sem WatchDog Timer;
; -> Power Up Timer Habilitado;
; -> Master Clear Desabilitado;
; -> Sem Brown Out;
; -> Sem prote��es.

	__config	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _CP_OFF & _CPD_OFF


; =================================================================================================
; --- Pagina��o de Mem�ria ---

	#define	bank0	bcf	STATUS,RP0			;cria mnem�nico para sele��o do banco 0 de mem�ria
	#define	bank1	bsf	STATUS,RP0			;cria mnem�nico para sele��o do banco 1 de mem�ria
	

; =================================================================================================
; --- Definica��o de Entradas e Sa�das ---

	#define	out3	GPIO,GP4				;sa�da 3 (mais significativa)
	#define	out0	GPIO,GP5				;sa�da 0 (menos significativa)
	#define ctrl	GPIO,GP3				;entrada de controle de dire��o do motor
	

; =================================================================================================
; --- Registradores de Uso Geral ---

	cblock	H'20'							;In�cio da mem�ria dispon�vel para o usu�rio
	
	W_TEMP									;Armazena valor tempor�rio de W
	STATUS_TEMP								;Armazena valor tempor�rio de STATUS
	STEP									;Armazena valor do passo atual do motor
	
	endc									;Final da mem�ria dispon�vel para o usu�rio


; =================================================================================================
; --- Vetor de RESET ---

	org		H'0000'							;Origem no endere�o 00h de mem�ria
	goto	inicio							;Desvia do vetor de interrup��o
	

; =================================================================================================
; --- Vetor de Interrup��o ---

	org		H'0004'							;Todas interrup��es apontam para este endere�o na mem�ria de programa
	
; -- Salva Contexto --
	movwf	W_TEMP							;Salva conte�do de Work no registrador W_TEMP
	swapf	STATUS,W						;Carrega conte�do de STATUS no registrador Work com nibbles invertidos
	bank0									;Seleciona o banco 0 de mem�ria
	movwf	STATUS_TEMP						;Salva conte�do de STATUS no registrador STATUS_TEMP
	
; -- Teste das flags --
	btfsc	INTCON,INTF						;Ocorreu interrup��o externa?
	goto	trata_INTE						;Sim, desvia para tratar interrup��o Externa
	goto	exit_ISR						;N�o, desvia para sa�da de interrup��o
	
	
; -- Trata Interrup��o Externa --
trata_INTE:
	bcf		INTCON,INTF						;Limpa flag

	call	process							;chama fun��o de controle do motor

		
; -- Recupera Contexto (Sa�da de Interrup��o ) --
exit_ISR:
	swapf	STATUS_TEMP,W					;Carrega conte�do de STATUS_TEMP no registrador Work
	movwf	STATUS							;Recupera STATUS pr� ISR
	swapf	W_TEMP,F						;Inverte nibbles do W_TEMP e armazena em W_TEMP
	SWAPF	W_TEMP,W						;Inverte novamente nibbles de W_TEMP armazendo em Work (Recupera Work pr� ISR)
	retfie									;Retorna da interrup��o
	

; =================================================================================================
; --- Configura��es Iniciais ---
inicio:

	bank1									;Seleciona banco1 de mem�ria
	movlw		H'0F'						;Carrega literal 00001111b para o registrador Work
	movwf		TRISIO						;Configura GP4 e GP5 como sa�da (TRISIO = 0x0F)
	movlw		H'C0'						;Carrega literal 11000000b para o registrador Work
	movwf		OPTION_REG					;(OPTION_REG = 0xC0)
											; - Desabilita Pull-Ups internos
											; - Configura interrup��o externa por borda de subida
											
	bank0									;Seleciona banco0 de mem�ria
	movlw		H'07'						;Carrega literal 00000111b para o registrador Work
	movwf		CMCON						;Desabilita comparadores internos (CMCON = 0x07)
	movlw		H'90'						;Carrega literal 10010000b para o registrador Work
	movwf		INTCON						;(INTCON = 0x90)		
											; - Habilita interrup��o global
											; - Habilita interrup��o externa
											
	bcf			out3						;out3 inicia em low
	bcf			out0						;out0 inicia em low
	movlw		H'04'						;Carrega literal 00000100b para o registrador Work
	movwf		STEP						;Inicializa STEP


 
	goto		$							;LOOP INFINITO, aguarda interrup��o
	

; =================================================================================================
; --- Fun��o para controle do Motor ---	
process:	

	rrf		STEP,F							;shift right em STEP
	movf	STEP,W							;carrega conte�do de STEP no registrador Work
	andlw	H'01'							;W = W and 00000001b
	btfsc	STATUS,Z						;Resultado da opera��o foi zero?
	goto	dir								;Sim, desvia para steps
	movlw	H'10'							;N�o, move 00010000b para work
	movwf	STEP							;reinicia STEP
	
dir:
	btfss	ctrl							;Entrada ctrl em high?	
	goto	steps2							;N�o, desvia para steps2
	
steps1:
	movf	STEP,W							;Carrega o conte�do de STEP no registrador Work
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_1							;N�o, desvia para o step_1
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_2							;N�o, desvia para o step_2
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_3							;N�o, desvia para o step_3
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_4							;N�o, desvia para o step_4
	return									;retorna
	

steps2:
	movf	STEP,W							;Carrega o conte�do de STEP no registrador Work
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_4							;N�o, desvia para o step_4
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_3							;N�o, desvia para o step_3
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_2							;N�o, desvia para o step_2
	movf	STEP,W							;Sim, carrega o conte�do de STEP no registrador Work
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Resultado da opera��o foi zero?
	goto	step_1							;N�o, desvia para o step_1
	return									;retorna
	
 
step_1:
	bsf		out3							;out3 em high
	bsf		out0							;out0 em high
	return									;retorna
		
step_2:
	bsf		out3							;out3 em high
	bcf		out0							;out0 em low
	return									;retorna
	
step_3:
	bcf		out3							;out3 em low
	bcf		out0							;out0 em low
	return									;retorna
	
step_4:
	bcf		out3							;out3 em low
	bsf		out0							;out0 em high
	return									;retorna
	

; =================================================================================================
; --- Final ---	
	end										;Final do programa