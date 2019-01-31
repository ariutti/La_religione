/**
 * TCA9548 I2CScanner.pde -- I2C bus scanner for Arduino
 * Based on code c. 2009, Tod E. Kurt, http://todbot.com/blog/
 * 
 * Modified by Nicola Ariutti - 21/05/2018
 */
 
#include "Wire.h"
extern "C" { 
#include "utility/twi.h"  // from Wire library, so we can do bus scanning
}


#define TCAADDR 0x70


// This function need to be used in order to talk with the I2C multiplexer
// so to select the appropriate MPR121 board when needed.
void tcaselect(uint8_t i) 
{
  if (i > 7) return;
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();  
}

 
 
void setup()
{
    while (!Serial) { delay(10); }
    delay(3000);
 
    Wire.begin();
    
    Serial.begin(9600);
    Serial.println("\nTCAScanner ready!");
    
    for (uint8_t t=0; t<8; t++) 
    {
      tcaselect(t);
      Serial.print("TCA Port #"); Serial.println(t);
 
      for (uint8_t addr = 0; addr<=127; addr++) {
        if (addr == TCAADDR) continue;
      
        uint8_t data;
        if (! twi_writeTo(addr, &data, 0, 1, 1)) {
           Serial.print("Found I2C 0x");  Serial.println(addr,HEX);
        }
      }
    }
    Serial.println("\nScan done");
}



void loop() 
{  
  delay(100);
}
