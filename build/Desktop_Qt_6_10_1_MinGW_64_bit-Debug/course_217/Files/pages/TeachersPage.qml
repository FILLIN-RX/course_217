import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: teachersPage
    anchors.fill: parent


    property bool isLoading: true
    property string searchQuery: ""

    // 1. Modèles de données
    ListModel { id: teacherModel }
    ListModel { id: filteredModel }

    // 2. Logique de filtrage
    function applyFilter() {
        filteredModel.clear();
        for (var i = 0; i < teacherModel.count; i++) {
            var item = teacherModel.get(i);
            var fullName = (item.prenomUser + " " + item.nomUser).toLowerCase();
            if (searchQuery === "" || fullName.indexOf(searchQuery.toLowerCase()) !== -1) {
                filteredModel.append(item);
            }
        }
    }

    // 3. Initialisation [cite: 5]
    Component.onCompleted: {
        if (root.userId > 0) {
            isLoading = true;
            teacherController.fetchMyTeachers(root.userId);
        }
    }

    TeacherForm {
        id: addForm
        currentAdminId: root.userId
        onTeacherSaved: {
            isLoading = true;
            teacherController.fetchMyTeachers(root.userId); // [cite: 6]
        }
    }

    // 4. Réception des données [cite: 7, 8, 9]
    Connections {
        target: teacherController
        function onTeachersLoaded(data) {
            teacherModel.clear();
            isLoading = false;
            try {
                var json = JSON.parse(data);
                for (var i = 0; i < json.length; i++) {
                    var item = json[i];
                    if (item.utilisateurs) {
                        var obj = {
                            "nomUser": item.utilisateurs.nom,
                            "prenomUser": item.utilisateurs.prenom, // [cite: 10]
                            "gradeUser": item.grade,
                            "emailUser": item.utilisateurs.email,
                            "specUser": item.specialite // [cite: 11]
                        };
                        teacherModel.append(obj); // [cite: 12]
                    }
                }
                applyFilter();
            } catch (e) {
                console.error("Erreur parsing:", e);
            }
        }
    }

    // 5. Interface utilisateur (ScrollView)
    ScrollView {
        anchors.fill: parent
        clip: true
        visible: !isLoading
         leftPadding: 20
        rightPadding: 20

        ColumnLayout {
            width: parent.width
            spacing: 30
            Layout.leftMargin: 30 // [cite: 15]
            Layout.rightMargin: 30
            Layout.topMargin: 20

            // --- HEADER ---
            RowLayout {
                Layout.fillWidth: true
                
                Column {
                    Layout.fillWidth: true
                    spacing: 4
                    Text {
                        text: "Enseignants" // [cite: 17]
                        font.pixelSize: 28
                        font.bold: true
                        color: "#1E293B"
                    }
                    Text {
                        text: "Gérez votre équipe éducative"
                        color: "#64748B"
                        font.pixelSize: 14 // [cite: 19]
                    }
                }

                // --- SEARCH BAR (MODERNE) ---
                Rectangle {
                    Layout.preferredWidth: 280
                    Layout.preferredHeight: 42 // [cite: 20]
                    color: "#F1F5F9"
                    radius: 8
                    border.width: 1
                    border.color: searchInput.activeFocus ? "#3B82F6" : "#E2E8F0" // [cite: 21]

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12

                        // CORRECTION ICI : Pas de virgules entre les propriétés
                        Text { 
                            text: "\ue8b6"
                            font.pixelSize: 18 
                            font.family: "Material Icons" 
                            color: "#94A3B8"
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextField {
                            id: searchInput
                            placeholderText: "Rechercher..."
                            Layout.fillWidth: true
                            background: null
                            onTextChanged: {
                                searchQuery = text; // [cite: 25]
                                applyFilter();
                            }
                        }
                    }
                }

                // --- BOUTON CRÉER ---
                Button {
                    text: "Créer un enseignant" // [cite: 27]
                    Layout.preferredHeight: 42
                    onClicked: addForm.open()
                    
                    background: Rectangle {
                        color: parent.down ? "#1D4ED8" : "#3B82F6" // [cite: 29]
                        radius: 8
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white" // [cite: 30]
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 15
                        rightPadding: 15
                    }
                }
            }

            // --- GRILLE DE CARTES ---
            Flow {
                Layout.fillWidth: true
                spacing: 20
                Repeater {
                    model: filteredModel
                    TeacherCard {
                        width: 280
                        name: model.prenomUser + " " + model.nomUser // [cite: 33]
                        title: model.gradeUser
                        email: model.emailUser // [cite: 34]
                        courses: [model.specUser]
                        initials: model.nomUser ? model.nomUser.substring(0, 2).toUpperCase() : "??" // [cite: 35]
                    }
                }
            }
        }
    }

    // 6. LOADER MODERNE
    Rectangle {
        anchors.fill: parent
        color: "white"
        visible: isLoading
        z: 999

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            BusyIndicator {
                running: true
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "Synchronisation..." // [cite: 37]
                font.pixelSize: 14
                color: "#64748B"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
