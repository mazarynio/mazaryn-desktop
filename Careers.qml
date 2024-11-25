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
            text: "Mazaryn Careers"
            font.pixelSize: 32
            font.bold: true
            color: "#2196F3"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "We're Hiring! We're looking for talented people to join our team."
            font.pixelSize: 16
            color: "#333333"
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            width: Math.min(parent.width * 0.8, 600)
        }

        // Apply Button
        Button {
            text: "Apply"
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
                // Logic for applying (e.g., redirect to a form or external link)
                console.log("Application process started");
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
