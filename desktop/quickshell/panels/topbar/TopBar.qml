import Quickshell
import QtQuick
import "../../components/buttons"
import "../../components/indicators"

PanelWindow {
    id: root

    required property var clockService
    required property var hyprlandService
    required property var audioService
    required property var networkService
    required property var notificationService
    required property var theme

    signal launcherToggled()
    signal notificationCenterToggled()
    signal controlCenterToggled()
    signal powerMenuToggled()

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 42
    color: "transparent"

    Row {
        anchors {
            left: parent.left
            leftMargin: 8
            top: parent.top
            topMargin: 5
        }

        spacing: 8

        LauncherButton {
            theme: root.theme
            onToggled: root.launcherToggled()
        }

        WorkspaceIndicator {
            hyprlandService: root.hyprlandService
            theme: root.theme
        }
    }

    ClockWidget {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 5
        }

        clockService: root.clockService
        theme: root.theme
    }

    Row {
        anchors {
            right: parent.right
            rightMargin: 8
            top: parent.top
            topMargin: 5
        }

        spacing: 8

        NetworkIndicator {
            networkService: root.networkService
            theme: root.theme
        }

        VolumeIndicator {
            audioService: root.audioService
            theme: root.theme
        }

        NotificationButton {
            notificationService: root.notificationService
            theme: root.theme
            onToggled: root.notificationCenterToggled()
        }

        ControlCenterButton {
            theme: root.theme
            onToggled: root.controlCenterToggled()
        }

        PowerButton {
            theme: root.theme
            onToggled: root.powerMenuToggled()
        }
    }
}
