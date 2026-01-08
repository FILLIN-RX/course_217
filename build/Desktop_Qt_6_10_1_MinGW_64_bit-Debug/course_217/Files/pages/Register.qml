import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: registerPage
    width: parent.width
    height: parent.height

    signal registerSuccess()
    signal goToLogin()

    Connections {
        target: authController
        function onSignUpSuccess() {
            console.log("✅ Inscription réussie en table SQL")
            registerPage.registerSuccess() 
        }
        function onErrorOccurred(error) {
            errorText.text = error
            errorText.visible = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#D4E8E6"

        Rectangle {
            width: 500
            height: 750 // Légèrement plus haut pour les nouveaux champs
            radius: 16
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 12

                Text {
                    text: "Créer un compte"
                    font.pixelSize: 24; font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    id: errorText
                    color: "red"
                    visible: false
                    Layout.alignment: Qt.AlignHCenter
                }

                // --- Nouveaux Champs ---
                TextField {
                    id: nomField
                    placeholderText: "Nom"
                    Layout.fillWidth: true
                }

                TextField {
                    id: prenomField
                    placeholderText: "Prénom"
                    Layout.fillWidth: true
                }

                TextField {
                    id: emailField
                    placeholderText: "Email"
                    Layout.fillWidth: true
                }

                TextField {
                    id: passwordField
                    placeholderText: "Mot de passe"
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                }

                ComboBox {
                    id: typeBox
                    Layout.fillWidth: true
                    model: ["Admin", "Enseignant", "Etudiant"]
                    currentIndex: 0 // "Admin" par défaut
                }

                Button {
                    Layout.fillWidth: true
                    height: 45
                    text: "S'inscrire"
                    onClicked: {
                        if (emailField.text === "" || passwordField.text === "" || nomField.text === "") {
                            errorText.text = "Veuillez remplir les champs obligatoires"
                            errorText.visible = true
                            return
                        }
                        
                        // Envoi des 5 paramètres au C++
                        authController.signUp(
                            nomField.text, 
                            prenomField.text, 
                            emailField.text, 
                            passwordField.text, 
                            typeBox.currentText.toLowerCase()
                        )
                    }
                }

                Text {
                    text: "Se connecter"
                    color: "#3498db"
                    Layout.alignment: Qt.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: registerPage.goToLogin()
                    }
                }
            }
        }
    }
}