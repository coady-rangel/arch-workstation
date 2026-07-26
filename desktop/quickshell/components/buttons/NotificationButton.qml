import QtQuick

Rectangle {
    id: root

    required property var notificationService
    required property var theme

    signal toggled()

    implicitWidth: root.notificationService.unreadCount > 0 ? 52 : 32
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    Row {
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: "🔔"
            color: root.theme.textPrimary
            font.pixelSize: 13
        }

        Text {
            visible: root.notificationService.unreadCount > 0
            text: root.notificationService.unreadCount
            color: root.theme.textPrimary
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
