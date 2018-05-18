/*
*  The "Moving Avg" class
* Created by Nicola Ariutti, May 03, 2018
* TODO: license
*/

#ifndef _DYNAMIC_MEAN
#define _DYNAMIC_MEAN

#include "Arduino.h"


class DynMean
{
public:
	DynMean();
	float getValue(float vMin, float vMax, float vMean);

private:
	float delta;
	float antibiasedMean;
};
#endif
