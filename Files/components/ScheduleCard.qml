import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    radius: 6

    property string title: ""
    property string teacher: ""
    property string room: ""
    property color baseColor: "#6366F1" // Violet par défaut

    color: baseColor

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 2

        Text {
            text: root.title
            font.bold: true; font.pixelSize: 11; color: "white"
            elide: Text.ElideRight; Layout.fillWidth: true
        }
        Text {
            text: root.teacher
            font.pixelSize: 9; color: "white"; opacity: 0.9
        }
        Item { Layout.fillHeight: true }
        Text {
            text: root.room
            font.pixelSize: 9; color: "white"; font.weight: Font.Medium
        }
    }
}
