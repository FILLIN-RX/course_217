#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext> // Indispensable pour exposer le C++ au QML
#include "controllers/authcontroller.h"
#include "controllers/TeacherController.h"
#include "controllers/RoomController.h"
#include "controllers/SessionController.h"
#include "controllers/MatiereController.h"
#include "controllers/GroupeController.h"
// ...

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    // 1. Créer l'instance du contrôleur
    // On utilise l'instance pour que le QML puisse l'appeler
    SupabaseAuth authController;
    TeacherController teacherController;
    RoomController roomController;
    SessionController sessionController;
    MatiereController matiereController;
    GroupeController groupeController;

    QQmlApplicationEngine engine;

    // 2. Exposer le contrôleur au QML
    // Le premier paramètre est le nom que tu utiliseras dans ton fichier .qml
    // Dans main.cpp

    engine.rootContext()->setContextProperty("teacherController", &teacherController);
    engine.rootContext()->setContextProperty("authController", &authController);
    engine.rootContext()->setContextProperty("roomController", &roomController);
    engine.rootContext()->setContextProperty("sessionController", &sessionController);
    engine.rootContext()->setContextProperty("matiereController", &matiereController);
    engine.rootContext()->setContextProperty("groupeController", &groupeController);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("course_217", "Main");

    return app.exec();
}