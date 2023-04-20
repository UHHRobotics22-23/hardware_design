#include <Servo.h>

// Calibration Offset

int DELAY_MS = 15;
int STEP_INCREASE = 5;
// int CALIBRATION_ZERO_POINT = 120;
int MAX_VALUE = 120;
int MIN_VALUE = 55;

String input;
String input_number;
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
  if(pos == targetPos || Serial.available() > 0) {
    // Serial.println("Awaiting new command");

    while(Serial.available() == 0) {
      delay(10);      
    }

    input = Serial.readStringUntil('\n');
    input.trim();
    Serial.print("\"");
    Serial.print(input);
    Serial.println("\"");
    if(input.startsWith("servoPos ")) {
      input_number = input.substring(9);
      long servoInput = input_number.toInt();
      if(!check_input_number_string() || servoInput < 0) {
        Serial.println("Could not parse number or input was less than 0");
      } else {
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("Value outside of safety bounds");
        } else {
          targetPos = (int) servoInput;
          Serial.println("ok");
        }
      }
    }

    else if(input.startsWith("malletPos ")) {
      input_number = input.substring(10);
      long servoInput = input_number.toInt();
      if(!check_input_number_string() || servoInput < 0) {
        Serial.println("Could not parse number or input was less than 0");
      } else if(servoInput > storedLen) {
        Serial.println("Input pos bigger than saved pos number");
      } else {
        int targetPosPre = stored[servoInput];
        if(targetPosPre < MIN_VALUE || targetPosPre > MAX_VALUE) {
          Serial.println("Interal value outside of safety bounds");
        } else {
          targetPos = targetPosPre;
          Serial.println("ok");
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

bool check_input_number_string() {
  for(int i = 0; i < input_number.length(); i++) {
    char c = input_number.charAt(i);
    if(c < '0' || c > '9') {
      return false;
    }
  }

  return true;
}