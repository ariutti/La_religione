// 2018_07_03
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

#define RX A1
#define DISTANCE A0

int threshold = 150;
bool state, prevState = false;

// set it to true if you want to send serial
// data trough serial communication
bool sendSerial = false;


// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  //while(!Serial){};
  //Serial.println("Ready!");
  pinMode(RX, OUTPUT);

  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  getSerialData();
  
  //trigger (stay HIGH for at least 20us)
  digitalWrite(RX, HIGH);
  delayMicroseconds(22);
  digitalWrite(RX, LOW);

  int v = analogRead(DISTANCE);
  
  if( v < threshold) {
    state = true;
    if( state != prevState ) {
      //sendo to VVVV
      if(sendSerial){ Serial.print("S0-");Serial.print( 1 );Serial.println(";"); }
      // update prev state
      prevState = state;
    }
  } else {
    state = false;
    if( state != prevState ) {
      //sendo to VVVV
      if(sendSerial){ Serial.print("S0-");Serial.print( 0 );Serial.println(";"); }
      // update prev state
      prevState = state;
    }
  }
  
  // make a reading every 99ms
  delay(100);
}



/************************************************************************************
 * SERIAL UTILITY FUNCTIONS
 ***********************************************************************************/
void getSerialData()
{
  if(Serial.available()) {
    char user_input = Serial.read(); // Read user input and trigger appropriate function
      
    if (user_input =='1')  {
       sendSerial = true;
    }
    else if(user_input =='2')  {
      sendSerial = false;
    }
  }
}

// to be used with the following Processing code
/*
// serial communication stuff
import processing.serial.*;
Serial myPort;
String myString = null;
String[] list;
boolean presence = false;
int value;
int lfcr = 10;

PFont font;

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;
Minim minim;
Oscil sineOsc;
AudioOutput out;


// SETUP ////////////////////////////////
void setup() 
{
  size(800, 800);
  smooth();

  // serial stuff
  printArray(Serial.list());
  String port = Serial.list()[0];
  myPort = new Serial(this, port, 9600); 
  
  value = 0;
  
  font = loadFont("Courier-Bold-240.vlw");
  textFont(font);
  textAlign(CENTER);

  // audio stuff
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );
  sineOsc = new Oscil( 440, .5, Waves.SINE );

}

// DRAW /////////////////////////////////
void draw() {
  read();
  if(presence)
  {
    background(255, 0, 0);
    fill(0);
    text(value, width/2, height/2);
  }
  else
  {
    background(0);
    fill(255);
    text(value, width/2, height/2);
  }
}

// READ values from Serial //////////////
void read()
{
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil('\n');
    if (myString != null) {
      //print(myString);
      //println( myString.indexOf('\n') );  
      value = int(myString.substring(0, myString.indexOf('\n')-1));
      //println(value);
      if(value < 200)
      {
        if(!presence) {
          presence = true;
          sineOsc.patch( out );
        }
      }
      else
      {
        if(presence) {
          presence = false;
          sineOsc.unpatch( out );
        }
      }
    }
  }
}
*/

