/* Create a WiFi access point and provide a web server on it. *
** For more details see http://42bots.com.
*/

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

IPAddress    apIP(42, 42, 42, 42);  // Defining a static IP address: local & gateway
                                    // Default IP in AP mode is 192.168.4.1

// WiFi access point settings
const char *ssid = "Dalan";
const char *password = "ordbajsa";
const long int rfid = 22342378;
const String json_part = "{\"rfid\":" + rfid;
const String json = json_part + "}";

// Define a web server at port 80 for HTTP
ESP8266WebServer server(80);

void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += ( server.method() == HTTP_GET ) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";

  for ( uint8_t i = 0; i < server.args(); i++ ) {
    message += " " + server.argName ( i ) + ": " + server.arg ( i ) + "\n";
  }

  server.send ( 404, "text/plain", message );
}

void setup() {
  
  delay(1000);
  Serial.begin(115200);
  Serial.println();
  Serial.println("Configuring access point...");

  //set-up the custom IP address
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));   // subnet FF FF FF 00  
  
  /* You can remove the password parameter if you want the AP to be open. */
  WiFi.softAP(ssid, password);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
 
  
  server.on("/", HTTP_OPTIONS, []() {
    server.sendHeader("Access-Control-Max-Age", "10000");
    server.sendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
    server.sendHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    server.send(200, "text/plain", "" );
  });

  server.on("/", HTTP_GET, []() {
    String response = "Time flies like an arrow, fruit flies like a banana!";
    Serial.println("Get request!");
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
    server.sendHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    server.send(200, "text/plain", response.c_str() );
  });

  server.onNotFound ( handleNotFound );
  
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();
}
