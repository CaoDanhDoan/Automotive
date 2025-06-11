import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id: root

    contentData: ColumnLayout {
        width: root.width
        spacing: 20

        RowLayout {
            width: parent.width
            Layout.alignment: Qt.AlignHCenter
            PrefsLabel {
                font.pixelSize: Style.h1
                text: qsTr("Members:")
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            RowLayout {
                spacing: 50

                RowLayout {
                    spacing: 10
                    PrefsLabel {
                        font.pixelSize: Style.h2
                        color: Style.grayColor
                        text: qsTr("Huynh Dang Phuong Au")
                    }
                    PrefsLabel {
                        isBold: true
                        font.pixelSize: Style.h2
                        text: qsTr("21CE067")
                    }
                }

                RowLayout {
                    spacing: 10
                    PrefsLabel {
                        font.pixelSize: Style.h2
                        color: Style.grayColor
                        text: qsTr("Vu Gia Bao")
                    }
                    PrefsLabel {
                        isBold: true
                        font.pixelSize: Style.h2
                        text: qsTr("21CE068")
                    }
                }

                RowLayout {
                    spacing: 10
                    PrefsLabel {
                        font.pixelSize: Style.h2
                        color: Style.grayColor
                        text: qsTr("La Thanh Canh")
                    }
                    PrefsLabel {
                        isBold: true
                        font.pixelSize: Style.h2
                        text: qsTr("21CE070")
                    }
                }
            }

            RowLayout {
                spacing: 100

                RowLayout {
                    spacing: 10
                    PrefsLabel {
                        font.pixelSize: Style.h2
                        color: Style.grayColor
                        text: qsTr("Doan Cao Danh")
                    }
                    PrefsLabel {
                        isBold: true
                        font.pixelSize: Style.h2
                        text: qsTr("21CE074")
                    }
                }

                RowLayout {
                    spacing: 10
                    PrefsLabel {
                        font.pixelSize: Style.h2
                        color: Style.grayColor
                        text: qsTr("Ton That Gia Hoang")
                    }
                    PrefsLabel {
                        isBold: true
                        font.pixelSize: Style.h2
                        text: qsTr("21CE089")
                    }
                }
            }
        }

        // Logo + tên trường
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Image {
                source: "qrc:/Icons/logo.png"
                width: 80
                height: 80
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}
