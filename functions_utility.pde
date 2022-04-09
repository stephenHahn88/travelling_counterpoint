PVector cartesianToSpherical(float x, float y, float z) {
  // x, y corresponds to map location. z is radius
  float longitude = x / z;
  float latitude = (float)(2 * atan(exp(y/z)) - PI/2);
  return new PVector(z * cos(latitude) * cos(longitude), z * cos(latitude) * sin(longitude), z * sin(latitude));
}

int randIntCenter0(int high) {
  return rand.nextInt(high*2) - high;
}

//From https://stackoverflow.com/questions/1972392/pick-a-random-value-from-an-enum
<T extends Enum<?>> T randomEnum(Class<T> clazz) {
  int x = rand.nextInt(clazz.getEnumConstants().length);
  return clazz.getEnumConstants()[x];
}

AudioPlayer playNote(int midiNum) {
  AudioPlayer ap = notes[midiNum - 21];
  ap.setGain(0.0);
  ap.rewind();
  ap.play();
  ap.shiftGain(ap.getGain(), -10, 1000);
  return ap;
}

AudioPlayer[] playHarmony(int[] midiNums) {
  AudioPlayer[] aps = new AudioPlayer[3];
  int i = 0;
  for (int midiNum : midiNums) {
    aps[i] = playNote(midiNum);
    i++;
  }
  return aps;
}

void pauseHarmony(AudioPlayer[] aps) {
  for (AudioPlayer ap : aps) {
    ap.pause();
  }
}

int getMidiPitch(Voice v) {
  switch (v) {
    case BASS: return currVoiceNotes[0];
    case ALTO: return currVoiceNotes[1];
    case SOPRANO: return currVoiceNotes[2];
    default: return 0;
  }
}

void changeMode() {
  if (currCM == CoordinateMode.CARTESIAN) {
    currCM = CoordinateMode.SPHERICAL;
    swirl.currPosition = contrapuntalMotionsSphere.get(contrapuntalMotionsSphere.size() - 1).end;
  } else {
    currCM = CoordinateMode.CARTESIAN;
    swirl.currPosition = contrapuntalMotions.get(contrapuntalMotions.size() - 1).end;
  }
}

Coordinate coordFromNotes(int[] notes) {
  int b = (CENTER_NOTE - notes[0]) * GRID_SPACE;
  int a = (CENTER_NOTE - notes[1]) * GRID_SPACE;
  int s = (CENTER_NOTE - notes[2]) * GRID_SPACE;
  return new Coordinate(b, a, s);
}

int calculateCrunch(int b, int a, int s) {
  int[] intervals = new int[] {abs(b-a)%12, abs(b-s)%12, abs(a-s)%12};
  int dissonances = 0;
  for (int i: intervals) {
    if (i == 1 | i == 2 | i == 6 | i == 10 | i == 11) {
      dissonances++;
    }
    if (i == 1 | i == 6 | i == 11) {
      dissonances++;
    }
  }
  return dissonances+1;
}
