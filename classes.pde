class Color {
  int r;
  int g;
  int b;
  
  Color(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

class Coordinate {
  float x;
  float y;
  float z;
  
  Coordinate(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class ContrapuntalMotion {
  Coordinate start;
  Coordinate end;
  
  int[] startNotes = new int[3];
  int[] endNotes = new int[3];
  
  Duration duration;
  
  ContrapuntalMotion(Coordinate start, Coordinate end, Duration duration, int[] startNotes, int[] endNotes) {
    this.start = start;
    this.end = end;
    this.duration = duration;
    
    this.startNotes = startNotes;
    this.endNotes = endNotes;
  }
  
  ContrapuntalMotion() {
    this.start = new Coordinate(0,0,0);
    this.end = new Coordinate(0,0,0);
    this.duration = Duration.Q;
    
    this.startNotes = new int[] {60, 60, 60};
    this.endNotes = new int[] {60, 60, 60};
  }
  
  ContrapuntalMotion(int[] startNotes, int[] endNotes, Duration duration) {
    this.startNotes = startNotes;
    this.endNotes = endNotes;
    this.duration = duration;
    
    this.start = coordFromNotes(startNotes);
    this.end = coordFromNotes(endNotes);
  }
  
  void toSpherical() {
    PVector starts = cartesianToSpherical(this.start.x, this.start.y, this.start.z);
    PVector ends = cartesianToSpherical(this.end.x, this.end.y, this.end.z);
    this.start = new Coordinate(starts.x, starts.y, starts.z);
    this.end = new Coordinate(ends.x, ends.y, ends.z);
  }
  
  void update(int[] startNotes, int[] endNotes, Duration newDur) {
    this.startNotes = startNotes;
    this.endNotes = endNotes;
    
    int bc = (CENTER_NOTE - startNotes[0]) * GRID_SPACE;
    int ac = (CENTER_NOTE - startNotes[1]) * GRID_SPACE;
    int sc = (CENTER_NOTE - startNotes[2]) * GRID_SPACE;
    this.start = new Coordinate(bc, ac, sc);
    
    int bassCoord = (CENTER_NOTE - endNotes[0]) * GRID_SPACE;
    int altoCoord = (CENTER_NOTE - endNotes[1]) * GRID_SPACE;
    int sopCoord = (CENTER_NOTE - endNotes[2]) * GRID_SPACE;
    this.end = new Coordinate(bassCoord, altoCoord, sopCoord);
    
    this.duration = newDur;
  }
  
  void update(ContrapuntalMotion cm) {
    this.start = cm.start;
    this.end = cm.end;
    this.startNotes = cm.startNotes;
    this.endNotes = cm.endNotes;
    this.duration = cm.duration;
  }
}

class Swirl {
  Coordinate currPosition;
  int radius;
  float frequency;
  float angle;
  float speed;
  PVector[][] globe;
  int total;
  
  Swirl(Coordinate startPos, int startR) {
    this.currPosition = startPos;
    this.radius = startR;
    this.angle = 0;
    this.speed = 0.003;
    this.total = 8;
    this.globe = new PVector[total+1][total+1];
  }
  
  //void drawNowOld() {
  //  for (float i=0; i < 10; i++) {
  //    pushMatrix();
  //      translate(this.currPosition.x, this.currPosition.y, this.currPosition.z);
  //      rotateX(TWO_PI*i / 10);
  //      rotateY(TWO_PI*i / 10);
  //      rotateZ(TWO_PI*i / 10);
  //      for (float a = 0; a < 5; a++) {
  //        translate(this.radius/2, 0, 0);
  //        rotateX(this.angle);
  //        rotateY(this.angle);
  //        rotateZ(this.angle);
  //        stroke(255, i*20, a*40);
  //        sphere(0.5);
  //        this.angle += this.speed;
  //      }
  //    popMatrix();
  //  }
  //}
  
  void drawNow() {
    int crunch;
    if (loopPlay) {
      crunch = calculateCrunch(currPlaying.startNotes[0], currPlaying.startNotes[1], currPlaying.startNotes[2]);
    } else {
      crunch = calculateCrunch(currPlaying.endNotes[0], currPlaying.endNotes[1], currPlaying.endNotes[2]);
    }
    translate(this.currPosition.x, this.currPosition.y, this.currPosition.z);
    for (int i = 0; i < total+1; i++) {
      float lat = map(i, 0, this.total, 0, PI);
      for (int j = 0; j < this.total+1; j++) {
        float lon = map(j, 0, this.total, 0, TWO_PI);
        float x = this.radius * sin(lat) * cos(lon) + (crunch * (float)Math.random() * 10);
        float y = this.radius * sin(lat) * sin(lon) + (crunch * (float)Math.random() * 10);
        float z = this.radius * cos(lat) + (crunch * (float)Math.random() * 10);
        this.globe[i][j] = new PVector(x,y,z);
      }
    }
    for (int i = 0; i<this.total; i++) {
      for (int j = 0; j < this.total; j++) {
        stroke(255/crunch + 40, i*40/crunch + 40, j*40/crunch + 40);
        drawSphere(globe[i][j].x, globe[i][j].y, globe[i][j].z, 0.2);
        rotateX(this.angle/5);
      }
      rotateX(this.angle);
      rotateY(this.angle);
      rotateZ(this.angle);
      this.angle += this.speed;
    }
  }
}
