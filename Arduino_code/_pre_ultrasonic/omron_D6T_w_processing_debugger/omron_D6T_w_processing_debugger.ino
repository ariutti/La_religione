/*
 * A sketch modified by Nicola Ariutti - 21-05-2018.
 * To be used with Processing "processing_debug_2".
 */
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
    //debugPrint();
  }
  
  
  /*
  // Use a for loop to output the data. 
  // We can copy this from serial monitor and save as a CSV
  for (i=0; i<16; i++) 
  {
    //Serial.print(tdata[i]);
    //Serial.print(",");
    
    if(tdata[i] > 0 )
    {
      Serial.write( i + 128 );
      Serial.write(int(tdata[i]) & 0x7F);
    }
  }

   // send data relative to the base temperature
   Serial.write( 16 + 128 );
   Serial.write(int(t_PTAT) & 0x7F);
  
  //Serial.print("\n");
  */
  
  delay(250);          
}


void makeCalculations()
{
  vMin = 1000;  // 100°C
  vMax = 0;     // 0°C
  vMean = 0.0;
  sum = 0;
  for(i=0; i<16; i++) {
    if(d6t.tP[i]>vMax)
      vMax = d6t.tP[i];
    if(d6t.tP[i]<vMin)
      vMin = d6t.tP[i];
    sum += d6t.tP[i];
  }
  vMean = (sum*1.0)/ 16;
}

void debugPrint()
{
  Serial.print("[ ");
  Serial.print(vMin); Serial.print("\t");
  Serial.print(vMax); Serial.print("\t");
  Serial.print(vMean);Serial.print(" ]");
  Serial.println();
}

// this function will send values to processing in form a 
// big, long string.
void sendToProcessing()
{
  // First print all the values indipendently
  //Serial.print("[");  
  for (i=0; i<16; i++) 
  {
    Serial.print(d6t.tP[i]); 
    Serial.print(",");  
  }
  //Serial.print("]"); 
  // now send min, max and mean
  //Serial.print(" ");
  //Serial.print(vMin); Serial.print(" - ");
  //Serial.print(vMax); Serial.print(" - ");
  //Serial.print(vMean); 
  Serial.print("\n");
}

