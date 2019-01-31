/*
 * a class to make it easy to manage an 
 * Omron D6T 44L thermal sensor.
 * 
 * below some useful links:
 * https://fenrir.naruoka.org/download/autopilot/external/camera_breakout/arduino_library/WireExt/
 * https://github.com/jordanlui/Omron-Arduino
 * Code from Arduino Forum https://forum.arduino.cc/index.php?topic=217394.0
 */

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
