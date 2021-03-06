/* ============================================================================
    Robo Aspirador

    MCU: PIC18F4520
    Clock: 20MHz
    Ciclo M?quina: 200ns
    Compilador: MikroC v.7.6.0

    Autor do Programa: Eng. Wagner Rambo
    Data de Cria??o: Junho 2020
    Autor das Altera??es: Jos? Pedro Faria
    Data da ?ltima Altera??o: Maio 2020
 =============================================================================*/
 //--- Comunica??o entre PIC e LCD ---
 sbit LCD_RS at RB4_bit;
 sbit LCD_EN at RB5_bit;
 sbit LCD_D7 at RB3_bit;
 sbit LCD_D6 at RB2_bit;
 sbit LCD_D5 at RB1_bit;
 sbit LCD_D4 at RB0_bit;
 
 sbit LCD_RS_Direction at TRISB0_bit;
 sbit LCD_EN_Direction at TRISB1_bit;
 sbit LCD_D4_Direction at TRISB2_bit;
 sbit LCD_D5_Direction at TRISB3_bit;
 sbit LCD_D6_Direction at TRISB4_bit;
 sbit LCD_D7_Direction at TRISB5_bit;

//=============================================================================
 //---Mapeamento de Hardware---
 #define         dir1          LATD0_bit                                        //controlo de dire??o 1
 #define         dir2          LATD1_bit                                        //controlo de dire??o 2
 #define         vel1          LATD6_bit                                        //controlo de velocidade 1
 #define         vel2          LATD7_bit                                        //controlo de velocidade 2
 #define         sens1         RD2_bit                                          //sensor 1 (Teste)
 #define         sens2         RD3_bit                                          //sensor 2 (Teste)

 //---Vari?veis Globais---
 unsigned char byteH      = 0x77,                                               //Byte mais sifnificativo overflow TM0
               byteL      = 0x48,                                               //Byte menos sifnificativo overflow TM0
               flags      = 0x00;                                               // registador flags auxiliares


 //---Fun??es---
 void voltmeter();

 //--Interrup??es---
 void interrupt()
 {
      //static int lcd_upt = 0;                                                   //vari?vel local para atualiza??o do display
      
      if(TMR0IF_bit)                                                            //Houve overflow do Timer0?
      {                                                                         //Sim
         TMR0IF_bit = 0x00;                                                     //Limpa Flag
         //lcd_upt   += 1;                                                        //incrementa 1
         TMR0L      = byteH;                                                    //Reinicia byte menos sifnificativo do Timer0
         TMR0H      = byteL;                                                    //Reinicia byte mais significativo do Timer0

         vel1       = ~vel1;                                                    //Gera clock para velocidade do motor1
         vel2       = ~vel2;                                                    //Gera clock para velocidade do motor2
         /*
         if(lcd_upt == 333)                                                     //Lcd_upt = 333 (numero de incrementos do timer0 necess?rios para contar 1s)
         {                                                                      //sim
          lcd_upt   = 0;                                                        //reseta a vari?vel
          flags     = ~flags;                                                   //Inverte o estado de flags (o registador inteiro)

         } //end if lcd_upt
         */
      } //end if TMR0IF
 } //end interrupt

