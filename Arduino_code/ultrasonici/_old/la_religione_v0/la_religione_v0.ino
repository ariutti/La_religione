// 2018_07_07

const int addresspins[] = {18, 19, 20, 21};
#define TRIG 2
#define SIG A5 // 23


#define NSENSORS 2
// class US is not used for the moment
//#include "US.h"
//US us[NSENSORS];

unsigned long th = 150;
unsigned long distance = 0;

// array of all booleans presences
struct US 
{
  int id;
  unsigned long th;
  unsigned long distance;
  bool presence;
} us[NSENSORS];


bool bSendSerial = false;

// SETUP /////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);
  
  //while(!Serial){};
  //Serial.println("Ready!");
  
  // initialize multiplexer address pins
  for(int i=0; i<4; i++) {
    pinMode( addresspins[i], OUTPUT );
    digitalWrite( addresspins[i], LOW );
  }

  // initialize US pins
  pinMode(TRIG, OUTPUT);
  digitalWrite(TRIG, LOW);

  //us = new US[ NSENSORS];
  for(int i=0; i<NSENSORS; i++)
  {
    us[i].id = i;
    us[i].th = th;
  }

  // Wait 175ms at least for the ultrasonic
  // to be ready for ranging
  delay(180);
}


// LOOP //////////////////////////////////////////
void loop() 
{
  getSerialData();
  
  // send trigger pulse
  digitalWrite (TRIG, HIGH);
  delayMicroseconds(21);
  digitalWrite(TRIG, LOW);

  //Serial.print("[ ");
    
  // read all the analog value from the multiplexer
  for(int i=0; i<NSENSORS; i++) 
  {
    createAddress(i); // compose address
    us[i].distance = analogRead( SIG );
    //sendToProcessing( i, us[i].distance );
    // Every US Sensor will take 99ms to make a scan
    delay( 99 );
    
    //Serial.print( us[i].getDistance() ); Serial.print(",\t");
    
  }

  calculatePresences();
  if(bSendSerial){ sendAllPresences(); }

  //Serial.println();
}



// CREATE ADDRESS ////////////////////////////////
void createAddress(byte id) 
{
  // TODO: check if address is correct
  
  // compose the address on address pins
  for(int i=0; i<4; i++) {
    digitalWrite( addresspins[i], id & _BV(i) );
  }
}



// SEND TO PROCESSING ////////////////////////////
void sendToProcessing( int _id, int _value)
{
  //Serial.print( _id ); Serial.print("-");
  Serial.print( _value ); Serial.print("\t"); //";");
}



// CALCULATE PRESENCES ///////////////////////////
void calculatePresences()
{
  for(int i=0; i<NSENSORS; i++)
  {
    if(us[i].distance < us[i].th)
    {
      if(!us[i].presence) {
        us[i].presence = true;
      }
    }
    else
    {
      if(us[i].presence) {
        us[i].presence = false;
      }
    }
  }
}



// SEND ALL PRESENCES ////////////////////////////
void sendAllPresences()
{
  for(int i=0; i<NSENSORS; i++)
  {
    Serial.print( us[i].presence );
  }
  Serial.println(";");
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



// SERIAL UTILITY FUNC /////////////////////////////////////////////////
void getSerialData()
{
  if(Serial.available()) {
    char user_input = Serial.read(); // Read user input and trigger appropriate function
      
    if (user_input =='1')  {
       bSendSerial = true;
    }
    else if(user_input =='0')  {
      bSendSerial = false;
    }
  }
}

