/* ============================================================================

   Ultrasonic Sensor

   Generates 10탎 trigger pulse every 60ms
   Read ECHO pulse and filter it

   3 LOW / HIGH outputs:
   Option A:
   distance greater than 20cm - dist1 in LOW dist2 in LOW dist3 in LOW
   distance less than 20cm - dist1 in HIGH dist2 in LOW dist3 in LOW
   distance less than 15cm - dist1 in HIGH dist2 in HIGH dist3 in LOW
   distance less than 10cm - dist1 in HIGH dist2 in HIGH dist3 in HIGH

   Option B:
   distance | dist1 | dist2 | dist3
     >= 40cm      0       0       0
      < 40cm      0       0       1
      < 35cm      0       1       0
      < 30cm      0       1       1
      < 25cm      1       0       0
      < 20cm      1       0       1
      < 15cm      1       1       0
      < 10cm      1       1       1

   Sensor: HC-SR04
   MCU: PIC12F629
   Clock: Interno 4MHz
   Compiler: MikroC Pro For PIC v.4.15.0.0

   Date:  2021

============================================================================ */


// ============================================================================
// --- Hardware Mapping ---
#define   trig         GPIO,1                  //trigger pulse output
#define   dist1        GP5_bit                 //distance indication output 1
#define   dist2        GP4_bit                 //distance indication output 2
#define   dist3        GP0_bit                 //distance indication output 3
#define   option       GP3_bit                 //input for selecting operating options


// ============================================================================
// --- Auxiliary Macros and Constants ---
#define   trig_pulse   asm bsf trig;     \
                       asm nop; asm nop; \
                       asm nop;          \
                       asm nop; asm nop; \
                       asm nop; asm nop; \
                       asm nop; asm nop; \
                       asm bcf trig;           //trig_pulse: generates a pulse with duration
                                               //10탎. Assembly created delay

#define   N            10                      //number of points of the moving average


 // ============================================================================
// --- Prototype of Functions ---
void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3);  //operating option A
void optionB();                                //operating option B
long moving_average(unsigned pulseIn);         //calculates the moving average


// ============================================================================
// --- Global Variables ---
unsigned       pulseL    = 0x00,               //stores the filtered pulse width in 탎
               pulseEcho = 0x00,               //stores the width of the echo pulse in 탎
               values[N];                      //vector for moving average


// ============================================================================
// --- Interruptions ---
void interrupt()
{
   // +++ External Interruption +++
   // Controls high reading of the sensor echo pulse
   if(INTF_bit)                                //was there an external interruption?
   {                                           //yes
      INTF_bit = 0x00;                         //clear the flag

      if(!TMR1ON_bit)                          //timer1 off?
      {                                        //yes
         TMR1ON_bit = 0x01;                    //turn on timer1
         INTEDG_bit = 0x00;                    //set external int for falling edge

      } //end if TMR1ON_bit

      else                                     //if not
      {                                        //timer1 on
         TMR1ON_bit = 0x00;                    //turn off timer1
         pulseEcho = (TMR1H << 8) + TMR1L;     //saves pulse width in 탎
         TMR1H  = 0x00;                        //restart TMR1H
         TMR1L  = 0x00;                        //restart TMR1L
         INTEDG_bit = 0x01;                    //set external int for rising edge

      } //end else TMR1ON_bit

   } //end INTF_bit

   // +++ Timer0 Interrupt +++
   // Controls time base for sensor trigger
   // T0OVF = CM x PS x (256-TMR0) = 1E-6 x 256 x 235 = 60.16ms
   if(T0IF_bit)                                //was timer0 interrupted?
   {                                           //yes
      T0IF_bit = 0x00;                         //clear the flag
      TMR0     =   21;                         //restart timer0

      // -- time base of approximately 60 ms --
      trig_pulse;                              //generates trigger pulse

   } //end T0IF_bit

} //end interrupt


