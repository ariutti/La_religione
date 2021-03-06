// 2018_07_06 - chain test
//
// * trigger: from Arduino digital pin
// * reading: from Arduino analog pin A0
//            from Arduino analog pin A1


#define RX 2
#define READ1 A0
#define READ2 A1

unsigned long distance = 0;

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

  //Serial.print("[ ");
  // reading from the first sensor
  distance = analogRead( READ1 );
  Serial.print( distance );

  
  Serial.print(",\t");

  // reading from the second sensor
  distance = analogRead( READ2 );
  Serial.print( distance );

  Serial.println(" ]");
  

  // make a reading every 99ms
  delay(250);
}
