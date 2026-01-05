import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: registerPage
    width: parent.width
    height: 940

    // Signaux pour communiquer avec le fichier Main.qml
    signal registerSuccess()
    signal goToLogin()

    // Le bloc Connections permet de réagir aux signaux envoyés par le C++ (AuthController)
    Connections {
        target: authService // C'est l'objet exposé dans le main.cpp

        // Cette fonction s'exécute quand le C++ émet 'registrationSuccess'
        function onRegistrationSuccess() {
            console.log("Succès : Utilisateur enregistré dans SQLite")
            registerPage.registerSuccess() // On informe le parent (Main.qml)
        }

        // Cette fonction s'exécute en cas d'erreur SQL
        function onRegistrationError(message) {
            console.log("Erreur reçue du C++ : " + message)
            errorText.text = "Erreur : " + message
            errorText.visible = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#D4E8E6" // Couleur de fond bleutée

        Rectangle {
            width: 550
            height: 800 // Augmenté pour accueillir les nouveaux champs
            radius: 16
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 12

                Text {
                    text: "Inscription"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignHCenter
                }

                // --- Message d'erreur ---
                Text {
                    id: errorText
                    visible: false
                    color: "red"
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                // --- CHAMP NOM ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Nom"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: nameField
                        placeholderText: "Votre nom"
                        Layout.fillWidth: true
                    }
                }

                // --- CHAMP PRÉNOM ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Prénom"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: firstNameField
                        placeholderText: "Votre prénom"
                        Layout.fillWidth: true
                    }
                }

                // --- CHAMP EMAIL ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Email"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: emailField
                        placeholderText: "email@exemple.com"
                        Layout.fillWidth: true
                    }
                }

                // --- CHAMP MOT DE PASSE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Mot de passe"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: passwordField
                        placeholderText: "Saisissez un mot de passe"
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                    }
                }

                // --- CHAMP TÉLÉPHONE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Téléphone"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: phoneField
                        placeholderText: "0123456789"
                        inputMethodHints: Qt.ImhDigitsOnly
                        Layout.fillWidth: true
                    }
                }

                // --- CHAMP RÔLE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Rôle"; font.pixelSize: 12; color: "gray" }
                    ComboBox {
                        id: roleComboBox
                        Layout.fillWidth: true
                        model: ["etudiant", "enseignant", "chef_departement", "admin"]
                        currentIndex: 0

                        // Style personnalisé pour le ComboBox
                        background: Rectangle {
                            border.color: "#cccccc"
                            border.width: 1
                            radius: 4
                        }

                        // Permet de voir le texte sélectionné
                        contentItem: Text {
                            text: roleComboBox.displayText
                            color: "black"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }
                    }
                }

                // --- CHAMP TYPE ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Type"; font.pixelSize: 12; color: "gray" }
                    TextField {
                        id: typeField
                        placeholderText: "standard, premium, etc."
                        Layout.fillWidth: true
                    }
                }

                // --- BOUTON DE VALIDATION ---
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50

                    Button {
                        id: registerButton
                        text: "Créer le compte"
                        width: parent.width
                        height: parent.height

                        onClicked: {
                            errorText.visible = false

                            // Validation basique
                            if (!nameField.text || !firstNameField.text || !emailField.text ||
                                !passwordField.text) {
                                errorText.text = "Veuillez remplir tous les champs obligatoires"
                                errorText.visible = true
                                return
                            }

                            // On appelle la fonction C++ avec TOUS les paramètres
                            authService.registerUser(
                                nameField.text,
                                firstNameField.text,
                                emailField.text,
                                passwordField.text,
                                phoneField.text,      // Téléphone
                                roleComboBox.currentText, // Rôle sélectionné
                                typeField.text       // Type
                            )
                        }
                    }
                }

                // Lien vers la connexion
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40

                    Row {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            text: "Déjà un compte ?";
                            color: "#666666"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Button {
                            text: "Se connecter"
                            flat: true
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: registerPage.goToLogin()
                        }
                    }
                }
            }
        }
    }
}
