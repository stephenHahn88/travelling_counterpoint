import ddf.minim.Minim;
import ddf.minim.AudioPlayer;

import peasy.*;

import java.util.Random;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Arrays;
import java.util.PriorityQueue;
import java.lang.Math;
import processing.sound.*;
import processing.video.*;

int NUM_GRID_LINES = 30;
int GRID_SPACE = 30;
int MAX_SPACE = NUM_GRID_LINES * GRID_SPACE;
int CENTER_NOTE = 60; //Uses midi pitch numbers (60 is middle C)
int[] ORIGINAL_VOICE_NOTES = {57,60,64};
int TEMPO = 88; //In quarters per minute

Minim minim;
AudioPlayer[] notes = new AudioPlayer[73];

PeasyCam cam;

Voice currVoice = Voice.BASS;
Duration currDuration = Duration.Q;
int durationIdx = 6;
int[] currVoiceNotes = {ORIGINAL_VOICE_NOTES[0], ORIGINAL_VOICE_NOTES[1], ORIGINAL_VOICE_NOTES[2]}; // Bass, alto, soprano
ArrayList<ContrapuntalMotion> contrapuntalMotions = new ArrayList<>();
ArrayList<ContrapuntalMotion> contrapuntalMotionsSphere = new ArrayList<>();
Random rand = new Random();

boolean evolving = false;
boolean loopPlay = false;
boolean gridOn = true;
CoordinateMode currCM = CoordinateMode.CARTESIAN;
ContrapuntalMotion currPlaying = new ContrapuntalMotion();

Swirl swirl = new Swirl(new Coordinate(0,0,0), 20);

void setup() {
  size(1000, 1000, P3D);
  stroke(255);
  strokeWeight(2);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  minim = new Minim(this);
  for (int i=0; i < notes.length; i++) {
    notes[i] = minim.loadFile((i+21) + ".mp3");
  }
  //String[] cameras = Capture.list();
  //if (cameras.length == 0) {
  //  println("No cameras available");
  //  exit();
  //} else {
  //  for (int i=0; i < cameras.length; i++) {
  //    println(cameras[i]);
  //  }
  //  cam = new Capture(this, cameras[0]);
  //  cam.start();
  //}
  
  //bach_aof();
  try {
    midiToContrapuntalMotions("C:\\Users\\sh597\\Desktop\\travelling_counterpoint\\data\\bach_bm_excerpt.txt");
    midiToContrapuntalMotions("C:\\Users\\sh597\\Desktop\\travelling_counterpoint\\data\\test.txt");
    //midiToContrapuntalMotions("C:\\Users\\sh597\\Desktop\\travelling_counterpoint\\data\\bach_dsharpm_excerpt.txt");
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void captureEvent(Capture cam) {
  cam.read();
}

void draw() {
  background(0);
  translate(width/2, height/2, 0);
  //rotateY(map(mouseX, 0, width, -PI, PI));
  //rotateX(map(mouseY, 0, height, -PI, PI));
  //translate(-100,100,-100);
  stroke(255);
  sphere(GRID_SPACE / 2);
  strokeWeight(2);
  if (gridOn) {drawGrid();}
  strokeWeight(4);
  if (!contrapuntalMotions.isEmpty()) {
    ContrapuntalMotion startCM = contrapuntalMotions.get(0);
    stroke(255);
    drawStartSphere(startCM);
  }
  drawCounterpoint();
  stroke(255);
  if (!contrapuntalMotions.isEmpty()){
    swirl.drawNow();
  }
  
}
