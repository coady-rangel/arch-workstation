import QtQuick

Rectangle {
    id: root

    required property var theme

    signal toggled()

    implicitWidth: 32
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    Text {
        anchors.centerIn: parent
        text: "◉"
        color: root.theme.textPrimary
        font.pixelSize: 14
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
