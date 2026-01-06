import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"

ScrollView {
    anchors.fill: parent
    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    leftPadding: 20
    rightPadding: 20


    ColumnLayout {
        width: parent.width
        spacing: 20
        anchors.margins: 25

        // --- EN-TÊTE ---
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Emploi du temps"; font.pixelSize: 24; font.bold: true; color: "#1E293B" }
                Text { text: "Semaine du 27 au 31 Décembre 2024"; color: "#64748B" }
            }
            Item { Layout.fillWidth: true }

            // Sélecteur (Aujourd'hui, flèches)
            RowLayout {
                spacing: 10
                Button { text: "<"; flat: true }
                Button { text: "Aujourd'hui" }
                Button { text: ">"; flat: true }
                Button {
                    text: "+ Nouvelle séance"
                    background: Rectangle { color: "#6366F1"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white"; font.bold: true; padding: 10 }
                }
            }
        }

        // --- LÉGENDE ---
        RowLayout {
            spacing: 15
            LegendItem { label: "Cours (CM)"; color: "#6366F1" }
            LegendItem { label: "Travaux Dirigés (TD)"; color: "#F59E0B" }
            LegendItem { label: "Travaux Pratiques (TP)"; color: "#10B981" }
        }

        // --- GRILLE D'EMPLOI DU TEMPS ---
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 600
            color: "white"; radius: 12; border.color: "#F1F5F9"
            clip: true

            GridLayout {
                anchors.fill: parent
                columns: 7 // Heure + 6 Jours (Lundi-Samedi)
                rows: 11   // En-tête + Heures (08:00 à 18:00)
                columnSpacing: 0; rowSpacing: 0

                // En-têtes de colonnes (Jours)
                Repeater {
                    model: ["Heure", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 40
                        border.color: "#F8FAFC"
                        Text { anchors.centerIn: parent; text: modelData; font.bold: true; color: "#64748B"; font.pixelSize: 12 }
                    }
                }

                // Cellules de la grille (Heures et cases vides)
                Repeater {
                    model: 10 * 7 // 10 heures x 7 colonnes
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        border.color: "#F8FAFC"

                        // Affichage de l'heure dans la première colonne uniquement
                        Text {
                            visible: index % 7 === 0
                            anchors.centerIn: parent
                            text: (8 + Math.floor(index / 7)) + ":00"
                            color: "#94A3B8"; font.pixelSize: 11
                        }
                    }
                }
            }

            // --- PLACEMENT DES COURS (Positions absolues basées sur la grille) ---
            // Exemple : Lundi 8h (Colonne 1, Ligne 1)
            ScheduleCard {
                x: parent.width / 7 * 1; y: 40
                width: parent.width / 7 - 4; height: 100
                title: "Génie Logiciel"; teacher: "Prof. Aboubakar"; room: "Amphi 500"
            }

            ScheduleCard {
                x: parent.width / 7 * 1; y: 150
                width: parent.width / 7 - 4; height: 100
                title: "Base de Données"; teacher: "Dr. Sovanny"; room: "TD 12"; baseColor: "#F59E0B"
            }

            ScheduleCard {
                x: parent.width / 7 * 4; y: 250
                width: parent.width / 7 - 4; height: 120
                title: "Prog. Web"; teacher: "M. Nguélé"; room: "Labo 1"; baseColor: "#10B981"
            }
        }
    }
}
