import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"

ScrollView {
    id: dashboardRoot
    anchors.fill: parent
    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    clip: true
    leftPadding: 20
    rightPadding: 20

    // Le ColumnLayout est le SEUL enfant direct du ScrollView.
    // Il gère l'empilement vertical de toutes les sections.
    ColumnLayout {
        width: dashboardRoot.availableWidth
        spacing: 25
        anchors.margins: 25

        // --- 1. EN-TÊTE ---
        ColumnLayout {
            spacing: 4
            Text {
                text: "Tableau de bord"
                font.pixelSize: 26; font.bold: true; color: "#1E293B"
            }
            Text {
                text: "Vue d'ensemble des activités académiques du département"
                font.pixelSize: 14; color: "#64748B"
            }
        }

        // --- 2. CARTES DE STATISTIQUES (Alignées horizontalement) ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            StatCard { title: "Séances aujourd'hui"; value: "24"; subValue: "8 CM • 10 TD • 6 TP"; trend: "↑ 12%"; iconSource: "\ue8b0"; Layout.fillWidth: true }
            StatCard { title: "Enseignants actifs"; value: "45"; subValue: "sur 52 inscrits"; isPrimary: true; iconSource: "\ue7ef"; Layout.fillWidth: true }
            StatCard { title: "Salles occupées"; value: "18/25"; subValue: "72% d'occupation"; iconSource: "\ue88a"; Layout.fillWidth: true }
            StatCard { title: "Séances effectuées"; value: "89%"; subValue: "cette semaine"; iconSource: "\ue86c"; Layout.fillWidth: true }
        }

        // --- 3. SECTION CENTRALE (SÉANCES + ACTIONS) ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 25

            // BLOC GAUCHE : LISTE DES SÉANCES
            Rectangle {
                Layout.fillWidth: true
                // On utilise implicitHeight pour que le rectangle s'adapte au contenu
                implicitHeight: sessionsList.implicitHeight + 40
                color: "white"; radius: 12; border.color: "#F1F5F9"

                ColumnLayout {
                    id: sessionsList
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    RowLayout {
                        Text { text: "Séances du jour"; font.bold: true; font.pixelSize: 18; color: "#1E293B" }
                        Item { Layout.fillWidth: true }
                        Text { text: "samedi 27 décembre"; color: "#94A3B8"; font.pixelSize: 13 }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        DailySessionItem { subject: "Génie Logiciel"; teacher: "Prof. Aboubakar"; room: "S008"; time: "08:00 - 10:00"; isCurrent: true; type: "CM" }
                        DailySessionItem { subject: "Base de Données"; teacher: "Dr. Sovanny"; room: "Salle TD 12"; time: "10:00 - 12:00"; type: "TD" }
                        DailySessionItem { subject: "Réseaux Informatiques"; teacher: "Dr. Messi"; room: "Labo Info 3"; time: "14:00 - 17:00"; type: "TP" }
                    }
                }
            }

            // BLOC DROITE : ACTIONS RAPIDES
            // ColumnLayout {
            //     Layout.preferredWidth: 320
            //     Layout.alignment: Qt.AlignTop // Aligne ce bloc en haut
            //     spacing: 15

            //     Text { text: "Actions rapides"; font.bold: true; font.pixelSize: 18; color: "#1E293B" }

            //     Button {
            //         Layout.fillWidth: true
            //         implicitHeight: 50
            //         background: Rectangle { radius: 10; color: "#6366F1" }
            //         contentItem: Text { text: "Nouvelle séance"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
            //     }

            //     // Pour les autres boutons, on peut utiliser des Rectangles simples pour le style
            //     Repeater {
            //         model: [
            //             {t: "Modifier emploi du temps", i: "\ue8ae"},
            //             {t: "Gérer les conflits", i: "\ue002"},
            //             {t: "Générer un rapport", i: "\ue8ad"}
            //         ]
            //         Rectangle {
            //             Layout.fillWidth: true; height: 60; radius: 10; border.color: "#F1F5F9"
            //             RowLayout {
            //                 anchors.fill: parent; anchors.margins: 12; spacing: 12
            //                 Rectangle { width: 32; height: 32; radius: 6; color: "#F8FAFC"
            //                     Text { anchors.centerIn: parent; text: modelData.i; font.family: "Material Icons"; color: "#6366F1" }
            //                 }
            //                 Text { text: modelData.t; font.pixelSize: 13; color: "#475569"; Layout.fillWidth: true }
            //             }
            //         }
            //     }
            // }
        }

        // --- 4. SECTION BAS DE PAGE ---
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 250
            radius: 12; color: "white"; border.color: "#F1F5F9"
            Text {
                anchors.centerIn: parent
                text: "Répartition hebdomadaire des séances"
                color: "#94A3B8"
            }
        }
    }
}
