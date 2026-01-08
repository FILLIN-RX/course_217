import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: teacherDialog
    title: "Ajouter un Nouvel Enseignant"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    anchors.centerIn: parent
    width: 450
property int currentAdminId: 0
    // Signaux pour rafraîchir la liste après ajout
    signal teacherSaved()

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        GridLayout {
            columns: 2
            Layout.fillWidth: true
            columnSpacing: 10
            rowSpacing: 10

            Text { text: "Nom:"; font.weight: Font.Medium }
            TextField { id: nomField; Layout.fillWidth: true; placeholderText: "ex: Aboubakar" }

            Text { text: "Prénom:"; font.weight: Font.Medium }
            TextField { id: prenomField; Layout.fillWidth: true; placeholderText: "ex: Jean" }

            Text { text: "Email:"; font.weight: Font.Medium }
            TextField { id: emailField; Layout.fillWidth: true; placeholderText: "nom@univ.cm" }

            Text { text: "Mot de passe:"; font.weight: Font.Medium }
            TextField { id: passField; Layout.fillWidth: true; echoMode: TextInput.Password; placeholderText: "••••••••" }

            Text { text: "Spécialité:"; font.weight: Font.Medium }
            TextField { id: specField; Layout.fillWidth: true; placeholderText: "ex: Génie Logiciel" }

            Text { text: "Grade:"; font.weight: Font.Medium }
            ComboBox {
                id: gradeBox
                Layout.fillWidth: true
                model: ["Assistant", "Chargé de Cours", "Maître de Conférences", "Professeur"]
            }
        }

        Text {
            id: formError
            color: "red"
            visible: false
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }

    onAccepted: {
        if (nomField.text === "" || emailField.text === "" || passField.text === "") {
            formError.text = "Veuillez remplir les champs obligatoires (Nom, Email, MDP)."
            formError.visible = true
            teacherDialog.open() // Garde ouvert si erreur
            return
        }

        // Appel au contrôleur C++ avec l'ID de l'admin actuel
        // Note: Assurez-vous d'avoir l'ID de l'admin stocké globalement (ex: 1 pour les tests)
        teacherController.addTeacher(
            nomField.text,
            prenomField.text,
            emailField.text,
            passField.text,
            specField.text,
            gradeBox.currentText,
            currentAdminId // ID de l'admin connecté à remplacer par votre variable globale
        )
    }

    Connections {
        target: teacherController
        function onTeacherAdded() {
            teacherSaved()
            clearForm()
        }
        function onErrorOccurred(msg) {
            formError.text = msg
            formError.visible = true
            teacherDialog.open()
        }
    }

    function clearForm() {
        nomField.text = ""
        prenomField.text = ""
        emailField.text = ""
        passField.text = ""
        specField.text = ""
        formError.visible = false
    }
}
