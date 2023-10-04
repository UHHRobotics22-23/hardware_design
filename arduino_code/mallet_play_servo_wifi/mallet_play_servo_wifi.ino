/**
 * The wifi based firmware for the two mallet servo controlled assembly.
 * Intended to be used with a Raspberry Pi Pico W as the code contains a workaround for the behaviour of the Servo library.
 */
#include <WiFi.h>
#include <WiFiClient.h>
#include <Servo.h>
#include <iostream>
#include <string>

int DELAY_MS = 5;       // Not used
int STEP_INCREASE = 1;  // Not used
int MAX_VALUE = 140;    // Max control value not creating collisions in the assembly
int MIN_VALUE = 70;     // Min control value not creating collisions in the assembly
int RESOLUTION = 180;   // Resolution of the control value. 180 as the standard write function for servos is used.

String input;           // Input "buffer" from the serial connection
String input_number;    // Input substring containing the command value number
String l_send;          // Send string "buffer" for l command
String p_send;          // Send string "buffer" for p command
String s_send;          // Send string "buffer" for s command
String err_send;        // Send string "buffer" for unknown commands

Servo malletServo;      // Servo Object

int targetPos = 140;    // target position. Used if slowly approaching the target
int pos = 140;          // target position. Used if slowly approaching the target
char packetBuffer[255]; // Buffer for udp packet data
// WIFI Setup
const char* ssid = "Marimbabot_Mallet"; // WIFI SSID
const char* password = "12345678";      // WIFI Password

// Set the IP address and port number for the server
// IP Adress: '192.168.42.1'
const uint16_t serverPort = 80;   // Not used
WiFiUDP udp;      // UDP Server

void setup() {
  Serial.begin(115200);
  malletServo.attach(2);    // Servo is controlled from pin 2
  malletServo.write(pos);

  // Connect to Wi-Fi network
  WiFi.softAP(ssid, password);
  Serial.println("Access Point created");

  // Start the server
  udp.begin(8888);          // UDP Server on port 8888
  Serial.print("Server listening on ");
}
void loop() {
  memset(packetBuffer, -1, 255);
  int packetSize = udp.parsePacket();
  if(pos == targetPos || packetSize > 0) {
    int len = udp.read(packetBuffer, 255);

    if (len > 0) {

      // Command for setting the position of the servo
      if(packetBuffer[0]=='s') {
        input_number = "";
        // Checking the amount of digits sent by the client
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

      // Converting to int and checking validity of number
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

      // Command for getting the current position of the servo
      //The actual postion is send to ROS
      else if (packetBuffer[0]=='p') {
        p_send ="p ";
        p_send.concat(pos);
        udp_sender(p_send);
      }

      // Command for getting the limits and resolution of the controller
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
  
  // Set to pos to targetPos immediately. Could add velocity constraining by limiting with a iteration based step
  pos = targetPos;

  // Ignore below command, was written after hours of debugging. But a two times multiplyer is needed
  // Ok, hear me out. We need to double scale this because someone in the pico w servo library made a oopsi
  malletServo.write((pos - 140) * 2 + 140);
}

// Simple helper function to send a udp reply
void udp_sender(String sender_message){

  udp.beginPacket(udp.remoteIP(), udp.remotePort());
  udp.write(sender_message.c_str());
  udp.endPacket();
}
