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

int NUM_GRID_LINES = 58;
int GRID_SPACE = 30;
int MAX_SPACE = NUM_GRID_LINES * GRID_SPACE;
int CENTER_NOTE = 60; //Uses midi pitch numbers (60 is middle C)
int[] ORIGINAL_VOICE_NOTES = {57,60,64};
int TEMPO = 88; //In quarters per minute
int EVOLVE_TIME = 1000;

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
boolean reactiveSphereOn = false;
CoordinateMode currCM = CoordinateMode.CARTESIAN;
ContrapuntalMotion currPlaying = new ContrapuntalMotion();

Swirl swirl = new Swirl(new Coordinate(0,0,0), 20);

void setup() {
  size(1800, 1000, P3D);
  stroke(255);
  strokeWeight(2);
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  
  minim = new Minim(this);
  for (int i=0; i < notes.length; i++) {
    notes[i] = minim.loadFile((i+21) + ".mp3");
  }
  
  try {
    String path = "C:\\Users\\sh597\\Desktop\\Git Projects";
    midiToContrapuntalMotions(path + "\\travelling_counterpoint\\data\\bach_bm_excerpt.txt");
    //midiToContrapuntalMotions(path + "\\travelling_counterpoint\\data\\test.txt");
    //midiToContrapuntalMotions(path + "\\travelling_counterpoint\\data\\bach_dsharpm_excerpt.txt");
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  setupReactiveSphere();
  setupGUI();
}

void draw() {
  background(0);
  
  translate(width/2, height/2, 0);
  
  stroke(255);
  sphere(GRID_SPACE / 2);
  strokeWeight(2);
  
  if (reactiveSphereOn) {drawReactiveSphere();}
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
  drawGUI();
}
