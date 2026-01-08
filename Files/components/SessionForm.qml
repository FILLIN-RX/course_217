import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: sessionPopup
    width: 480
    height: 650
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true

    // Propriétés pour recevoir les données de la grille
    property string selectedDay: ""
    property string selectedTime: ""

    // --- MODÈLES DE DONNÉES ---
    ListModel { id: matiereModel }
    ListModel { id: enseignantModel }
    ListModel { id: salleModel }
    ListModel { id: groupeModel }

    // --- CHARGEMENT AUTOMATIQUE ---
    onOpened: {
        console.log("Chargement des listes pour le formulaire...")
        sessionController.fetchTeachersList()
        roomController.fetchRooms(root.userId)
        matiereController.fetchMatieres()
        groupeController.fetchGroupes()
    }

    // --- GESTION DES RÉPONSES C++ (SIGNaux) ---
    Connections {
        target: sessionController
        function onTeachersLoaded(json) {
            let data = JSON.parse(json)
            enseignantModel.clear()
            for (let i = 0; i < data.length; i++) {
                enseignantModel.append({
                    "id": data[i].enseignant_id,
                    "nom": data[i].utilisateurs.nom
                })
            }
        }
    }

   Connections {
    target: roomController // Correction du nom de la cible
    function onRoomsLoaded(data) {
        // 'data' est un QByteArray, on le convertit en string avant le JSON.parse
        let json = data.toString()
        try {
            let parsedData = JSON.parse(json)
            salleModel.clear()
            for (let i = 0; i < parsedData.length; i++) {
                salleModel.append({
                    "id": parsedData[i].salle_id,
                    "nom": parsedData[i].nom
                })
            }
        } catch(e) {
            console.error("Erreur parsing Salles:", e)
        }
    }
}

    Connections {
        target: matiereController
        function onMatieresLoaded(json) {
            let data = JSON.parse(json)
            matiereModel.clear()
            for (let i = 0; i < data.length; i++) {
                matiereModel.append({
                    "id": data[i].matiere_id,
                    "intitule": data[i].intitule
                })
            }
        }
    }

    Connections {
        target: groupeController
        function onGroupesLoaded(json) {
            let data = JSON.parse(json)
            groupeModel.clear()
            for (let i = 0; i < data.length; i++) {
                groupeModel.append({
                    "id": data[i].groupe_id,
                    "nom": data[i].nom
                })
            }
        }
    }

    // --- INTERFACE GRAPHIQUE ---
    background: Rectangle { 
        radius: 12
        color: "white"
        border.color: "#E2E8F0"
    }

    contentItem: ColumnLayout {
        spacing: 20
        anchors.margins: 25

        Text {
            text: "Planifier : " + sessionPopup.selectedDay
            font.pixelSize: 22
            font.bold: true
            color: "#1E293B"
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 10
                spacing: 15

                // Matière
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Matière"; font.bold: true; font.pixelSize: 13 }
                    ComboBox {
                        id: matiereCombo
                        Layout.fillWidth: true
                        textRole: "intitule"
                        model: matiereModel
                    }
                }

                // Enseignant
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Enseignant"; font.bold: true; font.pixelSize: 13 }
                    ComboBox {
                        id: profCombo
                        Layout.fillWidth: true
                        textRole: "nom"
                        model: enseignantModel
                    }
                }

                // Salle
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Salle"; font.bold: true; font.pixelSize: 13 }
                    ComboBox {
                        id: salleCombo
                        Layout.fillWidth: true
                        textRole: "nom"
                        model: salleModel
                    }
                }

                // Groupe
                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: "Groupe / Classe"; font.bold: true; font.pixelSize: 13 }
                    ComboBox {
                        id: groupeCombo
                        Layout.fillWidth: true
                        textRole: "nom"
                        model: groupeModel
                    }
                }

                // Type (CM/TD/TP)
                RowLayout {
                    spacing: 20
                    Text { text: "Type:"; font.bold: true }
                    RadioButton { id: cmType; text: "CM"; checked: true }
                    RadioButton { id: tdType; text: "TD" }
                    RadioButton { id: tpType; text: "TP" }
                }

                // Heure (Pré-remplie)
                RowLayout {
                    spacing: 15
                    ColumnLayout {
                        Text { text: "Heure début"; font.bold: true }
                        TextField { 
                            id: startHour
                            text: sessionPopup.selectedTime
                            Layout.preferredWidth: 100 
                        }
                    }
                    ColumnLayout {
                        Text { text: "Durée (heures)"; font.bold: true }
                        SpinBox { id: durationBox; from: 1; to: 4; value: 2 }
                    }
                }
            }
        }

        Button {
            text: "Enregistrer la séance"
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            onClicked: {
                sessionController.addSession(
                    matiereModel.get(matiereCombo.currentIndex).id,
                    enseignantModel.get(profCombo.currentIndex).id,
                    salleModel.get(salleCombo.currentIndex).id,
                    groupeModel.get(groupeCombo.currentIndex).id,
                    cmType.checked ? "CM" : (tdType.checked ? "TD" : "TP"),
                    "2026-01-08", // À remplacer par une date dynamique si nécessaire
                    startHour.text,
                    durationBox.value
                )
                sessionPopup.close()
            }
            background: Rectangle { color: "#6366F1"; radius: 8 }
            contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
        }
    }
}
