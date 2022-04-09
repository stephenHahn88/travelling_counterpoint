void drawStartSphere(ContrapuntalMotion startCM) {
  if (currCM == CoordinateMode.CARTESIAN) {
    drawSphere(startCM.start.x, startCM.start.y, startCM.start.z, GRID_SPACE / 4);
  } else {
    PVector starts = cartesianToSpherical(startCM.start.x, startCM.start.y, startCM.start.z);
    drawSphere(starts.x, starts.y, starts.z, GRID_SPACE / 4);
  }
  
}

void drawCounterpoint() {
  switch (currCM) {
    case CARTESIAN:
      for (ContrapuntalMotion cm : contrapuntalMotions) {
        stroke(cm.duration.r, cm.duration.g, cm.duration.b);
        line(cm.start.x, cm.start.y, cm.start.z, cm.end.x, cm.end.y, cm.end.z);
        stroke(255);
        drawSphere(cm.end.x, cm.end.y, cm.end.z, GRID_SPACE / 8);
      }
      break;
    case SPHERICAL:
      for (ContrapuntalMotion cm : contrapuntalMotionsSphere) {
        stroke(cm.duration.r, cm.duration.g, cm.duration.b);
        line(cm.start.x, cm.start.y, cm.start.z, cm.end.x, cm.end.y, cm.end.z);
        stroke(255);
        drawSphere(cm.end.x, cm.end.y, cm.end.z, GRID_SPACE / 8);
      }
      break;
    default:
      break;
  }
}

void drawSphere(float tx, float ty, float tz, float r) {
  translate(tx, ty, tz);
  PShape sphere = createShape(SPHERE, r);
  //if (cam.isAvailable()) {
  //  sphere.setTexture(cam);
  //}
  shape(sphere);
  //sphere(r);
  translate(-tx, -ty, -tz);
}

void drawGrid() {
  for (int i = -NUM_GRID_LINES; i<=NUM_GRID_LINES; i++) {
      float strokeValue = 255 / (abs(i)+2) + 1;
      stroke(strokeValue, 0, 0);
      line( 0, NUM_GRID_LINES*GRID_SPACE, GRID_SPACE*i, 0, -NUM_GRID_LINES*GRID_SPACE, GRID_SPACE*i );
      line( 0, -GRID_SPACE*i, -NUM_GRID_LINES*GRID_SPACE, 0, -GRID_SPACE*i, NUM_GRID_LINES*GRID_SPACE );
      stroke(0, strokeValue, 0);
      line( -NUM_GRID_LINES*GRID_SPACE, -GRID_SPACE*i, 0, NUM_GRID_LINES*GRID_SPACE, -GRID_SPACE*i, 0 );
      line( GRID_SPACE*i, NUM_GRID_LINES*GRID_SPACE, 0, GRID_SPACE*i, -NUM_GRID_LINES*GRID_SPACE, 0  );
      stroke(0, 0, strokeValue);
      line( -NUM_GRID_LINES*GRID_SPACE, 0, GRID_SPACE*i,  NUM_GRID_LINES*GRID_SPACE, 0, GRID_SPACE*i );
      line( GRID_SPACE*i, 0, -NUM_GRID_LINES*GRID_SPACE,  GRID_SPACE*i, 0, NUM_GRID_LINES*GRID_SPACE  );
    }
}
