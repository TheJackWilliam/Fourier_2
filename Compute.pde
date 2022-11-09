// https://www.princeton.edu/~cuff/ele201/kulkarni_text/frequency.pdf

class Compute {
  public float[] magnitudes;
  public float[] phases;
  public Complex[] fullWaveform;
  public Complex[] fastWaveform;
  public float maxMagnitude;
  
  // window parameters
  private int x1 = 0;
  private int x2 = width;
  private int y1 = height/3;
  private int y2 = 2*height/3;
  public float margin = 20;
  
  Compute() {
    magnitudes = new float[(x2-x1)/2];
    phases = new float[(x2-x1)/2];
    fullWaveform = new Complex[(x2-x1)/2];
    fastWaveform = new Complex[freqRange];
  }
  
  public void fullDFT(float[] input) {
    float w = TWO_PI / input.length; // base frequency is size of window
    for (int k = 0; k < magnitudes.length; k++) {
      Complex sum = new Complex();
      for (int n = 0; n < input.length; n++) { // use freqRange/magnitudes.length to convert k from 0-800 to 0-10
        Complex rotation = new Complex(cos(-k*w*n * freqRange/magnitudes.length), sin(-k*w*n * freqRange/magnitudes.length));
        rotation.muleq(input[n]);
        sum.addeq(rotation); 
      }
      magnitudes[k] = (float)sum.abs();
      phases[k] = (float)sum.arg();
      fullWaveform[k] = sum;
      
      if (k % (magnitudes.length / min(freqRange, magnitudes.length)) == 0) {
        fastWaveform[k*freqRange/magnitudes.length] = sum;
      }
    }
  }
  
  public void fastDFT(float[] input, int bands) {
    float w = TWO_PI / input.length; // base frequency is size of window
    for (int k = 0; k < bands; k++) {
      Complex sum = new Complex();
      for (int n = 0; n < input.length; n++) {
        Complex rotation = new Complex(cos(-k*w*n), sin(-k*w*n));
        rotation.muleq(input[n]);
        sum.addeq(rotation); 
      }
      fastWaveform[k] = sum;
    }
  }
  
