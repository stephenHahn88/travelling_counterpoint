import java.io.File;

import javax.sound.midi.MidiEvent;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.Sequence;
import javax.sound.midi.ShortMessage;
import javax.sound.midi.Track;


void midiToContrapuntalMotions(String filepath) throws Exception {
  String path = dataPath(filepath);
  final int NOTE_ON = 0x90;
  
  ArrayList<ArrayList<Integer>> voices = new ArrayList<>();
  ArrayList<ArrayList<Integer>> times = new ArrayList<>();
  for (int i=0; i<3; i++) {
    voices.add(new ArrayList<Integer>());
    times.add(new ArrayList<Integer>());
  }
  Sequence sequence = MidiSystem.getSequence(new File(path));
  int trackNumber = 0;
  for (Track track: sequence.getTracks()) {
    trackNumber++;
    if (trackNumber >= 3) {
      break;
    }
    for (int i=0; i<track.size(); i++) {
      MidiEvent event = track.get(i);
      MidiMessage message = event.getMessage();
      if (message instanceof ShortMessage) {
        ShortMessage sm = (ShortMessage) message;
        if (sm.getCommand() == NOTE_ON) {
          voices.get(trackNumber - 1).add(sm.getData1());
          times.get(trackNumber - 1).add((Integer) round(event.getTick()));
        }
      }
    }
  }
  for (int i = 0; i<3; i++) {
    System.out.println(voices.get(i).toString());
    System.out.println(times.get(i).toString());
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
