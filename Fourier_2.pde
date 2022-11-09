import complexnumbers.*;
import processing.sound.*;

/*
  The objective of this program is to be able to take in a digital waveform, and 
  approximate the fourier transform of said wave. The implementation will likely 
  be less visual than the previous version but also more consise.
*/

boolean DO_FULL = false;
boolean DO_FAST = true;
boolean DO_ONCE = false;
boolean USE_INT = true; // harmonics of fundemental frequency

Input input;
Compute compute;
Output output;

int dataPoints = 800;
int freqRange = dataPoints/20; // make sure that dataPoints % freqRange = 0 for good mag graph in fullDFT

void setup() {
  size(1600, 400);
  
  input = new Input(10);
  compute = new Compute();
  output = new Output();
  
  if (DO_ONCE) compute();
}

void compute() {
  if (DO_FULL) {
    compute.fullDFT(input.waveform);
    output.fullInverseDFT(compute.fullWaveform);
  }
  else if (DO_FAST) {
    compute.fastDFT(input.waveform, freqRange);
    output.fastInverseDFT(compute.fastWaveform);
  }
}

void draw() {
  background(20);
  
  input.phaseShift(0.01);
  if (!DO_ONCE) compute();
  
  input.show();
  if (DO_FULL) compute.showFull();
  else if (DO_FAST) compute.showFast();
  output.show();
  
  //println(frameRate);
}

void mouseClicked() {
  boolean temp = DO_FULL;
  DO_FULL = DO_FAST;
  DO_FAST = temp;
}

//void mousePressed() {
//  DO_ONCE = !DO_ONCE;
//}
