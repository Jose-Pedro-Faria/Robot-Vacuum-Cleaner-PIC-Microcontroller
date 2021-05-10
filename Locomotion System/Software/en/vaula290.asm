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
; --- File Listings and Inclusions

	list		p=12f629					;Microcontroller used in the project
	#include	<p12f629.inc>				;Includes file with PIC12F629 registers
	

; =================================================================================================
; --- FUSE Bits ---
; -> Internal Oscillator 4MHz without external clock;
; -> Without WatchDog Timer;
; -> Power Up Timer On;
; -> Master Clear Off;
; -> Without Brown Out;
; -> Without proteções.

	__config	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _CP_OFF & _CPD_OFF


; =================================================================================================
; --- Memory Paging ---

	#define	bank0	bcf	STATUS,RP0			;creates mnemonic for selection of memory bank 0
	#define	bank1	bsf	STATUS,RP0			;creates mnemonic for selection of memory bank 1
	

; =================================================================================================
; --- Defining Inputs and Outputs ---

	#define	out3	GPIO,GP4				;output 3 (most significant)
	#define	out0	GPIO,GP5				;output 0 (least significant)
	#define ctrl	GPIO,GP3				;engine direction control input
	

; =================================================================================================
; --- General Purpose Recorders ---

	cblock	H'20'							;Start of user available memory
	
	W_TEMP									;Stores temporary value of W
	STATUS_TEMP								;Stores temporary value of STATUS
	STEP									;Stores current motor step value
	
	endc									;End of memory available to the user


; =================================================================================================
; --- RESET vector ---

	org		H'0000'							;Origin at address 00h of memory
	goto	inicio							;Bypasses the interrupt vector
	

; =================================================================================================
; --- Interruption Vector ---

	org		H'0004'							;All interrupts point to this address in the program memory
	
; -- Save Context --
	movwf	W_TEMP							;Saves Work content to the W_TEMP register
	swapf	STATUS,W						;Load STATUS content into the Work register with inverted nibbles
	bank0									;Selects bank 0 of memory
	movwf	STATUS_TEMP						;Saves STATUS content to the STATUS_TEMP register
	
; -- Flags test --
	btfsc	INTCON,INTF						;Has there been an external interruption?
	goto	trata_INTE						;Yes, divert to handle External interruption
	goto	exit_ISR						;No, bypasses interrupt output
	
	
; -- Handles External Interruption --
trata_INTE:
	bcf		INTCON,INTF						;Clean flag

	call	process							;call engine control function

		
; -- Recovers Context (Interrupt Output) --
exit_ISR:
	swapf	STATUS_TEMP,W					;Load contents of STATUS_TEMP into the Work register
	movwf	STATUS							;Recovers pre ISR STATUS
	swapf	W_TEMP,F						;Invert W_TEMP nibbles and store in W_TEMP
	SWAPF	W_TEMP,W						;Inverts W_TEMP nibbles again storing in Work (Recovers Work pre ISR)
	retfie									;Returns from interruption
	

; =================================================================================================
; --- Initial Settings ---
inicio:

	bank1									;Selects memory bank1
	movlw		H'0F'						;Load literal 00001111b to the Work register
	movwf		TRISIO						;Configures GP4 and GP5 as output (TRISIO = 0x0F)
	movlw		H'C0'						;Load literal 11000000b into the Work register
	movwf		OPTION_REG					;(OPTION_REG = 0xC0)
											; - Disables internal pull-ups
											; - Configures external interruption by rising edge
											
	bank0									;Select memory bank0
	movlw		H'07'						;Load literal 00000111b into the Work register
	movwf		CMCON						;Disables internal comparators (CMCON = 0x07)
	movlw		H'90'						;Load literal 10010000b into the Work register
	movwf		INTCON						;(INTCON = 0x90)		
											; - Enable global interruption
											; - Enable external interrupt
											
	bcf			out3						;out3 starts at low
	bcf			out0						;out0 starts at low
	movlw		H'04'						;Load literal 00000100b to the Work register
	movwf		STEP						;Initializes STEP


 
	goto		$							;INFINITE LOOP, waiting for interruption
	

; =================================================================================================
; --- Motor control function ---	
process:	

	rrf		STEP,F							;shift right on STEP
	movf	STEP,W							;load STEP content into the Work register
	andlw	H'01'							;W = W and 00000001b
	btfsc	STATUS,Z						;Was the result of the operation zero?
	goto	dir								;Yes, divert to steps
	movlw	H'10'							;No, move 00010000b to work
	movwf	STEP							;restart STEP
	
dir:
	btfss	ctrl							;High ctrl input?	
	goto	steps2							;No, divert to steps2
	
steps1:
	movf	STEP,W							;Load the STEP content into the Work register
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_1							;No, skip to step_1
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_2							;No, deviate to step_2
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_3							;No, deviate to step_3
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_4							;No, deflect to step_4
	return									;return
	

steps2:
	movf	STEP,W							;Load the STEP content into the Work register
	andlw	H'02'							;W = W and 00000010b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_4							;No, deflect to step_4
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'04'							;W = W and 00000100b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_3							;No, deviate to step_3
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'08'							;W = W and 00000100b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_2							;No, deviate to step_2
	movf	STEP,W							;Yes, load the STEP content into the Work register
	andlw	H'10'							;W = W and 00010000b
	btfss	STATUS,Z						;Was the result of the operation zero?
	goto	step_1							;No, skip to step_1
	return									;return
	
 
step_1:
	bsf		out3							;out3 in high
	bsf		out0							;out0 in high
	return									;return
		
step_2:
	bsf		out3							;out3 in high
	bcf		out0							;out0 in low
	return									;return
	
step_3:
	bcf		out3							;out3 in low
	bcf		out0							;out0 in low
	return									;return
	
step_4:
	bcf		out3							;out3 in low
	bsf		out0							;out0 in high
	return									;return
	

; =================================================================================================
; --- End ---	
	end										;end of the program