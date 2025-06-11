import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id: root
    objectName: "ContactsPage"
    property alias contactModel: contactModel

    function appendCallHistory(name, phone, time) {
        callHistoryModel.append({
            name: name,
            phone: phone,
            time: time
        })
    }

    ListModel {
        id: contactModel
        property alias model: contactModel
        ListElement { name: "Jonathan"; phone: "0123456789" }
        ListElement { name: "Alice"; phone: "0987654321" }
        ListElement { name: "Bob"; phone: "0212345678" }
        ListElement { name: "Charlie"; phone: "0932456789" }
    }

    ListModel {
        id: callHistoryModel
        ListElement { name: "Jonathan"; phone: "0123456789"; time: "10:30 AM" }
        ListElement { name: "Alice"; phone: "0987654321"; time: "2:15 PM" }
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        spacing: 20

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            TabButton { text: qsTr("Contacts") }
            TabButton { text: qsTr("Call History") }
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    ListView {
                        id: contactListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 12
                        clip: true
                        model: contactModel

                        delegate: Rectangle {
                            width: parent.width
                            height: 70
                            color: "#FFFFFF"
                            radius: 12
                            border.color: "#E0E0E0"
                            anchors.horizontalCenter: parent.horizontalCenter

                            RowLayout {
                                anchors.fill: parent
                                spacing: 10

                                Image {
                                    source: "qrc:/Icons/bottomIcons/cont2.svg"
                                    width: 40; height: 40
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    spacing: 5
                                    PrefsLabel {
                                        font.pixelSize: Style.paragraph
                                        color: "black"
                                        text: name
                                    }
                                    PrefsLabel {
                                        font.pixelSize: Style.paragraph
                                        color: Style.grayColor
                                        text: phone
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                IconButton {
                                    Layout.alignment: Qt.AlignVCenter
                                    setIcon: "qrc:/Icons/calling/fluent_call-add-20-filled.svg"
                                    onClicked: {
                                        var page = gEagleStack.push("qrc:/Pages/Callling.qml")
                                        page.phoneNumber = phone
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    ListView {
                        id: callHistoryListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 12
                        clip: true
                        model: callHistoryModel

                        delegate: Rectangle {
                            width: parent.width
                            height: 80
                            color: "#FFFFFF"
                            radius: 12
                            border.color: "#E0E0E0"
                            anchors.horizontalCenter: parent.horizontalCenter

                            RowLayout {
                                anchors.fill: parent
                                spacing: 10

                                Image {
                                    source: "qrc:/Icons/bottomIcons/cont2.svg"
                                    width: 40; height: 40
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    spacing: 5
                                    PrefsLabel {
                                        font.pixelSize: Style.paragraph
                                        color: "black"
                                        text: name
                                    }
                                    PrefsLabel {
                                        font.pixelSize: Style.paragraph
                                        color: Style.grayColor
                                        text: phone
                                    }
                                    PrefsLabel {
                                        font.pixelSize: Style.paragraph
                                        color: Style.grayColor
                                        text: time
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                IconButton {
                                    Layout.alignment: Qt.AlignVCenter
                                    setIcon: "qrc:/Icons/calling/fluent_call-add-20-filled.svg"
                                    onClicked: {
                                        var page = gEagleStack.push("qrc:/Pages/Callling.qml")
                                        page.phoneNumber = phone
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
