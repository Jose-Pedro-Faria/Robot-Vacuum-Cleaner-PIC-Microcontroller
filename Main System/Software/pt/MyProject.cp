#line 1 "C:/Users/zecap/Documents/Projetos/Robo Aspirador/RA v1/Programa 18F v0.2/MyProject.c"
#line 24 "C:/Users/zecap/Documents/Projetos/Robo Aspirador/RA v1/Programa 18F v0.2/MyProject.c"
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





 TMR0L = 0x00;
 TMR0H = 0x00;
#line 75 "C:/Users/zecap/Documents/Projetos/Robo Aspirador/RA v1/Programa 18F v0.2/MyProject.c"
 TRISD = 0x3C;
 PORTD = 0x3F;
 ADCON1 = 0x0F;

 byteH = 0xA7;
 byteL = 0x38;

 while(1)
 {
 RD0_bit = ~RD0_bit;
 RD1_bit = ~RD1_bit;

 delay_ms(4000);
#line 111 "C:/Users/zecap/Documents/Projetos/Robo Aspirador/RA v1/Programa 18F v0.2/MyProject.c"
 }
}
