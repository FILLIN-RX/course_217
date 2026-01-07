#ifndef SUPABASEAUTH_H
#define SUPABASEAUTH_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include "../config/Config.h"

class SupabaseAuth : public QObject {
    Q_OBJECT
public:
    explicit SupabaseAuth(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
    }

    // Q_INVOKABLE permet au bouton "S'inscrire" du QML d'appeler cette fonction
    Q_INVOKABLE void signUp(const QString &email, const QString &password) {
        sendRequest(Config::SUPABASE_URL + "/auth/v1/signup", email, password);
    }
    Q_INVOKABLE void signIn(const QString &email, const QString &password) {
        sendRequest(Config::SUPABASE_URL + "/auth/v1/token?grant_type=password", email, password);
    }

signals:
    // Signaux qui seront captés par le bloc "Connections" dans Register.qml
    void signUpSuccess(const QJsonObject &user);
    void signInSuccess(const QJsonObject &user);
    void errorOccurred(const QString &error);

private:
    QNetworkAccessManager *manager;

    void sendRequest(const QString &endpoint, const QString &email, const QString &password) {
        QUrl url(endpoint);
        QNetworkRequest request(url);

        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QJsonObject json;
        json["email"] = email;
        json["password"] = password;

        QNetworkReply *reply = manager->post(request, QJsonDocument(json).toJson());

        // Utilisation de [this] dans la lambda pour pouvoir émettre des signaux
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                QByteArray data = reply->readAll();
                qDebug() << "✅ RÉUSSITE :" << data;

                // On transforme la réponse texte en objet JSON
                QJsonDocument doc = QJsonDocument::fromJson(data);
                
                // --- CRUCIAL : On prévient le QML que c'est réussi ---
                emit signUpSuccess(doc.object());
            } else {
                QString errorMsg = reply->errorString();
                QByteArray details = reply->readAll();
                qDebug() << "❌ ERREUR :" << errorMsg << details;

                // --- CRUCIAL : On prévient le QML qu'il y a eu une erreur ---
                emit errorOccurred(errorMsg);
            }
            reply->deleteLater();
        });
    }
};

#endif // SUPABASEAUTH_H