// serial communication stuff
import processing.serial.*;
Serial myPort;
String myString = null;
String[] list;
boolean presence = false;
int idx, distance;
int lfcr = 10;

PFont font;

final int TH = 220;

//// import everything necessary to make sound.
//import ddf.minim.*;
//import ddf.minim.ugens.*;
//Minim minim;
//Oscil sineOsc;
//AudioOutput out;

Meter[8] meter;


// SETUP ////////////////////////////////
void setup() 
{
  size(800, 800);
  smooth();

  // serial stuff
  printArray(Serial.list());
  String port = Serial.list()[3];
  myPort = new Serial(this, port, 9600); 
  
  idx = 0;
  distance = 0;
  
  font = loadFont("Courier-Bold-240.vlw");
  textFont(font);
  textAlign(CENTER);

  // audio stuff
  //minim = new Minim( this );
  //out = minim.getLineOut( Minim.MONO, 2048 );
  //sineOsc = new Oscil( 440, .5, Waves.SINE );

}

// DRAW /////////////////////////////////
void draw() {
  read();
  
}

// READ values from Serial //////////////
void read()
{
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil('\n');
    if (myString != null) {
      //print(myString);
      //println( myString.indexOf('\n') ); 
      idx = int(myString.substring(0, myString.indexOf('-')-1));
      distance = int(myString.substring(myString.indexOf('-'), myString.indexOf(';')-1));
      
      // TODO: here update Meter instance based on index
      meter[ idx ].update( distance );     
    }
  }
}

// to be used w/ the following Arduino code "omron_D6T_w_convolution"

