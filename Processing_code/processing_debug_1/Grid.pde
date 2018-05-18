class Grid
{
  
  PVector UL;
  PVector offset;
  PVector pos; // used to place all the 16 squares
  float W, H, w, h;
  
  int[] brightness = new int[16];
  int[] values = new int[16];
  int ptat = 0;
  
  PFont f;
  
  boolean xFlip, yFlip;
  int tmin = 235;
  int tmax = 280;

  // CONTRUCTOR //////////////////////////////////////////
  Grid(int _x, int _y, float _w, float _h, boolean _xFlip, boolean _yFlip)
  {
    UL = new PVector(_x, _y);
    W = _w;
    H = _h;
    w = W/4;
    h = H/4;
    pos = new PVector(0, 0);
    xFlip = _xFlip;
    yFlip = _yFlip;
    
    for(int i=0; i<brightness.length; i++) {
      brightness[i] = 0;
      values[i] = 0;
    }
    
    f = loadFont("Courier-48.vlw");
    textFont(f, 32);
    
    offset = new PVector(w/2, h/2); 
  }
  
  // UPDATE //////////////////////////////////////////////
  void update(int[] _t)
  {
    for(int i=0; i<_t.length; i++) {
      values[i] = _t[i];
      brightness[i] = int( constrain( map(values[i], tmin, tmax, 0, 255), 0, 255 ) );
    }
  }
  
  
  // DISPLAY /////////////////////////////////////////////
  void display(int _maxId, int _minId) 
  {
    pushMatrix();
    pushStyle();
    
    for(int i=0; i<16; i++) 
    {
      
      if(i == _maxId)
      {
        strokeWeight(5);
        stroke(255,0,0);
        fill( brightness[i], 0, 0 );
        
      }
      else if(i == _minId)
      {
        strokeWeight(5);
        stroke(0,0,255);
        fill( 0, 0, brightness[i] );
      }
      else
      {
        strokeWeight(1);
        stroke(255);
        fill( brightness[i] );
      }
      
      if(xFlip)
        pos.x = W-w - (i%4)*w;
      else
        pos.x = (i%4)*w;
        
      if(yFlip)
        pos.y = H-h - (i/4)*h;
      else
        pos.y = (i/4)*h;
      
      rect(UL.x+pos.x, UL.y+pos.y, w, h);
      fill(255);
      textAlign(CENTER);
      text( int(values[i]), UL.x + pos.x + offset.x, UL.y + pos.y + offset.y);
    } 
    
    noStroke();
    stroke(ptat, 0, 0);
    strokeWeight(1);
    ellipse(UL.x+W/2, UL.y+H/2, w/2, h/2);
    fill(255, 0, 0);
    text( int(ptat), UL.x+W/2, UL.y+H/2);
    popStyle();
    popMatrix();
  }
  

}
