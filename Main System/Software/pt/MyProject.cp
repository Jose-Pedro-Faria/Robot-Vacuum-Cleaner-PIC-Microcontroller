#line 1 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
#line 24 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
 unsigned char byteH = 0x77,
 byteL = 0x48;


 void interrupt()
 {
 if(TMR0IF_bit)
 {
 TMR0IF_bit = 0x00;
 TMR0L = byteH;
 TMR0H = byteL;

  LATD6_bit  = ~ LATD6_bit ;
  LATD7_bit  = ~ LATD7_bit ;
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
#line 75 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
 TRISD = 0x3C;
 PORTD = 0x3C;
 ADCON1 = 0x0F;

 byteH = 0xA7;
 byteL = 0x38;
#line 93 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x00;

 while(1)
 {
 if( RD2_bit )
 {
 TMR0ON_bit = 0x00;
  LATD6_bit  = 0x00;
  LATD7_bit  = 0x00;
 delay_ms(1000);
  LATD0_bit  = 0x01;
  LATD1_bit  = 0x01;
 TMR0ON_bit = 0x01;
 delay_ms(1500);
  LATD0_bit  = 0x01;
  LATD1_bit  = 0x00;
 delay_ms (3800);
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x00;
 }

 if ( RD3_bit )
 {
 TMR0ON_bit = 0x00;
  LATD6_bit  = 0x00;
  LATD7_bit  = 0x00;
 delay_ms(1000);
  LATD0_bit  = 0x01;
  LATD1_bit  = 0x01;
 TMR0ON_bit = 0x01;
 delay_ms(1500);
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;
 delay_ms (3800);
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x00;
 }

 }
}
