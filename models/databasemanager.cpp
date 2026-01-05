#include "databasemanager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

DatabaseManager::DatabaseManager() {
    // Utiliser un chemin standard pour la base de données
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dbPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString dbFile = dbPath + "/mabase.sqlite";

    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName(dbFile);

    if (!m_database.open()) {
        qDebug() << "Erreur d'ouverture de la base de données :"
                 << m_database.lastError().text();
    } else {
        qDebug() << "Base de données connectée avec succès !";
        qDebug() << "Fichier :" << dbFile;

        // Créer les tables après connexion
        setupTable();
    }
}

bool DatabaseManager::setupTable() {
    bool allSuccess = true;
    QSqlQuery query;

    // 1. Table Utilisateurs
    QString createUsersTable =
        "CREATE TABLE IF NOT EXISTS utilisateurs ("
        "utilisateur_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "nom TEXT NOT NULL,"
        "prenom TEXT NOT NULL,"
        "email TEXT UNIQUE NOT NULL,"
        "mot_de_passe_hash TEXT NOT NULL,"
        "telephone TEXT,"
        "role TEXT NOT NULL DEFAULT 'etudiant',"
        "type TEXT,"
        "date_creation DATETIME DEFAULT CURRENT_TIMESTAMP"
        ")";

    if (!query.exec(createUsersTable)) {
        qDebug() << "Erreur création table utilisateurs :" << query.lastError().text();
        allSuccess = false;
    } else {
        qDebug() << "Table 'utilisateurs' créée avec succès !";
    }

    // 2. Table Enseignant
    QString createEnseignantTable =
        "CREATE TABLE IF NOT EXISTS enseignant ("
        "enseignant_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "utilisateur_id INTEGER NOT NULL UNIQUE,"
        "specialite TEXT,"
        "grade TEXT,"
        "FOREIGN KEY(utilisateur_id) REFERENCES utilisateurs(utilisateur_id) ON DELETE CASCADE"
        ")";

    if (!query.exec(createEnseignantTable)) {
        qDebug() << "Erreur création table enseignant :" << query.lastError().text();
        allSuccess = false;
    }

    // 3. Table Chef Département
    QString createChefTable =
        "CREATE TABLE IF NOT EXISTS chef_departement ("
        "chef_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "utilisateur_id INTEGER NOT NULL UNIQUE,"
        "departement_id INTEGER,"
        "FOREIGN KEY(utilisateur_id) REFERENCES utilisateurs(utilisateur_id) ON DELETE CASCADE"
        ")";

    if (!query.exec(createChefTable)) {
        qDebug() << "Erreur création table chef_departement :" << query.lastError().text();
        allSuccess = false;
    }

    // 4. Table Etudiant
    QString createEtudiantTable =
        "CREATE TABLE IF NOT EXISTS etudiant ("
        "etudiant_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "utilisateur_id INTEGER NOT NULL UNIQUE,"
        "numero_etudiant TEXT UNIQUE,"
        "niveau TEXT,"
        "parcours TEXT,"
        "FOREIGN KEY(utilisateur_id) REFERENCES utilisateurs(utilisateur_id) ON DELETE CASCADE"
        ")";

    if (!query.exec(createEtudiantTable)) {
        qDebug() << "Erreur création table etudiant :" << query.lastError().text();
        allSuccess = false;
    }

    return allSuccess;
}
