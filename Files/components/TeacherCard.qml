import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    implicitWidth: 340
    implicitHeight: layout.implicitHeight + 32
    radius: 12
    color: "white"

    // Bordure très légère comme sur l'image
    border.color: "#F1F5F9"
    border.width: 1

    // Propriétés
    property string name: "Dr. Marie Fouda"
    property string title: "Maître de Conférences"
    property string email: "fouda@univ-yaounde1.cm"
    property string phone: "" // Optionnel
    property bool isActive: true
    property var courses: ["Base de Données", "Big Data"]
    property string weeklyHours: "10h"
    property string totalHours: "142h"
    property string initials: "MF"

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // --- EN-TÊTE (Avatar + Noms + Badge Statut) ---
        RowLayout {
            spacing: 12

            // Avatar Circulaire
            Rectangle {
                width: 48; height: 48; radius: 24
                color: "#EEF2FF"
                Text {
                    anchors.centerIn: parent
                    text: root.initials
                    font.pixelSize: 16; font.bold: true; color: "#6366F1"
                    opacity: 0.7
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                Text {
                    text: root.name
                    font.pixelSize: 15; font.bold: true; color: "#1E293B"
                }
                Text {
                    text: root.title
                    font.pixelSize: 12; color: "#64748B"
                }
            }

            // Badge "Actif" (Haut Droite)
            Rectangle {
                width: 50; height: 22; radius: 11
                color: root.isActive ? "#DCFCE7" : "#F1F5F9"
                Layout.alignment: Qt.AlignTop
                Text {
                    anchors.centerIn: parent
                    text: root.isActive ? "Actif" : "Absent"
                    color: root.isActive ? "#22C55E" : "#94A3B8"
                    font.pixelSize: 10; font.bold: true
                }
            }
        }

        // --- CONTACT (Email & Téléphone) ---
        ColumnLayout {
            spacing: 8

            // Email
            RowLayout {
                spacing: 8
                Text {
                    text: "\ue0be" // Icon 'mail_outline'
                    font.family: "Material Icons"; font.pixelSize: 16; color: "#94A3B8"
                }
                Text {
                    text: root.email
                    font.pixelSize: 12; color: "#64748B"
                }
            }

            // Téléphone (Vide sur l'image mais icône présente)
            RowLayout {
                spacing: 8
                Text {
                    text: "\ue0b0" // Icon 'phone'
                    font.family: "Material Icons"; font.pixelSize: 16; color: "#94A3B8"
                }
            }
        }

        // --- COURS ENSEIGNÉS ---
        ColumnLayout {
            spacing: 8
            RowLayout {
                spacing: 6
                Text {
                    text: "\ue02f" // Icon 'menu_book'
                    font.family: "Material Icons"; font.pixelSize: 16; color: "#94A3B8"
                }
                Text {
                    text: "Cours enseignés:"
                    font.pixelSize: 12; color: "#64748B"
                }
            }

            Flow {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: root.courses
                    Rectangle {
                        height: 24; radius: 12; color: "#F8FAFC"
                        width: txt.implicitWidth + 24
                        border.color: "#F1F5F9"
                        Text {
                            id: txt
                            anchors.centerIn: parent
                            text: modelData; font.pixelSize: 11; font.bold: true; color: "#1E293B"
                        }
                    }
                }
            }
        }

        // --- SÉPARATEUR ---
        Rectangle { Layout.fillWidth: true; height: 1; color: "#F1F5F9" }

        // --- STATISTIQUES (Bas de carte) ---
        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 4
                Text { text: "Cette semaine"; font.pixelSize: 11; color: "#94A3B8" }
                Text { text: root.weeklyHours; font.pixelSize: 16; font.bold: true; color: "#1E293B" }
            }

            Item { Layout.fillWidth: true } // Espaceur

            ColumnLayout {
                spacing: 4
                Text { text: "Total heures"; font.pixelSize: 11; color: "#94A3B8" }
                Text { text: root.totalHours; font.pixelSize: 16; font.bold: true; color: "#1E293B" }
            }
        }
    }
}
