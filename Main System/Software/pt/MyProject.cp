#line 1 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
#line 15 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
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
#line 39 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
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
#line 90 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
 TRISB = 0xC0;
 PORTB = 0xC0;
 TRISD = 0x3C;
 PORTD = 0x3C;
 ADCON1 = 0x0F;

 byteH = 0xB4;
 byteL = 0xE1;
#line 113 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
  LATD0_bit  = 0x00;
  LATD1_bit  = 0x01;

 Lcd_Init();
 Lcd_Out(1,1,"TESTE Display");

 while(1)
 {
#line 157 "C:/Users/zecap/Documents/GitHub/Robot-Vacuum-Cleaner-PIC-Microcontroller/Main System/Software/pt/MyProject.c"
 }
}
