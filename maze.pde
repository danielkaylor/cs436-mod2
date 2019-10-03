import processing.serial.*;

Serial p1Port;
Serial p2Port;
String p1Coords;
String p2Coords;
String p1Input;
String p2Input;

void setup() {
  fullScreen();
  p1Port = new Serial (this, "/dev/ttyUSB0", 115200); // need two?
  
  p2Port = new Serial (this, "/dev/ttyUSB0", 115201);
}

//public synchronized void serialEvent(Serial port) {
//  int[] arr = input.split(",");
//}

void draw() {
  if ( p1Port.available() > 0) {  // If data is available,
    p1Input = p1Port.readStringUntil('\n');
  }
  if ( p2Port.available() > 0) {
    p2Input = p2Port.readStringUntil('\n');
  }
  
  fill(255,10);
  rect(0,0,width,height);
  
  
}
