// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
// Example 15-13: Sharpen with convolution

PImage img;
int w = 80;

// create a custom convolution matrix
float a = 50;
float c = -1*(a/9.0);
// It's possible to perform a convolution
// the image with different matrices
// float[][] matrix = { { -1, -1, -1 }, { -1, 9, -1 }, { -1, -1, -1 } } ;    
float[][] matrix = { { c, c, c } , // The convolution matrix for a “sharpen” effect stored as a 3 x 3 two-dimensional array.
                     { c, a, c } ,
                     { c, c, c } } ;



void setup() 
{
  size(500,500);
  img = loadImage( "leonardo-ethernet-500x500.jpg" );
}



void draw() 
{
  // We're only going to process a portion of the image
  // so let's set the whole image as the background first
  image(img,0,0);
  // Where is the small rectangle we will process
  int xstart = constrain(mouseX-w/2,0,img.width); // In this example we are only processing a section of the image-an 80 x 80 rectangle around the mouse location.
  int ystart = constrain(mouseY-w/2,0,img.height);
  int xend = constrain(mouseX + w/2,0,img.width);
  int yend = constrain(mouseY + w/2,0,img.height);
  int matrixsize = 3;
  loadPixels();
  // Begin our loop for every pixel
  for (int x = xstart; x < xend; x++ ) {
    for (int y = ystart; y < yend; y++ ) {
      color c = convolution(x,y,matrix,matrixsize,img); //   Each pixel location (x,y) gets passed into a function called convolution( ) which returns a new color value to be displayed.
      int loc = x + y*img.width;
      pixels[loc] = c;
    }
  }
  updatePixels();
  stroke(0);
  noFill();
  rect(xstart,ystart,w,w);
}


color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {
      // What pixel are we testing
      int xloc = x + i-offset;
      int yloc = y + j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off the edge of the pixel array
      // It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  // Return the resulting color
  return color(rtotal,gtotal,btotal); // After the sums are constrained within a range of 0–255, a new color is made and returned.
}
