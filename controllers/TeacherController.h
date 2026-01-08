#ifndef TEACHERCONTROLLER_H
#define TEACHERCONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QCryptographicHash>
#include <QDate>
#include <QDebug>
#include "../config/Config.h"

class TeacherController : public QObject
{
    Q_OBJECT
public:
    explicit TeacherController(QObject *parent = nullptr) : QObject(parent)
    {
        manager = new QNetworkAccessManager(this);
    }

    // Utilitaire pour hasher le mot de passe (doit être le même que AuthController)
    QString hashPassword(const QString &password)
    {
        return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
    }

    // --- CRÉATION ENSEIGNANT LIÉ À UN ADMIN ---
    Q_INVOKABLE void addTeacher(const QString &nom, const QString &prenom, const QString &email,
                                const QString &password, const QString &specialite,
                                const QString &grade, int adminId)
    {

        QUrl url(Config::SUPABASE_URL + "/rest/v1/utilisateurs");
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        // "return=representation" permet de récupérer l'ID immédiatement après l'INSERT
        request.setRawHeader("Prefer", "return=representation");

        QJsonObject user;
        user["nom"] = nom;
        user["prenom"] = prenom;
        user["email"] = email;
        user["mot_de_passe_hash"] = hashPassword(password);
        user["type"] = "enseignant";

        QNetworkReply *reply = manager->post(request, QJsonDocument(user).toJson());

        connect(reply, &QNetworkReply::finished, this, [this, reply, specialite, grade, adminId]()
                {
            if (reply->error() == QNetworkReply::NoError) {
                QJsonArray res = QJsonDocument::fromJson(reply->readAll()).array();
                if (!res.isEmpty()) {
                    int newUserId = res.at(0).toObject()["utilisateur_id"].toInt();
                    // Étape 2 : Créer l'entrée dans la table enseignant
                    this->insertTeacherDetails(newUserId, specialite, grade, adminId);
                }
            } else {
                qDebug() << "❌ Erreur Création Utilisateur :" << reply->readAll();
                emit errorOccurred("Impossible de créer le compte utilisateur.");
            }
            reply->deleteLater(); });
    }

    // --- RÉCUPÉRER LES PROFS D'UN ADMIN PRÉCIS ---
    Q_INVOKABLE void fetchMyTeachers(int adminId)
    {
        // Jointure SQL : on prend tout de 'enseignant' + nom/prenom/email de 'utilisateurs'
        // Filtre : cree_par_admin_id doit être égal à l'admin connecté
        // Dans TeacherController.h, fonction fetchMyTeachers
        // On précise qu'on veut les infos de l'enseignant (via la clé enseignant_utilisateur_id_fkey)
        QString query = QString("/rest/v1/enseignant?cree_par_admin_id=eq.%1&select=*,utilisateurs!enseignant_utilisateur_id_fkey(*)")
                            .arg(adminId);

        QUrl url(Config::SUPABASE_URL + query);
        QNetworkRequest request(url);
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, this, [this, reply]()
                {
            if (reply->error() == QNetworkReply::NoError) {
                emit teachersLoaded(reply->readAll());
            } else {
                qDebug() << "❌ Erreur Fetch :" << reply->readAll();
            }
            reply->deleteLater(); });
    }

private:
    // Insertion dans la table public.enseignant
    void insertTeacherDetails(int userId, const QString &spec, const QString &grade, int adminId)
    {
        QUrl url(Config::SUPABASE_URL + "/rest/v1/enseignant");
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("apikey", Config::SUPABASE_KEY.toUtf8());
        request.setRawHeader("Authorization", "Bearer " + Config::SUPABASE_KEY.toUtf8());

        QJsonObject details;
        details["utilisateur_id"] = userId;
        details["specialite"] = spec;
        details["grade"] = grade;
        details["cree_par_admin_id"] = adminId; // Lien vers l'admin qui l'a créé
        details["statut"] = "Actif";
        details["date_embauche"] = QDate::currentDate().toString(Qt::ISODate);

        QNetworkReply *reply = manager->post(request, QJsonDocument(details).toJson());
        connect(reply, &QNetworkReply::finished, this, [this, reply]()
                {
            if (reply->error() == QNetworkReply::NoError) {
                emit teacherAdded();
            } else {
                qDebug() << "❌ Erreur Détails Enseignant :" << reply->readAll();
            }
            reply->deleteLater(); });
    }

signals:
    void teacherAdded();
    void teachersLoaded(const QByteArray &data);
    void errorOccurred(const QString &msg);

private:
    QNetworkAccessManager *manager;
};

#endif