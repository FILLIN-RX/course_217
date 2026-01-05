#include "authcontroller.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

AuthController::AuthController(QObject *parent) : QObject(parent) {
    // Constructeur vide
}

Q_INVOKABLE bool AuthController::registerUser(QString nom, QString prenom,
                                              QString email, QString mot_de_passe,
                                              QString telephone, QString role,
                                              QString type)
{
    QSqlQuery query;

    // Préparer l'insertion avec tous les champs
    query.prepare("INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe_hash, "
                  "telephone, role, type, date_creation) "
                  "VALUES (:nom, :prenom, :email, :mdp, :telephone, :role, :type, "
                  "CURRENT_TIMESTAMP)");

    query.bindValue(":nom", nom);
    query.bindValue(":prenom", prenom);
    query.bindValue(":email", email);
    query.bindValue(":mdp", mot_de_passe); // Note : Vous devriez hacher le mot de passe !
    query.bindValue(":telephone", telephone);
    query.bindValue(":role", role);
    query.bindValue(":type", type);

    if (query.exec()) {
        emit registrationSuccess();
        qDebug() << "Utilisateur créé avec succès dans la base !";
        return true;
    } else {
        emit registrationError(query.lastError().text());
        qDebug() << "Erreur lors de la création :" << query.lastError().text();
        return false;
    }
}
