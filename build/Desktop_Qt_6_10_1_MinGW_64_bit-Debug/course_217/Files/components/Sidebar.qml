import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: sidebar
    width: 260
    color: '#61aba0'
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    property int currentIndex: 0
    signal menuSelected(int index, string category)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        /* ===== LOGO ===== */
        Rectangle {
            height: 64
            Layout.fillWidth: true
            color: "#0F172A"

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                spacing: 12

                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: "#6366F1"

                    Text {
                        anchors.centerIn: parent
                        text: "\ue80c"              // school
                        font.family: "Material Icons"
                        font.pixelSize: 22
                        color: "white"
                    }
                }

                Column {
                    spacing: 2
                    Text {
                        text: "Univ. Yaoundé I"
                        font.pixelSize: 12
                        font.bold: true
                        color: "white"
                    }
                    Text {
                        text: "Gestion Académique"
                        font.pixelSize: 10
                        color: "#94A3B8"
                    }
                }
            }
        }

        /* ===== NAVIGATION ===== */
        ListView {
            id: menu
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            clip: true
            model: navModel
            currentIndex: sidebar.currentIndex

            delegate: Rectangle {
                width: ListView.view.width
                height: 44
                radius: 8
                color: ListView.isCurrentItem ? "#6366F1" : "transparent"

                property string itemCategory: category

                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        sidebar.currentIndex = index
                        sidebar.menuSelected(index, category)
                    }
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    spacing: 12

                    // Utilisation de Image pour les SVG et Text pour Material Icons
                    Loader {
                        id: iconLoader
                        sourceComponent: icon.startsWith("qrc:") ? imageIcon : materialIcon
                    }

                    Component {
                        id: imageIcon
                        Image {
                            source: icon
                            width: 22
                            height: 22
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            layer.enabled: true
                            // changer la couleur si sélectionné (simple filtre)
                            opacity: ListView.isCurrentItem ? 1.0 : 0.6
                        }
                    }

                    Component {
                        id: materialIcon
                        Text {
                            text: icon
                            font.family: "Material Icons"
                            font.pixelSize: 18
                            color: ListView.isCurrentItem ? "white" : "#CBD5E1"
                        }
                    }

                    Text {
                        text: label
                        font.pixelSize: 13
                        color: ListView.isCurrentItem ? "white" : "#CBD5E1"
                    }
                }
            }
        }

        /* ===== FOOTER ===== */
        Rectangle {
            height: 72
            Layout.fillWidth: true
            color: "#0F172A"

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                spacing: 12

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "#334155"

                    Text {
                        anchors.centerIn: parent
                        text: "CD"
                        font.bold: true
                        color: "white"
                    }
                }

                Column {
                    Text {
                        text: "Chef Département"
                        font.pixelSize: 12
                        color: "white"
                    }
                    Text {
                        text: "Informatique"
                        font.pixelSize: 10
                        color: "#94A3B8"
                    }
                }
            }
        }
    }

    /* ===== MENU DATA ===== */
    ListModel {
        id: navModel

        ListElement { label: "Tableau de bord"; icon: "qrc:/assets/icons/dashboard.svg"; category: "dashboard" }
        ListElement { label: "Emploi du temps"; icon: "qrc:/assets/icons/calender.svg"; category: "schedule" }
        ListElement { label: "Séances"; icon: "\ue8ef"; category: "sessions" }
        ListElement { label: "Enseignants"; icon: "qrc:/assets/icons/person.svg"; category: "teachers" }
        ListElement { label: "Salles"; icon: "\ue8d4"; category: "rooms" }
        ListElement { label: "Rapports"; icon: "\ue6e1"; category: "reports" }
        ListElement { label: "Paramètres"; icon: "\ue8b8"; category: "settings" }
    }
}
