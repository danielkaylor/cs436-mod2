import processing.serial.*;

Serial p1Port;
Serial p2Port;
player p1;
player p2;

//for keeping track of when game starts
int frameStart;

//for size of arena
float d = height;

boolean started;

void setup() {
  fullScreen();
  started = false;
  //size(2048, 2048);
  //println(Serial.list());
  p1Port = new Serial (this, "COM3", 115200);
  Serial p2Port = new Serial (this, "COM4", 115200);
  p1 = new player(p1Port, (width/2.0) - (d/2.0) - 500, height/2.0);
  p2 = new player(p2Port, (width/2.0) + (d/2.0) + 500, height/2.0);
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
  if (!started) {
    
    fill(0, 0, 0, 10);
    rect(0, 0, width, height);
    
    textAlign(CENTER);
    fill(255, 255, 255);
    textSize(70);
    text("PRESS BOTH BUTTONS SIMULTANEOUSLY TO START", width/2.0, height/2.0);
    text("OBJECTIVE: TOUCH YOUR RED SIDE TO THE OPPONENT'S GREEN SIDE!", width/2.0, 2 * height/3.0);
    
    p1.popAll();
    p2.popAll();
    started = p1.b && p2.b;
    frameStart = frameCount;
    
  } else {

    fill(0, 40);
    rect(0, 0, width, height);
    arena();
    
    if ((distance(p1.x, p1.y, width/2.0, height/2.0) - 40) > (d/2.0)) {
      //p1 out of bounds
      p2.points++;
      fresh();
      fill(255, 255, 255);
      textSize(70);
      text("PLAYER 1 OUT OF BOUNDS! POINT TO PLAYER 2", width/2.0, height/5.0);
    } else if ((distance(p2.x, p2.y, width/2.0, height/2.0) - 40) > (d/2.0)) {
      //p2 out of bounds
      p1.points++;
      fresh();
      fill(255, 255, 255);
      textSize(70);
      text("PLAYER 2 OUT OF BOUNDS! POINT TO PLAYER 1", width/2.0, height/5.0);
    } else if (distance(p1.x, p1.y, p2.x, p2.y) <= 40) {
      boolean p1W = false, p2W = false;
      if (p1.x < p2.x) {
        p1W = p1.touch(true);
        p2W = p2.touch(false);
      } else {
        p1W = p1.touch(false);
        p2W = p2.touch(true);
      }
      if ((p1W && p2W) || (!p1W && !p2W)) {
        //DRAW
        fill(255, 255, 255);
        textSize(160);
        text("DRAW", width/2.0, height/2.0); 
        p1.x = width/2.0 - d/2 + 150;
        p1.y = height/2.0;
        p2.x = width/2.0 + d/2 - 150;
        p2.y = height/2.0;
        p1.drawMe();
        p2.drawMe();
      } else if (p1W) {
        //p2 WINS
        p2.points++;
        fresh();
      } else {
        //p1 WINS
        fresh();
        p1.points++;
      }
    } else {
      p1.popAll();
      p1.drawMe();
      p2.popAll();
      p2.drawMe();
    }
  }
  textAlign(CENTER);
  textSize(70);
  fill(255, 255, 255);
  text(String.format("PLAYER 1 POINTS: %d", p1.points), width/6.0, height/20.0);
  text(String.format("PLAYER 2 POINTS: %d", p2.points), 5 * width/6.0, height/20.0);
}

void arena() {
  
  stroke(0, 0, 255);
  fill(0, 0);
  d = height - (frameCount - frameStart);
  if ( d < height/4.0 ) {
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
    points = 0;
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

      //for scaling to screen (this value is only joystick dependent)
      dx -= 1882;
      dy -= 1910;

      dx /= width/10.0;
      dy /= height/10.0;
      //println("B: " + this.b + " | T: " + this.t + " | X: " + this.dx + " | Y: " + this.dy);
    }
    x -= dy;
    y += dx;
  }

  boolean touch(boolean left) {
    if (t && left || !t && !left) {
      return true;
    } else {
      return false;
    }
  }
}

public static float distance(float x1, float y1, float x2, float y2) {
  float sum = 0.0;

  sum += Math.pow((x1 - x2), 2.0);
  sum += Math.pow((y1 - y2), 2.0);

  return (float) Math.sqrt(sum);
}
