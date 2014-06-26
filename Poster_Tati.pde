//   TIFF Poster Generation Example
//   Tomas Laurenzo
//   http://laurenzo.net
//   tomas@laurenzo.net

// This sketch writes everything onto a PGraphics object, shows it on screen, and then saves it
// timestamped.

// Resulting TIFF File is standard poster size. 

PImage img;
PGraphics pg;

PVector [] noisyPoints;
int TOTAL = 300;

int WIDTH = 4724;
int HEIGHT = 5906;

void setup() {
  
  size(400, 500, P3D);  // on screen size
  
  pg = createGraphics(WIDTH, HEIGHT, P3D);   // print size 
  
  
  smooth(4);  // antialiasing optional. Delete this for no antialiasing.
  noLoop(); // We only need to run draw() once.
  
   noisyPoints = new PVector[TOTAL];
   float nx, ny, nz;
   nx = 0;
   ny = 100;
   nz = 200;
   float nSpeed = 0.1;
   float vel = 800;
   
   noisyPoints[0] = new PVector(WIDTH/2, HEIGHT/2, 0);
   
   for(int i = 1; i < TOTAL; i++) {
     noisyPoints[i] = new PVector();
     noisyPoints [i].x = noisyPoints[i-1].x + vel * noise (nx) - (vel/2);
     noisyPoints [i].y = noisyPoints[i-1].y + vel * noise (ny) - (vel/2);
     noisyPoints [i].z = noisyPoints[i-1].z + vel * noise (nz) - (vel/2);
     
     PVector center = new PVector (WIDTH/2, HEIGHT/2, 0);
     attract (noisyPoints[i], center);     
     
     nx += nSpeed;
     ny += nSpeed;
     nz += nSpeed;
   }
   
    pg.ellipseMode(CENTER);
    pg.rectMode(CENTER);
}



void attract (PVector v, PVector c) {
  PVector vel = new PVector();
  vel.set(c);
  vel.sub(v);
  vel.mult(0.07); // james bond
  v.add(vel);
  
}

void doBackground(){
 
  int hop = 150;
  pg.stroke(255);
  pg.fill(255);
  for (int i = hop/2; i < WIDTH; i+=hop) {
    for (int j = hop/2; j < HEIGHT; j+=hop) {
      
      pg.rect (i, j, 20, 20);
      
    }
  }
  
  pg.filter(BLUR, 2);
  
  pg.strokeWeight(20);
  pg.stroke(255);
  pg.pushMatrix();
  pg.translate(0, 0, 1);
  pg.fill(0);  
  pg.ellipse(WIDTH/2, HEIGHT/2, 3500, 3500);
  pg.popMatrix();
}

void doRender() {
   pg.fill(255,255,255,50);
  
  pg.stroke(255,255,255,120); 
  pg.strokeWeight(20);
  
  for (int i = 0; i < TOTAL; i++) {
    pg.pushMatrix();
    pg.translate (noisyPoints[i].x, noisyPoints[i].y, noisyPoints[i].z);
    pg.sphere(200);  
    pg.popMatrix();
  }
  
  pg.strokeWeight(5);
  pg.stroke(255,255,255,50);  

for (int h = 0; h < 6; h++) {
  for (int i = 0; i < TOTAL; i++) {
    float p = random (0, TOTAL-1);
    int n = (int)p;
    pg.line (noisyPoints[i].x, noisyPoints[i].y, noisyPoints[i].z, noisyPoints[n].x, noisyPoints[n].y, noisyPoints[n].z);
  }
}
 
}

void bezierLines(){
  
  pg.stroke(0,0, 0, 150);
  pg.strokeWeight(20);
  pg.noFill();
  
  pg.beginShape();
  //pg.vertex(noisyPoints[0].x, noisyPoints[0].y, noisyPoints[0].z);

    for (int i = 0; i < TOTAL; i++) {
      
      pg.curveVertex(noisyPoints[i].x, noisyPoints[i].y, noisyPoints[i].z);
  }
  
  pg.endShape();

}

void draw() {
  
  // we start writing onto the PGraphics object
  // in this example we write a red circle and some random lines  
  
  pg.beginDraw();
  pg.background(0);
  
  pg.sphereDetail(50);
  
  doBackground();
  
  doRender();
  //bezierLines();
 
 /*
  pg.pushMatrix(); 
  pg.rotateZ(radians(180));
  doRender();
  pg.popMatrix();
  
  */
  
  pg.pushMatrix();
  pg.stroke(255,0,0,255);
  pg.translate(0,0,520);
  
  //bezierLines();
  
  pg.popMatrix();
  
  pg.strokeWeight(20);
  pg.stroke(255);
  pg.fill(0,0,0,0);
  
  pg.ellipse(WIDTH/2, HEIGHT/2, 3500, 3500);
  
  
  pg.endDraw();
  
  
  
  // finished writing to the PGraphics object 


  image (pg, 0, 0, 400, 500); // show the result on screen 
 
  // save the 
  PImage output = pg.get();  
  saveTimestamped(output);
}


// saves the image with a timestamped filename
void saveTimestamped(PImage im) {
  int s = second();  // Values from 0 - 59
  int mi = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  
  String filename = y+"-"+m+"-"+d+"-"+h+"-"+mi+"-"+s+".tiff";
   im.save(filename); 
  
} 
