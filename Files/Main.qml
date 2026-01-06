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

        FontLoader {
            id: materialFont
            source: "qrc:/qt/qml/course_217/assets/MaterialIcons-Regular.ttf"
        }
    readonly property string iconFontFamily: materialFont.name

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
        MainPage {
            Component.onCompleted: {
                root.visibility = Window.Maximized // Passe en plein écran au login
            }
        }
    }
}
