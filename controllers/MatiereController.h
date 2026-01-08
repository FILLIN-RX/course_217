// MatiereController.h
#ifndef MATIERECONTROLLER_H
#define MATIERECONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "../config/Config.h"

class MatiereController : public QObject {
    Q_OBJECT
public:
    explicit MatiereController(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
    }

    Q_INVOKABLE void fetchMatieres() {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/matiere?select=*");
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                emit matieresLoaded(reply->readAll()); // Émet le signal capté par QML
            }
            reply->deleteLater();
        });
    }

signals:
    void matieresLoaded(QString json);

private:
    QNetworkAccessManager *manager;
};
#endif
