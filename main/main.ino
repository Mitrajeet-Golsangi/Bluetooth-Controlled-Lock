#define LED_PIN 13;
int cmd = -1;
int flag = 0;

#include <Servo.h>
Servo servo;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  Serial.begin(9600);

  servo.attach(9, 600, 2300);
}

void loop() {
  if (Serial.available() > 0) {
    cmd = Serial.read();
    flag = 1;
  }

  if (flag == 1) {
    switch(cmd) {
      case '0':
        digitalWrite(LED_PIN, LOW);
        servo.write(180);
        Serial.println("Door Unlocked");
        break;
      case '1':
        digitalWrite(LED_PIN, HIGH);
        Serial.println("Door Locked");
        servo.write(55);
        break;
    }
    flag = 0;
  }

  Serial.flush();
  delay(100);
}
