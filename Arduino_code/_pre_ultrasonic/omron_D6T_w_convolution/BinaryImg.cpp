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


