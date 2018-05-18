#include "MovingAvg.h"


MovingAvg::MovingAvg()
{
	for (int i=0; i<WINDOW_SIZE; i++)
	{
		window[i] = 0.0;
	}
	index = 0;
	sum = 0.0;
	avg = 0.0;
}


void MovingAvg::setValue(float newValue)
{
	//Serial.print("index: "); Serial.println(index);
	//Serial.print("new value"); Serial.println(newValue);
	sum -= window[index];
	window[index] = newValue;
	sum += window[index];
	avg = sum / WINDOW_SIZE;
	//Serial.print("sum: "); Serial.println(sum);
	//Serial.print("avg: "); Serial.println(avg);
	//Serial.println();
	index = (index+1) % WINDOW_SIZE;
}


float MovingAvg::getAvg()
{
	return avg;
}
