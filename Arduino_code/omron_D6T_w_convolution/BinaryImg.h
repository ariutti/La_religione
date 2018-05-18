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

