// 2018_08_10 - modifiche in cantiere a Mestre

String temp; // used to share messages between VVVV and Arduino

// Analog pins: A0, A1, A2, A3
const int addresspins[] = {18, 19, 20, 21};

// Use digital pin 2 only if you want to use US in "chain mode"
// else you will need to define more trigger pins
#define TRIG 2
#define SIG A5 // 23


#define NSENSORS 1


// class US is not used for the moment
//#include "US.h"
//US us[NSENSORS];

unsigned long th = 200;
unsigned long distance = 500;

// array of all booleans presences
struct US 
{
  int id;
  unsigned long th;
  unsigned long distance;
  bool presence;
} us[NSENSORS];


bool bSendSerial = false;
bool bDebugMode = false;


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

  // US class is not used for the moment
  //us = new US[ NSENSORS];
  
  for(int i=0; i<NSENSORS; i++)
  {
    us[i].id = i;
    // preliminary settings
    us[i].th = th;
    us[i].distance = distance;
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
    delay( 90 );
    
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
    if( bDebugMode )
    {
      //Serial.print( us[i].id );
      Serial.print( us[i].distance );
      Serial.print( ',' );
      Serial.print( us[i].th );
      Serial.print( ',' );
      Serial.print( us[i].presence );
      // don't send the comma for the last value
      if(i!=NSENSORS-1) {Serial.print( ',' ); }
    }
    else
    {
      Serial.print( us[i].presence );
    }
  }
  Serial.println(";");
}


// SERIAL UTILITY FUNC /////////////////////////////////////////////////
void getSerialData()
{
  while (Serial.available() > 0)
  {
    char c = Serial.read();
    // the message from VVVV is finished
    if (c == ';')
    {
      if( temp[0]=='S') {
        // this is a "SET TH" msg
        char delimiter = temp[2]; // should be ','
        int from = 3;
        //int to = temp.length();
        int th = (temp.substring(from)).toInt();

        // 0 is 48 in ASCII
        // 7 is 55 in ASCII
        // (http://www.asciitable.com/)
        char index = temp[1]-48;
        
        if( index>=0 && index<NSENSORS && delimiter==',')
        {
          // this is a valid message
          us[index].th = th;
        }
      } else if( temp[0]=='A') {
        // this is a "SET TH FOR ALL" msg

        char delimiter = temp[1]; // should be ','
        int from = 2;
        int th = (temp.substring(from)).toInt();

        if( delimiter==',')
        {
          for(int i=0; i<NSENSORS; i++) 
          {
            us[i].th = th;
          }
        }
               
      } else if( temp[0]=='D') {
        // this is a "SET DEBUG MODE" msg
        bSendSerial = true;
        bDebugMode = true;
      } else if( temp[0]=='P') {
        // this is a "SET PRESENCE MODE" msg
        bSendSerial = true;
        bDebugMode = false;
      } else if( temp[0]=='1') {
        // this is a "SERIAL COMM ON" msg
        bSendSerial = true;
      } else if( temp[0]=='0') {
        // this is a "SERIAL COMM OFF" msg
        bSendSerial = false;
      }
      temp = "";
    }
    else
    {
      // if the message from VVVV is not finished yet,
      // append character to 'temp' string
      temp += c;
    }
  }
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
