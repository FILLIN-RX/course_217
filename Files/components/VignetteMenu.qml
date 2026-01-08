import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    id: control
    
    property string menuIcon: "" // Renommé ici pour éviter le conflit
    property bool active: false
    
    Layout.fillWidth: true
    implicitHeight: 50

    contentItem: RowLayout {
        spacing: 15
        Text {
            // Utilisation de la nouvelle propriété menuIcon
            text: control.menuIcon 
            font.family: root.iconFontFamily
            font.pixelSize: 20
            color: control.active ? "#3B82F6" : (control.hovered ? "#F8FAFC" : "#94A3B8")
        }
        Text {
            text: control.text
            font.pixelSize: 14
            font.bold: control.active
            color: control.active ? "#F8FAFC" : (control.hovered ? "#F1F5F9" : "#94A3B8")
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        radius: 10
        color: control.active ? "#334155" : (control.hovered ? "#1E293B" : "transparent")
        
        Rectangle {
            width: 4; height: 20; radius: 2
            color: "#3B82F6"
            visible: control.active
            anchors.left: parent.left
            anchors.leftMargin: -10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}