//==============================================================================
//---Fun??o Principal---
void main()
{
     //--Registrador INTCON (pag 95 datasheet)--
     INTCON        = 0xA0;                                                      //Habilita interrup??o global e interrup??o do Timer0
     //--

     //--Registradore T0CON (pag 125 datasheet)--
     TMR0ON_bit       = 0x01;                                                   //bit 7: liga o Timer0
     T08BIT_bit       = 0x00;                                                   //bit 6: habilita o modo de 16 bits para o Timer0
     T0CS_bit         = 0x00;                                                   //bit 5: timer0 incrementa com o ciclo de m?quina
     PSA_bit          = 0x01;                                                   //bit 3: timer0 sem prescaler (1:1)
     //--

     //--Inicializa Conte?do do Timer0--
     //
     //Timer0 = 35536d = 7748h (para contar at? 35000d)
     TMR0L    = 0x48;                                                           //byte menos significativo      0x48
     TMR0H    = 0x77;                                                           //byte mais significativo       0x77
     // --

     TRISA    = 0xFF;
     ADCON0   = 0x01;                                                           //Ligar o conversor A/C
     ADCON1   = 0x0E;                                                           //Apenas o AN0 como anal?gico
     ADCON2   = 0x18;

     //--Equa??o para Estouro do Timer0--
     //
     // Timer0_Ovf = (65536 - <TMR0H:TMR0L>) x prescaler T0 x ciclo m?quina
     //
     // Timer0_Ovf = (65536 - 35536)         x      1       x  200E-9
     //
     // Timer0_Ovf = 50ms
     //
     // Para garantir Ovf de 500ms : Timer0_Ovf x 10
     //
     //--

     TRISB   = 0xC0;                                                            //Configura IOs no PORTB
     PORTB   = 0xC0;                                                            //Inicializa PORTB
     TRISD   = 0x3C;                                                            //Configura IOs no PORTD
     PORTD   = 0x3C;                                                            //Inicializa PORTD
     ADCON1  = 0x0F;                                                            //Configura os pinos do PORTB como digitais
     
      byteH  = 0x93;                                                            //90Hz
      byteL  = 0x9A;
      
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
      
      dir1 = 0x00;                                                              //Define o bit de dire??o inicial
      dir2 = 0x01;                                                              //Define o bit de dire??o inicial
      
      //Lcd_Init();
      //Lcd_Cmd(_LCD_CLEAR);
      //Lcd_Cmd(_LCD_CURSOR_OFF);

      //Lcd_Out(1,1,"Jose Faria");
     
     while(1)
     {
     
     /*
      //if(flags) voltmeter();

      if(sens1)                                                                 //Sensor da Direita
      {
       TMR0ON_bit = 0x00;
       vel1 = 0x00;
       vel2 = 0x00;
       delay_ms(2000);                                                          //Robo STOP
       dir1 = 0x01;
       dir2 = 0x00;
       TMR0ON_bit = 0x01;
       delay_ms(1200);                                                          //Robo anda para tr?s
       dir1 = 0x01;
       dir2 = 0x01;
       delay_ms (4000);                                                         //Desvio Robo
       dir1 = 0x00;
       dir2 = 0x01;
      } //end if sens1
      
      if (sens2)                                                                //Sensore da Esquerda
      {
       TMR0ON_bit = 0x00;
       vel1 = 0x00;
       vel2 = 0x00;
       delay_ms(2000);                                                          //Robo STOP
       dir1 = 0x01;
       dir2 = 0x00;
       TMR0ON_bit = 0x01;
       delay_ms(1200);                                                          //Robo anda para tr?s
       dir1 = 0x00;
       dir2 = 0x00;
       delay_ms (4000);                                                         //Desvio Robo
       dir1 = 0x00;
       dir2 = 0x01;
      } //end if sens2
     */
     } //end while
} //end main

//==============================================================================
//---Fun??es---

//==============================================================================
//---Voltmeter---
//Mede a tens?o da bateria, imprime o valor no display e tomada de decis?o de tens?o baixa

void voltmeter()
{
 static float volts_f;
 static int   volts;
 
 volts_f = ADC_Read(0)*0.048875;
 volts_f *=2.8;
 volts = (int)volts_f;
 /*
 Lcd_Chr(2,1,((char)volts/100)+0x30);
 Lcd_Chr_cp( ((char)volts&100/10)+0x30);
 Lcd_Chr_cp('.');
 Lcd_Chr_cp( ((char)volts&10)+0x30);
 Lcd_Chr_cp('V');
 */
}




//==============================================================================
//---Final do Programa---