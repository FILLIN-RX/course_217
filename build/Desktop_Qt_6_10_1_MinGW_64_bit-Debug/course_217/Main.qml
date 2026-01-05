pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Controls

import "pages"
import "layout"

Window {
    id: root
    width: 900
    height: 700
    visible: true
    title: qsTr("Course 217")

    property string currentPage: "login" // "login", "register", "main"

    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: root.currentPage === "login" ? loginComponent : (root.currentPage === "register" ? registerComponent : mainComponent)
    }

    Component {
        id: loginComponent
        Login {
            onGoToRegister: root.currentPage = "register"
            onLoginSuccess: root.currentPage = "main"
        }
    }

    Component {
        id: registerComponent
        Register {
            onGoToLogin: root.currentPage = "login"
            onRegisterSuccess: root.currentPage = "main"
        }
    }

    Component {
        id: mainComponent
        MainPage {}
    }
}
