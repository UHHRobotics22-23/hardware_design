#include <Servo.h>

// Calibration Offset

int DELAY_MS = 5;
int STEP_INCREASE = 1;
int MAX_VALUE = 255;
int MIN_VALUE = 0;
int RESOLUTION = 255;

String input;
String input_number;
Servo malletServo;

int targetPos = 97;
int pos = 97;

void setup() {
  Serial.begin(115200);
  malletServo.attach(2);
  malletServo.write(pos);
}

void loop() {
  if(pos == targetPos || Serial.available() > 0) {
    // Serial.println("Awaiting new command");

    while(Serial.available() == 0) {
      delay(DELAY_MS);      
    }

    input = Serial.readStringUntil('\n');
    input.trim();
    if(input.startsWith("s ")) {
      input_number = input.substring(2);
      long servoInput = input_number.toInt();
      if(!check_input_number_string() || servoInput < 0) {
        Serial.println("err_input_num");
      } else {
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("err_input_range");
        } else {
          targetPos = (int) servoInput;
          Serial.println("ok");
        }
      }
    }
    
    else if(input.startsWith("p")) {
      Serial.print("p ");
      Serial.println(pos);
    }

    else if(input.startsWith("l")) {
      Serial.print("l ");
      Serial.print(MIN_VALUE);
      Serial.print(" ");
      Serial.print(MAX_VALUE);
      Serial.print(" ");
      Serial.println(RESOLUTION);
    }

    else {
      Serial.println("err_cmd");
    }
  }

  // Set to pos to targetPos immediately. Maybe readd lower code later for velocity constraining
  pos = targetPos;

  // if(pos < targetPos) {
  //   pos += min(STEP_INCREASE, targetPos - pos);
  // } else if(pos > targetPos) {
  //   pos -= min(STEP_INCREASE, pos - targetPos);
  // }

  malletServo.write(pos);
  
  delay(DELAY_MS);
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