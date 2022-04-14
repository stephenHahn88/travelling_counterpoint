void keyPressed() {
  switch (key) {
    case ENTER: thread("enterPress");
      break;
    case 'q': shiftVoice(Voice.SOPRANO, false);
      break;
    case 'w': shiftVoice(Voice.SOPRANO, true); 
      break;
    case 'a': shiftVoice(Voice.ALTO, false);
      break;
    case 's': shiftVoice(Voice.ALTO, true); 
      break;
    case 'z': shiftVoice(Voice.BASS, false);
      break;
    case 'x': shiftVoice(Voice.BASS, true);
      break;
    case 'd': changeDuration();
      break;
    case 'p': loopPlayToggle();
      break;
    case 't': TEMPO = TEMPO - 4;
      break;
    case 'y': TEMPO = TEMPO + 4;
      break;
    case BACKSPACE: 
      contrapuntalMotions.clear();
      contrapuntalMotionsSphere.clear();
      break;
    case 'g': gridOn = !gridOn;
      break;
    case '0': reactiveSphereOn = !reactiveSphereOn;
      break;
    case 'm': changeMode();
      break;
    case '8': evolveToggle();
      break;
    default:
      System.out.println("Key not implemented");
  }
}

void evolveToggle() {
  evolving = !evolving;
  thread("evolve");
}

void loopPlayToggle() {
  loopPlay = !loopPlay;
  thread("playPiece");
}

void evolve() {
  while (evolving) {
    int randomIndex = rand.nextInt(contrapuntalMotions.size()-1);
    ContrapuntalMotion cm = contrapuntalMotions.get(randomIndex);
    ContrapuntalMotion nm = contrapuntalMotions.get(randomIndex+1);
    ContrapuntalMotion cmSphere = contrapuntalMotionsSphere.get(randomIndex);
    ContrapuntalMotion nmSphere = contrapuntalMotionsSphere.get(randomIndex+1);
    
    int randomVoice = rand.nextInt(3);
    int randomHalfSteps = rand.nextInt(4) - 2;
    
    int[] cmEnd = {cm.endNotes[0], cm.endNotes[1], cm.endNotes[2]};
    int[] nmStart = {nm.startNotes[0], nm.startNotes[1], nm.startNotes[2]};
    
    cmEnd[randomVoice] = cmEnd[randomVoice] + randomHalfSteps;
    nmStart[randomVoice] = nmStart[randomVoice] + randomHalfSteps;
    
    Duration newDur;
    if (rand.nextBoolean()) {
      newDur = randomEnum(Duration.class);
    } else {
      newDur = cm.duration;
    }
    
    cm.update(cm.startNotes, cmEnd, newDur);
    nm.update(nmStart, nm.endNotes, nm.duration);
    cmSphere.update(cm);
    nmSphere.update(nm);
    cmSphere.toSpherical();
    nmSphere.toSpherical();
    delay(EVOLVE_TIME);
  }
}

void enterPress() {
  Coordinate start;
  Coordinate startSphere;
  ContrapuntalMotion prev;
  
  int[] startNotes = new int[3];
  if (!contrapuntalMotions.isEmpty()) {
    prev = contrapuntalMotions.get(contrapuntalMotions.size() - 1);
    start = prev.end;
    startSphere = contrapuntalMotionsSphere.get(contrapuntalMotionsSphere.size() - 1).end;
    startNotes = prev.endNotes;
  } else {
    int bc = (CENTER_NOTE - ORIGINAL_VOICE_NOTES[0]) * GRID_SPACE;
    int ac = (CENTER_NOTE - ORIGINAL_VOICE_NOTES[1]) * GRID_SPACE;
    int sc = (CENTER_NOTE - ORIGINAL_VOICE_NOTES[2]) * GRID_SPACE;
    start = new Coordinate(bc, ac, sc);
    PVector sphereStart = cartesianToSpherical(bc, ac, sc);
    startSphere = new Coordinate(sphereStart.x, sphereStart.y, sphereStart.z);
    startNotes = ORIGINAL_VOICE_NOTES;
  }
  int bassCoord = (CENTER_NOTE - currVoiceNotes[0]) * GRID_SPACE;
  int altoCoord = (CENTER_NOTE - currVoiceNotes[1]) * GRID_SPACE;
  int sopCoord = (CENTER_NOTE - currVoiceNotes[2]) * GRID_SPACE;
  Coordinate end = new Coordinate(bassCoord, altoCoord, sopCoord);
  PVector sphereEnd = cartesianToSpherical(bassCoord, altoCoord, sopCoord);
  Coordinate endSphere = new Coordinate(sphereEnd.x, sphereEnd.y, sphereEnd.z);
  
  int[] endNotes = {currVoiceNotes[0], currVoiceNotes[1], currVoiceNotes[2]};
  ContrapuntalMotion newCM = new ContrapuntalMotion(start, end, currDuration, startNotes, endNotes);
  ContrapuntalMotion newSpherical = new ContrapuntalMotion(startSphere, endSphere, currDuration, startNotes, endNotes);
  contrapuntalMotions.add(newCM);
  contrapuntalMotionsSphere.add(newSpherical);
  
  if (currCM == CoordinateMode.CARTESIAN) {
    swirl.currPosition = newCM.end;
  } else {
    swirl.currPosition = newSpherical.end;
  }
  currPlaying = newCM;
  AudioPlayer[] aps = playHarmony(currVoiceNotes);  
}

void changeDuration() {
  int numDurations = Duration.values().length;
  durationIdx++;
  currDuration = Duration.values()[durationIdx % numDurations];
  System.out.println("duration quarterlength: " + currDuration.quarterLength);
}

void playPiece() { 
  while (loopPlay) {
    for (ContrapuntalMotion cm : contrapuntalMotions) {
      swirl.currPosition = cm.start;
      currPlaying = cm;
      AudioPlayer[] aps = playHarmony(cm.startNotes);
      int timeDuration = Math.round(cm.duration.quarterLength * 60000 / TEMPO);
      delay(timeDuration);
      pauseHarmony(aps);
    }
    ContrapuntalMotion cm = contrapuntalMotions.get(contrapuntalMotions.size()-1);
    swirl.currPosition = cm.end;
    currPlaying = cm;
    AudioPlayer[] aps = playHarmony(cm.endNotes);
    int timeDuration = Math.round(cm.duration.quarterLength * 60000 / TEMPO);
    delay(timeDuration);
    pauseHarmony(aps);
  }
}

void shiftVoice(Voice v, boolean isUp) {
  int sign = 1;
  if (!isUp) {
    sign = -1;
  }
  switch (v) {
    case BASS:
      currVoiceNotes[0] = currVoiceNotes[0] + sign;
      break;
    case ALTO:
      currVoiceNotes[1] = currVoiceNotes[1] + sign;
      break;
    case SOPRANO:
      currVoiceNotes[2] = currVoiceNotes[2] + sign;
      break;
  }
  System.out.println(String.format(
    "bass %d alto %d soprano %d", 
    getMidiPitch(Voice.BASS), 
    getMidiPitch(Voice.ALTO), 
    getMidiPitch(Voice.SOPRANO)
  ));
}
