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
    property string selectedDate: "" // <-- AJOUT: Propriété pour la date

    // --- MODÈLES DE DONNÉES ---
    ListModel {
        id: matiereModel
    }
    ListModel {
        id: enseignantModel
    }
    ListModel {
        id: salleModel
    }
    ListModel {
        id: groupeModel
    }

    // --- CHARGEMENT AUTOMATIQUE ---
    onOpened: {
        console.log("Chargement des listes pour le formulaire...");
        console.log("Date sélectionnée:", selectedDate);
        console.log("Jour sélectionné:", selectedDay);
        console.log("Heure sélectionnée:", selectedTime);
        console.log("SessionForm: userId =", root.userId);
        console.log("SessionForm: roomController =", roomController);
        roomController.fetchRooms(root.userId);

        sessionController.fetchTeachersList();
        roomController.fetchRooms(root.userId);
        matiereController.fetchMatieres();
        groupeController.fetchGroupes();
    }

    // --- GESTION DES RÉPONSES C++ (SIGNaux) ---
    Connections {
        target: sessionController
        function onTeachersLoaded(json) {
            console.log("DEBUG: onTeachersLoaded appelé, données reçues:", json);
            console.log("Type de données:", typeof json);
            console.log("Longueur des données:", json.length);

            try {
                let data = JSON.parse(json);
                console.log("DEBUG: Parsing JSON réussi, nombre d'enseignants:", data.length);

                enseignantModel.clear();
                for (let i = 0; i < data.length; i++) {
                    console.log("Enseignant", i, ":", data[i]);
                    let nomProf = data[i].utilisateurs ? data[i].utilisateurs.nom : "Inconnu";
                    enseignantModel.append({
                        "id": data[i].enseignant_id,
                        "nom": nomProf
                    });
                }
            } catch (e) {
                console.error("DEBUG: Erreur parsing JSON:", e);
                console.error("Données brutes:", json);
            }
        }
    }

    Connections {
        target: roomController
        function onRoomsLoaded(data) {
            console.log("DEBUG: onRoomsLoaded appelé dans SessionForm, données:", data);

            try {
                // Parsez les données une seule fois
                let parsedData = JSON.parse(data);
                console.log("Salles reçues, nombre:", parsedData.length);

                salleModel.clear();
                for (let i = 0; i < parsedData.length; i++) {
                    salleModel.append({
                        "id": parsedData[i].salle_id,
                        "nom": parsedData[i].nom
                    });
                }
            } catch (e) {
                console.error("Erreur parsing Salles:", e);
                console.error("Données brutes:", data);
            }
        }
    }

    // --- GESTION DES MATIÈRES ---
    Connections {
        target: matiereController
        function onMatieresLoaded(json) {
            console.log("Matieres reçues: " + json);
            let data = JSON.parse(json);
            matiereModel.clear();
            for (let i = 0; i < data.length; i++) {
                matiereModel.append({
                    "id": data[i].matiere_id,
                    "intitule": data[i].intitule,
                    "code": data[i].code
                });
            }
        }
    }
    // --- GESTION DES GROUPES ---
    Connections {
        target: groupeController
        function onGroupesLoaded(json) {
            let data = JSON.parse(json);
            console.log("DEBUG: onGroupesLoaded, données:", json);
            console.log("Type:", typeof json);
            groupeModel.clear();
            for (let i = 0; i < data.length; i++) {
                groupeModel.append({
                    "id": data[i].groupe_id,
                    "nom": data[i].nom
                });
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

        // <-- MODIFICATION: Afficher la date dans le titre
        Text {
            text: {
                var displayText = "Planifier : " + sessionPopup.selectedDay;
                if (sessionPopup.selectedDate && sessionPopup.selectedDate !== "") {
                    // Formater la date pour l'affichage (ex: "2024-12-27" -> "27/12/2024")
                    var parts = sessionPopup.selectedDate.split("-");
                    if (parts.length === 3) {
                        displayText += " (" + parts[2] + "/" + parts[1] + "/" + parts[0] + ")";
                    }
                }
                return displayText;
            }
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
                    Text {
                        text: "Matière"
                        font.bold: true
                        font.pixelSize: 13
                    }
                    ComboBox {
                        id: matiereCombo
                        Layout.fillWidth: true
                        model: matiereModel
                        textRole: "intitule" // Pour la valeur sélectionnée

                        // Personnaliser l'affichage des items
                        delegate: ItemDelegate {
                            width: parent.width
                            height: 40
                            Row {
                                spacing: 10
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10

                                Text {
                                    text: model.code
                                    font.bold: true
                                    color: "#6366F1"
                                    width: 80
                                    font.pixelSize: 12
                                }

                                Text {
                                    text: model.intitule
                                    color: "#1E293B"
                                    elide: Text.ElideRight
                                    font.pixelSize: 12
                                }
                            }
                        }

                        // Affichage de l'item sélectionné
                        contentItem: Text {
                            text: {
                                if (matiereCombo.currentIndex >= 0) {
                                    var item = matiereModel.get(matiereCombo.currentIndex);
                                    return item.code + " - " + item.intitule;
                                }
                                return "Sélectionner une matière";
                            }
                            color: "#1E293B"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                            font.pixelSize: 14
                        }
                    }
                }

                // Enseignant
                ColumnLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Enseignant"
                        font.bold: true
                        font.pixelSize: 13
                    }
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
                    Text {
                        text: "Salle"
                        font.bold: true
                        font.pixelSize: 13
                    }
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
                    Text {
                        text: "Groupe / Classe"
                        font.bold: true
                        font.pixelSize: 13
                    }
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
                    Text {
                        text: "Type:"
                        font.bold: true
                    }
                    RadioButton {
                        id: cmType
                        text: "CM"
                        checked: true
                    }
                    RadioButton {
                        id: tdType
                        text: "TD"
                    }
                    RadioButton {
                        id: tpType
                        text: "TP"
                    }
                }

                // Heure (Pré-remplie)
                RowLayout {
                    spacing: 15
                    ColumnLayout {
                        Text {
                            text: "Heure début"
                            font.bold: true
                        }
                        TextField {
                            id: startHour
                            text: sessionPopup.selectedTime
                            Layout.preferredWidth: 100
                        }
                    }
                    ColumnLayout {
                        Text {
                            text: "Durée (heures)"
                            font.bold: true
                        }
                        SpinBox {
                            id: durationBox
                            from: 1
                            to: 4
                            value: 2
                        }
                    }
                }
            }
        }

        Button {
            text: "Enregistrer la séance"
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            onClicked: {
                // <-- MODIFICATION: Vérifier que la date est définie
                if (!selectedDate || selectedDate === "") {
                    console.error("❌ Erreur: Aucune date sélectionnée!");
                    return;
                }

                // 1. Extraire l'heure de début (ex: "08:00")
                let startParts = startHour.text.split(":");
                let h = parseInt(startParts[0]);
                let m = startParts.length > 1 ? parseInt(startParts[1]) : 0;

                // 2. Calculer l'heure de fin en ajoutant la durée
                let endH = h + durationBox.value;

                // 3. Formater en chaînes "HH:MM:SS" (important pour le type TIME de PostgreSQL)
                let formatTime = hh => {
                    let hourStr = (hh < 10 ? "0" + hh : hh.toString());
                    return hourStr + ":00:00";
                };

                let debutISO = formatTime(h);
                let finISO = formatTime(endH);

                console.log("📅 Envoi séance :");
                console.log("   Date:", selectedDate);
                console.log("   Jour:", selectedDay);
                console.log("   Début:", debutISO);
                console.log("   Fin:", finISO);
                console.log("   Matière:", matiereModel.get(matiereCombo.currentIndex).code);
                console.log("   Enseignant:", enseignantModel.get(profCombo.currentIndex).nom);
                console.log("   Salle:", salleModel.get(salleCombo.currentIndex).nom);
                console.log("   Groupe:", groupeModel.get(groupeCombo.currentIndex).nom);
                console.log("   Type:", cmType.checked ? "CM" : (tdType.checked ? "TD" : "TP"));

                // <-- MODIFICATION: Utiliser selectedDate au lieu de la date codée en dur
                sessionController.addSession(matiereModel.get(matiereCombo.currentIndex).id, enseignantModel.get(profCombo.currentIndex).id, salleModel.get(salleCombo.currentIndex).id, groupeModel.get(groupeCombo.currentIndex).id, cmType.checked ? "CM" : (tdType.checked ? "TD" : "TP"), selectedDate // <-- DATE DYNAMIQUE
                , debutISO, finISO);
                sessionPopup.close();
            }
            background: Rectangle {
                color: "#6366F1"
                radius: 8
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Button {
            text: "Test Fetch"
            onClicked: {
                console.log("Test fetchTeachersList...");
                sessionController.fetchTeachersList();
                console.log("Test fetchMatieres...");
                matiereController.fetchMatieres();
                console.log("Test fetchGroupes...");
                groupeController.fetchGroupes();
                console.log("Test fetchRooms...");
                roomController.fetchRooms(root.userId);
            }
        }
    }
}
