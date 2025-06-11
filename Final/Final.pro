QT += quick
QT += quick serialport

CONFIG += c++11
SOURCES += \
    main.cpp \
    serialhandler.cpp

HEADERS += \
    serialhandler.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += /usr/lib/x86_64-linux-gnu/qt5/qml

QML_DESIGNER_IMPORT_PATH =

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=
