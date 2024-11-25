import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle {
        color: "#f5f5f5"
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(parent.width * 0.8, 600)

        Label {
            text: "Contact Mazaryn Support"
            font.pixelSize: 32
            font.bold: true
            color: "#2196F3"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Mazaryn Help channel will answer all your questions about our services, your account, and more."
            font.pixelSize: 16
            color: "#333333"
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            width: Math.min(parent.width * 0.8, 600)
        }

        // Email Input Field
        TextField {
            id: emailField
            placeholderText: "Enter your email address"
            font.pixelSize: 16
            width: Math.min(parent.width * 0.8, 600)
            Layout.alignment: Qt.AlignHCenter
        }

        // Description Input Field
        TextArea {
            id: descriptionField
            placeholderText: "Write your description or query here..."
            font.pixelSize: 16
            width: Math.min(parent.width * 0.8, 600)
            height: 150
            Layout.alignment: Qt.AlignHCenter
        }

        // Submit Button
        Button {
            text: "Submit"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 50

            background: Rectangle {
                color: parent.pressed ? "#1976D2" : "#2196F3"
                radius: 6
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }

            onClicked: {
                // Logic for submitting the form (you can handle it here)
                console.log("Email: " + emailField.text);
                console.log("Description: " + descriptionField.text);
            }
        }

        // Back Button
        Button {
            text: "Back"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 50

            background: Rectangle {
                color: "transparent"
                border.color: "#2196F3"
                border.width: 2
                radius: 6
            }

            contentItem: Text {
                text: parent.text
                color: "#2196F3"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }

            onClicked: stackView.pop()
        }
    }
}
