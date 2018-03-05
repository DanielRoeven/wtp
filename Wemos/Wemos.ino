#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

IPAddress    apIP(42, 42, 42, 42);  // Defining a static IP address: local & gateway
                                    // Default IP in AP mode is 192.168.4.1

// WiFi access point settings
const char *ssid = "Dalan";
const char *password = "ordbajsa";

// Define a web server at port 80 for HTTP
ESP8266WebServer server(80);

void setup() {
  
  delay(1000);
  Serial.begin(115200);
  Serial.println();
  Serial.println("Configuring access point...");

  //set-up the custom IP address
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));   // subnet FF FF FF 00  
  
  // You can remove the password parameter if you want the AP to be open.
  WiFi.softAP(ssid, password);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
 
  // If we receive a preflight request, respond with correct CORS headers.
  // Note: not used with basic "text/plain" request and content types.
  // So I don't think this is used, but keep it for safety / the future.
  server.on("/", HTTP_OPTIONS, []() {
    server.sendHeader("Access-Control-Max-Age", "10000");
    server.sendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
    server.sendHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    server.send(200, "text/plain", "" );
  });

  // Responding to regular GET requests with a CORS header
  server.on("/", HTTP_GET, []() {
    String response = "0,1,0,0,0,0";

    // Set CORS headers to allow access from any domain
    server.sendHeader("Access-Control-Allow-Origin", "*");
    server.sendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
    server.sendHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

    // Send response (with response as a C-style string)
    server.send(200, "text/plain", response.c_str() );
  });

  server.begin();
}

void loop() {
  server.handleClient();
}
