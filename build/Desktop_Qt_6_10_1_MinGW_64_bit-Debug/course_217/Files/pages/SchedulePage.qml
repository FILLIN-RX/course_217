import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"

ScrollView {
    
    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    leftPadding: 20
    rightPadding: 20

    // Déclaration du Popup (Assurez-vous que le fichier SessionForm.qml existe)
    SessionForm { 
        id: sessionPopup 
    }

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

            RowLayout {
                spacing: 10
                Button { text: "<"; flat: true }
                Button { text: "Aujourd'hui" }
                Button { text: ">"; flat: true }
                Button {
                    text: "+ Nouvelle séance"
                    background: Rectangle { color: "#6366F1"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white"; font.bold: true; padding: 10 }
                    onClicked: sessionPopup.open() // Ouvrir manuellement aussi
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
            id: gridContainer
            Layout.fillWidth: true
            implicitHeight: 600
            color: "white"; radius: 12; border.color: "#F1F5F9"
            clip: true

            GridLayout {
                anchors.fill: parent
                columns: 7 
                rows: 11   
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

                // Cellules de la grille cliquables
                Repeater {
                    model: 10 * 7 
                    Rectangle {
                        id: cell
                        Layout.fillWidth: true; Layout.fillHeight: true
                        border.color: "#F8FAFC"
                        
                        // Propriétés de calcul pour cette cellule
                        property int dayIndex: index % 7
                        property int startHour: 8 + Math.floor(index / 7)
                        property string dayName: ["Heure", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"][dayIndex]

                        // Effet visuel au survol
                        color: (cellMouseArea.containsMouse && dayIndex > 0) ? "#F1F5F9" : "white"

                        Text {
                            visible: parent.dayIndex === 0
                            anchors.centerIn: parent
                            text: parent.startHour + ":00"
                            color: "#94A3B8"; font.pixelSize: 11
                        }

                        // --- ZONE D'ACTION ---
                        MouseArea {
                            id: cellMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: parent.dayIndex > 0 // Désactive le clic sur la colonne "Heure"

                            onClicked: {
                                // On formate l'heure (ex: "08:00")
                                let timeStr = (parent.startHour < 10 ? "0" : "") + parent.startHour + ":00"
                                
                                // Injection des données dans le Popup
                                sessionPopup.selectedDay = parent.dayName
                                sessionPopup.selectedTime = timeStr
                                sessionPopup.open()
                            }
                        }
                    }
                }
            }

            // --- PLACEMENT DES COURS EXISTANTS ---
            ScheduleCard {
                x: parent.width / 7 * 1; y: 40
                width: parent.width / 7 - 4; height: 100
                title: "Génie Logiciel"; teacher: "Prof. Aboubakar"; room: "Amphi 500"
            }
            // ... autres cartes
        }
    }
}