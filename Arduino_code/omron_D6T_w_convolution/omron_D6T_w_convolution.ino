#include "D6T44L.h"
#include "BinaryImg.h"

int i = 0; // utility variable
int *tpRef;
int* conv;

D6T44L d6t;
BinaryImg binaryImg;


// SETUP /////////////////////////////////////////////////
void setup()
{
  d6t.init();
  binaryImg.init( 300, d6t.getTpRef() );
  
  tpRef = d6t.getTpRef();
  conv  = binaryImg.getConvRef();
  
  Serial.begin(9600);

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}


// LOOP //////////////////////////////////////////////////
void loop()
{
  if(d6t.read() > 0) {
    //sendRawToProcessing();
    binaryImg.update();
    //sendBinaryToProcessing();
    // To be used w/ "Processing_debug_sound" sketch
    Serial.println( binaryImg.getValue() );
  }
  delay(250);          
}

// this function will send values to processing 
// as a big, long string.
// To be used w/ "Processing_debug_1" sketch
void sendRawToProcessing()
{
  // First print all the values indipendently;  
  for (i=0; i<16; i++) {
    Serial.print(tpRef[i]); 
    Serial.print(",");  
  }
  Serial.print("\n");
}

// To be used w/ "Processing_debug_1" sketch
void sendBinaryToProcessing()
{
  // First print all the values indipendently 
  for (i=0; i<16; i++) {
    Serial.print(conv[i]); 
    Serial.print(",");  
  }
  Serial.print("\n");
}

