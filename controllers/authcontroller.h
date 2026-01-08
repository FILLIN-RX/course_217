#ifndef SUPABASEAUTH_H
#define SUPABASEAUTH_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QCryptographicHash>
#include <QDebug>
#include "../config/Config.h"

class SupabaseAuth : public QObject {
    Q_OBJECT
public:
    explicit SupabaseAuth(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
    }

    // Fonction utilitaire pour HASHER le mot de passe
    QString hashPassword(const QString &password) {
        return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
    }

    // --- REGISTER : Avec Nom, Prénom et Hash ---
    Q_INVOKABLE void signUp(const QString &nom, const QString &prenom, const QString &email, const QString &password, const QString &type = "admin") {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/utilisateurs");
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QJsonObject user;
        user["nom"] = nom;
        user["prenom"] = prenom;
        user["email"] = email;
        user["mot_de_passe_hash"] = hashPassword(password); // On stocke le HASH
        user["type"] = type;

        QNetworkReply *reply = manager->post(request, QJsonDocument(user).toJson());
        
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                emit signUpSuccess();
            } else {
                qDebug() << "❌ Erreur SQL :" << reply->readAll();
                emit errorOccurred("Erreur lors de la création du compte.");
            }
            reply->deleteLater();
        });
    }

    // --- LOGIN : On compare l'email et le HASH du mot de passe saisi ---
    Q_INVOKABLE void signIn(const QString &email, const QString &password) {
        QString hashedInput = hashPassword(password);
        
        QString query = QString("/rest/v1/utilisateurs?email=eq.%1&mot_de_passe_hash=eq.%2&select=*")
                            .arg(email).arg(hashedInput);
        
        QUrl url(Config::SUPABASE_URL + query);
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                QJsonArray users = QJsonDocument::fromJson(reply->readAll()).array();
                if (!users.isEmpty()) {
                    // On renvoie l'objet utilisateur complet au QML
                    emit profileReceived(QJsonDocument(users.at(0).toObject()).toJson());
                } else {
                    emit errorOccurred("Email ou mot de passe incorrect.");
                }
            } else {
                emit errorOccurred("Erreur de connexion serveur.");
            }
            reply->deleteLater();
        });
    }

signals:
    void signUpSuccess();
    void profileReceived(const QByteArray &data);
    void errorOccurred(const QString &msg);

private:
    QNetworkAccessManager *manager;
};

#endif