import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: roomsPage
    // Note: anchors.fill supprimé pour éviter les conflits avec StackView

    property bool isLoading: true
    property string searchQuery: ""

    ListModel { id: roomModel }
    ListModel { id: filteredRoomModel }

    function applyFilter() {
        filteredRoomModel.clear();
        for (var i = 0; i < roomModel.count; i++) {
            var item = roomModel.get(i);
            var nameMatch = item.nom.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
            if (searchQuery === "" || nameMatch) {
                filteredRoomModel.append(item);
            }
        }
    }

    Component.onCompleted: {
        if (root.userId > 0) {
            isLoading = true;
            roomController.fetchRooms(root.userId);
        }
    }

    Connections {
        target: roomController
        function onRoomsLoaded(data) {
            roomModel.clear();
            isLoading = false;
            try {
                var json = JSON.parse(data);
                for (var i = 0; i < json.length; i++) {
                    roomModel.append(json[i]);
                }
                applyFilter();
            } catch (e) { console.error("Erreur parsing salles:", e); }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true
        visible: !isLoading
        leftPadding: 20
        rightPadding: 20

        ColumnLayout {
            width: parent.width
            spacing: 35
            anchors.margins: 25
            // AJOUT DU PADDING DEMANDÉ
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.topMargin: 30
            Layout.bottomMargin: 30

            // --- HEADER ---
            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 4
                    Text { text: "Salles de classe"; font.pixelSize: 28; font.bold: true; color: "#1E293B" }
                    Text { text: "Gérez vos espaces et leur capacité en temps réel"; color: "#64748B"; font.pixelSize: 14 }
                }

                Item { Layout.fillWidth: true }

                // BARRE DE RECHERCHE
                Rectangle {
                    Layout.preferredWidth: 300; Layout.preferredHeight: 44
                    color: "#F1F5F9"; radius: 10; border.color: searchInput.activeFocus ? "#3B82F6" : "#E2E8F0"
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 15
                        Text { text: "\ue8b6"; font.family: "Material Icons"; font.pixelSize: 20; color: "#94A3B8" }
                        TextField {
                            id: searchInput
                            placeholderText: "Rechercher une salle..."
                            Layout.fillWidth: true; background: null
                            onTextChanged: { searchQuery = text; applyFilter(); }
                        }
                    }
                }

                // BOUTON AJOUTER
                Button {
                    id: addBtn
                    text: "Ajouter une salle"
                    Layout.preferredHeight: 44
                    onClicked: addRoomForm.open()
                    background: Rectangle { 
                        color: addBtn.down ? "#1D4ED8" : "#3B82F6"
                        radius: 10 
                    }
                    contentItem: Text { 
                        text: parent.text; color: "white"; font.bold: true
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        leftPadding: 20; rightPadding: 20 
                    }
                }
            }

            // --- GRILLE ---
            Flow {
                Layout.fillWidth: true
                spacing: 25
                Repeater {
                    model: filteredRoomModel
                    delegate: RoomCard {
                        name: model.nom
                        type: model.type || "Standard"
                        capacity: model.capacite || 0
                        batiment: model.batiment || "N/A"
                        etage: (model.etage !== undefined && model.etage !== null) ? model.etage : -1
                        status: "Disponible"
                    }
                }
            }
        }
    }

    // LOADER DE PAGE
    Rectangle {
        anchors.fill: parent; color: "white"; visible: isLoading; z: 999
        ColumnLayout {
            anchors.centerIn: parent; spacing: 15
            BusyIndicator { running: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: "Synchronisation des espaces..."; font.pixelSize: 14; color: "#64748B"; Layout.alignment: Qt.AlignHCenter }
        }
    }

    RoomForm {
        id: addRoomForm
        currentAdminId: root.userId
        onRoomSaved: {
            isLoading = true;
            roomController.fetchRooms(root.userId);
        }
    }
}