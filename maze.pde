import processing.serial.*;

Serial p1Port;
Serial p2Port;

int b1;
int b2;

int x1;
int x2;
 
int y1;
int y2;

int t1;
int t2;

String p1Input;
String p2Input;

void setup() {
  fullScreen();
  println(Serial.list());
  p1Port = new Serial (this, "COM3", 115200); // need two?
  
  //p2Port = new Serial (this, "/dev/ttyUSB1", 115200);
  
  b1 = b2 = x1 = x2 = y1 = y2 = t1 = t2 = 0;
}

//public synchronized void serialEvent(Serial port) {
//  int[] arr = input.split(" ");
//}

void draw() {
  if ( p1Port.available() > 0) {  // If data is available,
    p1Input = p1Port.readStringUntil(' ');
    p1Input.replace(" ", "");
    println("THIS IS P1 INPUT:" + p1Input + "END OF P1 INPUT");
    b1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ');
    p1Input.replace(" ", "");
    t1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ');
    p1Input.replace(" ", "");
    x1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ');
    p1Input.replace(" ", "");
    y1 = Integer.parseInt(p1Input);
  }
  if ( p2Port.available() > 0) {
    p2Input = p2Port.readStringUntil('\n');
  }
  
  //to fade out the trail
  fill(255,10);
  rect(0,0,width,height);
  
  stroke(0, 0, 0);
  point(x1, y1);
  
}
