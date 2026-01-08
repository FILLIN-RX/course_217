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

    // --- CHARGEMENT DES POLICES ET GLOBALS ---
    FontLoader {
        id: materialFont
        source: "qrc:/qt/qml/course_217/assets/MaterialIcons-Regular.ttf"
    }
    readonly property string iconFontFamily: materialFont.name

    // État de la navigation
    property string currentPage: "login" // "login", "register", "main"

    // --- STOCKAGE DU PROFIL UTILISATEUR ---
    // Ces données seront affichées dans la Sidebar
    property var userProfile: {
        "nom": "Utilisateur",
        "role": "Étudiant",
        "initiales": "U"
    }

    // Gestionnaire central pour le changement de page
    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: {
            if (root.currentPage === "login") return loginComponent;
            if (root.currentPage === "register") return registerComponent;
            if (root.currentPage === "main") return mainComponent;
            return loginComponent;
        }
    }

    // --- COMPOSANTS DES PAGES ---

    // Page de Connexion
  // Main.qml
Component {
    id: loginComponent
    Login {
        onGoToRegister: root.currentPage = "register"
        onLoginSuccess: {
            root.currentPage = "main" // C'est ici que la redirection se fait
        }
    }
}

    // Page d'Inscription
    Component {
        id: registerComponent
        Register {
            onGoToLogin: root.currentPage = "login"
            onRegisterSuccess: root.currentPage = "main"
        }
    }

    // Page Principale (Dashboard + Sidebar)
    Component {
        id: mainComponent
        MainPage {
            Component.onCompleted: {
                // Maximiser la fenêtre une fois connecté pour une meilleure immersion
                root.visibility = Window.Maximized
            }
        }
    }

    // --- ÉCOUTEUR GLOBAL POUR LES DONNÉES C++ ---
    Connections {
        target: authController

        // Quand le profil est reçu du C++
        function onProfileReceived(data) {
            let profile = JSON.parse(data);
            
            // Mise à jour des infos pour la Sidebar
            root.userProfile = {
                "nom": profile.nom || "Utilisateur",
                "role": profile.role || "Étudiant",
                "initiales": (profile.nom ? profile.nom.substring(0,1).toUpperCase() : "U")
            };
            
            console.log("Profil mis à jour pour :", root.userProfile.nom);
        }
        
        function onErrorOccurred(error) {
            console.error("Erreur Auth globale:", error);
        }
    }
}