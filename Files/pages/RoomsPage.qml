import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

ScrollView {
    anchors.fill: parent
    contentWidth: availableWidth
    padding: 24

    ColumnLayout {
        width: parent.width - 48
        spacing: 24

        // --- TITRE ET BOUTON AJOUTER ---
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Gestion des salles"; font.pixelSize: 28; font.bold: true; color: "#0F172A" }
                Text { text: "Attribution et disponibilité des espaces"; font.pixelSize: 14; color: "#64748B" }
            }
            Item { Layout.fillWidth: true }
            Button {
                id: addRoomBtn
                contentItem: RowLayout {
                    spacing: 8
                    Text { text: "\ue145"; font.family: "Material Icons"; color: "white"; font.pixelSize: 18 }
                    Text { text: "Ajouter une salle"; color: "white"; font.bold: true }
                }
                background: Rectangle { implicitWidth: 160; implicitHeight: 40; radius: 8; color: "#1E40AF" }
            }
        }

        // --- STATS RAPIDES (Cartes du haut) ---
        RowLayout {
            Layout.fillWidth: true; spacing: 20

            // Exemple Stat: Total
            Rectangle {
                Layout.fillWidth: true; height: 100; radius: 12; color: "white"; border.color: "#F1F5F9"
                ColumnLayout { anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "Total salles"; font.pixelSize: 12; color: "#64748B" }
                    Text { text: "8"; font.pixelSize: 24; font.bold: true; color: "#1E293B" }
                }
            }
            // Exemple Stat: Disponibles
            Rectangle {
                Layout.fillWidth: true; height: 100; radius: 12; color: "white"; border.color: "#F1F5F9"
                ColumnLayout { anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "Disponibles"; font.pixelSize: 12; color: "#64748B" }
                    Text { text: "4"; font.pixelSize: 24; font.bold: true; color: "#16A34A" }
                }
            }
            // Exemple Stat: Occupées
            Rectangle {
                Layout.fillWidth: true; height: 100; radius: 12; color: "white"; border.color: "#F1F5F9"
                ColumnLayout { anchors.fill: parent; anchors.margins: 16; spacing: 4
                    Text { text: "Occupées"; font.pixelSize: 12; color: "#64748B" }
                    Text { text: "3"; font.pixelSize: 24; font.bold: true; color: "#DC2626" }
                }
            }
        }

        // --- BARRE DE RECHERCHE ---
        Rectangle {
            Layout.fillWidth: true; height: 44; radius: 8; color: "#F8FAFC"; border.color: "#E2E8F0"
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 12
                Text { text: "\ue8b6"; font.family: "Material Icons"; color: "#94A3B8" }
                TextField { placeholderText: "Rechercher une salle..."; Layout.fillWidth: true; background: null }
            }
        }

        // --- GRILLE DES SALLES ---
        Flow {
            Layout.fillWidth: true; spacing: 16

            RoomCard {
                name: "Amphi 500"; status: "Occupée"; type: "Amphithéâtre"
                currentCourse: "Génie Logiciel - CM"; occupationPercent: 85
            }
            RoomCard {
                name: "Amphi 300"; status: "Disponible"; type: "Amphithéâtre"; currentCourse: ""
            }
            RoomCard {
                name: "Amphi 200"; status: "Maintenance"; type: "Amphithéâtre"
                equipment: ["Vidéoprojecteur", "WiFi"]
            }
            RoomCard {
                name: "Salle TD 12"; status: "Occupée"; type: "Salle TD"; capacity: 50
                equipment: ["Tableau blanc", "WiFi"]
                currentCourse: "Base de Données - TD"; occupationPercent: 75
            }
            // Ajoute les autres ici...
        }
    }
}
