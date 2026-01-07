import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: parent.width
    height: 940

    signal goToRegister
    signal loginSuccess

    // --- CONNEXION AVEC LE CONTROLEUR C++ ---
    Connections {
        target: authController // Nom défini dans main.cpp

        // En cas de succès (Supabase renvoie un utilisateur)
        function onSignUpSuccess(user) { 
            console.log("Connexion réussie !")
            root.loginSuccess() 
        }

        // En cas d'erreur (Identifiants incorrects, etc.)
        function onErrorOccurred(error) {
            errorText.text = "Erreur : " + error
            errorText.visible = true
        }
    }

    // Fond
    Rectangle {
        anchors.fill: parent
        color: "#F8FAFC" 

        // Conteneur Principal
        Rectangle {
            id: loginCard
            width: 480
            height: 600
            radius: 24
            color: "white"
            anchors.centerIn: parent
            border.color: "#E2E8F0"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 24

                // Logo stylisé
                Rectangle {
                    width: 64
                    height: 64
                    radius: 16
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#9333EA" }
                        GradientStop { position: 1.0; color: "#7C2AE8" }
                    }
                    Layout.alignment: Qt.AlignHCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "◈"
                        color: "white"
                        font.pixelSize: 32
                    }
                }

                // En-tête
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8
                    Text {
                        text: "Bienvenue"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: "#1E293B"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "Connectez-vous pour continuer"
                        font.pixelSize: 14
                        color: "#64748B"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Formulaire
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    InputGroup {
                        id: emailInput
                        label: "Email"
                        placeholder: "nom@exemple.com"
                        icon: "\ue0be"
                        Layout.fillWidth: true
                    }

                    InputGroup {
                        id: pwdInput
                        label: "Mot de passe"
                        placeholder: "••••••••"
                        icon: "\ue897"
                        isPassword: true
                        Layout.fillWidth: true
                    }
                }

                // Texte d'erreur
                Text {
                    id: errorText
                    color: "#ef4444"
                    font.pixelSize: 12
                    visible: false
                    Layout.alignment: Qt.AlignHCenter
                }

                // Options de compte
                RowLayout {
                    Layout.fillWidth: true
                    CheckBox {
                        id: rememberMe
                        text: "Se souvenir de moi"
                        contentItem: Text {
                            text: rememberMe.text
                            font.pixelSize: 13
                            color: "#64748B"
                            leftPadding: rememberMe.indicator.width + rememberMe.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "Mot de passe oublié ?"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#7C2AE8"
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                // Bouton Connexion
                Button {
                    id: loginBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    
                    contentItem: Text {
                        text: "Se connecter"
                        color: "white"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 12
                        color: loginBtn.pressed ? "#6D28D9" : (loginBtn.hovered ? "#8B5CF6" : "#7C2AE8")
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    onClicked: {
                        errorText.visible = false
                        if (emailInput.text === "" || pwdInput.text === "") {
                            errorText.text = "Veuillez remplir tous les champs"
                            errorText.visible = true
                        } else {
                            // APPEL AU CONTROLEUR C++
                            authController.signIn(emailInput.text, pwdInput.text)
                        }
                    }
                }

                // Footer
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    Text {
                        text: "Pas encore de compte ?"
                        color: "#64748B"
                        font.pixelSize: 14
                    }
                    Text {
                        text: "S'inscrire"
                        color: "#7C2AE8"
                        font.weight: Font.Bold
                        font.pixelSize: 14
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.goToRegister()
                        }
                    }
                }
            }
        }
    }

    // --- Composant interne pour les champs de saisie ---
    component InputGroup : ColumnLayout {
        property string label: ""
        property string placeholder: ""
        property string icon: ""
        property bool isPassword: false
        
        // Alias pour permettre au bouton de lire la valeur saisie
        property alias text: inputField.text

        spacing: 8

        Text {
            text: label
            font.pixelSize: 13
            font.weight: Font.Medium
            color: "#334155"
        }

        Rectangle {
            id: inputContainer
            Layout.fillWidth: true
            height: 48
            radius: 12
            color: "#F1F5F9"
            border.width: 1
            border.color: inputField.activeFocus ? "#7C2AE8" : "transparent"
            
            Behavior on border.color { ColorAnimation { duration: 200 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                
                TextField {
                    id: inputField
                    placeholderText: placeholder
                    echoMode: isPassword ? TextInput.Password : TextInput.Normal
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    color: "#1E293B"
                    background: null 
                }

                Text {
                    text: icon
                    color: "#94A3B8"
                    font.pixelSize: 18
                    font.family: root.iconFontFamily // Utilise la police d'icônes chargée dans Main.qml
                }
            }
        }
    }
}