import processing.serial.*;

Serial p1Port;
Serial p2Port;
player p1;
player p2;

//for keeping track of when game starts
int frameStart;

//for size of arena
float d;

boolean started;

void setup() {
  fullScreen();
  started = false;
  //size(2048, 2048);
  println(Serial.list());
  p1Port = new Serial (this, "COM3", 115200);
  Serial p2Port = new Serial (this, "COM4", 115200);
  p1 = new player(p1Port, 400, 400);
  p2 = new player(p2Port, width - 400, height - 400);
}

void fresh() {
  started = false;
  p1.x = p1.startx;
  p1.y = p1.starty;
  p2.x = p2.startx;
  p2.y = p2.starty;
  
  fill(0, 0, 0);
  rect(0, 0, width, height);
}

void draw() {
  while (!started) {
    p1.popAll();
    p2.popAll();
    started = p1.b && p2.b;
    delay(50);
    frameStart = frameCount;
  }
  
  fill(0, 40);
  rect(0, 0, width, height);
  arena();
  
  if (distance(p1.x, p1.y, p2.x, p2.y) <= 40) {
    fresh();
  } else {
    p1.popAll();
    p1.drawMe();
    p2.popAll();
    p2.drawMe();
  }
}

void arena() {
  stroke(0, 0, 255);
  fill(0, 0);
  d = height - (frameCount - frameStart);
  if( d < height/4.0 ) {
    d = height/4.0;
  }
  circle(width/2, height/2, d);
}

class player {
  Serial port;
  
  float startx;
  float starty;

  boolean b;
  boolean t;
  float x;
  float y;

  int dx;
  int dy;

  color c;
  
  int points;

  player(Serial nPort, float nx, float ny) {
    b = false;
    t = false;
    port = nPort;
    x = startx = nx;
    y = starty = ny;
    dx = 0;
    dy = 0;
    c = color(225, 200, 175);
  }

  void drawMe() {
    float rot = 0;
    if (this.t) {
      rot = PI;
    }
    stroke(c);
    fill(255, 0, 0);
    arc(x, y, 40, 40, 3 * PI / 2 + rot, 5 * PI / 2 + rot, OPEN);
    fill(0, 255, 0);
    arc(x, y, 40, 40, PI / 2 + rot, 3 * PI / 2 + rot, OPEN);
    port.clear();
    fill(0, 0, 0);
    circle(x, y, 20);
  }

  void popAll() {
    String tmp = "";
    if (port.available() > 0) {  // If data is available,
      tmp = port.readStringUntil(' ').trim();
      if (Integer.parseInt(tmp) == 1) {
        b = true;
      } else {
        b = false;
      }
      tmp = port.readStringUntil(' ').trim();
      if (Integer.parseInt(tmp) == 1) {
        t = true;
      } else {
        t = false;
      }
      tmp = port.readStringUntil(' ').trim();
      dx = Integer.parseInt(tmp);
      tmp = port.readStringUntil(' ').trim();
      dy = Integer.parseInt(tmp);

      //for scaling to screen
      dx -= 1882;
      dy -= 1910;

      dx /= width/10.0;
      dy /= height/10.0;
      //println("B: " + this.b + " | T: " + this.t + " | X: " + this.dx + " | Y: " + this.dy);
    }
    x -= dy;
    y += dx;
  }
}

public static float distance(float x1, float y1, float x2, float y2) {
    float sum = 0.0;
    
    sum += Math.pow((x1 - x2), 2.0);
    sum += Math.pow((y1 - y2), 2.0);

    return (float) Math.sqrt(sum);
}
