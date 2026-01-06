// Files/components/LegendItem.qml
import QtQuick
import QtQuick.Layouts

RowLayout {
    property string label: ""
    property color color: "transparent"
    spacing: 8

    Rectangle {
        width: 12; height: 12; radius: 3
        color: parent.color
    }
    Text {
        text: label
        font.pixelSize: 12; color: "#64748B"
    }
}
