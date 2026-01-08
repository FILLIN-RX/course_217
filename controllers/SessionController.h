#ifndef SESSIONCONTROLLER_H
#define SESSIONCONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "../config/Config.h"

class SessionController : public QObject
{
    Q_OBJECT
public:
    explicit SessionController(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
    }

    // --- 1. RÉCUPÉRER TOUTES LES SÉANCES (Vue Admin / Chef de Dept) ---
    Q_INVOKABLE void fetchSessionsWithDetails() {
        // Syntaxe Supabase pour récupérer les données liées (jointures)
        QString query = "/rest/v1/seance?select=*,matiere(intitule,code),salle(nom),groupe(nom),enseignant(utilisateurs(nom,prenom))";
        
        QUrl url(Config::SUPABASE_URL + query);
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                emit sessionsLoaded(reply->readAll());
            } else {
                qDebug() << "Erreur Fetch Sessions:" << reply->errorString();
            }
            reply->deleteLater();
        });
    }

    // --- 2. RÉCUPÉRER LES SÉANCES D'UN PROF PRÉCIS (Pour TeacherDashboard) ---
    Q_INVOKABLE void fetchSessionsByTeacher(int teacherId) {
        // On filtre par l'ID de l'enseignant
        QString query = QString("/rest/v1/seance?enseignant_id=eq.%1&select=*,matiere(intitule,code),salle(nom,batiment),groupe(nom)").arg(teacherId);
        
        QUrl url(Config::SUPABASE_URL + query);
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                emit sessionsLoaded(reply->readAll());
            }
            reply->deleteLater();
        });
    }

    // --- 3. CRÉER UNE NOUVELLE SÉANCE (Planification) ---
    Q_INVOKABLE void addSession(int matiereId, int enseignantId, int salleId, int groupeId, 
                                QString type, QString date, QString debut, QString fin) {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/seance");
        QNetworkRequest request(url);
        
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QJsonObject session;
        session["matiere_id"] = matiereId;
        session["enseignant_id"] = enseignantId;
        session["salle_id"] = salleId;
        session["groupe_id"] = groupeId;
        session["type"] = type; // 'CM', 'TD' ou 'TP'
        session["date_seance"] = date; // Format YYYY-MM-DD
        session["heure_debut"] = debut; // Format HH:MM:SS
        session["heure_fin"] = fin;
        session["etat"] = "proposé";

        QNetworkReply *reply = manager->post(request, QJsonDocument(session).toJson());
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            bool success = (reply->error() == QNetworkReply::NoError);
            emit sessionSaved(success);
            if (!success) qDebug() << "Erreur insertion séance:" << reply->readAll();
            reply->deleteLater();
        });
    }

    // --- 4. RÉCUPÉRER LA LISTE DES ENSEIGNANTS POUR LES COMBOBOX ---
    Q_INVOKABLE void fetchTeachersList() {
        // Récupère l'ID enseignant et le nom de l'utilisateur lié
        QUrl url(Config::SUPABASE_URL + "/rest/v1/enseignant?select=enseignant_id,utilisateurs(nom)");
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                emit teachersLoaded(reply->readAll());
            }
            reply->deleteLater();
        });
    }

signals:
    void sessionsLoaded(QString data);
    void sessionSaved(bool success);
    void teachersLoaded(QString data);

private:
    QNetworkAccessManager *manager;
};

#endif