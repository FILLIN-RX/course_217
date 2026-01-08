pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "pages"
import "layout"

Window {
    id: root
    width: 900
    height: 700
    visible: true
    title: qsTr("Course 217")

    // --- CHARGEMENT DES POLICES ---
    FontLoader {
        id: materialFont
        source: "qrc:/qt/qml/course_217/assets/MaterialIcons-Regular.ttf"
    }
    readonly property string iconFontFamily: materialFont.name

    // --- ÉTATS GLOBAUX ---
    property string currentPage: "login" 
    property int userId: -1
    property string userRole: "" // Stockera "admin" ou "enseignant"
    
    property var userProfile: {
        "nom": "Utilisateur",
        "role": "",
        "initiales": "U"
    }

    // --- GESTIONNAIRE DE NAVIGATION CENTRAL ---
    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: {
            if (root.currentPage === "login") return loginComponent;
            if (root.currentPage === "register") return registerComponent;
            
            // REDIRECTION SELON LE RÔLE
            if (root.currentPage === "main") {
                if (root.userRole === "enseignant") {
                    return teacherMainComponent;
                } else {
                    return mainComponent;
                }
            }
            return loginComponent;
        }
    }

    // --- COMPOSANTS DES PAGES ---

    Component {
        id: loginComponent
        Login {
            onGoToRegister: root.currentPage = "register"
            onLoginSuccess: root.currentPage = "main" 
        }
    }

    Component {
        id: registerComponent
        Register {
            onGoToLogin: root.currentPage = "login"
            onRegisterSuccess: root.currentPage = "main"
        }
    }

    // Interface Administrateur (Chef de département)
    Component {
        id: mainComponent
        MainPage {
            Component.onCompleted: root.visibility = Window.Maximized
        }
    }

    // Interface Enseignant (NOUVEAU)
    Component {
        id: teacherMainComponent
        TeacherMainPage {
            Component.onCompleted: root.visibility = Window.Maximized
        }
    }

    // --- ÉCOUTEUR GLOBAL POUR LES DONNÉES ---
    Connections {
        target: authController

        function onProfileReceived(data) {
            let profile = JSON.parse(data);
            
            root.userId = profile.utilisateur_id;
            // On convertit le rôle en minuscule pour éviter les erreurs de casse (ex: "Enseignant" -> "enseignant")
            root.userRole = profile.type ? profile.type.toLowerCase() : "admin"; 

            console.log("--- LOG CONNEXION ---");
            console.log("Utilisateur connecté ID:", root.userId);
            console.log("Rôle détecté:", root.userRole);
            
            root.userProfile = {
                "nom": profile.nom || "Utilisateur",
                "role": profile.type || "Utilisateur",
                "initiales": (profile.nom ? profile.nom.substring(0,1).toUpperCase() : "U")
            };
        }

        function onErrorOccurred(error) {
            console.error("Erreur Auth globale:", error);
        }
    }
}