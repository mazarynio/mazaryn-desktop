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

    property string usernameError: ""
    property string emailError: ""
    property string passwordError: ""
    property string repeatPasswordError: ""

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
            text: "Create Account"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: theme.textColor
        }

        // Username section
        Label {
            text: "Username*"
            color: theme.textColor
            font.pixelSize: 14
            Layout.bottomMargin: -15
        }

        TextField {
            id: usernameField
            Layout.fillWidth: true
            placeholderText: "Enter your username"

            onTextChanged: {
                if(text.length < 3) {
                    signupPage.usernameError = "Username must be at least 3 characters"
                } else {
                    signupPage.usernameError = ""
                }
            }
        }

        Label {
            visible: usernameError !== ""
            text: usernameError
            color: "red"
            font.pixelSize: 12
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
                validatePasswords()
            }
        }

        Label {
            visible: passwordError !== ""
            text: passwordError
            color: "red"
            font.pixelSize: 12
        }

        // Repeat Password section
        Label {
            text: "Repeat Password*"
            color: theme.textColor
            font.pixelSize: 14
            Layout.bottomMargin: -15
        }

        TextField {
            id: repeatPasswordField
            Layout.fillWidth: true
            placeholderText: "Repeat your password"
            echoMode: TextInput.Password

            onTextChanged: validatePasswords()
        }

        Label {
            visible: repeatPasswordError !== ""
            text: repeatPasswordError
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

    function validatePasswords() {
        if (repeatPasswordField.text !== passwordField.text) {
            signupPage.repeatPasswordError = "Passwords do not match"
        } else {
            signupPage.repeatPasswordError = ""
        }
    }

    function canSignUp() {
        return usernameField.text.length >= 3 &&
               emailField.text.includes("@") &&
               emailField.text.includes(".") &&
               passwordField.text.length >= 8 &&
               passwordField.text === repeatPasswordField.text
    }

    function signUp() {
        signupHandler.signup(
            usernameField.text,
            emailField.text,
            passwordField.text
        )
    }
}
