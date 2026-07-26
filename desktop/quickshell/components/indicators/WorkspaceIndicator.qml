import QtQuick
import Quickshell.Io

Rectangle {
    id: root

    required property var hyprlandService
    required property var theme

    implicitWidth: workspaceRow.implicitWidth + 18
    implicitHeight: 32

    radius: 14
    color: theme.surfaceRaised

    Row {
        id: workspaceRow

        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.hyprlandService.workspaces

            Rectangle {
                required property var modelData

                width: modelData.id === root.hyprlandService.activeWorkspace ? 18 : 8
                height: 8
                radius: 4

                color: root.theme.textPrimary

                opacity: modelData.id === root.hyprlandService.activeWorkspace
                    ? 1.0
                    : 0.45

                Behavior on width {
                    NumberAnimation {
                        duration: 120
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        workspaceSwitch.command = [
                            "hyprctl",
                            "dispatch",
                            "workspace",
                            String(modelData.id)
                        ]

                        workspaceSwitch.running = true
                    }
                }

                Process {
                    id: workspaceSwitch
                }
            }
        }
    }
}
