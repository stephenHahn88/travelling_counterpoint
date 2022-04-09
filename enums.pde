enum Voice {
  SOPRANO, // Z dimension
  ALTO,    // Y dimension
  BASS     // X dimension
}

enum Duration {
  //T(0.125, 255, 255, 0), //thirtysecond
  S(0.25, 255, 128, 0), //sixteenth
  DS(0.375, 255, 0, 0),//dotted sixteenth
  E(0.5, 255, 0, 128), //etc.
  DE(0.75, 255, 0, 255),
  Q(1, 128, 0, 255),
  DQ(1.5, 0, 0, 255),
  H(2, 0, 128, 255),
  DH(3, 0, 255, 255),
  W(4, 0, 255, 128),
  DW(6, 0, 255, 0);
  
  public final float quarterLength;
  public final int r;
  public final int g;
  public final int b;
  
  private Duration(float quarterLength, int r, int g, int b) {
    this.quarterLength = quarterLength;
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

enum CoordinateMode {
  CARTESIAN,
  SPHERICAL
}
