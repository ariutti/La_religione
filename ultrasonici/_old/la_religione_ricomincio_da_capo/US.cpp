#include "US.h"

void US::setId(int _id)
{
  id = _id;
}

void US::setTh(unsigned long _th)
{
  th = _th;
}

void US::update(unsigned long _distance)
{
  distance = _distance;
  if(distance < th)
  {
    if(!presence) {
      presence = true;
    }
  }
  else
  {
    if(presence) {
      presence = false;
    }
  }
}


bool US::getState()
{
  return presence;
}

unsigned long US::getDistance()
{
  return distance;
}

