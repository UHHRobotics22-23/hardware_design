
#include <WiFi.h>
#include <WiFiClient.h>
#include <Servo.h>
#include <iostream>
#include <string>
// Calibration Offset

int DELAY_MS = 5;
int STEP_INCREASE = 1;
int MAX_VALUE = 140;
int MIN_VALUE = 70;
int RESOLUTION = 180;

String input;
String input_number;
String l_send;
String p_send;
String s_send;
String err_send;

Servo malletServo;

int targetPos = 140;
int pos = 140;
char packetBuffer[255];
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
  memset(packetBuffer, -1, 255);
  int packetSize = udp.parsePacket();
  if(pos == targetPos || packetSize > 0) {
    int len = udp.read(packetBuffer, 255);

    if (len > 0) {
      if(packetBuffer[0]=='s') {
        input_number = "";
        if(packetBuffer[4] >= '0' && packetBuffer[4] <= '9') {
          input_number.concat(packetBuffer[2]);
          input_number.concat(packetBuffer[3]);
          input_number.concat(packetBuffer[4]);
        }
        else if(packetBuffer[3] >= '0' && packetBuffer[3] <= '9') {
          input_number.concat(packetBuffer[2]);
          input_number.concat(packetBuffer[3]);
        }
        else{
          input_number.concat(packetBuffer[2]);
        }
      long servoInput = input_number.toInt();
      if(servoInput < 0) {
        Serial.println("err_input_num");
        udp_sender("err_input_num");
        }
      else {
        if(((int) servoInput) < MIN_VALUE || ((int) servoInput) > MAX_VALUE) {
          Serial.println("err_input_range");
          udp_sender("err_input_range");
        } 
        else {
          targetPos = input_number.toInt();
          udp_sender("ok");
          
        }
      }

      }
      //The actual postion is send to ROS
      else if (packetBuffer[0]=='p') {
        p_send ="p ";
        p_send.concat(pos);
        udp_sender(p_send);
      }

      else if(packetBuffer[0]=='l') {
        l_send ="l ";
        l_send.concat(MIN_VALUE);
        l_send.concat(" ");
        l_send.concat(MAX_VALUE);
        l_send.concat(" ");
        l_send.concat(RESOLUTION);
        
        udp_sender(l_send);
     
      }

      else {
        err_send ="err_cmd";
        udp_sender(err_send);
        Serial.println("err_cmd");
      }
    }
  }
  // Set to pos to targetPos immediately. Maybe readd lower code later for velocity constraining
  
  pos = targetPos;
  // Ok, hear me out. We need to double scale this because someone in the pico w servo library made a oopsi
  malletServo.write((pos - 140) * 2 + 140);
}

void udp_sender(String sender_message){

  udp.beginPacket(udp.remoteIP(), udp.remotePort());
  udp.write(sender_message.c_str());
  udp.endPacket();
}