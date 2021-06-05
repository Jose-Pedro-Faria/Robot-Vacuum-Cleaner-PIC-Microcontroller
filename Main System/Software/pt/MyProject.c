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
 #define         dir1          LATD0_bit                                        //controlo de direção 1
 #define         dir2          LATD1_bit                                        //controlo de direção 2
 #define         vel1          LATD6_bit                                        //controlo de velocidade 1
 #define         vel2          LATD7_bit                                        //controlo de velocidade 2
 #define         sens1         RD2_bit                                          //sensor 1 (Teste)
 #define         sens2         RD3_bit                                          //sensor 2 (Teste)

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
     
     byteH  = 0xB4;                                                            //130Hz
     byteL  = 0xE1;
      
     /*
     byteH = 0xA7;
     byteL = 0x38;                                                              //110Hz

      byteH  = 0x77;                                                            //70Hz
      byteL  = 0x48;

      byteH  = 0x93;                                                            //90Hz
      byteL  = 0x9A;

      byteH  = 0xB4;                                                            //130Hz
      byteL  = 0xE1;
      */
      
      dir1 = 0x00;
      dir2 = 0x01;
     
     while(1)
     {
     /*
      if(sens1)
      {
       TMR0ON_bit = 0x00;
       vel1 = 0x00;
       vel2 = 0x00;
       delay_ms(1000);
       dir1 = 0x01;
       dir2 = 0x00;
       TMR0ON_bit = 0x01;
       delay_ms(1500);
       dir1 = 0x00;
       dir2 = 0x01;
       delay_ms (3800);
       dir1 = 0x00;
       dir2 = 0x01;
      } //end if sens1
      
      if (sens2)
      {
       TMR0ON_bit = 0x00;
       vel1 = 0x00;
       vel2 = 0x00;
       delay_ms(1000);
       dir1 = 0x01;
       dir2 = 0x01;
       TMR0ON_bit = 0x01;
       delay_ms(1500);
       dir1 = 0x00;
       dir2 = 0x01;
       delay_ms (3800);
       dir1 = 0x00;
       dir2 = 0x00;
      } //end if sens2
      
      */
     } //end while
} //end main


//==============================================================================
//---Final do Programa---