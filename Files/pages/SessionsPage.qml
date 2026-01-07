import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

ColumnLayout {
    spacing: 24
    anchors.fill: parent
    anchors.margins: 30

    // --- EN-TÊTE ---
    RowLayout {
        Layout.fillWidth: true
        ColumnLayout {
            Text { text: "Séances du jour"; font.pixelSize: 26; font.bold: true; color: "#0F172A" }
            Text { text: "Suivi en temps réel des activités académiques"; font.pixelSize: 14; color: "#64748B" }
        }
        Item { Layout.fillWidth: true }
        Button {
            text: "+ Nouvelle séance"
            background: Rectangle { implicitWidth: 150; implicitHeight: 40; radius: 8; color: "#6366F1" }
            palette.buttonText: "white"
        }
    }

    // --- FILTRES RAPIDES ---
    RowLayout {
        spacing: 10
        Repeater {
            model: ["Toutes", "En cours", "Terminées", "À venir"]
            Button {
                text: modelData
                flat: true
                // Style personnalisé pour le filtre actif...
            }
        }
    }

    // --- LISTE DES SÉANCES ---
    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        ColumnLayout {
            width: parent.width - 20
            spacing: 12

            SessionCard {
                subject: "Génie Logiciel"; isLive: true; teacher: "Prof. Aboubakar"
                onClicked: detailPopup.open()
            }
            SessionCard {
                subject: "Base de Données"; teacher: "Dr. Marie Fouda"; time: "10:00 - 12:00"
                onClicked: detailPopup.open()
            }
            SessionCard {
                subject: "Réseaux"; teacher: "M. Essomba"; time: "13:00 - 15:00"
                onClicked: detailPopup.open()
            }
        }
    }

    // --- DIALOGUE DE DÉTAILS (Ce que voit le chef de département) ---
    Popup {
        id: detailPopup
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: 500; height: 600; modal: true; focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle { radius: 16; color: "white" }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            RowLayout {
                Text { text: "Détails de la séance"; font.pixelSize: 20; font.bold: true }
                Item { Layout.fillWidth: true }
                Button { text: "X"; flat: true; onClicked: detailPopup.close() }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#F1F5F9" }

            // Infos détaillées
            GridLayout {
                columns: 2; rowSpacing: 15; columnSpacing: 20

                Text { text: "Enseignant:"; color: "#64748B" }
                Text { text: "Prof. Aboubakar (Présent)"; font.bold: true; color: "#16A34A" }

                Text { text: "Matière:"; color: "#64748B" }
                Text { text: "Génie Logiciel (INF301)"; font.bold: true }

                Text { text: "Salle:"; color: "#64748B" }
                Text { text: "Amphi 500 (85% d'occupation)"; font.bold: true }

                Text { text: "Effectif:"; color: "#64748B" }
                Text { text: "425 étudiants présents / 500"; font.bold: true }
            }

            Text { text: "Progression du cours"; font.bold: true }
            ProgressBar {
                Layout.fillWidth: true; value: 0.65
            }

            Text { text: "Remarques:"; font.bold: true }
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                color: "#F8FAFC"; radius: 8; border.color: "#E2E8F0"
                TextEdit {
                    anchors.fill: parent; anchors.margins: 10
                    text: "Séance démarrée à l'heure. Utilisation du vidéoprojecteur ok."; readOnly: true
                    wrapMode: Text.WordWrap; color: "#475569"
                }
            }

            Button {
                Layout.fillWidth: true; text: "Valider la séance"
                background: Rectangle { implicitHeight: 45; radius: 8; color: "#1E40AF" }
                palette.buttonText: "white"
            }
        }
    }
}
