#include <Servo.h>

// Calibration Offset

int DELAY_MS = 15;
int STEP_INCREASE = 5;
// int CALIBRATION_ZERO_POINT = 120;
int MAX_VALUE = 120;
int MIN_VALUE = 55;

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
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("Value outside of safety bounds");
        } else {
          targetPos = (int) servoInput;
        }
      }
    }

    else if(input.startsWith("malletPos ")) {
      long servoInput = input.substring(10).toInt();
      if(servoInput <= 0) {
        Serial.println("Could not parse number or input was 0 or lower");
      } else if(servoInput > storedLen) {
        Serial.println("Input pos bigger than saved pos number");
      } else {
        int targetPosPre = stored[servoInput-1];
        if(targetPosPre < MIN_VALUE || targetPosPre > MAX_VALUE) {
          Serial.println("Interal value outside of safety bounds");
        } else {
          targetPos = targetPosPre;
        }
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
