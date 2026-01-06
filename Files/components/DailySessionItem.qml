import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    Layout.fillWidth: true
    height: 70
    color: "transparent"
    // On affiche une bordure et un fond léger si c'est la séance actuelle
    border.color: isCurrent ? "#6366F1" : "transparent"
    border.width: isCurrent ? 1 : 0
    radius: 8

    // Fond subtil pour l'élément actif
    Rectangle {
        anchors.fill: parent
        color: "#6366F1"
        opacity: 0.05
        visible: root.isCurrent
        radius: 8
    }

    property string type: "CM"
    property string subject: ""
    property string teacher: ""
    property string room: ""
    property string time: ""
    property bool isCurrent: false

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 15

        // Badge Type (CM/TD/TP)
        Rectangle {
            width: 36; height: 36; radius: 18
            color: root.type === "CM" ? "#F5F3FF" : "#F0FDF4"
            Text {
                anchors.centerIn: parent
                text: root.type
                font.pixelSize: 11; font.bold: true
                color: root.type === "CM" ? "#7C3AED" : "#16A34A"
            }
        }

        // Infos Séance
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Text {
                text: root.subject
                font.bold: true; font.pixelSize: 14; color: "#1E293B"
            }
            RowLayout {
                spacing: 12
                Text { text: "\ue7fd" + root.teacher; font.pixelSize: 11; color: "#64748B" }
                Text { text: "\ue58c " + root.room; font.pixelSize: 11; color: "#eb4034" }
            }
        }

        // Heure et Statut "En cours"
        RowLayout {
            spacing: 12

            Text {
                text: root.time
                font.pixelSize: 12; color: "#64748B"; font.weight: Font.Medium
            }

            // Remplacement du 'if' par un Row avec propriété 'visible'
            Row {
                spacing: 6
                visible: root.isCurrent // C'est ici qu'on gère la condition

                Rectangle {
                    width: 8; height: 8; radius: 4
                    color: "#22C55E"
                    anchors.verticalCenter: parent.verticalCenter

                    // Petite animation de pulsation pour le badge "En cours"
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1; to: 0.4; duration: 800 }
                        NumberAnimation { from: 0.4; to: 1; duration: 800 }
                    }
                }

                Text {
                    text: "En cours"
                    font.pixelSize: 11; font.bold: true; color: "#22C55E"
                }
            }
        }
    }

    // Ligne de séparation (masquée si c'est l'élément actif)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 24
        height: 1
        color: "#F1F5F9"
        visible: !root.isCurrent
    }
}
