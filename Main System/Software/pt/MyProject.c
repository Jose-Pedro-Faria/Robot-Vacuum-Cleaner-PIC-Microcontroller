/* ============================================================================
    Robo Aspirador

    MCU: PIC18F4520
    Clock: 20MHz
    Ciclo Máquina: 200ns
    Compilador: MikroC v.7.6.0

    Autor do Programa: Eng. Wagner Rambo
    Data de Criação: Junho 2020
    Autor das Alterações: José Pedro Faria
    Data da Última Alteração: Maio 2020
 =============================================================================*/

 //---Mapeamento de Hardware---
 #define         vel1          LATD6_bit                                        //Saída de teste oscilador em polling
 #define         vel2          LATD7_bit                                        //Saída de teste oscilador com Overflow do Timer

 //---Variáveis Globais---
 unsigned char byteH      = 0x77,
               byteL      = 0x48;

 //--Interrupções---
 void interrupt()
 {
      if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
      {                                                                         //Sim
         TMR0IF_bit = 0x00;                                                     //Limpa Flag
         TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
         TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0

         vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
         vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
      } //end if TMR0IF
 } //end interrupt

//==============================================================================
//---Função Principal---
void main()
{
     //--Registrador INTCON (pag 95 datasheet)--
     INTCON        = 0xA0;                                                      //Habilita interrupção global e interrupção do Timer0
     //--

     //--Registradore T0CON (pag 125 datasheet)--
     TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
     T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
     T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de máquina
     PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
     //--

     //--Inicializa Conteúdo do Timer0--
     //
     //Timer0 = 35536d = 7748h (para contar até 35000d)
     TMR0L    = 0x48;                                                           //byte menos significativo      0x48
     TMR0H    = 0x77;                                                           //byte mais significativo       0x77
     // --

     //--Equação para Estouro do Timer0--
     //
     // Timer0_Ovf = (65536 - <TMR0H:TMR0L>) x prescaler T0 x ciclo máquina
     //
     // Timer0_Ovf = (65536 - 35536)         x      1       x  200E-9
     //
     // Timer0_Ovf = 50ms
     //
     // Para garantir Ovf de 500ms : Timer0_Ovf x 10
     //
     //--

     TRISD   = 0x3C;                                                            //Configura IOs no PORTD
     PORTD   = 0x3C;                                                            //Inicializa PORTD
     ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais

     while(1)
     {
     /*
      byteH  = 0x3C;                                                            //50Hz
      byteL  = 0xB0;
      delay_ms(2000);
     */
      byteH  = 0x77;                                                            //70Hz
      byteL  = 0x48;
      delay_ms(5000);
      /*
      byteH  = 0x93;                                                            //90Hz
      byteL  = 0x9A;
      delay_ms(2000);
      */
      byteH  = 0xA7;                                                            //110Hz
      byteL  = 0x38;
      delay_ms(5000);

      byteH  = 0xB4;                                                            //130Hz
      byteL  = 0xE1;
      delay_ms(5000);
     
      RD0_bit = ~RD0_bit;
      RD1_bit = ~RD1_bit;
     } //end while
} //end main


//==============================================================================
//---Final do Programa---