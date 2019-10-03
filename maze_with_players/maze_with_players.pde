import processing.serial.*;

player p1;
player p2;

void setup() {
  //fullScreen();
  size(2048, 2048);
  println(Serial.list());
  Serial p1Port = new Serial (this, "COM3", 115200);
  Serial p2Port = new Serial (this, "COM4", 115200);
  p1 = new player(p1Port, 48, 48);
  p2 = new player(p2Port, 2000, 2000);
}

void draw() {
  p1.drawMe();
  p2.drawMe();
}

class player {
  Serial port;

  boolean b;
  boolean t;
  float x;
  float y;
  
  color c;
  
  player(Serial nPort, float nx, float ny) {
    b = false;
    t = false;
    port = nPort;
    nx = x;
    ny = y;
    c = color(225, 200, 175);
  }

  void drawMe() {
    String tmp = "";
    int dx = 0, dy = 0;
    if ( port.available() > 0) {  // If data is available,
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
    }
    
    x += dx / 500;
    y += dy / 500;
    
    fill(0, 0, 0);
    stroke(c);
    circle(x, y, 40);
    port.clear();
  }
}
