class Output {
  public float[] waveform;
  public float margin = 20;
  
  // window parameters
  private int x1 = 0;
  private int x2 = width;
  private int y1 = height*2/3;
  private int y2 = height;
  
  Output() {
    waveform = new float[dataPoints];
  }
  
  public void fullInverseDFT(Complex[] input) {
    float w = TWO_PI / waveform.length; // base frequency is size of window
    for (int n = 0; n < waveform.length; n++) {
      Complex sum = new Complex();
      for (int k = 0; k < input.length; k++) {  
        if (input[k].abs() < 1) continue;
        Complex rotation = new Complex(cos(k*w*n * freqRange/input.length), sin(k*w*n * freqRange/input.length));
        rotation.muleq(input[k]);
        sum.addeq(rotation); 
      }
      //sum.div(input.length);
      waveform[n] = (float)sum.re;
    }
  }
  
  public void fastInverseDFT(Complex[] input) {
    float w = TWO_PI / waveform.length; // base frequency is size of window
    for (int n = 0; n < waveform.length; n++) {
      Complex sum = new Complex();
      for (int k = 0; k < input.length; k++) {  
        if (input[k].abs() < 1) continue;
        Complex rotation = new Complex(cos(k*w*n), sin(k*w*n));
        rotation.muleq(input[k]);
        sum.addeq(rotation); 
      }
      //sum.div(input.length);
      waveform[n] = (float)sum.re;
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
