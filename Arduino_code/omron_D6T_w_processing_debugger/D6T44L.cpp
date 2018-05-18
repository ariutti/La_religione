#include "D6T44L.h"

void D6T44L::init() {
  Wire.begin();
}


/*
void D6T44L::getReadings() {
  
  // Begin a regular i2c transmission. Send the device address and then send it a command.
  Wire.beginTransmission(addr);
  Wire.write(cmd);
  Wire.endTransmission();
      
  // This is where things are handled differently. 
  // Omron D6T output data is 35 bytes and there is a limit here on what Wire can receive. 
  // We use WireExt to read the output data 1 piece at a time.
  // We store each byte as an element in rbuf.
  if (WireExt.beginReception(addr) >= 0) {
    for(i = 0; i < 35; i++) {
      rbuf[i] = WireExt.get_byte();
    }
    
    // end the reception routine
    WireExt.endReception();

    
//    // Do something with temperature compensation that we don't seem to use currently.
//    t_PTAT = (rbuf[0]+(rbuf[1]<<8))*0.1; 
//        
//    // Calculate the temperature values: add the low temp and 
//    // the bit shifted high value together. Multiply by 0.1
//    for (i = 0; i < 16; i++) 
//    {
//      data[i]=(rbuf[(i*2+2)]+(rbuf[(i*2+3)]<<8))*0.1;
//    } 
    

   
    t_PTAT = (rbuf[0]+(rbuf[1]<<8)); 
    for (i = 0; i < 16; i++) {
      data[i]=(rbuf[(i*2+2)]+(rbuf[(i*2+3)]<<8));
    } 
     
  } // end of wireExt.beginReception
}
*/

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

