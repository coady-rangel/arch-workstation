import Quickshell
import QtQuick
import QtQuick.Controls
import "../../components/buttons"
import "../../widgets"

PanelWindow {
    id: root

    required property var audioService
    required property var networkService
    required property var mediaService
    required property var sessionService
    required property var theme

    visible: false
    color: "transparent"
    focusable: true

    anchors {
        top: true
        right: true
    }

    implicitWidth: 340
    implicitHeight: content.implicitHeight + 32

    function openPanel() {
        root.visible = true
        focusTimer.restart()
    }

    function closePanel() {
        root.visible = false
    }

    function toggle() {
        if (root.visible)
            root.closePanel()
        else
            root.openPanel()
    }

    Timer {
        id: focusTimer
        interval: 30
        repeat: false
        onTriggered: keyHandler.forceActiveFocus()
    }

    Item {
        id: keyHandler
        anchors.fill: parent

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                root.closePanel()
                event.accepted = true
            }
        }
    }


    Rectangle {
        anchors.fill: parent
        radius: 18
        color: root.theme.surfaceRaised

        Column {
            id: content

            anchors {
                fill: parent
                margins: 16
            }

            spacing: 14

            Text {
                text: "Control Center"
                color: root.theme.textPrimary
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: parent.width
                height: networkSection.implicitHeight + 20
                radius: 12
                color: root.theme.surface

                Column {
                    id: networkSection

                    anchors {
                        fill: parent
                        margins: 10
                    }

                    spacing: 4

                    Text {
                        text: "Network"
                        color: root.theme.textSecondary
                        font.pixelSize: 12
                    }

                    Text {
                        text: root.networkService.connected
                            ? root.networkService.connectionName
                            : "Disconnected"

                        color: root.theme.textPrimary
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }

                    Text {
                        text: root.networkService.connected
                            ? root.networkService.connectionType + " · " + root.networkService.device
                            : ""

                        visible: text.length > 0
                        color: root.theme.textSecondary
                        font.pixelSize: 12
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 112
                radius: 12
                color: root.theme.surface

                Column {
                    anchors {
                        fill: parent
                        margins: 12
                    }

                    spacing: 10

                    Row {
                        width: parent.width
                        spacing: 10

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            text: root.audioService.muted
                                ? "🔇"
                                : root.audioService.outputType === "headphones"
                                    ? "🎧"
                                    : root.audioService.outputType === "bluetooth"
                                        ? "󰂯"
                                        : root.audioService.outputType === "display"
                                            ? "󰍹"
                                            : "🔊"

                            font.pixelSize: 16
                        }

                        Column {
                            spacing: 2

                            Text {
                                text: "Audio"
                                color: root.theme.textPrimary
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }

                            Text {
                                text: root.audioService.outputType
                                color: root.theme.textSecondary
                                font.pixelSize: 11
                            }
                        }

                        Item {
                            width: Math.max(
                                0,
                                parent.width
                                    - 10
                                    - 24
                                    - 80
                                    - 64
                            )
                            height: 1
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            text: root.audioService.volume + "%"
                            color: root.theme.textPrimary
                            font.pixelSize: 13
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: 10

                        Rectangle {
                            width: 34
                            height: 30
                            radius: 10

                            color: root.audioService.muted
                                ? root.theme.accent
                                : root.theme.surfaceHover

                            Text {
                                anchors.centerIn: parent
                                text: root.audioService.muted ? "🔇" : "🔊"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.audioService.toggleMute()
                            }
                        }

                        Slider {
                            id: volumeSlider

                            width: parent.width - 44
                            height: 30

                            from: 0
                            to: 100
                            value: root.audioService.volume

                            onMoved: root.audioService.setVolume(value)

                            background: Rectangle {
                                x: volumeSlider.leftPadding
                                y: volumeSlider.topPadding
                                    + volumeSlider.availableHeight / 2
                                    - height / 2

                                width: volumeSlider.availableWidth
                                height: 5
                                radius: 3
                                color: root.theme.surfaceHover

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: 3
                                    color: root.theme.accent
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.leftPadding
                                    + volumeSlider.visualPosition
                                    * (volumeSlider.availableWidth - width)

                                y: volumeSlider.topPadding
                                    + volumeSlider.availableHeight / 2
                                    - height / 2

                                width: 16
                                height: 16
                                radius: 8
                                color: root.theme.textPrimary
                            }
                        }
                    }
                }
            }

            MediaWidget {
                width: parent.width
                mediaService: root.mediaService
                theme: root.theme
            }

            Rectangle {
                width: parent.width
                height: sessionSection.implicitHeight + 20
                radius: 12
                color: root.theme.surface

                Column {
                    id: sessionSection

                    anchors {
                        fill: parent
                        margins: 10
                    }

                    spacing: 6

                    Text {
                        text: "Session"
                        color: root.theme.textSecondary
                        font.pixelSize: 12
                    }

                    SessionAction {
                        label: "Logout"
                        theme: root.theme
                        onTriggered: root.sessionService.logout()
                    }

                    SessionAction {
                        label: "Reboot"
                        theme: root.theme
                        onTriggered: root.sessionService.reboot()
                    }

                    SessionAction {
                        label: "Shutdown"
                        theme: root.theme
                        onTriggered: root.sessionService.shutdown()
                    }
                }
            }
        }
    }
}
