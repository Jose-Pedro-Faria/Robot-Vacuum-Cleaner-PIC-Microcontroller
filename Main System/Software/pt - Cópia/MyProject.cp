#line 1 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
#line 40 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
 unsigned char byteH = 0x77,
 byteL = 0x48,
 flags = 0x00;

 unsigned int cont = 0x00,
 cont2 = 0x00,
 parouimpar,
 parouimpar2;


 void voltmeter();
 int par_impar_test();
 void virardireita();
 void viraresquerda();
 void faltachao();


 void interrupt()
 {


 if(TMR0IF_bit)
 {
 TMR0IF_bit = 0x00;

 TMR0L = byteH;
 TMR0H = byteL;

  LATD6_bit  = ~ LATD6_bit ;
  LATD7_bit  = ~ LATD7_bit ;
#line 78 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
 }
 }



void main()
{

 INTCON = 0xA0;



 TMR0ON_bit = 0x01;
 T08BIT_bit = 0x00;
 T0CS_bit = 0x00;
 PSA_bit = 0x01;




 TMR0L = 0x48;
 TMR0H = 0x77;


 TRISA = 0xFF;
 ADCON0 = 0x01;
 ADCON1 = 0x0E;
 ADCON2 = 0x18;
#line 119 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
 TRISB = 0xC0;
 PORTB = 0xC0;
 TRISD = 0x3C;
 PORTD = 0x3C;
 ADCON1 = 0x0F;

 byteH = 0xB4;
 byteL = 0xE1;
#line 145 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;







 while(1)
 {


 if ( RD2_bit )
 {
 cont += 1;
 parouimpar = par_impar_test();

 switch(parouimpar)
 {
 case 0:
 viraresquerda();
 break;

 case 1:
 virardireita();
 break;

 default:
 break;
 }
 }

 if (! RD3_bit )
 {
 faltachao();

 }
 }
}







void voltmeter()
{
 static float volts_f;
 static int volts;

 volts_f = ADC_Read(0)*0.048875;
 volts_f *=2.8;
 volts = (int)volts_f;
#line 207 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt - Cópia/MyProject.c"
}





void faltachao()
{
 cont += 1;
 parouimpar2 = par_impar_test();

 switch(parouimpar2)
 {
 case 0:
 viraresquerda();
 break;

 case 1:
 virardireita();
 break;
 default:
 break;
 }
}




int par_impar_test ()
{
 if(cont % 2 == 0)
 {
 return 0;
 }
 else
 {
 return 1;
 }
}



void virardireita()
{
 TMR0ON_bit = 0x00;
  LATD6_bit  = 0x00;
  LATD7_bit  = 0x00;
 delay_ms(1500);

  LATD0_bit  = 0x01;
  LATD1_bit  = 0x00;
 TMR0ON_bit = 0x01;
 delay_ms(900);

  LATD0_bit  = 0x01;
  LATD1_bit  = 0x01;
 delay_ms (4300);

 if( RD2_bit )
 {
  LATD0_bit = 0x01;
  LATD1_bit  = 0x01;
 delay_ms (7500);
 cont2 += 1;
 }
 else
 {
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;
 delay_ms(5000);

  LATD0_bit  = 0x01;
  LATD1_bit  = 0x01;
 delay_ms (4300);
 }

  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;
}



void viraresquerda()
{
 TMR0ON_bit = 0x00;
  LATD6_bit  = 0x00;
  LATD7_bit  = 0x00;
 delay_ms(1500);

  LATD0_bit  = 0x01;
  LATD1_bit  = 0x00;
 TMR0ON_bit = 0x01;
 delay_ms(900);

  LATD0_bit  = 0x00;
  LATD1_bit  = 0x00;
 delay_ms (4200);

 if( RD2_bit )
 {
  LATD0_bit = 0x00;
  LATD1_bit  = 0x00;
 delay_ms (7500);
 }
 else
 {
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;
 delay_ms(5000);


  LATD0_bit  = 0x00;
  LATD1_bit  = 0x00;
 delay_ms (4200);
 }

  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;

}
