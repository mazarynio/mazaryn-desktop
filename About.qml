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

        Label {
            text: "About Mazaryn"
            font.pixelSize: 32
            font.bold: true
            color: "#2196F3"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Mazaryn is a social network designed to help users discover and nurture their unique talents.\n\n" +
                  "Our mission is to create a vibrant and supportive community where creativity thrives, " +
                  "opportunities are shared, and every moment brings happiness and inspiration.\n\n" +
                  "Together, we aim to empower individuals to achieve their potential and enjoy a journey " +
                  "of personal and collective growth."
            wrapMode: Text.WordWrap
            font.pixelSize: 16
            color: "#333333"
            Layout.alignment: Qt.AlignHCenter
            width: Math.min(parent.width * 0.8, 600)
        }

        Button {
            text: "Back"
            Layout.alignment: Qt.AlignHCenter
            onClicked: stackView.pop()
        }
    }
}
