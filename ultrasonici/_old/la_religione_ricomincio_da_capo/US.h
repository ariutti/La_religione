#ifndef __US_H__
#define __US_H__
#include "Arduino.h"


class US 
{
  private:
    int id;
    unsigned long th;
    unsigned long distance;
    bool presence;

  public:
    US() {};
    ~US() {};
    void setId(int _id);
    void setTh(unsigned long _th);
    void update(unsigned long _distance);
    bool getState();
    unsigned long getDistance();
};

#endif
