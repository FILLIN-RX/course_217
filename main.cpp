#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext> // Indispensable pour exposer le C++ au QML
#include "controllers/authcontroller.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    // 1. Créer l'instance du contrôleur
    // On utilise l'instance pour que le QML puisse l'appeler
    SupabaseAuth authController;

    QQmlApplicationEngine engine;

    // 2. Exposer le contrôleur au QML
    // Le premier paramètre est le nom que tu utiliseras dans ton fichier .qml
    engine.rootContext()->setContextProperty("authController", &authController);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("course_217", "Main");

    return app.exec();
}