// 2018_07_04
// using the multiplexer
//
// This code has been used with a MaxBotix Ultrasonic sensor
// MB1200 placed at 3.5m height, 1.5m away from the wall facing the floor.
//
// The sensor has been connected to the Arduino via a 10m ethernet cable
// w/o any problems.
//
// The sensor is being used in single trigger mode but eventually it will
// be used in "AN Output Commanded Loop" (see datasheet).
//
// CONNECTIONS:
// * connect pin GND of the sensor to Arduino GND;
// * connect pin VCC of the sensor to Arduino Vcc;
// * connect pin RX of the sensor to Arduino analog A1;
// * connect pin AN of the sensor to Arduino analog A0; 

//const int addresspins[] = {2, 3, 4, 5};
#define S0 8
#define S1 9
#define S2 10
#define S3 11
#define SIGNAL A0
unsigned long d = 0;


#define ECHO 6


// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  
  while(!Serial){};
  //Serial.println("Ready!");


  // initialize multiplexer address pins
  /*
  for(int i=0; i<4; i++) {
    pinMode( addresspins[i], OUTPUT );
    digitalWrite(addresspins[i], LOW);
  }
  */

  pinMode( S0, OUTPUT );
  pinMode( S1, OUTPUT );
  pinMode( S2, OUTPUT );
  pinMode( S3, OUTPUT );
  
  digitalWrite( S0, LOW);
  digitalWrite( S1, LOW);
  digitalWrite( S2, LOW);
  digitalWrite( S3, LOW);
  

  /*
  // initialize US pins
  pinMode(TRIGGER, OUTPUT);
  digitalWrite(TRIGGER, LOW);
  */
  pinMode(ECHO, INPUT);
  
  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  // compose address
  //createAddress(0);

  // compose addres to send
//  digitalWrite(S0, LOW);
//  digitalWrite(S1, LOW);
//  digitalWrite(S2, LOW);
//  digitalWrite(S3, LOW);
  //PORTB = PORTB | 0x00000000;

  // send trigger pulse
  pinMode(SIGNAL, OUTPUT);
  digitalWrite (SIGNAL, HIGH);
  delayMicroseconds(21);
  digitalWrite(SIGNAL, LOW);

  //delay(16);
    /*
  // compose address to receive
  digitalWrite(S0, LOW);
  digitalWrite(S1, LOW);
  digitalWrite(S2, LOW);
  digitalWrite(S3, HIGH);

  // read pulse width
  pinMode(SIGNAL, INPUT);
  */

 
  //PORTB = PORTB | 0x10000000; // this is address 8 on the multiplexer
  d = pulseIn(ECHO, HIGH, 65000);
  // 58uS per cm
  d = d / 58;
  

  //d = analogRead(SIGNAL);

  //int v = read_max(TRIGGER, ECHO);
  Serial.println(d);

  // make a reading every 99ms
  delay(100);
}

/*
// READ THE MAXBOTIX /////////////////////////////
int read_max(int trigger, int echo)
{
  //trigger (stay HIGH for at least 20us)
  digitalWrite (trigger, HIGH);
  delayMicroseconds(21);
  digitalWrite(trigger, LOW);

  // NOTE: here it is easily possible to change pinMode
  
  unsigned long d = pulseIn(echo, HIGH, 65000);
  // 58uS per cm
  d = d / 58;
  return d;
  //return min(d*2.54/147, 255);
}
*/


/*
void createAddress(byte id) 
{
  // check if address is correct
  
  // compose the address on address pins
  for(int i=0; i<4; i++)
  {
    digitalWrite( addresspins[i], id & _BV(i) );
  }
}
*/
