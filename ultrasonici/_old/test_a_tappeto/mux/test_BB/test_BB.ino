// 2018_07_07

// using:
// * Arduino digital 11 -> S3
// * Arduino digital 10 -> S2
// * Arduino digital 9  -> S1
// * Arduino digital 8  -> S0

#define RX 6
#define SIG A5
unsigned long distance = 0;

// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  
  while(!Serial){};
  Serial.println("Ready!");
 
  DDRB = DDRB | B11110000;

  // initialize US pins
  pinMode(RX, OUTPUT);
  digitalWrite(RX, LOW);

  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  // send trigger pulse
  digitalWrite (RX, HIGH);
  delayMicroseconds(21);
  digitalWrite(RX, LOW);


  Serial.print("[ ");
    
  // read all the analog value from the multiplexer
  for(int i=0; i<2; i++) {
    createAddress(i); // compose address
    distance = analogRead( SIG );
    Serial.print( distance ); Serial.print(",\t");
  }

  Serial.println(" ]");
  
  // make a reading every 99ms
  delay(200);
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

void createAddress(byte id) 
{
  // TODO: check if address is correct
  
  // compose the address on address pins
  PORTB = (id<<4) & B11110000;
  
}

