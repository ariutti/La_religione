#define PIR 2
#define LED 13

unsigned long on_start_t = 0;
unsigned long on_end_t = 0;
unsigned long off_start_t = 0;
unsigned long off_end_t = 0;

bool currValue = false;
bool prevValue = false;


// SETUP ////////////////////////////////////////
void setup() 
{
  Serial.begin(9600);
  pinMode(PIR,INPUT);
  pinMode(LED, OUTPUT);
  digitalWrite(LED,LOW);
}


// LOOP /////////////////////////////////////////
void loop() 
{
  currValue = digitalRead(PIR);

  
  if(currValue != prevValue )
  {
    
    if(currValue)
    {
      on_start_t = off_end_t = millis();
      Serial.print("time OFF: ");
      Serial.println(off_end_t - off_start_t);
      digitalWrite(LED,HIGH);
    }
    else
    {
      on_end_t = off_start_t = millis();
      Serial.print("\ntime ON: ");
      Serial.println(on_end_t - on_start_t);
      digitalWrite(LED,LOW);
    }
    prevValue = currValue;
  }
  delay(10);
}
