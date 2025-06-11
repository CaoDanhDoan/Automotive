import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id: root
    objectName: "MessengerPage"

    function appendReceivedMessage(phone, message) {
        historyModel.append({
            type: "received",
            phone: phone,
            message: message
        })
    }

    Component {
        id: createMessagePopup
        Popup {
            width: 400; height: 350; modal: true; focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            background: Rectangle { color: "white"; radius: 12; border.color: "#cccccc" }

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 24; spacing: 20

                PrefsLabel { Layout.alignment: Qt.AlignHCenter; font.pixelSize: Style.h2; text: qsTr("New Message") }
                TextField {
                    id: phoneInput
                    placeholderText: qsTr("Enter phone number")
                    Layout.fillWidth: true
                    font.pixelSize: Style.paragraph
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegExpValidator { regExp: /^[0-9]{0,10}$/ }
                }
                TextArea {
                    id: messageInput
                    placeholderText: qsTr("Enter message content")
                    Layout.fillWidth: true; Layout.fillHeight: true
                    font.pixelSize: Style.paragraph; wrapMode: Text.Wrap
                }
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Style.h3
                    background: Rectangle { color: "white"; radius: 8 }
                    contentItem: RowLayout {
                        anchors.centerIn: parent; spacing: 8
                        Image { source: "qrc:/Icons/send.svg"; height: 24 }
                        Text { text: qsTr("Send"); font.pixelSize: Style.h3; color: "black" }
                    }
                    onClicked: {
                        if (phoneInput.text.trim() !== "" && messageInput.text.trim() !== "") {
                            historyModel.append({
                                type: "sent",
                                phone: phoneInput.text,
                                message: messageInput.text
                            })
                            phoneInput.text = ""
                            messageInput.text = ""
                            createMessagePopup.createObject(root).close()
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: historyModel
        ListElement { type: "received"; phone: "0123456789"; message: "Hi, are you free today?" }
        ListElement { type: "sent"; phone: "0987654321"; message: "Don't forget the meeting at 3 PM!" }
    }

    contentItem: ColumnLayout {
        width: root.width; height: root.height; spacing: 30
        PrefsLabel {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Style.h1
            color: Style.grayColor
            text: qsTr("Messages")
        }

        ListView {
            id: historyList
            Layout.alignment: Qt.AlignHCenter
            width: root.width * 0.6
            height: root.height * 0.7
            spacing: 16
            clip: true
            model: historyModel

            delegate: Rectangle {
                width: historyList.width
                height: textMessage.paintedHeight + textPhone.paintedHeight + 40
                color: type === "sent" ? "#E6F7FF" : "#FFF7E6"
                radius: 12
                border.color: "#E0E0E0"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10

                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 10

                    PrefsLabel {
                        id: textPhone
                        font.pixelSize: Style.paragraph
                        color: type === "sent" ? "#007ACC" : "#D35400"
                        text: (type === "sent" ? "To: " : "From: ") + phone
                    }

                    PrefsLabel {
                        id: textMessage
                        font.pixelSize: Style.paragraph
                        color: "black"
                        wrapMode: Text.Wrap
                        text: message
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter; spacing: 12
            IconButton {
                contentItem: Image { source: "qrc:/Icons/create.svg"; width: 20; height: 20 }
                onClicked: createMessagePopup.createObject(root).open()
            }
            PrefsLabel {
                font.pixelSize: Style.h3; color: Style.grayColor; text: qsTr("Create New Message")
            }
        }
    }
}
