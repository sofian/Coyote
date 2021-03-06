#define COYOTE_NORMAL_BIKE 6
#define COYOTE_SMALL_BIKE  6

// #define COYOTE_SLOW_DEBUG
#define COYOTE_BIKE_TYPE COYOTE_NORMAL_BIKE


/*
 $$$$$$\   $$$$$$\  $$$$$$\ $$$$$$$$\       $$$$$$$\   $$$$$$\  $$\    $$\         $$$$$$\   $$$$$$\ $$\     $$\  $$$$$$\ $$$$$$$$\ $$$$$$$$\ 
 $$  __$$\ $$  __$$\ \_$$  _|\__$$  __|      $$  __$$\ $$  __$$\ $$ |   $$ |       $$  __$$\ $$  __$$\\$$\   $$  |$$  __$$\\__$$  __|$$  _____|
 $$ /  $$ |$$ /  \__|  $$ |     $$ |         $$ |  $$ |$$ /  $$ |$$ |   $$ |       $$ /  \__|$$ /  $$ |\$$\ $$  / $$ /  $$ |  $$ |   $$ |      
 $$$$$$$$ |$$ |$$$$\   $$ |     $$ |         $$$$$$$  |$$ |  $$ |\$$\  $$  |       $$ |      $$ |  $$ | \$$$$  /  $$ |  $$ |  $$ |   $$$$$\    
 $$  __$$ |$$ |\_$$ |  $$ |     $$ |         $$  ____/ $$ |  $$ | \$$\$$  /        $$ |      $$ |  $$ |  \$$  /   $$ |  $$ |  $$ |   $$  __|   
 $$ |  $$ |$$ |  $$ |  $$ |     $$ |         $$ |      $$ |  $$ |  \$$$  /         $$ |  $$\ $$ |  $$ |   $$ |    $$ |  $$ |  $$ |   $$ |      
 $$ |  $$ |\$$$$$$  |$$$$$$\    $$ |         $$ |$$\    $$$$$$  |$$\\$  /$$\       \$$$$$$  | $$$$$$  |   $$ |     $$$$$$  |  $$ |   $$$$$$$$\ 
 \__|  \__| \______/ \______|   \__|         \__|\__|   \______/ \__|\_/ \__|       \______/  \______/    \__|     \______/   \__|   \________|
 
 */


/* PASTE YOUR DRAWING ARRAY CODE BELOW
 ===============================*/

#define POVARRAYSIZE 200
int povArray[] = { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 4089 , 4089 , 3225 , 3225 , 2033 , 1905 , 1 , 1 , 25 , 121 , 481 , 1889 , 4065 , 505 , 25 , 1 , 1 , 4081 , 4089 , 1049 , 1561 , 825 , 1009 , 481 , 0 , 0 , 0 , 0 , 3072 , 3073 , 3073 , 4089 , 4089 , 3073 , 3073 , 3073 , 1 , 4089 , 4089 , 3169 , 3697 , 2009 , 921 , 1 , 3097 , 3097 , 4089 , 4089 , 3097 , 3097 , 1 , 4089 , 4089 , 3265 , 4033 , 1920 , 0 , 0 , 0 , 1 , 57 , 505 , 4033 , 4033 , 505 , 121 , 993 , 3969 , 4089 , 121 , 1 , 1 , 25 , 121 , 481 , 1889 , 4065 , 505 , 25 , 1 , 1 , 4089 , 4089 , 3169 , 3697 , 2009 , 921 , 1 , 481 , 2033 , 1593 , 3097 , 3097 , 3097 , 3121 , 2033 , 961 , 1 , 241 , 1017 , 1817 , 3609 , 3097 , 3121 , 3633 , 0 , 0 , 0 , 0 , 0 , 0 , 0};


/*  
 
 POV PIN CONFIGURTATION
 ==========================
 
 LED    ATMEGA168     ARDUINO PIN
 13     PD0           0
 12     PD1           1
 11     PC1           A1
 10     PC2           A2
 9      PC3           A3
 8      PC5           A5
 7      PC4           A4
 6      PC0           A0
 5      PB0           8
 4      PD7           7
 3      PB2           10
 2      PB1           9
 
 PORT D MASK : 0x83 B10000011
 PORT B MASK : 0x07 B00000111
 PORT C MASK : 0x3F B00111111
 

 ARDUINO 
 ATMEGA168     PIN  INTERRUPT
 HALL   PD3           3    1
 
 */
unsigned char ledPins[]={
  9,10,7,8,A0,A4,A5,A3,A2,A1,1,0};

#define HALL_INTERRUPT 1
#define HALL_PIN 3
  
#define WHEEL_RADIUS_FACTOR COYOTE_BIKE_TYPE

void setup() {                


  // SETUP THE POV
  // ===============================
  povSetup();
  povSetArray(povArray,POVARRAYSIZE);

  // 2s FADE OUT ANIMATION  
  // ================================
  unsigned long timeStamp = millis();
  unsigned long microTimeStamp = micros();
  while ( (millis() - timeStamp) < 2000) {

    unsigned long lapsed = (micros() - microTimeStamp); // 0-2000000 

    unsigned long dim = lapsed / 200; // 0-10000
    unsigned long frame = lapsed % 10000; //0-10000

      if ( frame >= dim ) {
      for ( int i=0; i < 12 ; i++ ) digitalWrite( ledPins[i],  LOW ); //ON
    } 
    else {
      for ( int i=0; i < 12 ; i++ ) digitalWrite( ledPins[i],  HIGH ); //OFF
    }



  }

  // TURN OFF ALL LEDS
  // ====================================
  for (unsigned char k=0;k<12;k++) {
    digitalWrite(ledPins[k],HIGH);
  }
}


  // MAIN LOOP
  // ====================================
void loop() {

  povDisplayCheck();

}



