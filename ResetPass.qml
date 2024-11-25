import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.mazaryn.handlers 1.0

Page {
    id: resetPasswordPage

    // Property grouping
    QtObject {
        id: internal
        property bool isLoading: false
        property var validationErrors: QtObject {
            property string email: ""
        }
    }

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

                background: Rectangle {
                    color: "transparent"
                }
            }
        }
    }

    // Loading indicator
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: internal.isLoading
        visible: running
        z: 1
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: theme.backgroundColor
    }

    // Main Content
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        spacing: 20

        // Title
        Label {
            text: qsTr("Reset Your Password")
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: theme.textColor
        }

        // Description
        Label {
            text: qsTr("Enter your email address and we'll send you instructions to reset your password.")
            color: theme.textColor
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 20
        }

        // Email Field Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Label {
                text: qsTr("Email*")
                color: theme.textColor
                font.pixelSize: 14
            }

            TextField {
                id: emailField
                Layout.fillWidth: true
                placeholderText: qsTr("Enter your email address")
                placeholderTextColor: "#999999"
                color: theme.textColor
                enabled: !internal.isLoading

                background: Rectangle {
                    color: "transparent"
                    border.color: emailField.activeFocus ? theme.primaryColor : theme.borderColor
                    border.width: 1
                    radius: 4
                }

                onTextChanged: {
                    if (!text.includes("@") || !text.includes(".")) {
                        internal.validationErrors.email = qsTr("Please enter a valid email address")
                    } else {
                        internal.validationErrors.email = ""
                    }
                }
            }

            // Error Message
            Label {
                visible: internal.validationErrors.email !== ""
                text: internal.validationErrors.email
                color: "red"
                font.pixelSize: 12
            }
        }

        // Reset Button
        Button {
            text: qsTr("Reset Password")
            Layout.fillWidth: true
            Layout.topMargin: 20
            enabled: isValidEmail() && !internal.isLoading

            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }

            background: Rectangle {
                color: parent.enabled ? theme.primaryColor : "#CCCCCC"
                radius: 4

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: parent.parent.hovered ? 0.1 : 0
                    radius: 4
                }
            }

            onClicked: resetPassword()
        }

        // Back to Login Link
        Button {
            text: qsTr("Back to Login")
            flat: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            enabled: !internal.isLoading

            contentItem: Text {
                text: parent.text
                color: theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }
        }
    }

    // Combined Dialog for Success and Error messages
    Dialog {
        id: messageDialog
        property bool isError: false
        property alias messageText: messageLabel.text

        anchors.centerIn: parent
        modal: true
        title: isError ? qsTr("Error") : qsTr("Success")
        closePolicy: Dialog.CloseOnEscape

        background: Rectangle {
            color: theme.backgroundColor
            border.color: theme.borderColor
            border.width: 1
            radius: 4
        }

        ColumnLayout {
            spacing: 20

            Label {
                id: messageLabel
                color: theme.textColor
                wrapMode: Text.WordWrap
                Layout.maximumWidth: Math.min(resetPasswordPage.width * 0.8, 300)
            }

            Button {
                text: qsTr("OK")
                Layout.fillWidth: true

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }

                background: Rectangle {
                    color: theme.primaryColor
                    radius: 4

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: parent.parent.hovered ? 0.1 : 0
                        radius: 4
                    }
                }

                onClicked: {
                    messageDialog.close()
                    if (!isError) {
                        stackView.pop()
                    }
                }
            }
        }
    }

    // ResetPasswordHandler
    ResetPasswordHandler {
        id: resetPasswordHandler
    }

    // Handler Connections
    Connections {
        target: resetPasswordHandler

        function onResetPasswordSuccess() {
            messageDialog.isError = false
            messageDialog.messageText = qsTr("Password reset instructions have been sent to your email.")
            messageDialog.open()
        }

        function onResetPasswordError(error) {
            messageDialog.isError = true
            messageDialog.messageText = error
            messageDialog.open()
        }

        function onResetPasswordProgress(inProgress) {
            internal.isLoading = inProgress
            busyIndicator.running = inProgress
        }
    }

    // Helper Functions
    function isValidEmail() {
        return emailField.text.includes("@") && emailField.text.includes(".")
    }

    function resetPassword() {
        if (isValidEmail()) {
            resetPasswordHandler.requestPasswordReset(emailField.text)
        }
    }

    // Clean up when page is destroyed
    Component.onDestruction: {
        if (messageDialog.visible) {
            messageDialog.close()
        }
    }
}
