import Quickshell
import QtQuick

PanelWindow {
    id: root

    required property var notificationService
    required property var theme

    visible: false
    color: "transparent"
    focusable: true

    anchors {
        top: true
        right: true
    }

    margins {
        top: 48
        right: 12
    }

    implicitWidth: 380
    implicitHeight: 520

    exclusionMode: ExclusionMode.Ignore

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
            anchors {
                fill: parent
                margins: 16
            }

            spacing: 12

            Row {
                width: parent.width

                Text {
                    text: "Notifications"
                    color: root.theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                }

                Item {
                    width: Math.max(
                        0,
                        parent.width
                            - 120
                            - clearAll.implicitWidth
                    )
                    height: 1
                }

                Text {
                    id: clearAll

                    visible: root.notificationService.history.length > 0
                    text: "Clear All"
                    color: root.theme.accent
                    font.pixelSize: 12

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: root.notificationService.clearHistory()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.theme.surfaceHover
            }

            Text {
                visible: root.notificationService.history.length === 0

                text: "No notifications"
                color: root.theme.textSecondary
                font.pixelSize: 13
            }

            ListView {
                id: historyList

                visible: root.notificationService.history.length > 0

                width: parent.width
                height: parent.height - 55

                clip: true
                spacing: 8

                model: root.notificationService.history

                delegate: Rectangle {
                    id: card

                    required property var modelData
                    required property int index

                    width: historyList.width
                    height: content.implicitHeight + 24

                    radius: 12
                    color: root.theme.surface

                    Row {
                        id: content

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 12
                        }

                        spacing: 10

                        Image {
                            width: 30
                            height: 30

                            source: card.modelData.appIcon
                                ? Quickshell.iconPath(
                                    card.modelData.appIcon
                                )
                                : ""

                            visible: source.toString().length > 0
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Column {
                            width: parent.width - 72
                            spacing: 4

                            Text {
                                width: parent.width

                                text: card.modelData.appName || ""
                                color: root.theme.textSecondary
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width

                                text: card.modelData.summary || ""
                                color: root.theme.textPrimary
                                font.pixelSize: 14
                                font.weight: Font.Medium

                                wrapMode: Text.Wrap
                            }

                            Text {
                                width: parent.width

                                visible: text.length > 0

                                text: card.modelData.body || ""
                                color: root.theme.textSecondary
                                font.pixelSize: 12
                                textFormat: Text.PlainText

                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            text: "×"
                            color: root.theme.textSecondary
                            font.pixelSize: 18

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    root.notificationService.dismissHistory(
                                        card.index
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
