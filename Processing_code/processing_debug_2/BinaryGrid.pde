class BinaryGrid
{
  PVector UL;
  PVector offset;
  PVector pos; // used to place all the 16 squares
  float W, H, w, h;

  boolean[] status = new boolean[16];
  int[] values = new int[16];

  boolean xFlip, yFlip;
  int th;



										// left

  int[][] mask = {{0, 1, 1, 1},
                  {1, 1, 1, 1},
  		/*top*/     {1, 1, 1, 1},				// bottom
                  {1, 1, 1, 1}};

										// right

  // CONTRUCTOR //////////////////////////////////////////
  BinaryGrid(int _x, int _y, float _w, float _h, int _th, boolean _xFlip, boolean _yFlip)
  {
    UL = new PVector(_x, _y);
    W = _w;
    H = _h;
    w = W/4;
    h = H/4;
    pos = new PVector(0, 0);
    xFlip = _xFlip;
    yFlip = _yFlip;
    th = _th;

    for(int i=0; i<status.length; i++) {
      status[i] = false;
      values[i] = 0;
    }

    offset = new PVector(w/2, h/2);
  }

  // UPDATE //////////////////////////////////////////////
  void update(int[] _t)
  {
    for(int i=0; i<_t.length; i++) {
      values[i] = _t[i];
      if( _t[i] > th ) {
        status[i] = true;
      }
      else
      {
        status[i] = false;
      }
    }
    applyMask();
  }

  // APPLY MASK //////////////////////////////////////////
  void applyMask()
  {
    for(int x=0; x<4; x++) {
      for(int y=0; y<4; y++) {
        int pos = x + 4*y;
        if(mask[x][y] == 0)
          status[pos] = false;
      }
    }
  }


  // IS SOMEBODY HERE ////////////////////////////////////
  boolean isSomebodyHere()
  {
    for(int x=0; x<4; x++) {
      for(int y=0; y<4; y++) {
        int pos = x + 4*y;
        if(status[pos])
          return true;
      }
    }
    return false;
  }


  // DISPLAY /////////////////////////////////////////////
  void display()
  {
    pushMatrix();
    pushStyle();

    strokeWeight(1);
    stroke(255);

    for(int i=0; i<16; i++)
    {
      if(status[i]) {
        fill( 255 );
      }
      else {
        fill( 0 );
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

      textAlign(CENTER);
      if(status[i]) {
        fill( 0 );
        text( int(values[i]), UL.x + pos.x + offset.x, UL.y + pos.y + offset.y);
      }
      else {
        fill( 255 );
        text( int(values[i]), UL.x + pos.x + offset.x, UL.y + pos.y + offset.y);
      }
    }

    /*
    noStroke();
    stroke(ptat, 0, 0);
    strokeWeight(1);
    ellipse(UL.x+W/2, UL.y+H/2, w/2, h/2);
    fill(255, 0, 0);
    text( int(ptat), UL.x+W/2, UL.y+H/2);
    */
    popStyle();
    popMatrix();
  }


}
