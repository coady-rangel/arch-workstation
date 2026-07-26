import QtQuick
import Quickshell.Io

Item {
    id: root

    property int volume: 0
    property bool muted: false
    property string outputType: "speaker"

    function refresh() {
        volumeProcess.running = true
        sinkInspectProcess.running = true
    }

    function toggleMute() {
        muteProcess.running = true
    }

    function setVolume(value) {
        const clamped = Math.max(0, Math.min(100, Math.round(value)))

        setVolumeProcess.command = [
            "wpctl",
            "set-volume",
            "@DEFAULT_AUDIO_SINK@",
            clamped + "%"
        ]

        setVolumeProcess.running = true
    }

    function increaseVolume() {
        increaseProcess.running = true
    }

    function decreaseVolume() {
        decreaseProcess.running = true
    }

    Process {
        id: volumeProcess
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()
                const match = output.match(/Volume:\s+([0-9.]+)/)

                if (match)
                    root.volume = Math.round(parseFloat(match[1]) * 100)

                root.muted = output.indexOf("[MUTED]") !== -1
            }
        }
    }

    Process {
        id: sinkInspectProcess
        command: ["wpctl", "inspect", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.toLowerCase()

                if (output.includes("headphone") || output.includes("headset"))
                    root.outputType = "headphones"
                else if (output.includes("hdmi") || output.includes("displayport"))
                    root.outputType = "display"
                else if (output.includes("bluez") || output.includes("bluetooth"))
                    root.outputType = "bluetooth"
                else
                    root.outputType = "speaker"
            }
        }
    }

    Process {
        id: muteProcess
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: root.refresh()
    }

    Process {
        id: setVolumeProcess
        command: ["true"]
        onExited: root.refresh()
    }

    Process {
        id: increaseProcess
        command: ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"]
        onExited: root.refresh()
    }

    Process {
        id: decreaseProcess
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        onExited: root.refresh()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
