import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import "../Component"

EaglePage {
    id:root
    width: parent.width
    leftPadding: 100
    header:RowLayout{
        width: parent.width
        spacing: 5
        PrefsLabel{
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 100
            font.pixelSize: Style.h2
            isStyle: true
            isBold: true
            text: qsTr("Sound")
        }

    }
}
