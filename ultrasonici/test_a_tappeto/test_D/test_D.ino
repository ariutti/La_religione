// 2018_07_06
//
// * trigger: from Arduino analog pin
// * reading: PW from Arduino digital pin

#define RX A0
#define PW 2

unsigned long distance = 0;

// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  
  while(!Serial){};
  Serial.println("Ready!");

  pinMode(RX, OUTPUT);
  pinMode(PW, INPUT);
  
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

  distance = pulseIn(PW, HIGH, 65000);
  distance = distance / 58; // 58uS per cm
  Serial.println( distance );

  // make a reading every 99ms
  delay(100);
}
