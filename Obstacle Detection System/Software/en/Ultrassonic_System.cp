#line 1 "C:/Users/zecap/Documents/GitHub/Robo-Aspirador/Obstacle Detection System/Software/en/Ultrassonic_System.c"
#line 61 "C:/Users/zecap/Documents/GitHub/Robo-Aspirador/Obstacle Detection System/Software/en/Ultrassonic_System.c"
void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3);
void optionB();
long moving_average(unsigned pulseIn);




unsigned pulseL = 0x00,
 pulseEcho = 0x00,
 values[ 10 ];




void interrupt()
{


 if(INTF_bit)
 {
 INTF_bit = 0x00;

 if(!TMR1ON_bit)
 {
 TMR1ON_bit = 0x01;
 INTEDG_bit = 0x00;

 }

 else
 {
 TMR1ON_bit = 0x00;
 pulseEcho = (TMR1H << 8) + TMR1L;
 TMR1H = 0x00;
 TMR1L = 0x00;
 INTEDG_bit = 0x01;

 }

 }




 if(T0IF_bit)
 {
 T0IF_bit = 0x00;
 TMR0 = 21;


  asm bsf GPIO,1 ; asm nop; asm nop; asm nop; asm nop; asm nop; asm nop; asm nop; asm nop; asm nop; asm bcf GPIO,1 ; ;

 }

}




void main()
{
 CMCON = 0x07;
 OPTION_REG = 0xC7;

 INTCON = 0xB0;
 TMR0 = 21;
 TRISIO = 0x0C;
 GPIO = 0x0C;
 T1CON = 0x00;


 while(1)
 {
 pulseL = moving_average(pulseEcho);

 if( GP3_bit ) optionA(20,15,10);
 else optionB();



 }

}




void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3)
{
 if(pulseL < (cm1*58) && pulseL >= (cm2*58))
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x00;
  GP0_bit  = 0x00;

 }

 else if(pulseL < (cm2*58) && pulseL >= (cm3*58))
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x01;
  GP0_bit  = 0x00;

 }

 else if(pulseL < (cm3*58))
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x01;
  GP0_bit  = 0x01;

 }

 else
 {
  GP5_bit  = 0x00;
  GP4_bit  = 0x00;
  GP0_bit  = 0x00;

 }

}


void optionB()
{
 if(pulseL < 2320 && pulseL >= 2030)
 {
  GP5_bit  = 0x00;
  GP4_bit  = 0x00;
  GP0_bit  = 0x01;

 }

 else if(pulseL < 2030 && pulseL >= 1740)
 {
  GP5_bit  = 0x00;
  GP4_bit  = 0x01;
  GP0_bit  = 0x00;

 }

 else if(pulseL < 1740 && pulseL >= 1450)
 {
  GP5_bit  = 0x00;
  GP4_bit  = 0x01;
  GP0_bit  = 0x01;

 }

 else if(pulseL < 1450 && pulseL >= 1160)
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x00;
  GP0_bit  = 0x00;

 }

 else if(pulseL < 1160 && pulseL >= 870)
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x00;
  GP0_bit  = 0x01;

 }

 else if(pulseL < 870 && pulseL >= 580)
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x01;
  GP0_bit  = 0x00;

 }

 else if(pulseL < 580)
 {
  GP5_bit  = 0x01;
  GP4_bit  = 0x01;
  GP0_bit  = 0x01;

 }

 else
 {
  GP5_bit  = 0x00;
  GP4_bit  = 0x00;
  GP0_bit  = 0x00;

 }

}


long moving_average(unsigned pulseIn)
{
 int i;
 long adder = 0;

 for(i =  10 ; i > 0; i--)
 values[i] = values[i-1];

 values[0] = pulseIn;

 for(i = 0; i <  10 ; i++)
 adder = adder + values[i];

 return adder /  10 ;

}
