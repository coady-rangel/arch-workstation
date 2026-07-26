import QtQuick

Rectangle {
    id: root

    required property var clockService
    required property var theme

    implicitWidth: content.implicitWidth + 28
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 10

        Text {
            text: root.clockService.timeText
            color: root.theme.textPrimary
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        Rectangle {
            width: 1
            height: 18
            color: root.theme.textSecondary
            opacity: 0.45
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.clockService.dateText
            color: root.theme.textPrimary
            font.pixelSize: 14
            font.weight: Font.Medium
        }
    }
}
