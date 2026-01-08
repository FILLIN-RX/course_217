import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"
import QtQml

ScrollView {
    id: root
    contentWidth: availableWidth
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    leftPadding: 20
    rightPadding: 20

    // --- PROPRIÉTÉS POUR GÉRER LA SEMAINE ---
    property date mondayDate: new Date()
    property var sessionsData: []
    property var sessionCards: []

    // Fonction pour calculer le lundi de la semaine
    function getMonday(d) {
        d = new Date(d);
        let day = d.getDay();
        let diff = d.getDate() - day + (day === 0 ? -6 : 1);
        return new Date(d.setDate(diff));
    }

    // Initialisation
    Component.onCompleted: {
        mondayDate = getMonday(new Date());
        updateWeekLabel();
        loadSessions();
    }

    // Charger les sessions
    function loadSessions() {
        sessionController.fetchSessionsWithDetails();
    }

    // Mettre à jour le label
    function updateWeekLabel() {
        let monday = new Date(mondayDate);
        let friday = new Date(monday);
        friday.setDate(friday.getDate() + 4);

        let monthNames = ["janvier", "février", "mars", "avril", "mai", "juin",
                         "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

        weekLabel.text = "Semaine du " +
                        monday.getDate() + " " + monthNames[monday.getMonth()] +
                        " au " +
                        friday.getDate() + " " + monthNames[friday.getMonth()] +
                        " " + monday.getFullYear();

        loadSessions();
    }

    // Date pour un jour donné
    function getDateForDay(dayIndex) {
        let date = new Date(mondayDate);
        date.setDate(date.getDate() + dayIndex);
        return date;
    }

    // Formater date pour API
    function formatDateForAPI(date) {
        let year = date.getFullYear();
        let month = (date.getMonth() + 1).toString().padStart(2, '0');
        let day = date.getDate().toString().padStart(2, '0');
        return year + "-" + month + "-" + day;
    }

    // Position Y pour une heure
    function getYPositionForTime(timeStr) {
        if (!timeStr) return 40;
        let parts = timeStr.split(":");
        let hour = parseInt(parts[0]);
        let minutes = parts.length > 1 ? parseInt(parts[1]) : 0;
        let yOffset = 40;
        let cellHeight = (gridContainer.height - 40) / 10;

        if (hour < 8) hour = 8;
        if (hour > 18) hour = 18;

        let hourOffset = hour - 8;
        let minuteOffset = minutes / 60;

        return yOffset + (hourOffset + minuteOffset) * cellHeight;
    }

    // Hauteur pour durée
    function getHeightForDuration(startTime, endTime) {
        if (!startTime || !endTime) return 60;
        let startParts = startTime.split(":");
        let endParts = endTime.split(":");

        let startHour = parseInt(startParts[0]);
        let startMin = startParts.length > 1 ? parseInt(startParts[1]) : 0;
        let endHour = parseInt(endParts[0]);
        let endMin = endParts.length > 1 ? parseInt(endParts[1]) : 0;

        let totalHours = (endHour - startHour) + (endMin - startMin) / 60;
        if (totalHours <= 0) totalHours = 1;

        let cellHeight = (gridContainer.height - 40) / 10;
        return Math.max(totalHours * cellHeight, 60);
    }

    // Placer les cartes
    function placeSessionCards(sessions) {
        // Supprimer anciennes cartes
        for (let i = 0; i < sessionCards.length; i++) {
            if (sessionCards[i]) {
                sessionCards[i].destroy();
            }
        }
        sessionCards = [];

        if (sessions.length === 0) return;

        for (let i = 0; i < sessions.length; i++) {
            let session = sessions[i];
            if (!session.date_seance) continue;

            try {
                let sessionDate = new Date(session.date_seance + 'T00:00:00');
                if (isNaN(sessionDate.getTime())) continue;

                let monday = new Date(mondayDate);
                let friday = new Date(monday);
                friday.setDate(friday.getDate() + 6);

                if (sessionDate >= monday && sessionDate <= friday) {
                    let dayOfWeek = sessionDate.getDay();
                    let columnIndex = dayOfWeek === 0 ? 7 : dayOfWeek;
                    let columnWidth = gridContainer.width / 7;
                    let xPos = columnWidth * columnIndex;
                    let yPos = getYPositionForTime(session.heure_debut);
                    let cardHeight = getHeightForDuration(session.heure_debut, session.heure_fin);

                    let cardColor = "#6366F1";
                    if (session.type === "TD") cardColor = "#F59E0B";
                    if (session.type === "TP") cardColor = "#10B981";

                    let matiereNom = session.matiere ? (session.matiere.intitule || "Matière") : "Matière inconnue";
                    let matiereCode = session.matiere && session.matiere.code ? (session.matiere.code + " - ") : "";
                    let profNom = "Prof. Inconnu";
                    if (session.enseignant && session.enseignant.utilisateurs) {
                        profNom = "Pr. " + (session.enseignant.utilisateurs.nom || "Inconnu");
                    }
                    let salleNom = session.salle ? session.salle.nom : "Salle inconnue";

                    let component = Qt.createComponent("../components/ScheduleCard.qml");
                    if (component.status === Component.Ready) {
                        let card = component.createObject(gridContainer, {
                            x: xPos + 2,
                            y: yPos + 2,
                            width: columnWidth - 4,
                            height: Math.max(cardHeight - 4, 50),
                            title: matiereCode + matiereNom,
                            teacher: profNom,
                            room: salleNom,
                            baseColor: cardColor,
                            z: 10
                        });

                        if (card) {
                            sessionCards.push(card);
                        }
                    }
                }
            } catch (e) {
                console.error("Erreur:", e);
            }
        }
    }

    // Connexions
    Connections {
        target: sessionController
        function onSessionsLoaded(data) {
            try {
                if (data && data !== "" && data !== "[]") {
                    let sessions = JSON.parse(data);
                    sessionsData = sessions;
                    placeSessionCards(sessions);
                } else {
                    sessionsData = [];
                    placeSessionCards([]);
                }
            } catch (e) {
                console.error("Erreur parsing:", e);
            }
        }

        function onSessionSaved(success) {
            if (success) {
                loadSessions();
            }
        }
    }

    // Popup de formulaire
    SessionForm {
        id: sessionPopup
    }

    // Contenu principal
    ColumnLayout {
        width: parent.width
        spacing: 20
        anchors.margins: 25

        // En-tête
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    id: titleText
                    text: "Emploi du temps"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#1E293B"
                }
                Text {
                    id: weekLabel
                    text: "Chargement..."
                    color: "#64748B"
                }
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: 10
                Button {
                    id: prevWeekBtn
                    text: "<"
                    flat: true
                    onClicked: {
                        let newDate = new Date(mondayDate);
                        newDate.setDate(newDate.getDate() - 7);
                        mondayDate = newDate;
                        updateWeekLabel();
                    }
                }

                Button {
                    id: todayBtn
                    text: "Aujourd'hui"
                    onClicked: {
                        mondayDate = getMonday(new Date());
                        updateWeekLabel();
                    }
                }

                Button {
                    id: nextWeekBtn
                    text: ">"
                    flat: true
                    onClicked: {
                        let newDate = new Date(mondayDate);
                        newDate.setDate(newDate.getDate() + 7);
                        mondayDate = newDate;
                        updateWeekLabel();
                    }
                }

                Button {
                    id: newSessionBtn
                    text: "+ Nouvelle séance"
                    onClicked: {
                        let now = new Date();
                        let dayNames = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
                        sessionPopup.selectedDay = dayNames[now.getDay()];
                        sessionPopup.selectedTime = "08:00";
                        sessionPopup.selectedDate = formatDateForAPI(now);
                        sessionPopup.open();
                    }

                    background: Rectangle {
                        color: "#6366F1"
                        radius: 6
                    }

                    contentItem: Text {
                        text: newSessionBtn.text
                        color: "white"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Légende
        RowLayout {
            spacing: 15
            LegendItem {
                label: "Cours (CM)"
                color: "#6366F1"
            }
            LegendItem {
                label: "Travaux Dirigés (TD)"
                color: "#F59E0B"
            }
            LegendItem {
                label: "Travaux Pratiques (TP)"
                color: "#10B981"
            }
        }

        // Grille
        Rectangle {
            id: gridContainer
            Layout.fillWidth: true
            implicitHeight: 600
            color: "white"
            radius: 12
            border.color: "#F1F5F9"
            clip: true

            // Message si vide
            Text {
                anchors.centerIn: parent
                text: "Aucune séance cette semaine"
                color: "#94A3B8"
                font.pixelSize: 16
                visible: sessionsData.length === 0
            }

            // Grille interne
            GridLayout {
                anchors.fill: parent
                anchors.margins: 1
                columns: 7
                rows: 11
                columnSpacing: 0
                rowSpacing: 0

                // En-têtes
                Repeater {
                    model: ["Heure", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        color: "#F8FAFC"
                        border.color: "#E2E8F0"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: modelData
                                font.bold: true
                                color: "#64748B"
                                font.pixelSize: 12
                            }

                            Text {
                                text: index === 0 ? "" : (getDateForDay(index - 1).getDate() + "/" + (getDateForDay(index - 1).getMonth() + 1))
                                font.pixelSize: 10
                                color: "#94A3B8"
                            }
                        }
                    }
                }

                // Cellules
                Repeater {
                    model: 10 * 7

                    Rectangle {
                        id: cell
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        border.color: "#F1F5F9"
                        color: cellMouseArea.containsMouse && (index % 7) > 0 ? "#F8FAFC" : "transparent"

                        property int dayIndex: index % 7
                        property int startHour: 8 + Math.floor(index / 7)
                        property string dayName: ["Heure", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"][dayIndex]

                        // Heure (première colonne)
                        Text {
                            visible: parent.dayIndex === 0 && parent.startHour <= 17
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            text: parent.startHour + ":00"
                            color: "#94A3B8"
                            font.pixelSize: 11
                        }

                        // Zone cliquable
                        MouseArea {
                            id: cellMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: parent.dayIndex > 0

                            onClicked: {
                                let timeStr = (parent.startHour < 10 ? "0" : "") + parent.startHour + ":00"
                                let selectedDate = getDateForDay(parent.dayIndex - 1)
                                let dateStr = formatDateForAPI(selectedDate)

                                sessionPopup.selectedDay = parent.dayName
                                sessionPopup.selectedTime = timeStr
                                sessionPopup.selectedDate = dateStr
                                sessionPopup.open()
                            }
                        }
                    }
                }
            }
        }
    }
}
