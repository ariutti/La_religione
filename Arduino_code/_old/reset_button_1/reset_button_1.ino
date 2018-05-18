#define PUSH 2
bool resetted = false;

void setup() 
{
  Serial.begin(9600);
  pinMode(PUSH, INPUT);
  
}

void loop() 
{
  bool v = digitalRead(PUSH);
  
  if(!v)
  {
    if( !resetted )
    {
      Serial.println("get MIN and MAX reset");
      resetted = true;
    }
    else
    {
      Serial.println("already resetted");
    }
  }
  else 
  {
    if( resetted )
    {
      Serial.println("release");
      resetted = false;
    }
    else
    {
      Serial.println("already released");
    }
  }
  
  delay(100);
}
