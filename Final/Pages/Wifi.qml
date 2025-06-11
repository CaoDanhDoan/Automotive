import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Style 1.0
import "../Component"

EaglePage {
    id: root
    width: parent.width
    leftPadding: 100

    property var serial: serialHandler
    property string selectedSSID: ""

    Component.onCompleted: {
        if (serial) {
            serial.wifiPasswordError.connect(() => {
                passwordErrorDialog.open()
            })
        }
    }

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
                    text: qsTr("Wifi")
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
                                setIcon: "qrc:/Icons/Wifi.svg"
                                backgroundColor: "#00000000"
                            }
                            PrefsLabel {
                                Layout.alignment: Qt.AlignLeft
                                text: qsTr("Wifi")
                            }
                        }
                    }

                    indicator: PrefsSwitch {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        checked: serial ? serial.wifiSwitchOn : false
                        onToggled: {
                            if (serial) {
                                serial.wifiSwitchOn = checked
                                if (checked) {
                                    serial.sendCommand("SCAN_WIFI")
                                } else {
                                    serial.sendCommand("DISCONNECT_WIFI")
                                    serial.wifiList = []
                                    serial.connectedSSID = ""
                                }
                            }
                        }

                    }
                }

                PrefsLabel {
                    Layout.alignment: Qt.AlignLeft
                    font.pixelSize: Style.h4
                    color: Style.grayColor
                    text: qsTr("Select a Wi-Fi network to connect.")
                    visible: serial ? serial.wifiSwitchOn : false
                }

                ListView {
                    Layout.preferredWidth: root.width * 0.5
                    Layout.preferredHeight: 300
                    Layout.alignment: Qt.AlignLeft
                    clip: true
                    spacing: 5

                    visible: serial ? serial.wifiSwitchOn : false
                    model: serial ? serial.wifiList : []

                    delegate: ItemDelegate {
                        width: ListView.view ? ListView.view.width : 300

                        property var parts: modelData.replace("WiFi: ", "").split(",")
                        property bool isConnected: typeof serial.connectedSSID === "string" && parts.length > 0 && parts[0] === serial.connectedSSID

                        background: Rectangle {
                            color: isConnected ? "#eaffea" : "transparent"
                            radius: 5
                        }

                        contentItem: ColumnLayout {
                            width: parent ? parent.width : 300
                            spacing: 5

                            Label {
                                text: parts.length > 0 ? parts[0] : modelData
                                font.pixelSize: 18
                                font.bold: isConnected
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                Layout.alignment: Qt.AlignLeft
                                Layout.fillWidth: true
                                leftPadding: 50
                                color: isConnected ? "#28a745" : "#333"
                            }

                            Rectangle {
                                width: parent ? parent.width : 300
                                height: 1
                                color: "#ccc"
                            }
                        }

                        onClicked: {
                            if (parts.length > 0) {
                                selectedSSID = parts[0]
                                passwordField.text = ""
                                passwordDialog.open()
                            }
                        }
                    }
                }

                Dialog {
                    id: passwordDialog
                    title: "Enter Password"
                    standardButtons: Dialog.Ok | Dialog.Cancel
                    visible: false

                    contentItem: ColumnLayout {
                        spacing: 10
                        TextField {
                            id: passwordField
                            placeholderText: "Enter password for " + root.selectedSSID
                            echoMode: TextInput.Password
                            Layout.fillWidth: true
                            focus: true

                            Keys.onReturnPressed: passwordDialog.accept()
                        }
                    }

                    onAccepted: {
                        if (serial && root.selectedSSID.length > 0 && passwordField.text.length > 0) {
                            let cleanSSID = root.selectedSSID.replace("WiFi: ", "").trim()
                            let command = "CONNECT_WIFI," + cleanSSID + "," + passwordField.text
                            serial.sendCommand(command)
                        }
                    }
                }

                MessageDialog {
                    id: passwordErrorDialog
                    title: "Wi-Fi Connection Failed"
                    text: "Incorrect password. Please try again."
                    icon: StandardIcon.Critical
                    standardButtons: Dialog.Ok
                    onAccepted: {
                        passwordDialog.open()
                    }
                }
            }
        }
    }
}
