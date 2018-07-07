// 2018_07_07

// connections:
// * Arduino analog pin A0 -> mux S0
// * Arduino analog pin A1 -> mux S1
// * Arduino analog pin A2 -> mux S2
// * Arduino analog pin A3 -> mux S3

const int addresspins[] = {18, 19, 20, 21};
#define SIG A5
unsigned long distance = 0;

// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  
  while(!Serial){};
  Serial.println("Ready!");
  
  // initialize multiplexer address pins
  for(int i=0; i<4; i++) {
    pinMode( addresspins[i], OUTPUT );
    digitalWrite( addresspins[i], LOW );
  }

  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  // send trigger pulse
  pinMode(SIG, OUTPUT);
  // the mux trigger pin output is C8
  createAddress(8);
  digitalWrite (SIG, HIGH);
  delayMicroseconds(21);
  digitalWrite(SIG, LOW);

  pinMode(SIG, INPUT);
  
  Serial.print("[ ");
    
  // read all the analog value from the multiplexer
  for(byte i=0; i<2; i++) {
    createAddress(i); // compose address
    distance = analogRead( SIG );
    Serial.print( distance ); Serial.print(",\t");
    delay(100);
  }

  Serial.println(" ]");
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
  for(int i=0; i<4; i++) {
    digitalWrite( addresspins[i], id & _BV(i) );
  }
}

