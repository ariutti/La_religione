// 2018_07_06
//
// * trigger: from Arduino analog pin
// * reading: from Arduino analog pin

#define RX A1
#define DISTANCE A0

int distance = 0;

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

  distance = analogRead( DISTANCE );
  Serial.println( distance );

  // make a reading every 99ms
  delay(100);
}
