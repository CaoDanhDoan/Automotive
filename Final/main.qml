import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Style 1.0

import "./Component"
import "./Pages"

ApplicationWindow {
    id: root
    width: 1920
    height: 1080
    visible: true
    color: Style.background
    title: qsTr("Wireless Communication System")

    property StackView gEagleStack
    property string phoneNumber: ""

    background: Item {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            visible: Style.isDark
            source: "qrc:/Icons/dark/background.png"
        }
    }

    Component.onCompleted: root.showMaximized()

    header: Header {}

    footer: Footer {
        id: footerLayout
        onSettingsClicked: mainLoader.item.replace(null, settingsPage)
        onHomeClicked: mainLoader.item.replace(null, homePage)
        onContactClicked: mainLoader.item.replace(null, contactsPage)
        onMesClicked: mainLoader.item.replace(null, mesPage)
    }

    Component { id: homePage; HomePage {} }
    Component { id: mesPage; Messenger {} }
    Component { id: contactsPage; Contacts { objectName: "ContactsPage" } }

    Component {
        id: settingsPage
        SettingsPage {
            objectName: "SettingsPage"
            onBackToHome: mainLoader.item.replace(null, homePage)
        }
    }

    contentData: Loader {
        id: mainLoader
        anchors.fill: parent

        sourceComponent: StackView {
            id: mainStack
            initialItem: homePage

            Component.onCompleted: {
                root.gEagleStack = mainStack
            }

            onCurrentItemChanged: {
                footerLayout.visible = currentItem.objectName !== "SettingsPage"
            }
        }
    }

    // ================= Popups ===================
    Item {
        width: parent.width
        height: parent.height

        // Cuộc gọi đến
        Popup {
            id: callPopup
            modal: true
            focus: true
            width: 380
            height: 250
            x: (parent.width - width) / 2
            y: parent.height - height - 20
            closePolicy: Popup.CloseOnEscape

            background: Rectangle {
                color: "#fffdf2"
                radius: 12
                border.color: "#d0d0d0"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                PrefsLabel {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Style.h2
                    text: "Phone"
                }

                PrefsLabel {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Style.paragraph
                    text: "Số: " + root.phoneNumber
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 30

                    Rectangle {
                        width: 80; height: 80; radius: 40; color: "#FF3B30"
                        Image { anchors.centerIn: parent; source: "qrc:/Icons/calling/calling.svg" }
                        MouseArea { anchors.fill: parent; onClicked: callPopup.close() }
                    }

                    Rectangle {
                        width: 80; height: 80; radius: 40; color: "#007AFF"
                        Image { anchors.centerIn: parent; source: "qrc:/Icons/detail.svg"; height: 35; width: 35 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var incomingPage = Qt.createComponent("qrc:/Pages/Call.qml").createObject()
                                incomingPage.phoneNumber = root.phoneNumber
                                gEagleStack.push(incomingPage)
                                callPopup.close()
                            }
                        }
                    }

                    Rectangle {
                        width: 80; height: 80; radius: 40; color: "#34C759"
                        Image { anchors.centerIn: parent; source: "qrc:/Icons/calling/calling.svg" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var callPage = Qt.createComponent("qrc:/Pages/Callling.qml").createObject()
                                callPage.phoneNumber = root.phoneNumber
                                gEagleStack.push(callPage)
                                callPopup.close()
                            }
                        }
                    }
                }
            }
        }

        // Tin nhắn đến
        Popup {
            id: smsPopup
            modal: true
            focus: true
            width: 300
            height: 250
            x: (parent.width - width) / 2
            y: parent.height - height - 20
            closePolicy: Popup.CloseOnEscape

            property string senderPhone: ""
            property string messageText: ""

            background: Rectangle {
                color: "#fffdf2"
                radius: 12
                border.color: "#e6d89a"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                PrefsLabel {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Style.h2
                    text: "Messages:"
                }

                PrefsLabel {
                    font.pixelSize: Style.paragraph
                    text: "From: " + smsPopup.senderPhone
                }

                Rectangle {
                    color: "#ffffff"
                    radius: 8
                    Layout.fillWidth: true
                    height: 60
                    border.color: "#cccccc"

                    Text {
                        text: smsPopup.messageText
                        wrapMode: Text.Wrap
                        anchors.fill: parent
                        anchors.margins: 4
                        font.pixelSize: Style.paragraph
                        color: "#333"
                    }
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Đóng"
                    onClicked: smsPopup.close()
                }
            }
        }

        Connections {
            target: serialHandler

            onCallRequested: {
                root.phoneNumber = arguments[0] || "0123456789"
                callPopup.open()

                let contactPage = root.gEagleStack.find(function(item) {
                    return item.objectName === "ContactsPage"
                })

                if (contactPage) {
                    let now = new Date()
                    let timeStr = Qt.formatDateTime(now, "hh:mm:ss AP")
                    let foundName = "Unknown"

                    for (let i = 0; i < contactPage.contactModel.count; ++i) {
                        if (contactPage.contactModel.get(i).phone === root.phoneNumber) {
                            foundName = contactPage.contactModel.get(i).name
                            break
                        }
                    }

                    contactPage.appendCallHistory(foundName, root.phoneNumber, timeStr)
                }
            }

            onSmsRequested: {
                let phone = arguments[0] || "0999888777"
                let content = arguments[1] || "Have a good day!!"

                smsPopup.senderPhone = phone
                smsPopup.messageText = content
                smsPopup.open()

                let messengerPage = root.gEagleStack.find(function(item) {
                    return item.objectName === "MessengerPage"
                })

                if (messengerPage) {
                    messengerPage.appendReceivedMessage(phone, content)
                }
            }
        }
    }
}
