#ifndef ROOMCONTROLLER_H
#define ROOMCONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "../config/Config.h"

class RoomController : public QObject
{
    Q_OBJECT

public:
    explicit RoomController(QObject *parent = nullptr) : QObject(parent)
    {
        manager = new QNetworkAccessManager(this);
    }
    virtual ~RoomController() {}

    // --- RÉCUPÉRER LES SALLES D'UN ADMIN ---
    Q_INVOKABLE void fetchRooms(int adminId)
    {
        // Requête Supabase : Sélectionne les salles où cree_par_admin_id est égal à l'ID fourni
        QString query = QString("/rest/v1/salle?cree_par_admin_id=eq.%1&select=*")
                            .arg(adminId);

        QUrl url(Config::SUPABASE_URL + query);
        QNetworkRequest request(url);
        
        // Headers de sécurité Supabase 
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]()
        {
            if (reply->error() == QNetworkReply::NoError) {
    QByteArray response = reply->readAll();
    qDebug() << "✅ Réponse brute :" << response; // Pour débogage
    emit roomsLoaded(response);
} else {
    QByteArray error = reply->readAll();
    qDebug() << "❌ Erreur Fetch Rooms :" << error;
    emit errorOccurred(QString::fromUtf8(error));
}
            reply->deleteLater();
        });
    }

    // --- CRÉER UNE NOUVELLE SALLE ---
    Q_INVOKABLE void addRoom(int adminId, const QString &nom, const QString &type, int capacite)
    {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/salle");
        QNetworkRequest request(url);
        
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        // Construction de l'objet Salle
        QJsonObject room;
        room["nom"] = nom;
        room["type"] = type;
        room["capacite"] = capacite;
        room["cree_par_admin_id"] = adminId;

        QNetworkReply *reply = manager->post(request, QJsonDocument(room).toJson());
        
        connect(reply, &QNetworkReply::finished, this, [this, reply, adminId]()
        {
            if (reply->error() == QNetworkReply::NoError) {
                emit roomSaved(true, "Salle créée avec succès !");
                // Rafraîchir la liste automatiquement après l'ajout
                this->fetchRooms(adminId);
            } else {
                qDebug() << "❌ Erreur Création Salle :" << reply->readAll();
                emit roomSaved(false, "Erreur lors de la création de la salle.");
            }
            reply->deleteLater();
        });
    }

signals:
    void roomsLoaded(const QByteArray &data);
    void roomSaved(bool success, const QString &message);
    void errorOccurred(const QString &msg);

private:
    QNetworkAccessManager *manager;
};

#endif // ROOMCONTROLLER_H