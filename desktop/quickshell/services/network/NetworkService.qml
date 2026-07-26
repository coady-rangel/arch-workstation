import QtQuick
import Quickshell.Io

Item {
    id: root

    property string connectionType: "disconnected"
    property string connectionName: ""
    property string device: ""
    property bool connected: false

    function refresh() {
        networkProcess.running = true
    }

    Process {
        id: networkProcess

        command: [
            "nmcli",
            "-t",
            "-f",
            "DEVICE,TYPE,STATE,CONNECTION",
            "device"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")

                root.connected = false
                root.connectionType = "disconnected"
                root.connectionName = ""
                root.device = ""

                for (const line of lines) {
                    if (!line)
                        continue

                    const parts = line.split(":")
                    const device = parts[0]
                    const type = parts[1]
                    const state = parts[2]
                    const connection = parts.slice(3).join(":")

                    if (type === "loopback")
                        continue

                    if (state === "connected") {
                        root.connected = true
                        root.device = device
                        root.connectionName = connection

                        if (type === "wifi") {
                            root.connectionType = "wifi"
                        } else if (type === "ethernet") {
                            root.connectionType = "ethernet"
                        } else {
                            root.connectionType = type
                        }

                        break
                    }
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
