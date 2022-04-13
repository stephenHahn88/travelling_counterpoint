int cols, rows;
int scl = 200;
int w = 3000;
int h = 3000;
int crunchFactor = 10;
int jitterFactor = 3;

float[][] reactiveSphere;

void setupReactiveSphere() {
  cols = (w+scl*2) / scl;
  rows = (h+scl*2) / scl;
  reactiveSphere = new float[cols][rows];
}

// Based on Coding Train 
// https://www.youtube.com/watch?v=IKB1hWWedMk
void drawReactiveSphere() {
  int crunch;
  if (loopPlay) {
    crunch = calculateCrunch(currPlaying.startNotes[0], currPlaying.startNotes[1], currPlaying.startNotes[2]);
  } else {
    crunch = calculateCrunch(currPlaying.endNotes[0], currPlaying.endNotes[1], currPlaying.endNotes[2]);
  }
  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      reactiveSphere[x][y] = map(noise(xoff, yoff), 0, 1, 800 - rand.nextInt(jitterFactor)*crunch*crunchFactor, 1200 + rand.nextInt(jitterFactor)*crunch*crunchFactor);
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  stroke(100, 50, 0);
  noFill();
  
  //translate(width/2, height/2);
  //rotateX(PI/3);
  //translate(-w/2, -h/2);
  for (int y=0; y<rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x<cols; x++) {
      PVector sphericalCoord1 = cartesianToSpherical(x*scl, y*scl, reactiveSphere[x][y]);
      PVector sphericalCoord2 = cartesianToSpherical(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
      vertex(sphericalCoord1.x, sphericalCoord1.y, sphericalCoord1.z);
      vertex(sphericalCoord2.x, sphericalCoord2.y, sphericalCoord2.z);
      //vertex(x*scl, y*scl, reactiveSphere[x][y]);
      //vertex(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
    }
    endShape();
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x<cols; x++) {
      PVector sphericalCoord1 = cartesianToSpherical(-x*scl, -y*scl, reactiveSphere[x][y]);
      PVector sphericalCoord2 = cartesianToSpherical(-x*scl, -(y+1)*scl, reactiveSphere[x][y+1]);
      vertex(sphericalCoord1.x, sphericalCoord1.y, sphericalCoord1.z);
      vertex(sphericalCoord2.x, sphericalCoord2.y, sphericalCoord2.z);
      //vertex(x*scl, y*scl, reactiveSphere[x][y]);
      //vertex(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
    }
    endShape();
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x<cols; x++) {
      PVector sphericalCoord1 = cartesianToSpherical(x*scl, -y*scl, reactiveSphere[x][y]);
      PVector sphericalCoord2 = cartesianToSpherical(x*scl, -(y+1)*scl, reactiveSphere[x][y+1]);
      vertex(sphericalCoord1.x, sphericalCoord1.y, sphericalCoord1.z);
      vertex(sphericalCoord2.x, sphericalCoord2.y, sphericalCoord2.z);
      //vertex(x*scl, y*scl, reactiveSphere[x][y]);
      //vertex(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
    }
    endShape();
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x<cols; x++) {
      PVector sphericalCoord1 = cartesianToSpherical(-x*scl, y*scl, reactiveSphere[x][y]);
      PVector sphericalCoord2 = cartesianToSpherical(-x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
      vertex(sphericalCoord1.x, sphericalCoord1.y, sphericalCoord1.z);
      vertex(sphericalCoord2.x, sphericalCoord2.y, sphericalCoord2.z);
      //vertex(x*scl, y*scl, reactiveSphere[x][y]);
      //vertex(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
    }
    endShape();
  }
}

//void makeSphereSection(boolean xPos, boolean yPos, int x, int, y) {
//  int signx, signy;
//  if (xPos) {
//    signx = 1;
//  } else {
//    signx = -1;
//  }
//  if (yPos) {
//    signy = 1;
//  } else {
//    signy = -1;
//  }
//  beginShape(TRIANGLE_STRIP);
//    for (int x = 0; x<cols; x++) {
//      PVector sphericalCoord1 = cartesianToSpherical(signx*x*scl, signy*y*scl, reactiveSphere[x][y]);
//      PVector sphericalCoord2 = cartesianToSpherical(signx*x*scl, signy*(y+1)*scl, reactiveSphere[x][y+1]);
//      vertex(sphericalCoord1.x, sphericalCoord1.y, sphericalCoord1.z);
//      vertex(sphericalCoord2.x, sphericalCoord2.y, sphericalCoord2.z);
//      //vertex(x*scl, y*scl, reactiveSphere[x][y]);
//      //vertex(x*scl, (y+1)*scl, reactiveSphere[x][y+1]);
//    }
//    endShape();
//}
