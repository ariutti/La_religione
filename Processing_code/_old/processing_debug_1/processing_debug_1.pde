
// serial communication stuff
import processing.serial.*;
Serial myPort;
String myString = null;
String[] list;
int lfcr = 10;

// calculation values
int[] tP;
int sum, vMin, vMax;
float vMean;


int minIdx, maxIdx = 0;

Grid grid;


// SETUP ////////////////////////////////
void setup() {
  size(800, 800);
  smooth();
  
  grid = new Grid(0, 0, width, height, true, true);
  tP = new int[16];
  
  // serial stuff
  //printArray(Serial.list());
  String port = Serial.list()[3];
  myPort = new Serial(this, port, 9600); 
}

// DRAW /////////////////////////////////
void draw() {
  background(0);
  grid.display(maxIdx, minIdx);
  read();
  grid.update( tP );
  makeCalculations();
}


void makeCalculations() {
  vMin = 1000;  // 100°C
  vMax = 0;     // 0°C
  vMean = 0.0;
  sum = 0;
  for(int i=0; i<16; i++) {
    if(tP[i]>vMax)
    {
      vMax = tP[i];
      maxIdx = i;
    }
    if(tP[i]<vMin)
    {
      vMin = tP[i];
      minIdx = i;
    }
    sum += tP[i];
  }
  vMean = (sum*1.0)/ 16;
  
  // print section
  print("[ ");
  print(vMin); print(" - ");
  print(vMax); print(" - ");
  print(vMean);
  print(" ]\n");
}


// READ values from Serial //////////////
void read()
{
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lfcr);
    if (myString != null) {
      list = split(myString, ',');
      //print(myString);
      //printArray(list);
      println(list.length);
      for(int i=0; i<list.length-1; i++) {
        tP[i] = int(list[i]);
      }
      
      // print all the converted strings
      /*
      print("[ ");
      for(int i=0; i<16; i++)
      {
        print(tP[i]); 
        if(i!=15) print(", ");
      }
      print(" ]\n");
      */
    }
  }
}









/**********************************************************************
// This sketch will work with the following Arduino code

#include "D6T44L.h"

int i = 0; // utility variable

// calculation values
uint16_t sum, vMin, vMax;
float vMean;

D6T44L d6t;


// SETUP /////////////////////////////////////////////////
void setup()
{
  d6t.init();
  Serial.begin(9600);

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}


// LOOP //////////////////////////////////////////////////
void loop()
{
  
  if(d6t.read() > 0)
  {
    makeCalculations();
    sendToProcessing();
  }
  delay(250);          
}

// this function will send values to processing in form a 
// big, long string.
void sendToProcessing()
{
  // First print all the values indipendently
  for (i=0; i<16; i++) 
  {
    Serial.print(d6t.tP[i]); 
    Serial.print(",");  
  }
  Serial.print("\n");
}


// D6T44L.h file

//a class to make it easy to manage an 
//Omron D6T 44L thermal sensor.
//
//below some useful links:
//https://fenrir.naruoka.org/download/autopilot/external/camera_breakout/arduino_library/WireExt/
//https://github.com/jordanlui/Omron-Arduino
//Code from Arduino Forum https://forum.arduino.cc/index.php?topic=217394.0

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
};
#endif


// D6T44L.cpp file
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
*/
