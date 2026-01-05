#ifndef AUTHCONTROLLER_H
#define AUTHCONTROLLER_H

#include <QObject>
#include <QString>

class AuthController : public QObject
{
    Q_OBJECT
public:
    explicit AuthController(QObject *parent = nullptr);

    // Fonction complète avec tous les paramètres
    Q_INVOKABLE bool registerUser(QString nom, QString prenom, QString email,
                                  QString mot_de_passe, QString telephone,
                                  QString role, QString type);

signals:
    void registrationSuccess();
    void registrationError(QString message);
};

#endif // AUTHCONTROLLER_H
