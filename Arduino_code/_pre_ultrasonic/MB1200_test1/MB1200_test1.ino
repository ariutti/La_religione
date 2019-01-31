#define RX 2
#define DISTANCE A0

float vm = 0.0; // voltage measured
float vcm = 0.0049; // voltage per cm scaling
float Rcm = 0.0; // range in cm

// Rcm = (v * 0.00482813 ) / 0.0049; // un po' coem dire che Rcm == v
//vm = v * 0.0048;
//Rcm = vm / 0.0049;


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
  //trigger
  digitalWrite(RX, HIGH);
  delayMicroseconds(22);
  digitalWrite(RX, LOW);

  int v = analogRead(DISTANCE);
  Serial.println(v);

  // make a reading every 99ms
  delay(150);
}
