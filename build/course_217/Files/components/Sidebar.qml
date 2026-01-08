import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // Indispensable pour la couleur des SVG (Qt 6)

Rectangle {
    id: sidebar
    width: 260
    color: "#0F172A" // Fond Slate 950
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    property int currentIndex: 0
    signal menuSelected(int index, string category)
    property string userName: "Utilisateur"
    property string userRole: "Rôle non défini"
    property string userInitials: "U"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        /* ===== LOGO SECTION ===== */
        Rectangle {
            height: 80
            Layout.fillWidth: true
            color: "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    width: 40; height: 40; radius: 8
                    color: "#6366F1"
                    Text {
                        anchors.centerIn: parent
                        text: "\ue80c" // Icône school
                        font.family: materialFont.name
                        font.pixelSize: 22
                        color: "white"
                    }
                }

                Column {
                    Text {
                        text: "Univ. Yaoundé I"
                        font.pixelSize: 14; font.bold: true; color: "white"
                    }
                    Text {
                        text: "Gestion Académique"
                        font.pixelSize: 11; color: "#94A3B8"
                    }
                }
            }
        }

        /* ===== NAVIGATION LIST ===== */
        ListView {
            id: menu
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 12
            spacing: 4
            model: navModel
            currentIndex: sidebar.currentIndex
            clip: true

            delegate: Item {
                width: ListView.view.width
                height: 48

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 8
                    color: ListView.isCurrentItem ? "#1E293B" : (mouseArea.containsMouse ? "#1E293B66" : "transparent")
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        sidebar.currentIndex = index
                        sidebar.menuSelected(index, category)
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    spacing: 12

                    // --- LOGIQUE D'AFFICHAGE DES ICONES ---
                    Item {
                        width: 20; height: 20

                        // Si c'est un SVG (Chemin commençant par qrc)
                        Image {
                            id: iconImg
                            source: model.icon.startsWith("qrc") ? model.icon : ""
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            visible: false // On cache pour appliquer le ColorOverlay
                        }

                        ColorOverlay {
                            anchors.fill: iconImg
                            source: iconImg
                            color: ListView.isCurrentItem ? "white" : "#64748B"
                            visible: model.icon.startsWith("qrc")
                        }

                        // Si c'est une icône texte Material
                        Text {
                            anchors.centerIn: parent
                            text: !model.icon.startsWith("qrc") ? model.icon : ""
                            font.family: materialFont.name
                            font.pixelSize: 20
                            color: ListView.isCurrentItem ? "white" : "#64748B"
                            visible: !model.icon.startsWith("qrc")
                        }
                    }

                    Text {
                        text: model.label
                        Layout.fillWidth: true
                        font.pixelSize: 14
                        color: ListView.isCurrentItem ? "white" : "#94A3B8"
                        font.weight: ListView.isCurrentItem ? Font.DemiBold : Font.Normal
                    }
                }
            }
        }

        /* ===== USER PROFILE FOOTER ===== */
       Rectangle {
            height: 80
            Layout.fillWidth: true
            color: "#1E293B"
            radius: 12
            Layout.margins: 12

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12

                Rectangle {
                    width: 36; height: 36; radius: 18; color: "#334155"
                    Text { 
                        anchors.centerIn: parent
                        text: sidebar.userInitials // Liaison ici [cite: 63]
                        color: "white"
                        font.bold: true 
                    }
                }

                Column {
                    Layout.fillWidth: true
                    Text { 
                        text: sidebar.userName // Liaison ici [cite: 64]
                        color: "white"
                        font.pixelSize: 12
                        font.bold: true 
                        elide: Text.ElideRight // Pour éviter que le nom dépasse
                    }
                    Text { 
                        text: sidebar.userRole // Liaison ici [cite: 65]
                        color: "#94A3B8"
                        font.pixelSize: 10 
                    }
                }

                Text {
                    text: "\ue8ac" // Logout
                    font.family: materialFont.name
                    font.pixelSize: 18
                    color: "#64748B"
                }
            }
        }
    }

    /* ===== MODÈLE DE DONNÉES ===== */
    ListModel {
        id: navModel
        // Utilisez les codes exacts correspondant à Material Icons
        ListElement { label: "Tableau de bord"; icon: "\ue871"; category: "dashboard" } // dashboard icon
        ListElement { label: "Emploi du temps"; icon: "\ue916"; category: "schedule" }  // calendar icon
        ListElement { label: "Séances"; icon: "\ue8df"; category: "sessions" }          // event icon
        ListElement { label: "Enseignants"; icon: "\ue7ef"; category: "teachers" }      // group icon
        ListElement { label: "Salles"; icon: "\ue88a"; category: "rooms" }             // meeting room icon
        ListElement { label: "Rapports"; icon: "\ue85c"; category: "reports" }           // assessment icon
        ListElement { label: "Paramètres"; icon: "\ue8b8"; category: "settings" }        // settings icon
    }
}
