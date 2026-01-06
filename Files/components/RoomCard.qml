import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    implicitWidth: 300
    implicitHeight: 380
    radius: 12
    color: "white"
    border.color: "#F1F5F9"
    border.width: 1

    // Propriétés de la salle
    property string name: "Amphi 500"
    property string type: "Amphithéâtre"
    property string status: "Occupée" // Occupée, Disponible, Maintenance
    property int capacity: 500
    property var equipment: ["Vidéoprojecteur", "Micro", "WiFi"]
    property string currentCourse: ""
    property int occupationPercent: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // En-tête : Nom et Statut
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: root.name
                font.pixelSize: 16; font.bold: true; color: "#1E293B"
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 75; height: 24; radius: 12
                color: status === "Occupée" ? "#FEE2E2" : (status === "Disponible" ? "#DCFCE7" : "#FFEDD5")
                Text {
                    anchors.centerIn: parent
                    text: root.status
                    font.pixelSize: 11; font.bold: true
                    color: status === "Occupée" ? "#EF4444" : (status === "Disponible" ? "#22C55E" : "#F59E0B")
                }
            }
        }

        // Type de salle (Badge bleu clair)
        Rectangle {
            height: 22; radius: 6; color: "#EFF6FF"
            width: typeLabel.implicitWidth + 16
            Text {
                id: typeLabel
                anchors.centerIn: parent
                text: root.type; font.pixelSize: 11; color: "#3B82F6"
            }
        }

        // Capacité
        RowLayout {
            spacing: 8
            Text { text: "\ue7ef"; font.family: "Material Icons"; font.pixelSize: 16; color: "#94A3B8" }
            Text { text: "Capacité: " + root.capacity + " places"; font.pixelSize: 13; color: "#64748B" }
        }

        // Équipements (Flow)
        Flow {
            Layout.fillWidth: true
            spacing: 6
            Repeater {
                model: root.equipment
                Rectangle {
                    height: 22; radius: 6; color: "#F8FAFC"
                    border.color: "#E2E8F0"
                    width: eqTxt.implicitWidth + 16
                    Text { id: eqTxt; anchors.centerIn: parent; text: modelData; font.pixelSize: 10; font.bold: true; color: "#475569" }
                }
            }
        }

        // Section "En cours"
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "#F8FAFC"; radius: 8
            visible: root.currentCourse !== ""
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 10; spacing: 2
                Text { text: "En cours:"; font.pixelSize: 10; color: "#94A3B8" }
                Text { text: root.currentCourse; font.pixelSize: 13; color: "#3B82F6"; font.bold: true }
            }
        }

        Item { Layout.fillHeight: true } // Pousse le reste vers le bas

        // Barre d'occupation
        ColumnLayout {
            Layout.fillWidth: true; spacing: 4
            visible: root.status === "Occupée"
            RowLayout {
                Text { text: "Occupation"; font.pixelSize: 11; color: "#64748B" }
                Item { Layout.fillWidth: true }
                Text { text: root.occupationPercent + "%"; font.pixelSize: 11; font.bold: true; color: "#1E293B" }
            }
            ProgressBar {
                Layout.fillWidth: true
                value: root.occupationPercent / 100
                background: Rectangle { implicitHeight: 6; radius: 3; color: "#E2E8F0" }
                contentItem: Item {
                    Rectangle { width: parent.visualPosition * parent.width; height: 6; radius: 3; color: "#2563EB" }
                }
            }
        }
    }
}
