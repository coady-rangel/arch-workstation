import QtQuick

Rectangle {
    id: root

    required property var networkService
    required property var theme

    implicitWidth: content.implicitWidth + 20
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    readonly property string networkIcon: {
        if (!networkService.connected)
            return "×"

        switch (networkService.connectionType) {
        case "wifi":
            return "📶"
        case "ethernet":
            return "↔"
        default:
            return "●"
        }
    }

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.networkIcon
            color: root.theme.textPrimary
            font.pixelSize: 14
        }

        Text {
            text: root.networkService.connected
                ? root.networkService.connectionName
                : "Disconnected"

            color: root.theme.textPrimary
            font.pixelSize: 14
            font.weight: Font.Medium
        }
    }
}
