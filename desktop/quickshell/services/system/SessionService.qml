import QtQuick
import Quickshell.Io

Item {
    id: root

    function logout() {
        logoutProcess.running = true
    }

    function reboot() {
        rebootProcess.running = true
    }

    function shutdown() {
        shutdownProcess.running = true
    }

    Process {
        id: logoutProcess
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
    }

    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
    }
}