  private void showComponents() {
    // draw background 
    stroke(200);
    strokeWeight(1);
    fill(20);
    rect(x1, y1, x2 - x1, y2 - y1);
    
    // draw zero line
    stroke(50);
    strokeWeight(1);
    line(x1, (y2 + y1)/2, (x2 - x1)/2, (y2 + y1)/2);
    
    //// get the max 
    //float maxReal = 0;
    //float maxImag = 0;
    //for (int i = 0; i < fastWaveform.length; i++) {
    //  if (abs((float)fastWaveform[i].re) > maxReal) maxReal = abs((float)fastWaveform[i].re); 
    //  if (abs((float)fastWaveform[i].im) > maxImag) maxImag = abs((float)fastWaveform[i].im); 
    //}
    
    // draw tick lines
    for (int i = 0; i < fastWaveform.length; i++) { 
      float xPos = map(i, 0, fastWaveform.length, x1, (x2 - x1)/2);
      
      stroke(50);
      strokeWeight(1);
      line(xPos, y1, xPos, y2);
    }
    
    // draw imaginary
    stroke(0, 0, 200);
    strokeWeight(1);
    noFill();
    beginShape();
    for (int i = 0; i < fullWaveform.length; i++) {
      float xPos = map(i, 0, fullWaveform.length, x1, (x2 - x1)/2);
      float yPos = map((float)fullWaveform[i].im, -maxMagnitude, maxMagnitude, y2 - margin, y1 + margin);
      //float yPos = (y2 + y1)/2 - (float)fullWaveform[i].im / (y2 - y1);
      
      // clamp to window
      if (yPos < y1) yPos = y1;
      if (yPos > y2) yPos = y2;
      
      // find Positions here
      vertex(xPos, yPos);     
    }
    endShape();
    
    // draw real
    stroke(200, 0, 0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (int i = 0; i < fullWaveform.length; i++) {
      float xPos = map(i, 0, fullWaveform.length, x1, (x2 - x1)/2);
      float yPos = map((float)fullWaveform[i].re, -maxMagnitude, maxMagnitude, y2 - margin, y1 + margin);
      //float yPos = (y2 + y1)/2 - (float)fullWaveform[i].im / (y2 - y1);
      
      // clamp to window
      if (yPos < y1) yPos = y1;
      if (yPos > y2) yPos = y2;
      
      // find Positions here
      vertex(xPos, yPos);     
    }
    endShape();
  }
  
  private void showAbstractions() {
    // draw background 
    stroke(200);
    strokeWeight(1);
    fill(20);
    rect((x2 - x1)/2, y1, x2 - x1, y2 - y1);
    
    // draw zero line
    stroke(50);
    strokeWeight(1);
    line((x2 - x1)/2, (y2 + y1)/2, x2, (y2 + y1)/2);
    
    // draw tick lines and key circles
    for (int i = 0; i < fastWaveform.length; i++) { 
      float xPos = map(i, 0, fastWaveform.length, (x2 - x1)/2, x2);
      float yPos = map((float)fastWaveform[i].abs(), 0, maxMagnitude, (y2 + y1)/2, y1 + margin);
      
      stroke(50);
      strokeWeight(1);
      line(xPos, y1, xPos, y2);
      
      stroke(200);
      strokeWeight(1);
      noFill();
      circle(xPos, yPos, 10);
    }
    
    // draw phases
    stroke(0, 100, 0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (int i = 0; i < phases.length; i++) {
      float xPos = map(i, 0, phases.length, (x2 - x1)/2, x2);
      float yPos = map(phases[i], -PI, PI, y2 - margin, y1 + margin);
      
      // clamp to window
      if (yPos < y1) yPos = y1;
      
      // find Positions here
      vertex(xPos, yPos);     
    }
    endShape();
    
    // draw magnitudes
    stroke(0, 200, 0);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < magnitudes.length; i++) {
      float xPos = map(i, 0, magnitudes.length, (x2 - x1)/2, x2);
      float yPos = map(magnitudes[i], 0, maxMagnitude, (y2 + y1)/2, y1 + margin);
      
      // clamp to window
      if (yPos < y1) yPos = y1;
      
      // find Positions here
      vertex(xPos, yPos);     
    }
    endShape();
  }
  
  public void showFull() {
    // get the max 
    maxMagnitude = 0;
    for (int i = 0; i < fastWaveform.length; i++) {
      if (fastWaveform[i].abs() > maxMagnitude) maxMagnitude = (float)fastWaveform[i].abs();      
    }
    
    // show both windows
    showComponents();
    showAbstractions();
    
    // draw seperator
    stroke(200);
    strokeWeight(1);
    line((x1 + x2)/2, y1, (x1 + x2)/2, y2);
  }
  
  public void showFast() {
        // draw background 
    stroke(200);
    strokeWeight(1);
    fill(20);
    rect(x1, y1, x2 - x1, y2 - y1);
    
    // draw zero line
    stroke(50);
    strokeWeight(1);
    line(x1, y2 - margin, x2, y2 - margin);
    
    maxMagnitude = 0;
    for (int i = 0; i < fastWaveform.length; i++) {
      if (fastWaveform[i].abs() > maxMagnitude) maxMagnitude = (float)fastWaveform[i].abs();    
    }
    
    stroke(200);
    strokeWeight(2);
    noFill();
    for (int i = 0; i < fastWaveform.length; i++) {
      float xPos = map(i, 0, fastWaveform.length, x1, x2);
      float yPos = map((float)fastWaveform[i].abs(), 0, maxMagnitude, y2 - margin, y1 + margin);

      line(xPos, y2 - margin, xPos, yPos);
    }
  }
};
