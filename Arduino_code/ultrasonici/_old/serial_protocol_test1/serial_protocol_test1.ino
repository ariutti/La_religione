String temp; // used to share messages between VVVV and Arduino

#define NSENSORS 8

// array of all booleans presences
struct US 
{
  int id;
  unsigned long th;
  unsigned long distance;
  bool presence;
} us[NSENSORS];

unsigned long th = 150;
unsigned long distance = 0;

bool bSendSerial = false;
bool bDebugMode = false;


// SETUP ////////////////////////////////////////////////////
void setup() 
{
  // setup serial comm
  Serial.begin(9600);

  for(int i=0; i<NSENSORS; i++)
  {
    us[i].id = i;
    us[i].th = th;
  }

}


// LOOP /////////////////////////////////////////////////////
void loop() 
{
  getSerialData();

  // this function will be replaced by the 
  // "read-from-the-sensors" routine
  generateRandomDistances();

  calculatePresences();
  if(bSendSerial){ sendAllPresences(); }

  delay(1000);

}


// SERIAL DATA //////////////////////////////////////////////
void getSerialData()
{
  while (Serial.available() > 0)
  {
    char c = Serial.read();
    // the message from VVVV is finished
    if (c == ';')
    {
      if( temp[0]=='S') {
        // this is a "SET TH" msg
        char delimiter = temp[2]; // should be ','
        int from = 3;
        //int to = temp.length();
        int th = (temp.substring(from)).toInt();

        // 0 is 48 in ASCII
        // 7 is 55 in ASCII
        // (http://www.asciitable.com/)
        char index = temp[1]-48;
        
        if( index>=0 && index<NSENSORS && delimiter==',')
        {
          // this is a valid message
          us[index].th = th;
        }
      } else if( temp[0]=='A') {
        // this is a "SET TH FOR ALL" msg

        char delimiter = temp[1]; // should be ','
        int from = 2;
        int th = (temp.substring(from)).toInt();

        if( delimiter==',')
        {
          for(int i=0; i<NSENSORS; i++) 
          {
            us[i].th = th;
          }
        }
               
      } else if( temp[0]=='D') {
        // this is a "SET DEBUG MODE" msg
        bSendSerial = true;
        bDebugMode = true;
      } else if( temp[0]=='P') {
        // this is a "SET PRESENCE MODE" msg
        bSendSerial = true;
        bDebugMode = false;
      } else if( temp[0]=='1') {
        // this is a "SERIAL COMM ON" msg
        bSendSerial = true;
      } else if( temp[0]=='0') {
        // this is a "SERIAL COMM OFF" msg
        bSendSerial = false;
      }
      temp = "";
    }
    else
    {
      // if the message from VVVV is not finished yet,
      // append character to 'temp' string
      temp += c;
    }
  }
}

void generateRandomDistances() 
{
  for(int i=0; i<NSENSORS; i++)
  {
    us[i].distance = random(10, 400);
  }
}


// CALCULATE PRESENCES ///////////////////////////
void calculatePresences()
{
  for(int i=0; i<NSENSORS; i++)
  {
    if(us[i].distance < us[i].th)
    {
      if(!us[i].presence) {
        us[i].presence = true;
      }
    }
    else
    {
      if(us[i].presence) {
        us[i].presence = false;
      }
    }
  }
}


// SEND ALL PRESENCES ////////////////////////////
void sendAllPresences()
{
  for(int i=0; i<NSENSORS; i++)
  {
    if( bDebugMode )
    {
      //Serial.print( us[i].id );
      Serial.print( us[i].distance );
      Serial.print( ',' );
      Serial.print( us[i].th );
      Serial.print( ',' );
      Serial.print( us[i].presence );
      if(i!=NSENSORS-1) {Serial.print( ',' ); }
    }
    else
    {
      Serial.print( us[i].presence );
    }
  }
  Serial.println(";");
}

