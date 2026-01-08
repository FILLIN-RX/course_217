import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    implicitWidth: 280
    implicitHeight: 220
    radius: 12
    color: "white"
    border.color: "#F1F5F9"
    border.width: 1

    property string name: ""
    property string type: ""
    property int capacity: 0
    property string batiment: ""
    property int etage: 0
    property string status: "Disponible"

    // On pré-calcule le texte de l'étage pour éviter l'erreur de calcul dans le Text {}
    readonly property string etageSuffix: (root.etage >= 0) ? " • Étage " + root.etage : ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Text { 
                text: root.name
                font.pixelSize: 18
                font.bold: true
                color: "#1E293B"
                Layout.fillWidth: true
                elide: Text.ElideRight 
            }
            Rectangle {
                width: 70; height: 22; radius: 11
                color: "#DCFCE7"
                Text { 
                    anchors.centerIn: parent
                    text: root.status
                    font.pixelSize: 10
                    font.bold: true
                    color: "#16A34A" 
                }
            }
        }

        // LIGNE 30 (Corrigée) : Localisation
        RowLayout {
            spacing: 6
            Text { 
                text: "\ue0c8"
                font.family: "Material Icons"
                font.pixelSize: 14
                color: "#94A3B8" 
            }
            Text { 
                // On utilise la propriété calculée plus haut
                text: root.batiment + root.etageSuffix
                font.pixelSize: 13
                color: "#64748B" 
            }
        }

        Rectangle {
            height: 22; radius: 6; color: "#EFF6FF"
            width: typeTxt.implicitWidth + 16
            Text { 
                id: typeTxt
                anchors.centerIn: parent
                text: root.type
                font.pixelSize: 11
                color: "#3B82F6"
                font.bold: true 
            }
        }

        Item { Layout.fillHeight: true }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#F1F5F9" }

        RowLayout {
            Layout.fillWidth: true
            Text { text: "\ue7ef"; font.family: "Material Icons"; font.pixelSize: 16; color: "#94A3B8" }
            Text { 
                text: root.capacity + " places"
                font.pixelSize: 13
                color: "#475569"
                font.bold: true 
            }
            Item { Layout.fillWidth: true }
            Text { text: "Détails →"; font.pixelSize: 12; color: "#3B82F6"; font.bold: true }
        }
    }
}