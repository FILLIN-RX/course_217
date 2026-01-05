import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: mainPage
    anchors.fill: parent

    /* ===== SIDEBAR ===== */
    Sidebar {
        id: sidebar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 260
        
        onMenuSelected: function(index, category) {
            console.log("Menu selected:", index, category);
            switch (index) {
                case 0: contentStack.replace(dashboardPage); break;
                case 1: contentStack.replace(schedulePage); break;
                case 2: contentStack.replace(sessionsPage); break;
                case 3: contentStack.replace(teachersPage); break;
                case 4: contentStack.replace(roomsPage); break;
                case 5: contentStack.replace(reportsPage); break;
                case 6: contentStack.replace(settingsPage); break;
            }
        }
    }

    /* ===== CONTENU PRINCIPAL ===== */
    Rectangle {
        id: contentArea
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        color: "#F8FAFC"

        /* ===== Navigation globale ===== */
        StackView {
            id: contentStack
            anchors.fill: parent
            initialItem: dashboardPage
        }
    }

    /* ===== PAGES ===== */
    Component {
        id: dashboardPage
        DashboardPage {}
    }

    Component {
        id: schedulePage
        SchedulePage {}
    }

    Component {
        id: sessionsPage
        SessionsPage {}
    }

    Component {
        id: teachersPage
        TeachersPage {}
    }

    Component {
        id: roomsPage
        RoomsPage {}
    }

    Component {
        id: reportsPage
        ReportsPage {}
    }

    Component {
        id: settingsPage
        SettingsPage {}
    }
}