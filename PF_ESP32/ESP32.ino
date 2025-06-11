#include "WiFi.h"
#include "BLEDevice.h"

BLEClient* pClient = nullptr;
bool isBLEConnected = false;

// LED
const int ledPinWiFi = 22;
const int ledPinBLE = 23;

// CALL/SMS button
#define CALL_BUTTON_PIN 12
#define SMS_BUTTON_PIN  13
unsigned long lastCallSentTime = 0;
unsigned long lastSmsSentTime  = 0;
const unsigned long triggerInterval = 3000;

void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(ledPinWiFi, OUTPUT);
  pinMode(ledPinBLE, OUTPUT);
  digitalWrite(ledPinWiFi, LOW);
  digitalWrite(ledPinBLE, LOW);

  pinMode(CALL_BUTTON_PIN, INPUT_PULLUP);
  pinMode(SMS_BUTTON_PIN, INPUT_PULLUP);

  Serial.println("ESP32 Ready");
}

void loop() {
  handleSerialCommand();
  handleButtons();
  delay(10);
}

// ============================
// Xử lý lệnh Serial
// ============================
void handleSerialCommand() {
  if (!Serial.available()) return;

  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  if (cmd == "SCAN_WIFI") {
    scanWiFi();
  }
  else if (cmd == "SCAN_BLE") {
    scanBLE();
  }
  else if (cmd.startsWith("CONNECT_WIFI,")) {
    handleConnectWiFi(cmd);
  }
  else if (cmd.startsWith("CONNECT_BLE:")) {
    handleConnectBLE(cmd);
  }
  else if (cmd == "DISCONNECT_WIFI") {
    handleDisconnectWiFi();
  }
  else if (cmd == "DISCONNECT_BLE") {
    handleDisconnectBLE();
  }
}

// ============================
// Xử lý nút bấm CALL / SMS
// ============================
void handleButtons() {
  int callState = digitalRead(CALL_BUTTON_PIN);
  int smsState  = digitalRead(SMS_BUTTON_PIN);
  unsigned long now = millis();

  if (callState == LOW && (now - lastCallSentTime) >= triggerInterval) {
    Serial.println("CALL");
    lastCallSentTime = now;
  }

  if (smsState == LOW && (now - lastSmsSentTime) >= triggerInterval) {
    Serial.println("SMS");
    lastSmsSentTime = now;
  }
}

// ============================
// Quét WiFi
// ============================
void scanWiFi() {
  Serial.println("Start WiFi scan...");
  WiFi.disconnect(true);
  delay(1000);

  int n = WiFi.scanNetworks();
  for (int i = 0; i < n; ++i) {
    Serial.printf("WiFi: %s, RSSI: %d\n", WiFi.SSID(i).c_str(), WiFi.RSSI(i));
  }
}

// ============================
// Quét BLE
// ============================
void scanBLE() {
  Serial.println("Start BLE scan...");
  BLEDevice::init("");
  BLEScan* pBLEScan = BLEDevice::getScan();
  pBLEScan->setActiveScan(true);

  unsigned long scanStartTime = millis();

  BLEScanResults* results = pBLEScan->start(10, false);  
  int count = results->getCount();

  if (count == 0) {
    Serial.printf("No device found after %lu ms\n", millis() - scanStartTime);
  } else {
    Serial.printf("Found %d BLE device(s):\n", count);
    for (int i = 0; i < count; i++) {
      BLEAdvertisedDevice d = results->getDevice(i);

      // Lấy tên hoặc gán "Unknown" nếu không có tên
      String name = d.haveName() ? d.getName().c_str() : "Unknown";

      Serial.printf("BLE: %s,%s, RSSI: %d\n",
                    name.c_str(),
                    d.getAddress().toString().c_str(),
                    d.getRSSI());
    }
  }

  pBLEScan->clearResults();
}



// ============================
// Kết nối WiFi
// ============================
void handleConnectWiFi(String cmd) {
  int firstComma = cmd.indexOf(',');
  int secondComma = cmd.indexOf(',', firstComma + 1);
  if (firstComma == -1 || secondComma == -1) {
    Serial.println("Error: Invalid CONNECT_WIFI format");
    return;
  }

  String ssid = cmd.substring(firstComma + 1, secondComma);
  String pass = cmd.substring(secondComma + 1);

  Serial.printf("Connecting to SSID: %s\n", ssid.c_str());
  WiFi.disconnect(true);
  WiFi.begin(ssid.c_str(), pass.c_str());

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < 10000) {
    delay(500);
    Serial.print(".");
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi connected!");
    Serial.print("IP: ");
    Serial.println(WiFi.localIP());
    blinkLED(ledPinWiFi, 3, 200);
    digitalWrite(ledPinWiFi, HIGH);
  } else {
    digitalWrite(ledPinWiFi, LOW);
    Serial.println("WiFi password incorrect");
  }
}

// ============================
// Kết nối BLE
// ============================
void handleConnectBLE(String cmd) {
  String mac = cmd.substring(String("CONNECT_BLE:").length());
  Serial.printf("Connecting to BLE device: %s\n", mac.c_str());

  BLEAddress bleAddr(mac.c_str());

  if (pClient != nullptr && pClient->isConnected()) {
    Serial.println("Disconnecting existing BLE connection...");
    pClient->disconnect();
    delete pClient;
    pClient = nullptr;
  }

  BLEDevice::init("");
  pClient = BLEDevice::createClient();

  if (pClient->connect(bleAddr)) {
    Serial.printf("Connected to BLE device: %s\n", mac.c_str());
    blinkLED(ledPinBLE, 3, 200);
    digitalWrite(ledPinBLE, HIGH);
  } else {
    Serial.println("Failed to connect to BLE device");
    digitalWrite(ledPinBLE, LOW);
  }
}

// ============================
// Ngắt kết nối
// ============================
void handleDisconnectWiFi() {
  Serial.println("Disconnecting WiFi...");
  WiFi.disconnect(true);
  digitalWrite(ledPinWiFi, LOW);
}

void handleDisconnectBLE() {
  Serial.println("Disconnecting BLE...");
  if (pClient != nullptr && pClient->isConnected()) {
    pClient->disconnect();
    delete pClient;
    pClient = nullptr;
  }
  digitalWrite(ledPinBLE, LOW);
}

// ============================
// Hàm nhấp nháy LED
// ============================
void blinkLED(int ledPin, int times, int delayMs) {
  for (int i = 0; i < times; i++) {
    digitalWrite(ledPin, HIGH);
    delay(delayMs);
    digitalWrite(ledPin, LOW);
    delay(delayMs);
  }
}
