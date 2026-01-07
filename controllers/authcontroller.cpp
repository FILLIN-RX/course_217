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

    // AJOUT DE Q_INVOKABLE : Permet l'appel depuis Register.qml
    Q_INVOKABLE void signUp(const QString &email, const QString &password) {
        sendRequest(Config::SUPABASE_URL + "/auth/v1/signup", email, password, true);
    }

    Q_INVOKABLE void signIn(const QString &email, const QString &password) {
        sendRequest(Config::SUPABASE_URL + "/auth/v1/token?grant_type=password", email, password, false);
    }

signals:
    // SIGNAUX : Indispensables pour le bloc Connections en QML
    void signUpSuccess(const QJsonObject &user);
    void errorOccurred(const QString &message);

private:
    QNetworkAccessManager *manager;

    void sendRequest(const QString &endpoint, const QString &email, const QString &password, bool isSignUp) {
        QUrl url(endpoint);
        QNetworkRequest request(url);

        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QJsonObject json;
        json["email"] = email;
        json["password"] = password;

        QNetworkReply *reply = manager->post(request, QJsonDocument(json).toJson());

        // Capture de 'this' pour pouvoir émettre les signaux
        connect(reply, &QNetworkReply::finished, [this, reply, isSignUp]() {
            if (reply->error() == QNetworkReply::NoError) {
                QByteArray data = reply->readAll();
                QJsonDocument doc = QJsonDocument::fromJson(data);
                qDebug() << "✅ RÉUSSITE :" << data;
                
                if (isSignUp) {
                    emit signUpSuccess(doc.object()); // Envoie le signal au QML
                }
            } else {
                QString errorMsg = reply->errorString();
                qDebug() << "❌ ERREUR :" << errorMsg;
                emit errorOccurred(errorMsg); // Envoie l'erreur au QML
            }
            reply->deleteLater();
        });
    }
};

#endif