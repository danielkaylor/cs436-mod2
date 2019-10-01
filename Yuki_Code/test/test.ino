//18 is Button
//23 is Toggle
//34 is SW -> Disabled
//35 is Y
//32 is X

void setup() {
  Serial.begin(115200);
  pinMode(18, INPUT);
  pinMode(23, INPUT);
  pinMode(32, INPUT);
  //pinMode(34, INPUT);
  pinMode(35, INPUT);
}

void loop() {
  int B = digitalRead(18);
  int T = digitalRead(23);
  int X = analogRead(32);
  int Y = analogRead(35);
  Serial.printf("%d %d %d %d\n", B, T, X, Y);
  //Serial.printf("Button is: %d | ", digitalRead(18));
  //Serial.printf("Toggle is: %d | ", digitalRead(23));
  //Serial.printf("SW is: %d | ", digitalRead(34));
  //Serial.printf("(X, Y) : (%d, %d)\n", analogRead(32), analogRead(35));
  delay(50);
}
