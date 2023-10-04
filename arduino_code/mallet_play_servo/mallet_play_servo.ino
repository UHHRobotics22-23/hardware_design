/*
 * This file the serial connection based firmware for the two mallet holder.
 * It is intended to be used with a Raspberry PI Pico, not the Pico W as the Servo library of the Pico W behaves differently
 */
#include <Servo.h>

int DELAY_MS = 5;         // A delay controling the maximum update rate of the loop in ms
int STEP_INCREASE = 1;    // Not used

int MAX_VALUE = 180;      // Max control value not creating collisions in the assembly
int MIN_VALUE = 0;        // Min control value not creating collisions in the assembly
int RESOLUTION = 180;     // Resolution of the control value. 180 as the standard write function for servos is used.


String input;             // Input "buffer" from the serial connection
String input_number;      // Input substring containing the command value number
Servo malletServo;        // Servo Object

int targetPos = 97;       // target position. Used if slowly approaching the target
int pos = 97;             // Current set position of the servo

void setup() {
  Serial.begin(115200);
  malletServo.attach(2);  // Servo is controlled from pin 2
  malletServo.write(pos);
}

void loop() {
  // If serial messages are present or we reached the target position
  if(pos == targetPos || Serial.available() > 0) {
    // Serial.println("Awaiting new command");

    // Wait if there are no messages available
    while(Serial.available() == 0) {
      delay(DELAY_MS);      
    }

    input = Serial.readStringUntil('\n');
    input.trim();

    // Command for setting the position of the servo
    if(input.startsWith("s ")) {
      input_number = input.substring(2);
      long servoInput = input_number.toInt();
      // Check if the string was actually a valid number
      if(!check_input_number_string() || servoInput < 0) {
        Serial.println("err_input_num");
      } else {
        // Check if the input is within the valid range
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("err_input_range");
        } else {
          targetPos = (int) servoInput;
          Serial.println("ok");
        }
      }
    }

    // Command for getting the current position of the servo
    else if(input.startsWith("p")) {
      Serial.print("p ");
      Serial.println(pos); 
    }

    // Command for getting the limits and resolution of the controller
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

  // Set to pos to targetPos immediately. Could readd lower code later for velocity constraining
  pos = targetPos;

  // if(pos < targetPos) {
  //   pos += min(STEP_INCREASE, targetPos - pos);
  // } else if(pos > targetPos) {
  //   pos -= min(STEP_INCREASE, pos - targetPos);
  // }

  malletServo.write(pos);
  
  delay(DELAY_MS);
}

// Simple function to check if all characters of the number string are valid numbers.
bool check_input_number_string() {
  for(int i = 0; i < input_number.length(); i++) {
    char c = input_number.charAt(i);
    if(c < '0' || c > '9') {
      return false;
    }
  }

  return true;
}
