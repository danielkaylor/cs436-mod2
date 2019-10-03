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

float prevx1;
float prevy1;

void setup() {
  //fullScreen();
  size(2048, 2048);
  println(Serial.list());
  p1Port = new Serial (this, "COM3", 115200); // need two?
  
  //p2Port = new Serial (this, "/dev/ttyUSB1", 115200);
  
  b1 = b2 = x1 = x2 = y1 = y2 = t1 = t2 = 0;
  
  prevx1 = width/2;
  prevy1 = height/2;
}

//public synchronized void serialEvent(Serial port) {
//  int[] arr = input.split(" ");
//}

void draw() {
  if ( p1Port.available() > 0) {  // If data is available,
    p1Input = p1Port.readStringUntil(' ').trim();
    b1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ').trim();
    t1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ').trim();
    x1 = Integer.parseInt(p1Input);
    p1Input = p1Port.readStringUntil(' ').trim();
    y1 = Integer.parseInt(p1Input);
    
    //for scaling to screen
    x1 -= 1882;
    y1 -= 1910;
  }
  
  println(x1 + " " + y1);
  //if ( p2Port.available() > 0) {
  //  p2Input = p2Port.readStringUntil('\n');
  //}
  
  //to fade out the trail
  fill(255,10);
  rect(0,0,width,height);
  
  //stroke(0, 0, 0);
  //point(x1, y1);
  fill(0, 0, 0);
  circle(prevx1, prevy1, 40);
  
  prevx1 += x1/500.0;
  prevy1 += y1/500.0;
  p1Port.clear();
  
}
