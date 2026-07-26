import QtQuick

Rectangle {
    id: root

    required property var audioService
    required property var theme

    implicitWidth: content.implicitWidth + 20
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    readonly property string audioIcon: {
        if (audioService.muted) {
            return "🔇"
        }

        switch (audioService.outputType) {
        case "headphones":
            return "🎧"
        case "display":
            return "🖥"
        case "bluetooth":
            return "🎧"
        default:
            return "🔊"
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.audioIcon
            color: root.theme.textPrimary
            font.pixelSize: 14
        }

        Text {
            text: root.audioService.volume + "%"
            color: root.theme.textPrimary
            font.pixelSize: 14
            font.weight: Font.Medium
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton

        onClicked: root.audioService.toggleMute()

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                root.audioService.increaseVolume()
            } else if (wheel.angleDelta.y < 0) {
                root.audioService.decreaseVolume()
            }
        }
    }
}
