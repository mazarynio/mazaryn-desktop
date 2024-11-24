import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.mazaryn.handlers 1.0

Page {
    id: signupPage

    header: ToolBar {
        background: Rectangle {
            color: "transparent"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10

            Button {
                text: "← Back"
                flat: true
                onClicked: stackView.pop()

                contentItem: Text {
                    text: parent.text
                    color: theme.primaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    property string emailError: ""
    property string passwordError: ""

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
        visible: running
        z: 1
    }

    Rectangle {
        anchors.fill: parent
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        spacing: 20

        Label {
            text: "Login"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: theme.textColor
        }


        // Email section
        Label {
            text: "Email*"
            color: theme.textColor
            font.pixelSize: 14
            Layout.bottomMargin: -15
        }

        TextField {
            id: emailField
            Layout.fillWidth: true
            placeholderText: "Enter your email address"

            onTextChanged: {
                if (!text.includes("@") || !text.includes(".")) {
                    signupPage.emailError = "Please enter a valid email address"
                } else {
                    signupPage.emailError = ""
                }
            }
        }

        Label {
            visible: emailError !== ""
            text: emailError
            color: "red"
            font.pixelSize: 12
        }

        // Password section
        Label {
            text: "Password*"
            color: theme.textColor
            font.pixelSize: 14
            Layout.bottomMargin: -15
        }

        TextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: "Enter your password"
            echoMode: TextInput.Password

            onTextChanged: {
                if (text.length < 8) {
                    signupPage.passwordError = "Password must be at least 8 characters"
                } else {
                    signupPage.passwordError = ""
                }

            }
        }

        Label {
            visible: passwordError !== ""
            text: passwordError
            color: "red"
            font.pixelSize: 12
        }


        Button {
            text: "Sign up"
            Layout.fillWidth: true
            enabled: canSignUp() && !busyIndicator.running

            onClicked: signUp()

            background: Rectangle {
                color: parent.enabled ? theme.primaryColor : "#CCCCCC"
                radius: 4
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Dialog {
        id: errorDialog
        title: "Error"
        property string text: ""

        Label {
            text: errorDialog.text
        }

        standardButtons: Dialog.Ok
    }

    Connections {
        target: signupHandler

        function onSignupSuccess() {
            stackView.push("qrc:/pages/MainApp.qml")
        }

        function onSignupError(error) {
            errorDialog.text = error
            errorDialog.open()
        }

        function onSignupProgress(inProgress) {
            busyIndicator.running = inProgress
        }
    }


    function canLogin() {
        return emailField.text.includes("@") &&
               emailField.text.includes(".") &&
               passwordField.text.length >= 8
    }

    function login() {
        loginHandler.login(
            emailField.text,
            passwordField.text
        )
    }
}
