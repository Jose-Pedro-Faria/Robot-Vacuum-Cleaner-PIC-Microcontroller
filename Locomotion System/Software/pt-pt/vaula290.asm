; =================================================================================================
; Source Code for Unipolar Stepper Motor Control
;
; Processor: PIC12F629   Clock: Intern 4MHz  Machine Cycle: 1µs
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
; --- Listagens e Inclusões de Arquivos

	list		p=12f629					;Microcontrolador utilizado no projeto
	#include	<p12f629.inc>				;Inclui arquivo com registradores do PIC12F629
	

; =================================================================================================
; --- FUSE Bits ---
; -> Oscilador Interno 4MHz sem clock externo;
; -> Sem WatchDog Timer;
; -> Power Up Timer Habilitado;
; -> Master Clear Desabilitado;
; -> Sem Brown Out;
; -> Sem proteções.

	__config	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _CP_OFF & _CPD_OFF


; =================================================================================================
; --- Paginação de Memória ---

	#define	bank0	bcf	STATUS,RP0			;cria mnemônico para seleção do banco 0 de memória
	#define	bank1	bsf	STATUS,RP0			;cria mnemônico para seleção do banco 1 de memória
	

; =================================================================================================
; --- Definicação de Entradas e Saídas ---

	#define	out3	GPIO,GP4				;saída 3 (mais significativa)
	#define	out0	GPIO,GP5				;saída 0 (menos significativa)
	#define ctrl	GPIO,GP3				;entrada de controle de direção do motor
	

; =================================================================================================
; --- Registradores de Uso Geral ---

	cblock	H'20'							;Início da memória disponível para o usuário
	
	W_TEMP									;Armazena valor temporário de W
	STATUS_TEMP								;Armazena valor temporário de STATUS
	STEP									;Armazena valor do passo atual do motor
	
	endc									;Final da memória disponível para o usuário


; =================================================================================================
; --- Vetor de RESET ---

	org		H'0000'							;Origem no endereço 00h de memória
	goto	inicio							;Desvia do vetor de interrupção
	

; =================================================================================================
; --- Vetor de Interrupção ---

	org		H'0004'							;Todas interrupções apontam para este endereço na memória de programa
	
; -- Salva Contexto --
	movwf	W_TEMP							;Salva conteúdo de Work no registrador W_TEMP
	swapf	STATUS,W						;Carrega conteúdo de STATUS no registrador Work com nibbles invertidos
	bank0									;Seleciona o banco 0 de memória
	movwf	STATUS_TEMP						;Salva conteúdo de STATUS no registrador STATUS_TEMP
	
; -- Teste das flags --
	btfsc	INTCON,INTF						;Ocorreu interrupção externa?
	goto	trata_INTE						;Sim, desvia para tratar interrupção Externa
	goto	exit_ISR						;Não, desvia para saída de interrupção
	
	
; -- Trata Interrupção Externa --
trata_INTE:
	bcf		INTCON,INTF						;Limpa flag

	call	process							;chama função de controle do motor

		
; -- Recupera Contexto (Saída de Interrupção ) --
exit_ISR:
	swapf	STATUS_TEMP,W					;Carrega conteúdo de STATUS_TEMP no registrador Work
	movwf	STATUS							;Recupera STATUS pré ISR
	swapf	W_TEMP,F						;Inverte nibbles do W_TEMP e armazena em W_TEMP
	SWAPF	W_TEMP,W						;Inverte novamente nibbles de W_TEMP armazendo em Work (Recupera Work pré ISR)
	retfie									;Retorna da interrupção
	

; =================================================================================================
; --- Configurações Iniciais ---
inicio:

	bank1									;Seleciona banco1 de memória
	movlw		H'0F'						;Carrega literal 00001111b para o registrador Work
	movwf		TRISIO						;Configura GP4 e GP5 como saída (TRISIO = 0x0F)
	movlw		H'C0'						;Carrega literal 11000000b para o registrador Work
	movwf		OPTION_REG					;(OPTION_REG = 0xC0)
											; - Desabilita Pull-Ups internos
											; - Configura interrupção externa por borda de subida
											
	bank0									;Seleciona banco0 de memória
	movlw		H'07'						;Carrega literal 00000111b para o registrador Work
	movwf		CMCON						;Desabilita comparadores internos (CMCON = 0x07)
	movlw		H'90'						;Carrega literal 10010000b para o registrador Work
	movwf		INTCON						;(INTCON = 0x90)		
											; - Habilita interrupção global
											; - Habilita interrupção externa
											
	bcf			out3						;out3 inicia em low
	bcf			out0						;out0 inicia em low
	movlw		H'04'						;Carrega literal 00000100b para o registrador Work
	movwf		STEP						;Inicializa STEP


 
	goto		$							;LOOP INFINITO, aguarda interrupção
	

; =================================================================================================
; --- Função para controle do Motor ---	
process:	

	rrf		STEP,F							;shift right em STEP
	movf	STEP,W							;carrega conteúdo de STEP no registrador Work
	andlw	H'01'							;W = W and 00000001b
	btfsc	STATUS,Z						;Resultado da operação foi zero?
	goto	dir								;Sim, desvia para steps
	movlw	H'10'							;Não, move 00010000b para work
	movwf	STEP							;reinicia STEP
	
dir:
	btfss	ctrl							;Entrada ctrl em high?	
	goto	steps2							;Não, desvia para steps2
	
steps1:
	movf	STEP,W							;Carrega o conteúdo de STEP no registrador Work
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_1							;Não, desvia para o step_1
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_2							;Não, desvia para o step_2
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_3							;Não, desvia para o step_3
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_4							;Não, desvia para o step_4
	return									;retorna
	

steps2:
	movf	STEP,W							;Carrega o conteúdo de STEP no registrador Work
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_4							;Não, desvia para o step_4
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_3							;Não, desvia para o step_3
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_2							;Não, desvia para o step_2
	movf	STEP,W							;Sim, carrega o conteúdo de STEP no registrador Work
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Resultado da operação foi zero?
	goto	step_1							;Não, desvia para o step_1
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