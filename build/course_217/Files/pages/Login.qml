import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    width: parent.width
    height: 940

    // Correct signal names (lowercase for QML convention)
    signal goToRegister
    signal loginSuccess

    Rectangle {
        anchors.fill: parent
        color: "#D4E8E6"

        Rectangle {
            width: 550
            height: 520
            radius: 16
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 50
                spacing: 16

                // Logo - Fixed: Use placeholder or ensure file exists
                Rectangle {
                    width: 56
                    height: 56
                    radius: 8
                    color: "#7C2AE8"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 4

                    Text {
                        anchors.centerIn: parent
                        text: "Logo"
                        color: "white"
                        font.pixelSize: 12
                    }
                }

                Text {
                    text: "Sign in Your Account"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 12
                }

                // Email
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "Email"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: "#1A1A1A"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        color: "#F5F5F5"
                        radius: 8
                        border.width: 1
                        border.color: "#E0E0E0"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 10

                            TextField {
                                id: emailField
                                Layout.fillWidth: true
                                font.pixelSize: 14
                                placeholderText: "Enter your email"
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text: "✉"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }
                    }
                }

                // Password
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "Mots de passe"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: "#1A1A1A"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        color: "#F5F5F5"
                        radius: 8
                        border.width: 1
                        border.color: "#E0E0E0"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 10

                            TextField {
                                id: passwordField
                                Layout.fillWidth: true
                                font.pixelSize: 14
                                placeholderText: "Enter your password"
                                echoMode: TextInput.Password
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text: "🔒"
                                font.pixelSize: 20
                                color: "#666666"
                            }
                        }
                    }
                }

                // Remember + Forgot
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    spacing: 0

                    RowLayout {
                        spacing: 6

                        Rectangle {
                            width: 18
                            height: 18
                            radius: 3
                            border.width: 2
                            border.color: "#CCCCCC"
                            color: "transparent"
                        }

                        Text {
                            text: "Remember my preference"
                            font.pixelSize: 13
                            color: "#666666"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Forgot Password?"
                        color: "#7C2AE8"
                        font.pixelSize: 13
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Forgot password clicked")
                        }
                    }
                }

                // Spacer
                Item {
                    Layout.fillHeight: true
                    Layout.minimumHeight: 10
                }

                // Sign In Button - FIXED: Simplified to avoid style conflicts
                Button {
                    text: "Sign In"
                    Layout.fillWidth: true
                    height: 48

                    // Use Material-compatible styling
                    palette.button: "#7C2AE8"
                    palette.buttonText: "white"

                    onClicked: {
                        console.log("Login attempt:", emailField.text)
                        loginSuccess()  // Emit signal
                    }
                }

                // Sign up text
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 8
                    spacing: 4

                    Text {
                        text: "Pas de compte?"
                        font.pixelSize: 13
                        color: "#666666"
                    }

                    Button {
                        text: "Sign up"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        flat: true  // Makes it look like text
                        onClicked: goToRegister()  // Emit signal
                    }
                }
            }
        }
    }
}
