import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: teacherSchedule

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 25

        Text { text: "Mon Emploi du Temps"; font.pixelSize: 28; font.bold: true; color: "#0F172A" }

        // Sélecteur de jour (Tabs)
        RowLayout {
            spacing: 10
            Repeater {
                model: ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"]
                Button {
                    id: dayBtn
                    text: modelData
                    property bool isToday: modelData === "Mer"
                    background: Rectangle {
                        implicitWidth: 60; implicitHeight: 40
                        radius: 8
                        color: dayBtn.isToday ? "#1E293B" : "transparent"
                        border.color: dayBtn.isToday ? "#1E293B" : "#E2E8F0"
                    }
                    contentItem: Text {
                        text: parent.text; color: dayBtn.isToday ? "white" : "#64748B"
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        font.bold: dayBtn.isToday
                    }
                }
            }
        }

        // Liste des séances du jour sélectionné
        ScrollView {
            Layout.fillWidth: true; Layout.fillHeight: true; clip: true
            ColumnLayout {
                width: parent.width - 20; spacing: 15

                // Exemple d'un bloc de cours
                Repeater {
                    model: 4
                    delegate: Rectangle {
                        Layout.fillWidth: true; height: 100; radius: 12
                        color: "#F8FAFC"; border.color: "#E2E8F0"
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 20; spacing: 20

                            Column {
                                Text { text: "08:00"; font.bold: true; font.pixelSize: 18; color: "#1E293B" }
                                Text { text: "10:00"; font.pixelSize: 14; color: "#64748B" }
                            }

                            Rectangle { width: 4; Layout.fillHeight: true; radius: 2; color: "#3B82F6" }

                            ColumnLayout {
                                Text { text: "Base de Données - TP"; font.bold: true; font.pixelSize: 16 }
                                RowLayout {
                                    Text { text: "\ue0c8"; font.family: "Material Icons"; font.pixelSize: 14; color: "#94A3B8" }
                                    Text { text: "Labo Info 2"; color: "#64748B" }
                                    Text { text: " • "; color: "#CBD5E1" }
                                    Text { text: "Groupe B"; color: "#64748B" }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
