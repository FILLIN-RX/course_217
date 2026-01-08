#ifndef GROUPECONTROLLER_H
#define GROUPECONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "../config/Config.h"

class GroupeController : public QObject
{
    Q_OBJECT
public:
    explicit GroupeController(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
    }

    // Fonction appelée par le QML : groupeController.fetchGroupes()
    Q_INVOKABLE void fetchGroupes() {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/groupe?select=*");
        QNetworkRequest request(url);

        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);

        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                QString jsonResponse = reply->readAll();
                // On émet le signal capté par Connections { function onGroupesLoaded(json) }
                emit groupesLoaded(jsonResponse);
            } else {
                qDebug() << "Erreur Supabase Groupe:" << reply->errorString();
            }
            reply->deleteLater();
        });
    }

signals:
    // Le nom du signal en C++ doit correspondre au handler QML (on + NomDuSignal)
    void groupesLoaded(QString json);

private:
    QNetworkAccessManager *manager;
};

#endif
