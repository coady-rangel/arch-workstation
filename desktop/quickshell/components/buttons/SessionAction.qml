import QtQuick

Rectangle {
    id: root

    required property string label
    required property var theme

    signal triggered()

    implicitWidth: 160
    implicitHeight: 32

    radius: 10
    color: "transparent"

    Text {
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }

        text: root.label
        color: root.theme.textPrimary
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: root.triggered()

        hoverEnabled: true
        onEntered: root.color = root.theme.surface
        onExited: root.color = "transparent"
    }
}
