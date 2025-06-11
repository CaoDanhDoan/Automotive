import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id: root
    width: parent.width
    leftPadding: 100

    property var serial: serialHandler

    contentData: RowLayout {
        width: root.width
        spacing: 20

        Pane {
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 0

            background: Rectangle {
                anchors.fill: parent
                color: Style.background
            }

            ColumnLayout {
                width: parent.width
                spacing: 30

                PrefsLabel {
                    Layout.alignment: Qt.AlignLeft
                    font.pixelSize: Style.h1
                    text: qsTr("Bluetooth")
                }

                SwitchDelegate {
                    Layout.preferredWidth: parent.width * 0.5
                    spacing: 20

                    background: Rectangle {
                        anchors.fill: parent
                        color: "#00B1B2"
                        radius: 7.9
                    }

                    contentItem: Item {
                        width: parent.width
                        RowLayout {
                            PrefsButton {
                                setIcon: "qrc:/Icons/bluetooth.svg"
                                backgroundColor: "#00000000"
                            }
                            PrefsLabel {
                                Layout.alignment: Qt.AlignLeft
                                text: qsTr("Bluetooth")
                            }
                        }
                    }

                    indicator: PrefsSwitch {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        checked: serial ? serial.bleSwitchOn : false

                        onToggled: {
                            if (serial) {
                                serial.bleSwitchOn = checked
                                if (checked) {
                                    serial.sendCommand("SCAN_BLE")
                                } else {
                                    serial.sendCommand("DISCONNECT_BLE")

                                }
                            }
                        }
                    }
                }
                PrefsLabel {
                    Layout.alignment: Qt.AlignLeft
                    font.pixelSize: Style.h4
                    color: Style.grayColor
                    text: qsTr("Select a BLE network to connect.")
                    visible: serial ? serial.bleSwitchOn : false
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    clip: true
                    spacing: 0
                    visible: serial ? serial.bleSwitchOn : false
                    model: serial ? serial.bleList : []

                    delegate: Rectangle {
                        width: root.width * 0.5  // hoặc giá trị cụ thể như 200
                        height: 60
                        color: isConnected ? "#eaffea" : "transparent"   // nền xanh nhạt nếu đang kết nối

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10

                                    Label {
                                        text: parts.length > 0 ? parts[0] : modelData
                                        font.pixelSize: 18
                                        font.bold: isConnected
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.alignment: Qt.AlignLeft
                                        Layout.fillWidth: true
                                        color: isConnected ? "#28a745" : "#333"
                                        leftPadding: 60
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (serial && parts.length > 1) {
                                            const mac = parts[1].trim()
                                            serial.sendCommand("CONNECT_BLE:" + mac)
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#cccccc"
                                opacity: 0.4
                            }
                        }

                        property var parts: modelData.split(",")
                        property bool isConnected: serial && modelData.split(",")[1].trim() === serial.connectedMAC

                    }
                }

            }
        }
    }
}
