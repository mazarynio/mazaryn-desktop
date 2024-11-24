#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "signuphandler.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<SignupHandler>("com.mazaryn.handlers", 1, 0, "SignupHandler");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
    Qt::QueuedConnection);
    engine.loadFromModule("mazaryn-desktop", "Main");

    return app.exec();
}