/*
// file D6T44L.h ////////////////////////////////////////////////////////////////////////////////

#ifndef _NICOLAARIUTTI_D6T44L
#define _NICOLAARIUTTI_D6T44L
#include "Arduino.h"

#include <Wire.h>
#include <WireExt.h>

//#define D6T_addr 0x0A // Address of OMRON D6T is 0x0A in hex
//#define D6T_cmd 0x4C // Standard command is 4C in hex


class D6T44L 
{

private:
  int addr = 0x0A;
  int cmd =  0x4C;
  int i=0;
  int state;
  
  unsigned char calc_crc(unsigned char data);
  unsigned char checkPEC(char buf, int pPEC);
  
public:

  // Actual raw data is coming in as 35 bytes.
  // Hence the needed for WireExt so that we can handle more than 32 bytes 
  byte rbuf[35]; 
  // The data comming from the sensor is 16 elements, in a 16x1 array
  int tPTAT;
  int tP[16]; 
  int tPEC;

  // constructor
  D6T44L() {};
  
  void init();
  int read();
  int* getTpRef();
};
#endif

// file D6T44L.cpp //////////////////////////////////////////////////////////////////////////////
#include "D6T44L.h"

void D6T44L::init() {
  Wire.begin();
}

// D6T READ VALUES //////////////////////////////////////////////
int D6T44L::read()
{
  // Begin a regular I2C transmission.
  // Send the device address and then send it a command.
  Wire.beginTransmission(addr);
  Wire.write(cmd);
  Wire.endTransmission();
  
  if ( WireExt.beginReception(addr) >= 0 )
  {
    for (i = 0; i<35; i++) {
      rbuf[i] = WireExt.get_byte();
    }
    WireExt.endReception(); // end the reception routine
  }

  // if there are some error
  if(!checkPEC(rbuf, 34)) {
    return -1;
  }
  
  tPTAT = (rbuf[1]<<8) + rbuf[0];
  tPEC = rbuf[34];
  for (i = 0; i<16; i++) {
    tP[i] = (rbuf[i*2+3]<<8) + rbuf[i*2+2];
  } 
  return 1;
}

// return a reference to the temperatures array
int* D6T44L::getTpRef()
{
  return &tP[0];
}

// D6T READ VALUES //////////////////////////////////////////////
unsigned char D6T44L::calc_crc(unsigned char data)
{
  int index;
  unsigned char temp;
  for(index=0; index<8;index++)
  {
    temp = data;
    data <<= 1;
    if(temp & 0x80) data ^= 0x07;
  }
  return data;  
}

// D6T ERROR CORRECTION /////////////////////////////////////////
unsigned char D6T44L::checkPEC(char buf, int pPEC)
{
  unsigned char crc;
  int i;
  crc = calc_crc( 0x15 );
  for(i=0;i<pPEC;i++)
  {
    crc = calc_crc(rbuf[i]^ crc);
  }
  return (crc == rbuf[pPEC]);
}

// file BinaryImg.h /////////////////////////////////////////////////////////////////////////////
#ifndef _NICOLAARIUTTI_BINARYIMG
#define _NICOLAARIUTTI_BINARYIMG
#include "Arduino.h"

class BinaryImg 
{
private:
  int* tpRef;
  // an array to keep track of the convolved values
  int convolved[16];
  // another array to keep track of booleans
  boolean bools[16];
  // a single boolean value to signal human presence
  boolean presence;
  // get the last value which was found above the th
  int value;
  
  // kernel
  int kernelSize = 3;
  float kenrel[3][3] = { {-1,-1,-1 } , 
                         {-1, 9,-1 } ,
                         {-1,-1,-1 } 
                       };
  // mask
  int mask[4][4] = {{0, 1, 1, 1},
                    {1, 1, 1, 1},
                    {1, 1, 1, 1},
                    {1, 1, 1, 1}
                   };
  int th;
  
public:
  // constructor
  BinaryImg() {};
  void init(int threshold, int* _tpRef);
  int update();
  int convolution(int _x, int _y);
  void applyMask();
  bool isSomebodyHere();
  int* getConvRef();
  int getValue();
};
#endif


// file BinaryImg.cpp ///////////////////////////////////////////////////////////////////////////
#include "BinaryImg.h"

void BinaryImg::init(int _th, int* _tpRef)
{
  for(int i=0; i<16; i++) {
    convolved[i] = 0;
  }
  th = _th;
  tpRef = _tpRef;
  presence = false;
  value = 0;
}

int BinaryImg::update()
{
  // calculate the convolution 
  for(int x=0; x<4; x++) {
    for(int y=0; y<4; y++) {
      int value = convolution(x,y);
      int pos = x+ 4*y;
      convolved[pos] = value;
    }
  }
  
  // set booleans
  for(int i=0; i<16; i++) {
    if( convolved[i] > th ) {
      bools[i] = true;
    }
    else {
      bools[i] = false;
    }
  }

  // apply the layer mask
  applyMask();

  isSomebodyHere();
}



int BinaryImg::convolution(int _x, int _y)
{
  int total = 0;
  int offset = kernelSize / 2;
  
  // Loop through convolution matrix
  for (int i = 0; i < kernelSize; i++ ) {
    for (int j = 0; j < kernelSize; j++ ) {
      
      // What pixel are we testing
      int xloc = _x + i-offset;
      int yloc = _y + j-offset;
      int loc = xloc + 4*yloc;
      
      // Make sure we haven't walked off the edge of the pixel array
      // It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
      loc = constrain(loc,0, 16-1);
      
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      total += (  tpRef[loc] * kenrel[i][j]);
    }
  }
  
  // Make sure RGB is within range
  total = constrain(total,0,1000);
  
  // Return the resulting color
  return total; 
}

void BinaryImg::applyMask()
{
  for(int x=0; x<4; x++) {
    for(int y=0; y<4; y++) {
      int pos = x + 4*y;
      if(mask[x][y] == 0)
        bools[pos] = false;
    }
  }
}

boolean BinaryImg::isSomebodyHere()
{
  value = 0;
  presence = false;
  for(int i=0; i<16; i++) {
    if( bools[i] ) {
      presence = true;
      value = convolved[i];
      return presence;
    }
  }
  return false;  
}

// return a reference to the convolved values array
int* BinaryImg::getConvRef()
{
  return &convolved[0];
}

int BinaryImg::getValue()
{
  return value;
}
*/
