#define US 2
unsigned long duration; //usecs
float distance = 0.0;

float A = 0.1;
float B;

void setup()
{
  Serial.begin(9600);
  pinMode(US, OUTPUT);
  digitalWrite(US, LOW);
  B = 1.0 - A;
  
}

void loop()
{
  pinMode(US, OUTPUT);
  // The US triggered by a HIGH pulse of 10 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  digitalWrite(US, LOW);
  delayMicroseconds(2);
  digitalWrite(US, HIGH);
  delayMicroseconds(10);
  digitalWrite(US, LOW);

  // The same pin is used to read the signal from the US, a HIGH pulse
  // whose duration is the time (in microseconds) from the sending of the ping
  // to the reception of its echo off of an object.
  pinMode(US, INPUT);
  duration = pulseInLong(US, HIGH, 38000);
  distance = (duration/58.0) * A + distance * B;
  
  Serial.println(distance);
  delay(100);
}

