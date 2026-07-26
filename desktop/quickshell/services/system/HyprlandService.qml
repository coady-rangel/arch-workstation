import QtQuick
import Quickshell.Io

Item {
    id: root

    property int activeWorkspace: 1
    property var workspaces: []

    function refreshWorkspaces() {
        workspaceProcess.running = true
    }

    function refreshActiveWorkspace() {
        activeWorkspaceProcess.running = true
    }

    Process {
        id: workspaceProcess

        command: ["hyprctl", "workspaces", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text)

                    parsed.sort((a, b) => a.id - b.id)
                    root.workspaces = parsed
                } catch (error) {
                    console.warn("Failed to parse Hyprland workspaces:", error)
                }
            }
        }
    }

    Process {
        id: activeWorkspaceProcess

        command: ["hyprctl", "activeworkspace", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text)
                    root.activeWorkspace = parsed.id
                } catch (error) {
                    console.warn("Failed to parse active workspace:", error)
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: {
            root.refreshWorkspaces()
            root.refreshActiveWorkspace()
        }
    }

    Component.onCompleted: {
        refreshWorkspaces()
        refreshActiveWorkspace()
    }
}
