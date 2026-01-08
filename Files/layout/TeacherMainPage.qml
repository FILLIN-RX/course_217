import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../pages"

Item {
    id: teacherMainRoot
    anchors.fill: parent

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // --- SIDEBAR ENSEIGNANT ---
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            color: "#0F172A" // Fond sombre pro

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Profil Rapide
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        width: 45; height: 45; radius: 22.5
                        color: "#3B82F6"
                        Text { 
                            anchors.centerIn: parent
                            text: root.userProfile.initiales
                            color: "white"; font.bold: true 
                        }
                    }
                    Column {
                        Text { text: root.userProfile.nom; color: "white"; font.bold: true; font.pixelSize: 14 }
                        Text { text: "Enseignant"; color: "#64748B"; font.pixelSize: 12 }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#1E293B"; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                // Boutons du Menu
                VignetteMenu {
                    text: "Tableau de bord"
                    menuIcon: "\ue871"
                    active: teacherStack.currentIndex === 0
                    onClicked: teacherStack.currentIndex = 0
                }
                VignetteMenu {
                    text: "Mon Emploi du Temps"
                    menuIcon: "\ue916"
                    active: teacherStack.currentIndex === 1
                    onClicked: teacherStack.currentIndex = 1
                }

                Item { Layout.fillHeight: true } // Pousse le bouton déconnexion vers le bas

                VignetteMenu {
                    text: "Déconnexion"
                    menuIcon: "\ue9ba"
                    onClicked: root.currentPage = "login"
                }
            }
        }

        // --- ZONE DE CONTENU ---
        StackLayout {
            id: teacherStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            TeacherDashboard { } // Votre page créée précédemment
            TeacherSchedule { }  // Votre page créée précédemment
        }
    }
}