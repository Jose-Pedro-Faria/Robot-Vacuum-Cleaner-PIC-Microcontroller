/* ============================================================================

   Sensor Ultrassônico

   Gera pulso de trigger de 10µs a cada 60ms
   Lê pulso de ECHO e realiza filtragem do mesmo

   3 saídas LOW/HIGH:
   Opção A:
   distância superior a 20cm - dist1 em  LOW  dist2 em  LOW  dist3 em  LOW
   distância inferior a 20cm - dist1 em HIGH  dist2 em  LOW  dist3 em  LOW
   distância inferior a 15cm - dist1 em HIGH  dist2 em HIGH  dist3 em  LOW
   distância inferior a 10cm - dist1 em HIGH  dist2 em HIGH  dist3 em HIGH

   Opção B:
   distância  | dist1 | dist2 | dist3
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
   Compilador: MikroC Pro For PIC v.4.15.0.0

   Data:  2021

============================================================================ */


// ============================================================================
// --- Mapeamento de Hardware ---
#define   trig         GPIO,1                  //saída para pulso de trigger
#define   dist1        GP5_bit                 //saída de indicação de distância 1
#define   dist2        GP4_bit                 //saída de indicação de distância 2
#define   dist3        GP0_bit                 //saída de indicação de distância 3
#define   option       GP3_bit                 //entrada para seleção de opções de funcionamento


// ============================================================================
// --- Macros e Constantes Auxiliares ---
#define   trig_pulse   asm bsf trig;     \
                       asm nop; asm nop; \
                       asm nop;          \
                       asm nop; asm nop; \
                       asm nop; asm nop; \
                       asm nop; asm nop; \
                       asm bcf trig;           //trig_pulse: gera pulso com duração
                                               //de 10µs. Atraso criado em Assembly

#define   N            10                      //número de pontos da média móvel


 // ============================================================================
// --- Protótipo das Funções ---
void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3);  //opção de funcionamento A
void optionB();                                //opção de funcionamento B
long moving_average(unsigned pulseIn);         //calcula a média móvel


// ============================================================================
// --- Variáveis Globais ---
unsigned       pulseL    = 0x00,               //armazena a largura do pulso filtrada em µs
               pulseEcho = 0x00,               //armazena a largura do pulso de echo em µs
               values[N];                      //vetor para média móvel


// ============================================================================
// --- Interrupções ---
void interrupt()
{
   // +++ Interrupção Externa +++
   // Controla leitura em high do pulso de echo do sensor
   if(INTF_bit)                                //houve interrupção externa?
   {                                           //sim
      INTF_bit = 0x00;                         //limpa a flag

      if(!TMR1ON_bit)                          //timer1 desligado?
      {                                        //sim
         TMR1ON_bit = 0x01;                    //liga timer1
         INTEDG_bit = 0x00;                    //configura int externa para borda de descida

      } //end if TMR1ON_bit

      else                                     //senão
      {                                        //timer1 ligado
         TMR1ON_bit = 0x00;                    //desliga timer1
         pulseEcho = (TMR1H << 8) + TMR1L;     //salva largura do pulso em µs
         TMR1H  = 0x00;                        //reinicia TMR1H
         TMR1L  = 0x00;                        //reinicia TMR1L
         INTEDG_bit = 0x01;                    //configura int externa para borda de subida

      } //end else TMR1ON_bit

   } //end INTF_bit

   // +++ Interrupção do Timer0 +++
   // Controla base de tempo para disparo do sensor
   // T0OVF = CM x PS x (256-TMR0) = 1E-6 x 256 x 235 = 60.16ms
   if(T0IF_bit)                                //houve interrupção do timer0?
   {                                           //sim
      T0IF_bit = 0x00;                         //limpa a flag
      TMR0     =   21;                         //reinicia timer0

      // -- base de tempo de aprox. 60ms --
      trig_pulse;                              //gera pulso de trigger

   } //end T0IF_bit

} //end interrupt


