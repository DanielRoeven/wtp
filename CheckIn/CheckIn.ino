// RFID Reader
//////////////////////

#include <SoftwareSerial.h>
#include <avr/pgmspace.h>

// Define tags that will be recognized

const char  tag_0[] PROGMEM = "3C00CDDB6b43";
const char  tag_1[] PROGMEM = "000000000000";
const char  tag_2[] PROGMEM = "000000000000";
const char  tag_3[] PROGMEM = "000000000000";
const char  tag_4[] PROGMEM = "000000000000";
const char  tag_5[] PROGMEM = "000000000000";

const char * const tag_table[] PROGMEM ={tag_0,tag_1,tag_2,tag_3,tag_4,tag_5};

SoftwareSerial rfidReader(2,3); // Digital pins 2 and 3 connect to pins 1 and 2 of the RMD6300
String tagString;
char tagNumber[14];
boolean receivedTag;
  
//LED Ring
//////////////////////

#include <Adafruit_NeoPixel.h>
#include "WS2812_Definitions.h"

#define PIN 4
#define LED_COUNT 16

// Create an instance of the Adafruit_NeoPixel class called "leds".
// That'll be what we refer to from here on...
Adafruit_NeoPixel leds = Adafruit_NeoPixel(LED_COUNT, PIN, NEO_GRB + NEO_KHZ800);

//////////////////////
// Setup
//////////////////////

void setup() {

  Serial.begin(9600);
  rfidReader.begin(9600); // the RDM6300 runs at 9600bps
  Serial.println("RFID Reader is ready!");

  leds.begin();  // Call this to start up the LED strip.
  clearLEDs();   // This function, defined below, turns all LEDs off...
  leds.show();   // ...but the LEDs don't actually update until you call this.

}

//////////////////////
// Loop
//////////////////////

void loop() {

// The loop will continuously check for a present RFID tag. 
// Once detected it will:
//    1. Check the ID
//    2. Check if ID is in database
//    3. Toggle check-in/out state
//    4. Perform according action on LED strip

  receivedTag=false;
  while (rfidReader.available()){
    int BytesRead = rfidReader.readBytesUntil(3, tagNumber, 15);//EOT (3) is the last character in tag
    Serial.println(BytesRead); 
    receivedTag=true;
  }  
 
  if (receivedTag){
    
    tagString=tagNumber;
    Serial.println();
    Serial.print("Tag Number: ");
    Serial.println(tagString);
    
    if (checkTag(tagString)){
      Serial.print("Tag Authorized...");
      showCheckIn(180); 

      //delay(2500);
      rfidReader.flush();

    }
    else{
      Serial.print("Unauthorized Tag: ");
      Serial.println(tagString);
      showUnknown(60);
      leds.show();

      //delay(2500);
      rfidReader.flush();
        
    }
    memset(tagNumber,0,sizeof(tagNumber)); //erase tagNumber
  }

}

//////////////////////
// Define functions
//////////////////////

boolean checkTag(String tag){
   char testTag[14];
   
   for (int i = 0; i < sizeof(tag_table)/2; i++)
   {
    strcpy_P(testTag, (char*)pgm_read_word(&(tag_table[i])));
    if(tag.substring(1,13)==testTag){//substring function removes SOT and EOT
      return true;
      break;
    }
  }
   return false;
 }

void checkState(){

  
 }


void showCheckIn(byte wait)
{
    clearLEDs();leds.show();  
    for (int i=LED_COUNT-1; i>=0; i--)
    {
      //clearLEDs();
      leds.setPixelColor(i+1, DARKDARKGREEN);
      leds.setPixelColor(i, SUPERGREEN);
      leds.setPixelColor(i-1, LIGHTGREEN);
      leds.show();
      delay(wait);
    }
}

void showCheckOut(byte wait)
{
    clearLEDs();leds.show();
    for (int i=0; i<LED_COUNT; i++)
    {
      //clearLEDs();  // Turn off all LEDs
      leds.setPixelColor(i, WHITE);  // Set just this one
      leds.show();
      delay(wait);
    }

}
 
void showUnknown(byte wait)
{
    clearLEDs();leds.show();
    for (int i=LED_COUNT-1; i>=0; i--)
    {
      //clearLEDs();
      leds.setPixelColor(i, RED);
      leds.show();
      delay(wait);
    }
}

void clearLEDs()
{
  for (int i=0; i<LED_COUNT; i++)
  {
    leds.setPixelColor(i, 0);
  }
}



void cascadeLEDs(unsigned long color, byte direction, byte wait)
{
  if (direction == TOP_DOWN)
  {
    for (int i=0; i<LED_COUNT; i++)
    {
      //clearLEDs();  // Turn off all LEDs
      leds.setPixelColor(i, color);  // Set just this one
      leds.show();
      delay(wait);
    }
  }
  else
  {
    for (int i=LED_COUNT-1; i>=0; i--)
    {
      //clearLEDs();
      leds.setPixelColor(i, color);
      leds.show();
      delay(wait);
    }
  }
  clearLEDs();
  leds.show();
}

