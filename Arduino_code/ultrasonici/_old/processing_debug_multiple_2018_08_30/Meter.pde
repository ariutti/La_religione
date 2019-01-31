class Meter 
{
  PVector pos;
  float w, h;
  boolean presence;
  
  // CONSTRUCTOR //////////////////////////////////////
  Meter(float _x, float _y, float _w, float _h)
  {
    pos = new PVector(_x, _y);
    w = _w;
    h = _h;
    presence = false;
  }
  
  // UPDATE /////////////////////////////////////////
  /*
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
  */
  
  void setPresence(int _p)
  {
    if(_p == 1)
      presence = true;
    else
      presence = false;
    
  }
  
  // DISPLAY ////////////////////////////////////////
  void display()
  //{
  //  pushMatrix();
  //  pushStyle();
  //  translate(pos.x, pos.y);
    
  //  if(presence)
  //  {
  //    fill(255, 0, 0);
  //    rect(0, 0, w, h);
  //    fill(0);
  //    text( distance, w/2, h/2);
  //  }
  //  else
  //  {
  //    fill(0);
  //    rect(0, 0, w, h);
  //    fill(255);
  //    text( distance, w/2, h/2);
  //  }
    
    
  //  popStyle();
  //  popMatrix();
  //}
  {
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y);
    stroke(255);
    
    if(presence)
    {
      fill(255, 0, 0);
      rect(0, 0, w, h);
    }
    else
    {
      fill(0);
      rect(0, 0, w, h);
    }
    
    popStyle();
    popMatrix();
  }
}
