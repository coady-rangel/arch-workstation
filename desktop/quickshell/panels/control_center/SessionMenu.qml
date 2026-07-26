import Quickshell
import QtQuick
import "../../components/buttons"

PanelWindow {
    id: root

    required property var sessionService
    required property var theme

    visible: false
    focusable: true

    anchors {
        top: true
        right: true
    }

    implicitWidth: 180
    implicitHeight: menuColumn.implicitHeight + 20

    color: "transparent"

    function openMenu() {
        root.visible = true
        focusTimer.restart()
    }

    function closeMenu() {
        root.visible = false
    }

    function toggleMenu() {
        if (root.visible)
            root.closeMenu()
        else
            root.openMenu()
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
                root.closeMenu()
                event.accepted = true
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: root.theme.surfaceRaised

        Column {
            id: menuColumn

            anchors {
                fill: parent
                margins: 10
            }

            spacing: 6

            SessionAction {
                label: "Logout"
                theme: root.theme

                onTriggered: {
                    root.closeMenu()
                    root.sessionService.logout()
                }
            }

            SessionAction {
                label: "Reboot"
                theme: root.theme

                onTriggered: {
                    root.closeMenu()
                    root.sessionService.reboot()
                }
            }

            SessionAction {
                label: "Shutdown"
                theme: root.theme

                onTriggered: {
                    root.closeMenu()
                    root.sessionService.shutdown()
                }
            }
        }
    }
}