// ============================================================================
// --- Main Function ---
void main()
{
   CMCON      = 0x07;                          //disables internal comparators
   OPTION_REG = 0xC7;                          //external rising edge interruption
                                               //timer0 with prescaler 1:256
   INTCON     = 0xB0;                          //enable global interruption of timer0 and external
   TMR0       =   21;                          //initializes Timer0 to 21
   TRISIO     = 0x0C;                          //sets up I/Os
   GPIO       = 0x0C;                          //initializes I/Os
   T1CON      = 0x00;                          //timer1 starts off with prescaler 1:1


   while(1)                                    //infinite loop
   {
      pulseL = moving_average(pulseEcho);      //filters echo pulse and stores in pulseL

      if(option) optionA(20,15,10);            //if option in HIGH, operating option A
      else       optionB();                    //if option in LOW, option of operation B



   } //end while

} //end main


// ============================================================================
// --- Function Development ---
void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3)
{
   if(pulseL < (cm1*58) && pulseL >= (cm2*58)) //distance less than cm1 and greater than cm2?
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x00;                            //dist2  LOW
      dist3 = 0x00;                            //dist3  LOW

   } //end pulseL 1160

   else if(pulseL < (cm2*58) && pulseL >= (cm3*58))  //distance less than cm2 and greater than cm2 = 3?
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x00;                            //dist3 LOW

   } //end pulseL 870

   else if(pulseL < (cm3*58))                  //distance less than cm3?
   {                                           //sim
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x01;                            //dist3 HIGH

   } //end pulseL 580

   else                                        //if not
   {                                           //distance greater than cm1
      dist1 = 0x00;                            //dist1 LOW
      dist2 = 0x00;                            //dist2 LOW
      dist3 = 0x00;                            //dist3 LOW

   } //end else

} //end optionA


void optionB()
{
   if(pulseL < 2320 && pulseL >= 2030)         //distance less than 40cm? (2320/58)
   {                                           //yes
      dist1 = 0x00;                            //dist1 LOW
      dist2 = 0x00;                            //dist2 LOW
      dist3 = 0x01;                            //dist3 HIGH

   } //end pulseL 2320

   else if(pulseL < 2030 && pulseL >= 1740)    //distance less than 35cm? (2030/58)
   {                                           //yes
      dist1 = 0x00;                            //dist1 LOW
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x00;                            //dist3 LOW

   } //end pulseL 2030

   else if(pulseL < 1740 && pulseL >= 1450)    //distance less than 30cm? (1740/58)
   {                                           //yes
      dist1 = 0x00;                            //dist1 LOW
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x01;                            //dist3 HIGH

   } //end pulseL 1740

   else if(pulseL < 1450 && pulseL >= 1160)    //distance less than 25cm? (1450/58)
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x00;                            //dist2 LOW
      dist3 = 0x00;                            //dist3 LOW

   } //end pulseL 1450

   else if(pulseL < 1160 && pulseL >= 870)     //distance less than 20cm? (1160/58)
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x00;                            //dist2 LOW
      dist3 = 0x01;                            //dist3 HIGH

   } //end pulseL 1160

   else if(pulseL < 870 && pulseL >= 580)      //distance less than 15cm? (870/58)
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x00;                            //dist3 LOW

   } //end pulseL 870

   else if(pulseL < 580)                       //distance less than 10cm? (580/58)
   {                                           //yes
      dist1 = 0x01;                            //dist1 HIGH
      dist2 = 0x01;                            //dist2 HIGH
      dist3 = 0x01;                            //dist3 HIGH

   } //end pulseL 580

   else                                        //if not
   {                                           //distance greater than 40cm
      dist1 = 0x00;                            //dist1 LOW
      dist2 = 0x00;                            //dist2 LOW
      dist3 = 0x00;                            //dist3 LOW

   } //end else

} //end optionB


long moving_average(unsigned pulseIn)          //returns the moving average according to the designated resolution
{
   int i;                                      //variable for iterations
   long adder = 0;                             //variable for summation

   for(i = N; i > 0; i--)                      //displaces every vector discarding the oldest element
      values[i] = values[i-1];

   values[0] = pulseIn;                        //the first element of the vector receives the pulse value

   for(i = 0; i < N; i++)                      //does the sum
      adder = adder + values[i];

   return adder / N;                           //returns the mean

} //end moving_average
// ============================================================================
// --- End of the Program ---