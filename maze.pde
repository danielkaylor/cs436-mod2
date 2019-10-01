import processing.serial.*;

Serial myPort;

void setup() {
  fullScreen();
  myPort = new Serial (this, "/dev/ttyUSB0", 115200); // need two?
  myPort.bufferUntil('\n'); //Receiving data from Arduino IDE
}

public synchronized void serialEvent(Serial myPort) {
  int[] arr = input.split(",");
}
