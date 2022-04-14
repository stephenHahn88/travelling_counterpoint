import controlP5.*;
import processing.opengl.*;

ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

void createSlider(String listener, int w, int h, int x, int y, int low, int high, int beginning, String label) {
  cp5.addSlider(listener)
    .setBroadcast(false)
    .setPosition(x, y)
    .setSize(w, h)
    .setRange(low, high)
    .setValue(beginning)
    .setNumberOfTickMarks(high-low+1)
    .showTickMarks(false)
    .setLabel(label)
    .setSliderMode(Slider.FLEXIBLE)
    .setBroadcast(true)
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM);
}

void createBang(String listener, int w, int h, int x, int y, String label) {
  cp5.addBang(listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setLabel(label)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    
}

void setupGUI() {
  g3 = (PGraphics3D)g;
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
 
  createBang("togglePlayBang", 120, 30, 20, 20, "Play/Pause");
  createSlider("tempoSlider", 200, 30, 20, 60, 20, 160, 88, "Quarter Notes Per Minute");
  
  createBang("toggleEvolveBang", 120, 30, 20, 140, "Evolve/Stagnate");
  createSlider("evolveTimeSlider", 200, 30, 20, 180, 300, 5000, 1000, "Milliseconds Between Evolutions");
  
  createSlider("bassNumberSlider", 40, 500, 20, height-600, 21, 108, 57, "Bass");
  createSlider("altoNumberSlider", 40, 500, 100, height-600, 21, 108, 60, "Alto");
  createSlider("sopranoNumberSlider", 40, 500, 180, height-600, 21, 108, 64, "Soprano");
  createBang("addNoteBang", 200, 60, 20, height-80, "Add Note");
    
  createBang("toggleGridBang", 30, 30, width-40, height-40, "Grid");
  createBang("toggleSphereBang", 30, 30, width-80, height-40, "Sphere");
  
  createBang("clearBang", 30, 30, width-40, 40, "Clear");
}

void drawGUI() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.draw();
  g3.camera = currCameraMatrix;
}

void togglePlayBang() {
  loopPlayToggle();
}

void tempoSlider(int val) {
  TEMPO = val;
}

void toggleEvolveBang() {
  evolveToggle();
}

void evolveTimeSlider(int val) {
  EVOLVE_TIME = val;
}

void bassNumberSlider(int val) {
  currVoiceNotes[0] = val;
}

void altoNumberSlider(int val) {
  currVoiceNotes[1] = val;
}

void sopranoNumberSlider(int val) {
  currVoiceNotes[2] = val;
}

void addNoteBang() {
   enterPress();
}

void toggleGridBang() {
  gridOn = !gridOn;
}

void toggleSphereBang() {
  reactiveSphereOn = !reactiveSphereOn;
}

void clearBang() {
  contrapuntalMotions.clear();
  contrapuntalMotionsSphere.clear();
}
