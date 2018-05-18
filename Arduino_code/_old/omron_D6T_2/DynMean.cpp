#include "DynMean.h"


DynMean::DynMean()
{
	delta = 0.0;
	antibiasedMean = 0;
}


float DynMean::getValue(float vMin, float vMax, float vMean)
{
	delta = vMax - vMin;
	antibiasedMean = vMean - vMin;
	return sqrt(antibiasedMean / delta)*100;
}