// ============================================================================
// --- Função Principal ---
void main()
{
   CMCON      = 0x07;                          //desabilita comparadores internos
   OPTION_REG = 0xC7;                          //interrupção externa por borda de subida
                                               //timer0 com prescaler 1:256
   INTCON     = 0xB0;                          //habilita interrupção global, do timer0 e externa
   TMR0       =   21;                          //inicializa Timer0 em 21
   TRISIO     = 0x0C;                          //configura I/Os
   GPIO       = 0x0C;                          //inicializa I/Os
   T1CON      = 0x00;                          //timer1 inicia desligado com prescaler 1:1


   while(1)                                    //loop infinito
   {
      pulseL = moving_average(pulseEcho);      //filtra pulso de echo e armazena em pulseL

      if(option) optionA(20,15,10);            //se option em HIGH, opção de funcionamento A
      else       optionB();                    //se option em  LOW, opção de funcionamento B



   } //end while

} //end main


// ============================================================================
// --- Desenvolvimento das Funções ---
void optionA(unsigned char cm1, unsigned char cm2, unsigned char cm3)
{
   if(pulseL < (cm1*58) && pulseL >= (cm2*58)) //distância menor que cm1 e maior igual a cm2?
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x00;                            //dist3 em  LOW

   } //end pulseL 1160

   else if(pulseL < (cm2*58) && pulseL >= (cm3*58))  //distância menor que cm2 e maior igual a cm2=3?
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x00;                            //dist3 em  LOW

   } //end pulseL 870

   else if(pulseL < (cm3*58))                  //distância menor que cm3?
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x01;                            //dist3 em HIGH

   } //end pulseL 580

   else                                        //senão
   {                                           //distância superior a cm1
      dist1 = 0x00;                            //dist1 em  LOW
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x00;                            //dist3 em  LOW

   } //end else

} //end optionA


void optionB()
{
   if(pulseL < 2320 && pulseL >= 2030)         //distância menor que 40cm? (2320/58)
   {                                           //sim
      dist1 = 0x00;                            //dist1 em  LOW
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x01;                            //dist3 em HIGH

   } //end pulseL 2320

   else if(pulseL < 2030 && pulseL >= 1740)    //distância menor que 35cm? (2030/58)
   {                                           //sim
      dist1 = 0x00;                            //dist1 em  LOW
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x00;                            //dist3 em  LOW

   } //end pulseL 2030

   else if(pulseL < 1740 && pulseL >= 1450)    //distância menor que 30cm? (1740/58)
   {                                           //sim
      dist1 = 0x00;                            //dist1 em  LOW
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x01;                            //dist3 em HIGH

   } //end pulseL 1740

   else if(pulseL < 1450 && pulseL >= 1160)    //distância menor que 25cm? (1450/58)
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x00;                            //dist3 em  LOW

   } //end pulseL 1450

   else if(pulseL < 1160 && pulseL >= 870)     //distância menor que 20cm? (1160/58)
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x01;                            //dist3 em HIGH

   } //end pulseL 1160

   else if(pulseL < 870 && pulseL >= 580)      //distância menor que 15cm? (870/58)
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x00;                            //dist3 em  LOW

   } //end pulseL 870

   else if(pulseL < 580)                       //distância menor que 10cm? (580/58)
   {                                           //sim
      dist1 = 0x01;                            //dist1 em HIGH
      dist2 = 0x01;                            //dist2 em HIGH
      dist3 = 0x01;                            //dist3 em HIGH

   } //end pulseL 580

   else                                        //senão
   {                                           //distância superior a 40cm
      dist1 = 0x00;                            //dist1 em  LOW
      dist2 = 0x00;                            //dist2 em  LOW
      dist3 = 0x00;                            //dist3 em  LOW

   } //end else

} //end optionB


long moving_average(unsigned pulseIn)          //retorna a média móvel de acordo com a resolução designada
{
   int i;                                      //variável para iterações
   long adder = 0;                             //variável para somatório

   for(i = N; i > 0; i--)                      //desloca todo vetor descartando o elemento mais antigo
      values[i] = values[i-1];

   values[0] = pulseIn;                        //o primeiro elemento do vetor recebe o valor do pulso

   for(i = 0; i < N; i++)                      //faz a somatória
      adder = adder + values[i];

   return adder / N;                           //retorna a média

} //end moving_average
// ============================================================================
// --- Final do Programa ---