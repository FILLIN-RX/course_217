import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: teacherDb

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        // --- EN-TÊTE ---
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Bonjour, Pr. " + root.userName; font.pixelSize: 28; font.bold: true; color: "#0F172A" }
                Text { text: "Mercredi, 07 Janvier 2026"; color: "#64748B"; font.pixelSize: 16 }
            }
        }

        // --- CARTE COURS ACTUEL (LA PRIORITÉ) ---
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2563EB" }
                GradientStop { position: 1.0; color: "#1D4ED8" }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 30

                ColumnLayout {
                    spacing: 10
                    Rectangle {
                        width: 80; height: 26; radius: 13; color: "#38BDF8"
                        Text { anchors.centerIn: parent; text: "EN COURS"; color: "white"; font.bold: true; font.pixelSize: 11 }
                    }
                    Text { text: "Programmation C++ / Qt6"; color: "white"; font.pixelSize: 24; font.bold: true }
                    Text { text: "Salle: Amphi 500 | Groupe: L3 Informatique"; color: "#BFDBFE"; font.pixelSize: 16 }
                }

                Item { Layout.fillWidth: true }

                Button {
                    id: startBtn
                    Layout.preferredWidth: 200; Layout.preferredHeight: 50
                    background: Rectangle { color: "white"; radius: 10 }
                    contentItem: Text {
                        text: "Faire l'appel & Débuter"; color: "#2563EB"; font.bold: true;
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: console.log("Démarrage de la séance...")
                }
            }
        }

        // --- RÉSUMÉ DE LA JOURNÉE ---
        Text { text: "Prochains cours aujourd'hui"; font.pixelSize: 20; font.bold: true; color: "#1E293B" }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 15
            model: 2 // Statique pour l'instant
            delegate: Rectangle {
                width: parent.width; height: 80; radius: 12; border.color: "#E2E8F0"
                RowLayout {
                    anchors.fill: parent; anchors.margins: 20
                    Text { text: index === 0 ? "14:00" : "16:00"; font.bold: true; font.pixelSize: 16 }
                    Rectangle { width: 2; Layout.fillHeight: true; color: "#CBD5E1" }
                    ColumnLayout {
                        Text { text: index === 0 ? "Architecture des Systèmes" : "Algorithmique Avancée"; font.bold: true }
                        Text { text: "Salle TD 4 | Niveau L2"; color: "#64748B" }
                    }
                    Item { Layout.fillWidth: true }
                    Text { text: "\ue5cc"; font.family: "Material Icons"; color: "#94A3B8" }
                }
            }
        }
    }
}
