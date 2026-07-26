import Quickshell
import QtQuick

PanelWindow {
    id: root

    required property var notificationService
    required property var theme

    visible: notificationService.popupNotifications.length > 0
    color: "transparent"

    anchors {
        top: true
        right: true
    }

    margins {
        top: 54
        right: 12
    }

    implicitWidth: 360
    implicitHeight: toastStack.implicitHeight

    exclusionMode: ExclusionMode.Ignore

    Column {
        id: toastStack

        width: 360
        spacing: 8

        Repeater {
            model: root.notificationService.popupNotifications

            delegate: Rectangle {
                id: toast

                required property var modelData

                width: 360
                height: content.implicitHeight + 28

                radius: 16
                color: root.theme.surfaceRaised

                Timer {
                    interval: {
                        const requested = toast.modelData.expireTimeout

                        if (requested > 0)
                            return Math.max(1000, requested * 1000)

                        return 5000
                    }

                    running: true
                    repeat: false

                    onTriggered: {
                        root.notificationService.expirePopup(
                            toast.modelData
                        )
                    }
                }

                Row {
                    id: content

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 14
                    }

                    spacing: 12

                    Image {
                        width: 34
                        height: 34

                        visible: source.toString().length > 0

                        source: toast.modelData.appIcon
                            ? Quickshell.iconPath(
                                toast.modelData.appIcon
                            )
                            : ""

                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Column {
                        width: parent.width - 46
                        spacing: 5

                        Text {
                            width: parent.width

                            text: toast.modelData.appName || ""

                            color: root.theme.textSecondary
                            font.pixelSize: 11
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width

                            text: toast.modelData.summary || ""

                            color: root.theme.textPrimary
                            font.pixelSize: 15
                            font.weight: Font.DemiBold

                            wrapMode: Text.Wrap
                        }

                        Text {
                            width: parent.width

                            visible: text.length > 0

                            text: toast.modelData.body || ""

                            color: root.theme.textSecondary
                            font.pixelSize: 13
                            textFormat: Text.PlainText

                            wrapMode: Text.Wrap
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons:
                        Qt.LeftButton | Qt.RightButton

                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        root.notificationService.dismissPopup(
                            toast.modelData
                        )
                    }
                }
            }
        }
    }
}
