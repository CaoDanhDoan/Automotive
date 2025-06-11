#ifndef SERIALHANDLER_H
#define SERIALHANDLER_H

#include <QObject>
#include <QSerialPort>

class SerialHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList wifiList READ wifiList NOTIFY wifiListChanged)
    Q_PROPERTY(QStringList bleList READ bleList NOTIFY bleListChanged)

    Q_PROPERTY(bool wifiSwitchOn READ wifiSwitchOn WRITE setWifiSwitchOn NOTIFY wifiSwitchOnChanged)
    Q_PROPERTY(bool bleSwitchOn READ bleSwitchOn WRITE setBleSwitchOn NOTIFY bleSwitchOnChanged)

    Q_PROPERTY(bool wifiConnected READ wifiConnected NOTIFY wifiConnectedChanged)
    Q_PROPERTY(bool bleConnected READ bleConnected NOTIFY bleConnectedChanged)

    Q_PROPERTY(QString connectedSSID READ connectedSSID NOTIFY connectedSSIDChanged)

    Q_PROPERTY(QString connectedMAC READ connectedMAC NOTIFY connectedMACChanged)
public:
    explicit SerialHandler(QObject *parent = nullptr);

    QString connectedSSID() const { return m_connectedSSID; }
    QString connectedMAC() const { return m_connectedMAC; }
    // Getter
    QStringList wifiList() const { return m_wifiList; }
    QStringList bleList() const { return m_bleList; }

    bool wifiSwitchOn() const { return m_wifiSwitchOn; }
    bool bleSwitchOn() const { return m_bleSwitchOn; }

    bool wifiConnected() const { return m_wifiConnected; }
    bool bleConnected() const { return m_bleConnected; }

    // Setter
    void setWifiSwitchOn(bool on) {
        if (m_wifiSwitchOn == on) return;
        m_wifiSwitchOn = on;
        emit wifiSwitchOnChanged();
    }

    void setBleSwitchOn(bool on) {
        if (m_bleSwitchOn == on) return;
        m_bleSwitchOn = on;
        emit bleSwitchOnChanged();
    }

    Q_INVOKABLE void sendCommand(const QString &cmd); // Gửi lệnh xuống ESP32

signals:
    void wifiListChanged();
    void bleListChanged();

    void wifiSwitchOnChanged();
    void bleSwitchOnChanged();

    void wifiConnectedChanged();
    void bleConnectedChanged();

    void connectedSSIDChanged();  // Signal khi SSID thay đổi
    void connectedMACChanged();   // Signal khi MAC address Bluetooth thay đổi
    void wifiPasswordError();

    // Các tín hiệu mô phỏng từ ESP32 gửi lên
    void callRequested();  // Khi ESP32 gửi "CALL"
    void smsRequested();   // Khi ESP32 gửi "SMS"

private slots:
    void readSerial();  // Đọc dữ liệu từ ESP32

private:
    void parseLine(const QString &line);  // Xử lý từng dòng từ ESP32

    QString m_connectedSSID;
    QString m_connectedMAC;

    QSerialPort serial;
    QString buffer;

    QStringList m_wifiList;
    QStringList m_bleList;

    bool m_wifiSwitchOn = false;
    bool m_bleSwitchOn = false;

    bool m_wifiConnected = false;
    bool m_bleConnected = false;
};

#endif // SERIALHANDLER_H
