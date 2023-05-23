
#include <WiFi.h>
#include <WiFiClient.h>
#include <Servo.h>
// Calibration Offset

int DELAY_MS = 5;
int STEP_INCREASE = 1;
int MAX_VALUE = 200;
int MIN_VALUE = -10;
int RESOLUTION = 255;

String input;
String input_number;
Servo malletServo;

int targetPos = 120;
int pos = 120;

// WIFI Setup
const char* ssid = "Marimbabot_Mallet";
const char* password = "12345678";

// Set the IP address and port number for the server
// IP Adress: '192.168.42.1'
const uint16_t serverPort = 80;
WiFiUDP udp;

void setup() {
  Serial.begin(115200);
  malletServo.attach(2);
  malletServo.write(pos);

  // Connect to Wi-Fi network
  WiFi.softAP(ssid, password);
  Serial.println("Access Point created");

  // Start the server
  
  udp.begin(8888);
  Serial.print("Server listening on ");
}

void loop() {
  char packetBuffer[255];
  int packetSize = udp.parsePacket();

  if(pos == targetPos || packetSize > 0) {
    // Serial.println("Awaiting new command");

   

    int len = udp.read(packetBuffer, 255);
    if (len > 0) {
      packetBuffer[len] = 0;
    if(packetBuffer[0]=='s'){
      char* substring = packetBuffer + 2; // Zeiger auf den 3. Charakter erstellen
      int angle = atoi(substring); // von Zeichenkette zu int umwandeln
      //Serial.println(angle);
      //myservo.write(angle);
      input_number = substring;
      long servoInput = angle;

       if(!check_input_number_string() || servoInput < 0) {
        Serial.println("err_input_num");
      } else {
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("err_input_range");
        } else {
          targetPos = (int) servoInput;
          Serial.println(servoInput);
        }
      }

    }
    
    else if (packetBuffer[0]=='p') {
      Serial.print("p ");
      Serial.println(pos);
    }

    else if(packetBuffer[0]=='l') {
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
  }

  // Set to pos to targetPos immediately. Maybe readd lower code later for velocity constraining
  pos = targetPos;

  // if(pos < targetPos) {
  //   pos += min(STEP_INCREASE, targetPos - pos);
  // } else if(pos > targetPos) {
  //   pos -= min(STEP_INCREASE, pos - targetPos);
  // }

  malletServo.write(pos);
  udp.beginPacket(udp.remoteIP(), udp.remotePort());
  udp.write("ACK");
  udp.endPacket();
  
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


