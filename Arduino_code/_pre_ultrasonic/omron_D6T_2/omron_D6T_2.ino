// To find information about the sensor and 
// how to use it see links below:
// * https://fenrir.naruoka.org/download/autopilot/external/camera_breakout/arduino_library/WireExt/
// * https://github.com/jordanlui/Omron-Arduino
// * https://forum.arduino.cc/index.php?topic=217394.0

#include <Wire.h>
#include <WireExt.h>
#include "MovingAvg.h"
#include "DynMean.h"

#define D6T_addr 0x0A // Address of OMRON D6T is 0x0A in hex
#define D6T_cmd  0x4C // Standard command is 0x4C in hex

// Actual raw data is coming in as 35 bytes.
// Hence the needed for WireExt so that we can handle more than 32 bytes 
byte rbuf[35]; 
// The data comming from the sensor is 16 elements, in a 16x1 array
int tPTAT;
int tP[16]; 
int tPEC;
int i = 0;

float tMEAN = 200.0;
float delta_tMIN_tMEAN = 200.0;
float th = 200.0;
int tMIN = 500;
int tMAX = 190;

MovingAvg vMaxAvg;
MovingAvg vMinAvg;
MovingAvg vMeanAvg;
DynMean dynMean;

int status = 0;

// SETUP /////////////////////////////////////////////////
void setup()
{
  Wire.begin();
  Serial.begin(9600);

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}

// LOOP //////////////////////////////////////////////////
void loop()
{
  status = D6T_getvalue();
  //serialDebug( status );
  //send2Processing( status );

  computeMean();
  computeMinMax();
  //computeDeltas();
  //vMinAvg.setValue(tMIN);
  //vMaxAvg.setValue(tMAX);
  //vMeanAvg.setValue(tMEAN);
 
  //Serial.println( dynMean.getValue( vMinAvg.getAvg(), vMaxAvg.getAvg(), vMeanAvg.getAvg() ) );
  graph();
  

  // the D6T is ready with new data 
  // 4 times per second 
  delay(250);          
}

// D6T READ VALUES //////////////////////////////////////////////
int D6T_getvalue()
{
  // Begin a regular I2C transmission.
  // Send the device address and then send it a command.
  Wire.beginTransmission(D6T_addr);
  Wire.write(D6T_cmd);
  Wire.endTransmission();
  
  if ( WireExt.beginReception(D6T_addr) >= 0 )
  {
    for (i = 0; i<35; i++) {
      rbuf[i] = WireExt.get_byte();
    }
    WireExt.endReception(); // end the reception routine
  }

  // if there are some error
  if(!D6T_checkPEC(rbuf, 34)) {
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
unsigned char calc_crc(unsigned char data)
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
unsigned char D6T_checkPEC(char buf, int pPEC)
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

// SERIAL DEBUG /////////////////////////////////////////////////
void serialDebug( int st )
{
  if(st < 0) {
    // handle the error
    Serial.println("Errore");
  }
  else
  {
    Serial.print( tPTAT );
    Serial.print(" - ");
    
    for(i=0; i<16; i++) {
      Serial.print( tP[i] );
      Serial.print(",");
    }
    
    Serial.print(" - ");
    Serial.print( tPEC );
    Serial.println("");
  }
}

// TO PROCESSING ////////////////////////////////////////////////
void send2Processing( int st )
{
  if(st < 0) {
    // handle the error
  }
  else
  {    
    float f = 0.0;
    for(i=0; i<16; i++) {
      Serial.write( 128 + i);
      f = tP[i]*0.1;
      Serial.write( int(f) & 0x7F );
    } 
   // send data relative to the base temperature
   Serial.write( 128 + 16 );
   f = tPTAT*0.1;
   Serial.write( int(f) & 0x7F);
  }
}


void computeMean()
{
  tMEAN = 0.0;
  for (i = 0; i<16; i++) {
    tMEAN += tP[i];
  } 
  tMEAN = tMEAN / 16.0;
}


float computeMinMax() 
{
  tMIN = 500;
  tMAX = 0;
  for (i = 0; i<16; i++) {
    if(tP[i]>tMAX) tMAX = tP[i];
    if(tP[i]<tMIN) tMIN = tP[i];
  } 
}

void computeDeltas()
{
  delta_tMIN_tMEAN = th = 0.0;
  delta_tMIN_tMEAN = tMEAN - tMIN;
  th = 2*delta_tMIN_tMEAN + tMIN;
}

void graph()
{
  Serial.print(tMEAN); Serial.print("\t");
  Serial.print(tMIN); Serial.print("\t");
  Serial.print(tMAX); Serial.print("\t");
  //Serial.print(vMaxAvg.getAvg()); Serial.print("\t");
  //Serial.print(th);
  Serial.println();
}

