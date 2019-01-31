// 2018_06_06
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
// * connect pin RX of the sensor to Arduino digital pin 2;
// * connect pin AN of the sensor to Arduino analog A0; 

#define RX 2
#define DISTANCE A0

// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  while(!Serial){};
  Serial.println("Ready!");

  
  pinMode(RX, OUTPUT);

  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  //trigger (stay HIGH for at least 20us)
  digitalWrite(RX, HIGH);
  delayMicroseconds(22);
  digitalWrite(RX, LOW);

  int v = analogRead(DISTANCE);
  Serial.println(v);

  // make a reading every 99ms
  delay(500);
}

