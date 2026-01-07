import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: sessionRoot
    implicitWidth: parent.width
    height: 80
    radius: 12
    color: "#F8FAFC"
    border.color: "#E2E8F0"

    property string subject: "Génie Logiciel"
    property string type: "CM"
    property string teacher: "Prof. Aboubakar"
    property string room: "S008"
    property string time: "08:00 - 10:00"
    property bool isLive: false

    signal clicked()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 15

        // Indicateur visuel (Barre de couleur)
        Rectangle {
            width: 4; Layout.fillHeight: true; radius: 2
            color: sessionRoot.isLive ? "#22C55E" : "#6366F1"
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            RowLayout {
                Text { text: sessionRoot.subject; font.pixelSize: 15; font.bold: true; color: "#1E293B" }
                Rectangle {
                    width: 35; height: 18; radius: 4; color: "#EEF2FF"
                    Text { anchors.centerIn: parent; text: sessionRoot.type; font.pixelSize: 10; font.bold: true; color: "#6366F1" }
                }
                Text {
                    text: "En cours"; font.pixelSize: 11; color: "#22C55E"; font.bold: true
                    visible: sessionRoot.isLive
                }
            }
            RowLayout {
                spacing: 12
                Text { text: "\ue7fd " + sessionRoot.teacher; font.family: "Material Icons"; font.pixelSize: 12; color: "#64748B" }
                Text { text: "\ue0c8 " + sessionRoot.room; font.family: "Material Icons"; font.pixelSize: 12; color: "#64748B" }
            }
        }

        Text { text: sessionRoot.time; font.pixelSize: 13; font.bold: true; color: "#475569" }

        Button {
            text: "Détails"
            onClicked: sessionRoot.clicked()
            background: Rectangle { implicitWidth: 80; implicitHeight: 32; radius: 6; color: "white"; border.color: "#E2E8F0" }
        }
    }
}
