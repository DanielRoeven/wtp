//////////////////////
// RFID Reader Initializing
//////////////////////

#include <SPI.h>
#include <MFRC522.h>

constexpr uint8_t RST_PIN = 9;
constexpr uint8_t SS_PIN = 10;
 
MFRC522 rfid(SS_PIN, RST_PIN);    // Instance of the class

// Define tags & states that will be recognized
#include "tagIDs.h"

char knownID[6][9] = {ID0,  // White Card  90fb78a2
                      ID1,  // Blue Tag    3ea882b9
                      ID2,
                      ID3,
                      ID4,
                      ID5};

int  IDState[6] = {0, 0, 0, 0, 0, 0,};

//////////////////////
//LED Ring Initializing
//////////////////////

#include <Adafruit_NeoPixel.h>
#include "Definitions.h"

#define PIN 4
#define LED_COUNT 16

// Create an instance of the Adafruit_NeoPixel class called "leds".
Adafruit_NeoPixel leds = Adafruit_NeoPixel(LED_COUNT, PIN, NEO_GRB + NEO_KHZ800);


//////////////////////
// Setup
//////////////////////

void setup(){

  Serial.begin(9600); // Init Console
  SPI.begin();        // Init SPI bus
  rfid.PCD_Init();    // Init MFRC522 

  Serial.println("Now able to scan the MIFARE Classsic NUID.");

  pinMode(A0, OUTPUT);
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);
  pinMode(A4, OUTPUT);
  
  leds.begin();  // Call this to start up the LED strip.

  // Blink 3 times blue
  for (int i=0; i<3; i++){
    setLEDs(BLUE, 10);
    leds.show();
    delay(200);
    clearLEDs();   // This function, defined below, turns all LEDs off...
    leds.show();   // ...but the LEDs don't actually update until you call this.
    delay(250);
  }
}

//////////////////////
// Loop
//////////////////////

void loop(){

// The loop will continuously check for a present RFID tag. 
//    1. Check for a tag
//    1. Check the ID
//    2. Check if ID is known
//    3. Toggle check-in/out state
//    4. Perform according action on LED strip
//    5. Write to webpage


  // Look for new cards  
  if ( ! rfid.PICC_IsNewCardPresent())
    return;
  // Verify if the NUID has been read
  if ( !rfid.PICC_ReadCardSerial())
    return;

  // Check if the PICC is of Classic MIFARE type
  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI &&  
    piccType != MFRC522::PICC_TYPE_MIFARE_1K &&
    piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    Serial.println(F("Your tag is not of type MIFARE Classic."));
    return;
  }

  // Create string for scannedTagID
  char scannedTagID[9];
  sprintf(scannedTagID, "%02x%02x%02x%02x", rfid.uid.uidByte[0], rfid.uid.uidByte[1], rfid.uid.uidByte[2], rfid.uid.uidByte[3]);
  
  Serial.println("");
  Serial.println(scannedTagID);

  // Check if scanned tag is known, and which ID number it is
  boolean checkFound = false;
  for (int i=0; i<6; i++){
    if (strcmp(scannedTagID, knownID[i]) == 0){
      int currentID = i;
      checkFound = true;
      Serial.print("ID no.");
      Serial.println(i);

      if (IDState[i] == 0){       //Currently logged out, so trying to log in
        IDState[i] = 1;
        Serial.println("Now checked in!");
        switch (i) {
          case 0:
            digitalWrite(A0, HIGH);
            break;
          case 1:
            digitalWrite(A1, HIGH);
            break;
          case 2:
            digitalWrite(A2, HIGH);
            break;
          case 3:
            digitalWrite(A3, HIGH);
            break;
          case 4:
            digitalWrite(A4, HIGH);
            break;
          case 5:
            digitalWrite(A5, HIGH);
            break;
          default:
            Serial.println("Trying to activate unknown index");
        }
        showCheckIn(130);
      }
      else if (IDState[i] == 1){  //Currently logged in, so trying to log out
        IDState[i] = 0;
        Serial.println("Now checked out!");
        switch (i) {
          case 0:
            digitalWrite(A0, LOW);
            break;
          case 1:
            digitalWrite(A1, LOW);
            break;
          case 2:
            digitalWrite(A2, LOW);
            break;
          case 3:
            digitalWrite(A3, LOW);
            break;
          case 4:
            digitalWrite(A4, LOW);
            break;
          case 5:
            digitalWrite(A5, LOW);
            break;
          default:
            Serial.println("Trying to activate unknown index");
        }  
        showCheckOut(20);
      }
      else{    // This should never happen, so show in console if it does
        Serial.println("Wrong IDState");
        Serial.println("Current ID: ");
        Serial.print  (scannedTagID);
        Serial.println("State:      ");
        Serial.print  (IDState[i]);
      }
    }
  }

  if (!checkFound){
      Serial.println("Unknown ID");
      showUnknown(4); showUnknown(4); showUnknown(4);  
  }
  
  // Halt PICC
  rfid.PICC_HaltA();
  // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
}

//////////////////////
// Define functions
//////////////////////

void checkState(){

  
 }

void showCheckIn(byte wait){
    clearLEDs();leds.show();  
    for (int i=LED_COUNT-1; i>=0; i--){
      leds.setPixelColor(i+1, DARKDARKGREEN);
      leds.setPixelColor(i, SUPERGREEN);
      leds.setPixelColor(i-1, LIGHTGREEN);
      leds.show();
      delay(wait);
    }
    leds.setPixelColor(0, DARKDARKGREEN);
    leds.show();
}

void showCheckOut(byte wait){
    clearLEDs();leds.show();
    for (int i=0; i<LED_COUNT; i++){
      //clearLEDs();  // Turn off all LEDs
      leds.setPixelColor(i, GREY50);  // Set just this one
      leds.show();
      delay(wait);
    }
    for (int i=100; i>0; i--){
      setLEDs(GREY50, i);
      leds.show();
      delay(10);
    }

}
 
void showUnknown(byte wait){
    // What if the RFID tag is recognized, yet unknown
  
    clearLEDs();leds.show();
    pulseLEDs(RED, 1, wait); // color, step size (percentage), wait time
}

void readError(){
    // What if the RFID tag is not read properly
  
}

//////////////////////
// Define subfunctions
//////////////////////

void pulseLEDs(unsigned long color, byte res, byte wait){
  // This functions fades all LEDs simultaneously up and down


  
  // Fade up...
  for (int i=0; i<100; i=i+res){
    setLEDs(color, i);
    leds.show();
    delay(wait);
  }
  
  // ...and back!
  for (int i=100; i>0; i=i-res){
    setLEDs(color, i);
    leds.show();
    delay(wait);
  }
}

void clearLEDs(){
  for (int i=0; i<LED_COUNT; i++)
  {
    leds.setPixelColor(i, 0);
  }
}

void setLEDs(unsigned long color, float intensity){
  // This function assigns the same color to all LEDs
  // !!! Is there a way that the second argument does not have to be included? (Standard to 100)

  // Split the color into its RGB components (so we can factorize them individually)
  byte red = (color & 0xFF0000) >> 16;
  byte green = (color & 0x00FF00) >> 8;
  byte blue = (color & 0x0000FF);

  // Squaring the intensity factor gives a visually better change
  float s = (intensity/100)*(intensity/100); 
  
  // Set all LEDs to this color
  for (int i=0; i<LED_COUNT; i++)
  {
    leds.setPixelColor(i, red*s, green*s, blue*s);
  }
}
