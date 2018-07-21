class Meter 
{
  PVector pos;
  float w, h;
  float th;
  boolean presence;
  
  // CONSTRUCTOR //////////////////////////////////////
  Meter(float _x, float _y, float _w, float _h, int _th)
  {
    pos = new PVector(_x, _y);
    w = _w;
    h = _h;
    th = _th;
    presence = false;
  }
  
  void setThreshold(int _th)
  {
    th = _th;
  }
  
  // UPDATE /////////////////////////////////////////
  void update(int _distance)
  {
    distance = _distance;
    if(distance < th)
    {
      if(!presence) {
        presence = true;
        //sineOsc.patch( out );
      }
    }
    else
    {
      if(presence) {
        presence = false;
        //sineOsc.unpatch( out );
      }
    }
  }
  
  // DISPLAY ////////////////////////////////////////
  void display()
  {
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y);
    
    if(presence)
    {
      fill(255, 0, 0);
      rect(0, 0, w, h);
      fill(0);
      text( distance, w/2, h/2);
    }
    else
    {
      fill(0);
      rect(0, 0, w, h);
      fill(255);
      text( distance, w/2, h/2);
    }
    
    
    popStyle();
    popMatrix();
  }
}
