#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QSqlDatabase>

class DatabaseManager
{
public:
    DatabaseManager(); // Constructeur
    bool setupTable(); // Fonction pour créer les tables

private:
    QSqlDatabase m_database;
};

#endif // DATABASEMANAGER_H
