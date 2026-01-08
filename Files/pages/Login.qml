import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: parent.width
    height: parent.height

    signal goToRegister
    signal loginSuccess

    Connections {
        target: authController 

        function onProfileReceived(data) {
            // Conversion du JSON reçu du C++ en objet JavaScript
            var user = JSON.parse(data)
            console.log("✅ Connexion réussie : " + user.prenom + " " + user.nom)
            console.log("Rôle : " + user.type)
            
            // On peut stocker les infos ici si besoin avant de changer de page
            root.loginSuccess()
        }

        function onErrorOccurred(error) {
            errorText.text = error
            errorText.visible = true
            loginBtn.enabled = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#F8FAFC" 

        Rectangle {
            width: 480
            height: 500
            radius: 24
            color: "white"
            anchors.centerIn: parent
            border.color: "#E2E8F0"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 20

                Text {
                    text: "Connexion"
                    font.pixelSize: 28; font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    id: errorText
                    color: "#ef4444"
                    visible: false
                    Layout.alignment: Qt.AlignHCenter
                }

                TextField {
                    id: emailInput
                    placeholderText: "Email"
                    Layout.fillWidth: true
                }

                TextField {
                    id: passwordInput
                    placeholderText: "Mot de passe"
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                }

                Button {
                    id: loginBtn
                    text: "Se connecter"
                    Layout.fillWidth: true
                    onClicked: {
                        loginBtn.enabled = false
                        authController.signIn(emailInput.text, passwordInput.text)
                    }
                }

                Text {
                    text: "Pas de compte ? S'inscrire"
                    color: "#7C2AE8"
                    Layout.alignment: Qt.AlignHCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.goToRegister()
                    }
                }
            }
        }
    }
}