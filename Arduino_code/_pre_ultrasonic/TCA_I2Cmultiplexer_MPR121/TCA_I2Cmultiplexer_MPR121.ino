/**
 * TCA9548 I2CScanner.pde -- I2C bus scanner for Arduino
 * Based on code c. 2009, Tod E. Kurt, http://todbot.com/blog/
 * 
 * Modified by Nicola Ariutti - 21/05/2018
 * 
 * Connect 2x Adafruit MPR121 board to a single TCA I2C multiplexer like this:
 * - Arduino Vcc to TCA Vin and to both MPR121 Vin;
 * - Arduino GND to TCA GND and to both MPR121 GND;
 * - TCA SDA to Arduino SDA (no pullup needed, TCA already has one);
 * - TCA SCL to Arduino SCL (no pullup needed, TCA already has one);
 * - TCA SDA/SCL 5 to the first MPR121 (no pullup needed, MPR121 already have them on the board);
 * - TCA SDA/SCL 6 to the second MPR121 (no pullup needed, MPR121 already have them on the board);
 * 
 * See also the attached image as a schematics.
 */
 
#include "Wire.h"
extern "C" { 
#include "utility/twi.h"  // from Wire library, so we can do bus scanning
}
 
#define TCAADDR 0x70

#include "Adafruit_MPR121.h"
#define MPR_ADDR 0x5A
struct mpr121 {
  uint8_t plexPos;
  Adafruit_MPR121 cap;
  uint8_t addr;
  // Save an history of the pads that have been touched/released
  uint16_t lasttouched = 0;
  uint16_t currtouched = 0;
  uint16_t oor=0;
};

mpr121 mpr[2];


// This function need to be used in order to talk with the I2C multiplexer
// so to select the appropriate MPR121 board when needed.
void tcaselect(uint8_t i) {
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

    // NOTE: here I impose the first MPR to be in position 5 of the multiplexer.
    // Then I impose the second one to position 6.
    mpr[0].plexPos = 5;
    mpr[1].plexPos = 6;
    
    
    tcaselect( mpr[0].plexPos );
    if (!mpr[0].cap.begin(0x5A)) {
      Serial.println("cap1 not found");
      while (1);
    } else {
      Serial.println("cap1 FOUND");
    }

    tcaselect( mpr[1].plexPos );
    if (!mpr[1].cap.begin(0x5A)) {
      Serial.println("cap2 not found");
      while (1);
    } else {
      Serial.println("cap2 FOUND");
    }
}



void loop() {
  // CAPACITIVE STUFF **************************************************************/
  // cycle through all the MPR
  for(int i=0; i<2; i++)
  {
    
    tcaselect( mpr[i].plexPos );
    
    // Get the currently touched pads
    mpr[i].currtouched = mpr[i].cap.touched(); 
    
    // cycle through all the electrodes
    for(int j=0; j<12; j++)
    {
      if (( mpr[i].currtouched & _BV(j)) && !(mpr[i].lasttouched & _BV(j)) )
      {
        // pad 'i' has been touched
        Serial.print("[cap "); Serial.print(i); Serial.print("] Pad: "); Serial.print(j); Serial.println(" touched!"); 
      }
      if (!(mpr[i].currtouched & _BV(j)) && (mpr[i].lasttouched & _BV(j)) )
      {
        // pad 'i' has been released
        Serial.print("[cap "); Serial.print(i); Serial.print("] Pad: "); Serial.print(j); Serial.println(" released!");
      }
    }
    // reset our state
    mpr[i].lasttouched = mpr[i].currtouched;
  }
  
  delay(100);
}
