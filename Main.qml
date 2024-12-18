import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.mazaryn.handlers 1.0

ApplicationWindow {
    id: window
    width: 1900
    height: 980
    visible: true
    title: qsTr("Mazaryn")

    SignupHandler {
        id: signupHandler
    }

    QtObject {
        id: theme
        property color primaryColor: "#2196F3"
        property color backgroundColor: "#f5f5f5"
        property color textColor: "#333333"
        property color accentColor: "#1976D2"
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: welcomePage
    }

    Component {
        id: welcomePage

        Page {
            background: Rectangle {
                color: theme.backgroundColor
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 40
                width: Math.min(parent.width * 0.8, 600)

                Label {
                    text: "Mazaryn"
                    font {
                        pixelSize: 48
                        bold: true
                    }
                    color: theme.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Welcome to Mazaryn Desktop"
                    font.pixelSize: 24
                    color: theme.textColor
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Button {
                        text: "Sign Up"
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 50

                        background: Rectangle {
                            color: parent.pressed ? theme.accentColor : theme.primaryColor
                            radius: 6
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }

                        onClicked: stackView.push("Signup.qml")
                    }

                    Button {
                        text: "Login"
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 50

                        background: Rectangle {
                            color: "transparent"
                            border.color: theme.primaryColor
                            border.width: 2
                            radius: 6
                        }

                        contentItem: Text {
                            text: parent.text
                            color: theme.primaryColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }

                        onClicked: stackView.push("Login.qml")
                    }
                }
            }

            // Footer section for "About" and "Contact"
            Rectangle {
                width: parent.width
                height: 50
                anchors.bottom: parent.bottom
                color: "transparent"

                RowLayout {
                    spacing: 20
                    anchors.centerIn: parent

                    // About Section
                    Text {
                        text: "About"
                        color: theme.primaryColor
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.push("About.qml")
                        }
                    }

                    // Contact Section
                    Text {
                        text: "Contact"
                        color: theme.primaryColor
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.push("Contact.qml")
                        }
                    }

                    // Careers Section
                    Text {
                        text: "Careers"
                        color: theme.primaryColor
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.push("Careers.qml")
                        }
                    }

                    // Privacy Policy
                    Text {
                        text: "Privacy Policy"
                        color: theme.primaryColor
                        font.pixelSize: 14
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.push("PrivacyPolicy.qml")
                        }
                    }
                }
            }
        }
    }
}
