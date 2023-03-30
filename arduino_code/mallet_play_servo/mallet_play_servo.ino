#include <Servo.h>

// Servo Safety Checks
// Calibration Offset

int DELAY_MS = 15;
int STEP_INCREASE = 5;

String input;
Servo malletServo;
int stored[] = {
  120, 85, 55
};

int storedLen = 3;

int targetPos = 120;
int pos = 120;

void setup() {
  Serial.begin(9600);
  malletServo.attach(9);
  malletServo.write(pos);
}

void loop() {
  if(pos == targetPos) {
    Serial.println("Awaiting new command");

    while(Serial.available() == 0) {
      delay(10);      
    }

    input = Serial.readStringUntil('\n');
    if(input.startsWith("servoPos ")) {
      long servoInput = input.substring(9).toInt();
      if(servoInput <= 0) {
        Serial.println("Could not parse number or input was 0 or lower");
      } else {
        targetPos = (int) servoInput;
      }
    }

    else if(input.startsWith("malletPos ")) {
      long servoInput = input.substring(10).toInt();
      if(servoInput <= 0) {
        Serial.println("Could not parse number or input was 0 or lower");
      } else if(servoInput > storedLen) {
        Serial.println("Input pos bigger than saved pos number");
      } else {
        targetPos = stored[servoInput-1];
      }
    } else {
      Serial.println("Unknown command");
    }
  }

  if(pos < targetPos) {
    pos += min(STEP_INCREASE, targetPos - pos);
  } else if(pos > targetPos) {
    pos -= min(STEP_INCREASE, pos - targetPos);
  }

  malletServo.write(pos);
  
  delay(15);
}
