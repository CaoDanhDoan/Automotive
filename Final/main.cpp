#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "serialhandler.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;


    SerialHandler serialHandler;
    engine.rootContext()->setContextProperty("serialHandler", &serialHandler); // Expose serialHandler

    qmlRegisterSingletonType(QStringLiteral("qrc:/StyleTheme.qml"),"Style",1,0,"Style");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
