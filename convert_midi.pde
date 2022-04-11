import java.io.File;
import java.util.Scanner;

void midiToContrapuntalMotions(String filepath) throws Exception {
  ArrayList<Integer[]> notes = new ArrayList<>(); 
  ArrayList<Float> durations = new ArrayList<>();
  File file = new File(filepath);
  Scanner sc = new Scanner(file);
  while (sc.hasNextLine()) {
    String line = sc.nextLine();
    String[] parts = line.split("\t");
    Integer[] newNotes = new Integer[3];
    newNotes[0] = Integer.parseInt(parts[0]);
    newNotes[1] = Integer.parseInt(parts[1]);
    newNotes[2] = Integer.parseInt(parts[2]);
    notes.add(newNotes);
    durations.add(Float.parseFloat(parts[3]));
  }
  sc.close();
  for (Integer[] ints: notes) {
    int[] i = toIntArray(ints);
    System.out.println(String.format("%d %d %d", i[0], i[1], i[2]));
  }
  System.out.println(durations.toString());
  for (int i=0; i < durations.size()-1; i++) {
    int[] startNotes = toIntArray(notes.get(i));
    int[] endNotes = toIntArray(notes.get(i+1));
    Coordinate startCoord = coordFromNotes(startNotes);
    Coordinate endCoord = coordFromNotes(endNotes);
    PVector startCoordSphere = cartesianToSpherical(startCoord.x, startCoord.y, startCoord.z);
    PVector endCoordSphere = cartesianToSpherical(endCoord.x, endCoord.y, endCoord.z);
    Duration dur = quarterLengthToDuration(durations.get(i));
    contrapuntalMotions.add(new ContrapuntalMotion(startNotes, endNotes, dur));
    contrapuntalMotionsSphere.add(
      new ContrapuntalMotion(
        new Coordinate(startCoordSphere.x, startCoordSphere.y, startCoordSphere.z),
        new Coordinate(endCoordSphere.x, endCoordSphere.y, endCoordSphere.z),
        dur, startNotes, endNotes
      )
    );
  }
  
}

void bach_aof() {
  int[] s1 = {45, 69, 77}; 
  int[] s2 = {38, 66, 71};
  int[] s3 = {40, 67, 70};
  int[] s4 = {41, 64, 69}; //m. 184
  int[] s5 = {41, 65, 74};
  int[] s6 = {43, 63, 67};
  int[] s7 = {45, 61, 67};
  int[] s8 = {46, 62, 65};
  
  ContrapuntalMotion cm1 = new ContrapuntalMotion(s1, s2, Duration.Q);
  ContrapuntalMotion cm2 = new ContrapuntalMotion(s2, s3, Duration.Q);
  ContrapuntalMotion cm3 = new ContrapuntalMotion(s3, s4, Duration.Q);
  ContrapuntalMotion cm4 = new ContrapuntalMotion(s4, s5, Duration.Q);
  ContrapuntalMotion cm5 = new ContrapuntalMotion(s5, s6, Duration.Q);
  ContrapuntalMotion cm6 = new ContrapuntalMotion(s6, s7, Duration.Q);
  ContrapuntalMotion cm7 = new ContrapuntalMotion(s7, s8, Duration.Q);
  
  Collections.addAll(contrapuntalMotions, cm1, cm2, cm3, cm4, cm5, cm6, cm7);
}
