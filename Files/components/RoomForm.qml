import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: roomForm
    width: 460
    height: 620
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property int currentAdminId: 0
    property bool isSaving: false 
    signal roomSaved()

    background: Rectangle {
        radius: 16
        color: "white"
        border.color: "#E2E8F0"
        layer.enabled: true
        // Note: Assurez-vous d'importer QtQuick.Effects si disponible, sinon Rectangle suffit
    }

    contentItem: ColumnLayout {
        spacing: 24
        anchors.margins: 30

        // --- EN-TÊTE ---
        Column {
            spacing: 6
            Text {
                text: "Nouvelle Salle"
                font.pixelSize: 24; font.bold: true; color: "#0F172A"
            }
            Text {
                text: "Configurez les détails de votre espace de cours"
                font.pixelSize: 14; color: "#64748B"
            }
        }

        // --- CORPS DU FORMULAIRE ---
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 20

                // NOM
                ColumnLayout {
                    spacing: 8
                    Text { text: "Nom de la salle"; font.bold: true; font.pixelSize: 13; color: "#475569" }
                    TextField {
                        id: nomField
                        placeholderText: "ex: Amphi Malick Sy"
                        Layout.fillWidth: true
                        background: Rectangle {
                            radius: 8
                            border.color: parent.activeFocus ? "#3B82F6" : "#CBD5E1"
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }

                // TYPE
                ColumnLayout {
                    spacing: 8
                    Text { text: "Type d'espace"; font.bold: true; font.pixelSize: 13; color: "#475569" }
                    ComboBox {
                        id: typeCombo
                        Layout.fillWidth: true
                        model: ["Amphithéâtre", "Salle de cours", "Laboratoire", "Salle informatique"]
                        background: Rectangle { radius: 8; border.color: "#CBD5E1" }
                    }
                }

                // CAPACITÉ
                ColumnLayout {
                    spacing: 8
                    Text { text: "Capacité maximale"; font.bold: true; font.pixelSize: 13; color: "#475569" }
                    TextField {
                        id: capaciteField
                        placeholderText: "Nombre de places"
                        Layout.fillWidth: true
                        validator: IntValidator { bottom: 1; top: 9999 }
                        background: Rectangle {
                            radius: 8
                            border.color: parent.activeFocus ? "#3B82F6" : "#CBD5E1"
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }

                // BÂTIMENT
                ColumnLayout {
                    spacing: 8
                    Text { text: "Bâtiment / Bloc"; font.bold: true; font.pixelSize: 13; color: "#475569" }
                    TextField {
                        id: batimentField
                        placeholderText: "ex: Bloc Administratif"
                        Layout.fillWidth: true
                        background: Rectangle { radius: 8; border.color: "#CBD5E1" }
                    }
                }

                // ÉTAGE
                ColumnLayout {
                    spacing: 8
                    Text { text: "Numéro de l'étage"; font.bold: true; font.pixelSize: 13; color: "#475569" }
                    SpinBox {
                        id: etageSpin
                        from: 0; to: 20; Layout.fillWidth: true; editable: true
                    }
                }
            }
        }

        // --- ACTIONS ---
        RowLayout {
            spacing: 12
            Layout.alignment: Qt.AlignRight

            Button {
                text: "Annuler"
                onClicked: roomForm.close()
                flat: true
                enabled: !isSaving
            }

            Button {
                id: saveBtn
                Layout.preferredWidth: 180
                Layout.preferredHeight: 46
                enabled: !isSaving && nomField.text !== "" && capaciteField.text !== ""

                contentItem: RowLayout {
                    spacing: 10
                    Item { Layout.fillWidth: true }
                    BusyIndicator {
                        running: isSaving
                        visible: isSaving
                        implicitWidth: 20; implicitHeight: 20
                    }
                    Text {
                        text: isSaving ? "Enregistrement..." : "Créer la salle"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 14
                    }
                    Item { Layout.fillWidth: true }
                }

                background: Rectangle {
                    color: saveBtn.enabled ? (saveBtn.down ? "#1D4ED8" : "#3B82F6") : "#94A3B8"
                    radius: 10
                }

                onClicked: {
                    isSaving = true;
                    roomController.addRoom(
                        currentAdminId,
                        nomField.text,
                        typeCombo.currentText,
                        parseInt(capaciteField.text)
                    );
                }
            }
        }
    }

    Connections {
        target: roomController
        function onRoomSaved(success, message) {
            isSaving = false;
            if (success) {
                nomField.text = "";
                capaciteField.text = "";
                batimentField.text = "";
                roomForm.close();
                roomForm.roomSaved();
            }
        }
    }
}