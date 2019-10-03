import processing.serial.*;

Serial p1Port;
Serial p2Port;
player p1;
player p2;

boolean started;

void setup() {
  fullScreen();
  started = false;
  //size(2048, 2048);
  println(Serial.list());
  p1Port = new Serial (this, "COM5", 115200);
  //Serial p2Port = new Serial (this, "COM4", 115200);
  p1 = new player(p1Port, 400, 400);
  //p2 = new player(p2Port, width - 400, height - 400);
}

void fresh() {
  started = false;
  p1 = new player(p1Port, 400, 400);
}

void draw() {
  while (!started) {
    p1.popAll();
    started = p1.b;
    delay(50);
  }
  fill(0, 10);
  rect(0, 0, width, height);
  p1.popAll();
  p1.drawMe();
  //p2.popAll();
}

class player {
  Serial port;

  boolean b;
  boolean t;
  float x;
  float y;

  int dx;
  int dy;

  color c;

  player(Serial nPort, float nx, float ny) {
    b = false;
    t = false;
    port = nPort;
    nx = x;
    ny = y;
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

      dx /= 500;
      dy /= 500;
      //println("B: " + this.b + " | T: " + this.t + " | X: " + this.dx + " | Y: " + this.dy);
    }
    x -= dy;
    y += dx;
  }
}
