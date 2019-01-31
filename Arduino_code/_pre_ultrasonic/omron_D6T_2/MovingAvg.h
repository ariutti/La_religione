/*
*  The "Moving Avg" class
* Created by Nicola Ariutti, May 03, 2018
* TODO: license
*/

#ifndef _MOVING_AVG
#define _MOVING_AVG

#include "Arduino.h"
#define WINDOW_SIZE 5


class MovingAvg
{
public:
	MovingAvg();
	void setValue(float v);
  float getAvg();

private:
	uint8_t index;
  float window[WINDOW_SIZE];
	float sum;
	float avg;
};
#endif
