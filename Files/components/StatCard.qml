// Files/components/StatCard.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    implicitWidth: 280
    implicitHeight: 120
    radius: 12
    color: isPrimary ? "#6366F1" : "white"
    border.color: isPrimary ? "transparent" : "#F1F5F9"
    border.width: 1

    property string title: ""
    property string value: ""
    property string subValue: ""
    property string trend: ""
    property string iconSource: ""
    property bool isPrimary: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: root.title
                    color: root.isPrimary ? "#E0E7FF" : "#64748B"
                    font.pixelSize: 12
                }
                Text {
                    text: root.value
                    color: root.isPrimary ? "white" : "#1E293B"
                    font.pixelSize: 24
                    font.bold: true
                }
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 40; height: 40; radius: 8
                color: root.isPrimary ? "#FFFFFF20" : "#F8FAFC"
                Text {
                    anchors.centerIn: parent
                    text: root.iconSource
                    font.family: "Material Icons"
                    font.pixelSize: 20
                    color: root.isPrimary ? "white" : "#6366F1"
                }
            }
        }

        Text {
            text: root.subValue + (root.trend ? " • " + root.trend : "")
            color: root.isPrimary ? "#E0E7FF" : "#94A3B8"
            font.pixelSize: 11
        }
    }
}
