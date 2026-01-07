import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: registerPage
    width: parent.width
    height: parent.height

    // Signaux pour la navigation
    signal registerSuccess()
    signal goToLogin()

    // --- CONNEXION AVEC LE C++ (AuthController) ---
    Connections {
        target: authController // Nom exposé dans le main.cpp

        // Signal émis par le C++ en cas de succès
        function onSignUpSuccess(user) {
            console.log("Inscription réussie pour: " + user.email)
            registerPage.registerSuccess() 
        }

        // Signal émis par le C++ en cas d'erreur
        function onErrorOccurred(error) {
            errorText.text = "Erreur : " + error
            errorText.visible = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#D4E8E6"

        Rectangle {
            width: 500
            height: 650
            radius: 16
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 15

                Text {
                    text: "Créer un compte"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    id: errorText
                    visible: false
                    color: "#e74c3c"
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                // --- CHAMP EMAIL ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Email"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: emailField
                        placeholderText: "votre@email.com"
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }

                // --- CHAMP MOT DE PASSE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Mot de passe"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: passwordField
                        placeholderText: "Minimum 6 caractères"
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }

                // --- CHAMP RÔLE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Vous êtes ?"; font.pixelSize: 12; color: "gray" }
                    ComboBox {
                        id: roleComboBox
                        Layout.fillWidth: true
                        model: ["Étudiant", "Enseignant", "Admin"]
                    }
                }

                // --- BOUTON DE VALIDATION ---
                Button {
                    id: registerButton
                    text: "S'inscrire"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    
                    contentItem: Text {
                        text: registerButton.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Bold
                    }

                    background: Rectangle {
                        color: registerButton.down ? "#2980b9" : "#3498db"
                        radius: 8
                    }

                    onClicked: {
                        errorText.visible = false
                        if (emailField.text === "" || passwordField.text === "") {
                            errorText.text = "Veuillez remplir tous les champs"
                            errorText.visible = true
                            return
                        }
                        
                        // APPEL AU C++ (Supabase)
                        authController.signUp(emailField.text, passwordField.text)
                    }
                }

                // Lien vers la connexion
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5
                    Text { text: "Déjà inscrit ?"; color: "#666666" }
                    Text {
                        text: "Se connecter"
                        color: "#3498db"
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: registerPage.goToLogin()
                        }
                    }
                }
            }
        }
    }
}