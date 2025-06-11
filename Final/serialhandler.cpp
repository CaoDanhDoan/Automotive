#include "serialhandler.h"
#include <QDebug>

SerialHandler::SerialHandler(QObject *parent)
    : QObject(parent)
{
    serial.setPortName("/dev/ttyUSB0");  // Chỉnh cho đúng cổng ESP32
    serial.setBaudRate(QSerialPort::Baud115200);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    serial.setFlowControl(QSerialPort::NoFlowControl);

    if (serial.open(QIODevice::ReadWrite)) {
        connect(&serial, &QSerialPort::readyRead, this, &SerialHandler::readSerial);
        qDebug() << "Serial connected!";
    } else {
        qDebug() << "Serial open failed!";
    }
}

void SerialHandler::sendCommand(const QString &cmd) {
    QString fullCmd = cmd + "\n";  // Gửi lệnh có xuống dòng
    serial.write(fullCmd.toUtf8());
}

void SerialHandler::readSerial() {
    buffer += serial.readAll();

    while (buffer.contains('\n')) {
        int index = buffer.indexOf('\n');
        QString line = buffer.left(index).trimmed();
        buffer = buffer.mid(index + 1);

        parseLine(line);
    }
}

void SerialHandler::parseLine(const QString &line) {
    qDebug() << "Received:" << line;

    if (line.startsWith("WiFi:")) {
        m_wifiList.append(line);
        emit wifiListChanged();
    }
    else if (line.startsWith("BLE:")) {
        m_bleList.append(line); // Cập nhật danh sách Bluetooth
        emit bleListChanged();
    }
    else if (line.contains("Start WiFi scan")) {
        m_wifiList.clear();
        emit wifiListChanged();
    }
    else if (line.contains("Start BLE scan") || line.contains("Disconnecting BLE")) {
        m_bleList.clear();
        emit bleListChanged();
    }
    else if (line.startsWith("Connecting to SSID:")) {
        QString ssid = line.mid(QString("Connecting to SSID:").length()).trimmed();
        if (!ssid.isEmpty()) {
            m_connectedSSID = ssid;
            emit connectedSSIDChanged();
        }
    }
    else if (line.contains("WiFi connected")) {
        qDebug() << "[INFO] WiFi connected!";
        m_wifiConnected = true;
        emit wifiConnectedChanged();
    }
    else if (line.contains("Failed to connect")) {
        qDebug() << "[ERROR] WiFi connection failed!";
        m_wifiConnected = false;
        emit wifiConnectedChanged();

        m_connectedSSID.clear();
        emit connectedSSIDChanged();
    }
    else if (line.contains("Found BLE Device:")) {  // Xử lý thiết bị BLE tìm thấy
        m_bleList.append(line);
        emit bleListChanged();
    }
    else if (line.contains("WiFi password incorrect")) {
        m_wifiConnected = false;
        emit wifiConnectedChanged();

        m_connectedSSID.clear();
        emit connectedSSIDChanged();

        emit wifiPasswordError();
    }
    else if (line.startsWith("Connected to BLE device:")) {
        QString macAddress = line.mid(QString("Connected to BLE device:").length()).trimmed();
        if (!macAddress.isEmpty()) {
            m_connectedMAC = macAddress;
            emit connectedMACChanged();
        }
        m_bleConnected = true;
        emit bleConnectedChanged();
    }
    else if (line.contains("Failed to connect to BLE device")) {
        qDebug() << "[ERROR] Failed to connect to BLE device!";
        m_bleConnected = false;
        emit bleConnectedChanged();

        m_connectedMAC.clear();
        emit connectedMACChanged();
    }
    else if (line.contains("Disconnecting WiFi")) {
        m_connectedSSID.clear();
        emit connectedSSIDChanged();
        m_wifiConnected = false;
        emit wifiConnectedChanged();
    }
    else if (line.contains("Disconnecting BLE")) {
        m_connectedMAC.clear();
        emit connectedMACChanged();
        m_bleConnected = false;
        emit bleConnectedChanged();
    }
    // --- Phần thêm: xử lý tín hiệu mô phỏng từ ESP32 ---
    else if (line == "CALL") {
        qDebug() << "[SIMULATION] Call requested!";
        emit callRequested();  // Gửi tín hiệu lên QML/UI
    }
    else if (line == "SMS") {
        qDebug() << "[SIMULATION] SMS requested!";
        emit smsRequested();   // Gửi tín hiệu lên QML/UI
    }
}
