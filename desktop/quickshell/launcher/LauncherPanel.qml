import Quickshell
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: root

    required property var launcherService
    required property var theme

    visible: false
    color: "transparent"
    focusable: true

    implicitWidth: 560
    implicitHeight: 500

    anchors {
        top: true
        left: true
        right: true
    }

    function openLauncher() {
        root.visible = true
        searchField.text = ""
        appList.currentIndex = appList.count > 0 ? 0 : -1
        focusTimer.restart()
    }

    function closeLauncher() {
        root.visible = false
        searchField.text = ""
    }

    function toggleLauncher() {
        if (root.visible)
            closeLauncher()
        else
            openLauncher()
    }

    Timer {
        id: focusTimer
        interval: 30
        repeat: false
        onTriggered: searchField.forceActiveFocus()
    }

    Rectangle {
        width: 520
        height: 440

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 48
        }

        radius: 16
        color: root.theme.surfaceRaised

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            TextField {
                id: searchField

                width: parent.width
                height: 48

                leftPadding: 16
                rightPadding: 16

                placeholderText: "Search applications..."
                placeholderTextColor: root.theme.textSecondary

                color: root.theme.textPrimary
                selectionColor: root.theme.accent
                selectedTextColor: root.theme.background

                font.pixelSize: 15

                background: Rectangle {
                    radius: 12
                    color: root.theme.surface

                    border.width: searchField.activeFocus ? 1 : 0
                    border.color: root.theme.accent
                }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        root.closeLauncher()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Down) {
                        appList.incrementCurrentIndex()
                        appList.positionViewAtIndex(
                            appList.currentIndex,
                            ListView.Contain
                        )
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        appList.decrementCurrentIndex()
                        appList.positionViewAtIndex(
                            appList.currentIndex,
                            ListView.Contain
                        )
                        event.accepted = true
                    } else if (
                        event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter
                    ) {
                        if (appList.currentItem)
                            appList.currentItem.launch()

                        event.accepted = true
                    }
                }
            }

            ListView {
                id: appList

                width: parent.width
                height: parent.height - searchField.height - 12

                clip: true
                spacing: 4

                model: root.launcherService.applications

                delegate: Rectangle {
                    id: appDelegate

                    required property var modelData

                    width: appList.width
                    height: visible ? 48 : 0

                    property bool matchesSearch: {
                        const query = searchField.text.toLowerCase().trim()

                        if (query.length === 0)
                            return true

                        return modelData.name.toLowerCase().includes(query)
                    }

                    visible: matchesSearch
                    radius: 10

                    color: ListView.isCurrentItem
                        ? root.theme.surfaceHover
                        : "transparent"

                    function launch() {
                        root.launcherService.launch(modelData)
                        root.closeLauncher()
                    }

                    Row {
                        anchors {
                            left: parent.left
                            leftMargin: 12
                            verticalCenter: parent.verticalCenter
                        }

                        spacing: 12

                        Image {
                            width: 28
                            height: 28
                            anchors.verticalCenter: parent.verticalCenter

                            source: Quickshell.iconPath(appDelegate.modelData.icon)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            text: appDelegate.modelData.name
                            color: root.theme.textPrimary
                            font.pixelSize: 15
                            font.weight: Font.Medium
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: appList.currentIndex = index
                        onClicked: appDelegate.launch()
                    }
                }
            }
        }
    }
}
