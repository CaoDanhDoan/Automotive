import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import "../Component"
import Style 1.0

Page {
    padding: 0
    background: Rectangle {
        anchors.fill: parent
        color: Style.background
    }

    Item {
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: leftImage
            source: "qrc:/Icons/speedImg.png"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: parent.width/2.5
            scale: 1.1
            fillMode: Image.PreserveAspectFit
        }


        Image {
            id: rightImage
            source: "qrc:/Icons/tachoImg.png"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            width: parent.width/2.5
            scale: 1.1
            fillMode: Image.PreserveAspectFit
        }
        Image {
                  id: speedIndicator
                  source: "qrc:/Icons/Indicator.png"
                  width: leftImage.width / 2
                  height: leftImage.height / 2
                  x: 80
                  y: 230
                  scale: 0.9
                  fillMode: Image.PreserveAspectFit

                  Rotation {
                      id: speedIndicatorRotation
                      angle: 150
                  }

                  rotation: speedIndicatorRotation.angle
              }

              Image {
                  id: tachoIndicator
                  source: "qrc:/Icons/Indicator.png"
                  width: rightImage.width / 2
                  height: rightImage.height / 2
                  scale: 0.9
                  x: 1050
                  y: 230
                  fillMode: Image.PreserveAspectFit

                  Rotation {
                      id: tachoIndicatorRotation
                      angle: 150
                  }

                  rotation: tachoIndicatorRotation.angle
              }
    }
}
