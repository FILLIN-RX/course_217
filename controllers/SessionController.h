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
    // --- 3. CRÉER UNE NOUVELLE SÉANCE (Planification) ---
Q_INVOKABLE void addSession(int matiereId, int enseignantId, int salleId, int groupeId, 
                            QString type, QString date, QString debut, QString fin) {
    QUrl url(Config::SUPABASE_URL + "/rest/v1/seance");
    QNetworkRequest request(url);
    
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
    request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());
    request.setRawHeader("Prefer", "return=minimal"); // Important pour les INSERT

    QJsonObject session;
    session["matiere_id"] = matiereId;
    session["enseignant_id"] = enseignantId;
    session["salle_id"] = salleId;
    session["groupe_id"] = groupeId;
    session["type"] = type;
    session["date_seance"] = date;
    session["heure_debut"] = debut;
    session["heure_fin"] = fin;
    session["etat"] = "proposé";

    QByteArray jsonData = QJsonDocument(session).toJson();
    qDebug() << "📤 Envoi session:" << jsonData;

    QNetworkReply *reply = manager->post(request, jsonData);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "✅ Séance créée avec succès!";
            emit sessionSaved(true);
        } else {
            QString errorResponse = reply->readAll();
            qDebug() << "❌ Erreur insertion séance:" << errorResponse;
            emit sessionSaved(false);
        }
        reply->deleteLater();
    });
}

    // --- 4. RÉCUPÉRER LA LISTE DES ENSEIGNANTS POUR LES COMBOBOX ---
  Q_INVOKABLE void fetchTeachersList() {
    // Modification : utiliser !enseignant_utilisateur_id_fkey pour la jointure
    QUrl url(Config::SUPABASE_URL + "/rest/v1/enseignant?select=enseignant_id,utilisateurs!enseignant_utilisateur_id_fkey(nom)");
    
    QNetworkRequest request(url);
    request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
    request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QString response = reply->readAll();
            qDebug() << "DEBUG: Teachers response:" << response; // Ajoutez ce log
            emit teachersLoaded(response);
        } else {
            qDebug() << "Erreur fetchTeachersList:" << reply->errorString();
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