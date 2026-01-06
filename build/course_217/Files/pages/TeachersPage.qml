import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

ScrollView {
    id: teachersView
    anchors.fill: parent
    contentWidth: availableWidth
    padding: 20
    clip: true

    ColumnLayout {
        width: parent.width - 40 // Ajusté pour le padding
        spacing: 24

        // --- 1. TITRE ET DESCRIPTION ---
        ColumnLayout {
            spacing: 4
            Text {
                text: "Enseignants"
                font.pixelSize: 28; font.bold: true; color: "#0F172A"
            }
            Text {
                text: "Gestion du personnel enseignant du département"
                font.pixelSize: 14; color: "#64748B"
            }
        }

        // --- 2. ACTIONS (RECHERCHE + AJOUTER) ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            // Barre de Recherche
            Rectangle {
                Layout.fillWidth: true
                height: 44; radius: 10; color: "white"
                border.color: "#E2E8F0"

                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 12; spacing: 10
                    Text {
                        text: "\ue8b6" // Icône 'search'
                        font.family: "Material Icons"
                        font.pixelSize: 20; color: "#94A3B8"
                    }
                    TextField {
                        placeholderText: "Rechercher par nom, cours ou email..."
                        Layout.fillWidth: true
                        font.pixelSize: 14
                        background: null // Supprime la bordure par défaut
                        color: "#1E293B"
                    }
                }
            }

            // Bouton Ajouter
            Button {
                id: addBtn
                contentItem: RowLayout {
                    spacing: 8
                    Text {
                        text: "\ue145" // Icône 'add' (plus)
                        font.family: "Material Icons"
                        color: "white"; font.pixelSize: 20; font.bold: true
                    }
                    Text {
                        text: "Nouvel enseignant"; color: "white"
                        font.pixelSize: 14; font.weight: Font.DemiBold
                    }
                }
                background: Rectangle {
                    implicitWidth: 190; implicitHeight: 44; radius: 10
                    color: addBtn.down ? "#4338CA" : (addBtn.hovered ? "#4F46E5" : "#6366F1")
                }
            }
        }

        // --- 3. GRILLE DES ENSEIGNANTS ---
        // Utilisation de Flow pour que les cartes se rangent selon la largeur de l'écran
        Flow {
            Layout.fillWidth: true
            spacing: 20

            TeacherCard {
                name: "Prof. Aboubakar"; title: "Chef de Département"
                initials: "PA"; email: "azeukou@univ-yaounde1.cm"
                courses: ["Génie Logiciel", "Architecture"]
                weeklyHours: "12h"; totalHours: "156h"
                isActive: true
            }

            TeacherCard {
                name: "Dr. Marie Fouda"; title: "Maître de Conférences"
                initials: "MF"; email: "fouda@univ-yaounde1.cm"
                courses: ["Base de Données", "Big Data"]
                weeklyHours: "10h"; totalHours: "142h"
                isActive: true
            }

            TeacherCard {
                name: "Prof. Kwette"; title: "Professeur de Programmation"
                initials: "PK"; email: "bella@univ-yaounde1.cm"
                courses: ["Python", "Algorithmique"]
                weeklyHours: "08h"; totalHours: "98h"
                isActive: true
            }

            TeacherCard {
                name: "Dr. Samuel Mbarga"; title: "Chercheur IA"
                initials: "SM"; email: "mbarga@univ-yaounde1.cm"
                courses: ["Intelligence Artificielle", "ML"]
                weeklyHours: "0h"; totalHours: "120h"
                isActive: false
            }
        }
    }
}
