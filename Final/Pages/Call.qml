import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id: root
    property string phoneNumber: "0123456789" // số điện thoại gọi đến

    contentItem: ColumnLayout {
        anchors.fill: parent
        spacing: 30

        Image {
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/Icons/human1.png"
            width: 180
            height: 180
            fillMode: Image.PreserveAspectFit
        }

        PrefsLabel {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.h3
            color: Style.grayColor
            text: phoneNumber
        }

        PrefsLabel {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.paragraph
            color: "green"
            text: qsTr("Incoming Call...")
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 40

            // Nút từ chối
            Rectangle {
                width: 100
                height: 100
                radius: 50
                color: "#FF3B30"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        gEagleStack.pop()
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6
                    Image {
                        source: "qrc:/Icons/calling/calling.svg"
                        width: 32
                        height: 32
                    }
                }
            }

            // Nút nhận
            Rectangle {
                width: 100
                height: 100
                radius: 50
                color: "#34C759"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Chuyển sang trang gọi
                        var callPage = Qt.createComponent("Callling.qml").createObject()
                        callPage.phoneNumber = root.phoneNumber
                        gEagleStack.push(callPage)
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6
                    Image {
                        source: "qrc:/Icons/calling/calling.svg"
                        width: 32
                        height: 32
                    }
                }
            }
        }
    }
}
