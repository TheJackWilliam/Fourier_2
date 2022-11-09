class Input {
  public float[] waveform;
  public int numWaves;
  private float[] magnitudes;
  private float[] frequencies;
  private float[] phases;
  
  private float margin = 20;
  // window parameters
  private int x1 = 0;
  private int x2 = width;
  private int y1 = 0;
  private int y2 = height/3;
  
  Input(int _numWaves) {
    numWaves = _numWaves;
    waveform = new float[dataPoints];
    magnitudes = new float[numWaves];
    frequencies = new float[numWaves];
    phases = new float[numWaves];
    for (int i = 0; i < numWaves; i++) {
      magnitudes[i] = random(freqRange-1)+1;
      if (USE_INT) frequencies[i] = (int)random(freqRange-1)+1;
      else frequencies[i] = random(freqRange-1)+1;
      phases[i] = random(TWO_PI);
      generateSineWaveform(magnitudes[i], frequencies[i], phases[i]);
    }
  }
  
  private void generateSineWaveform(float mag, float freq, float phase) {
    for (int i = 0; i < dataPoints; i++) {
      waveform[i] += mag * cos((float)i/dataPoints * TWO_PI*freq + phase);
    }
  }
  
  public void phaseShift(float rad) {
    waveform = new float[dataPoints];
    for (int i = 0; i < numWaves; i++) {
      phases[i] += rad * frequencies[i];
      generateSineWaveform(magnitudes[i], frequencies[i], phases[i]);
    }
  }
  
  public void show() {
    // draw background
    stroke(200);
    strokeWeight(1);
    fill(20);
    rect(x1, y1, x2 - x1, y2 - y1);
    
    // draw waveform
    stroke(200);
    strokeWeight(4);
    noFill();
    beginShape();
    for (int i = 0; i < waveform.length; i++) {
      float xPos = map(i, 0, waveform.length, x1, x2);
      float yPos = map(waveform[i], min(waveform), max(waveform), y2 - margin, y1 + margin);
      vertex(xPos, yPos);
    }
    endShape();
  }
};
