import processing.serial.*;
Serial myPort;

int L;

int[] brightness = new int[16];
int ptat = 0;
int pixelAddr = 0;
PVector pos;
PVector offset;

PFont f;

boolean xFlip = true;
boolean yFlip = true;
int tmin = 18;
int tmax = 30;


// SETUP ////////////////////////////////
void setup()
{
  size(800, 800);
  L = width / 4;
  smooth();
  
  // serial stuff
  //printArray(Serial.list());
  String port = Serial.list()[3];
  myPort = new Serial(this, port, 9600);
  
  for(int i=0; i<brightness.length; i++)
  {
    brightness[i] = int(random(255));
  }
  
  f = loadFont("Courier-48.vlw");
  textFont(f, 32);
  pos = new PVector(0, 0);
  offset = new PVector(L/2, L/2);  
}

// DRAW /////////////////////////////////
void draw()
{
  background(0);
  stroke(255);

  for(int i=0; i<16; i++)
  {
    int v = int( constrain( map(brightness[i], tmin, tmax, 0, 255), 0, 255 ) );
    fill( v );
    if(xFlip)
      pos.x = width-L - (i%4)*L;
    else
      pos.x = (i%4)*L;
    if(yFlip)
      pos.y = height-L - (i/4)*L;
    else
      pos.y = (i/4)*L;
    
    rect(pos.x, pos.y, L, L);
    fill(255);
    textAlign(CENTER);
    text( int(brightness[i]), pos.x + offset.x, pos.y + offset.y);
  } 
  
  
  noStroke();
  stroke(ptat, 0, 0);
  ellipse(width/2, height/2, L/2, L/2);
  fill(255, 0, 0);
  text( int(ptat), width/2, height/2);
  
}


// SERIAL EVENT /////////////////////////////////
void serialEvent(Serial s)
{
  int b = s.read();
  if (b >= 128 )
  {
    // a "status" byte
    pixelAddr = (b & 0x7F);  // 0111 1111
  }
  else
  {
    // check it the temperature is the base temperature
    if( pixelAddr == 16) 
    {
      ptat = b;
    }
    else
    {
      brightness[ pixelAddr ] = b;
    }
  }
}
