import QtQuick

Rectangle {
    id: root

    required property var mediaService
    required property var theme

    visible: mediaService.available

    implicitWidth: 360
    implicitHeight: 118

    radius: 16
    color: theme.surfaceRaised

    Row {
        anchors {
            fill: parent
            margins: 14
        }

        spacing: 14

        Rectangle {
            width: 88
            height: 88
            radius: 12
            color: root.theme.surface

            Image {
                anchors.fill: parent
                anchors.margins: 4

                visible: root.mediaService.artwork.length > 0
                source: root.mediaService.artwork

                fillMode: Image.PreserveAspectCrop
                smooth: true
            }

            Text {
                anchors.centerIn: parent

                visible: root.mediaService.artwork.length === 0
                text: "♪"

                color: root.theme.textSecondary
                font.pixelSize: 28
            }
        }

        Column {
            width: parent.width - 116
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Column {
                width: parent.width
                spacing: 3

                Text {
                    width: parent.width

                    text: root.mediaService.title
                    color: root.theme.textPrimary

                    font.pixelSize: 15
                    font.weight: Font.DemiBold

                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width

                    text: root.mediaService.artist
                    color: root.theme.textSecondary

                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }

            Row {
                spacing: 8

                Rectangle {
                    width: 34
                    height: 30
                    radius: 10
                    color: root.theme.surfaceHover

                    Text {
                        anchors.centerIn: parent
                        text: "⏮"
                        color: root.theme.textPrimary
                        font.pixelSize: 13
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mediaService.previous()
                    }
                }

                Rectangle {
                    width: 42
                    height: 30
                    radius: 10
                    color: root.theme.accent

                    Text {
                        anchors.centerIn: parent

                        text: root.mediaService.playing
                            ? "⏸"
                            : "▶"

                        color: root.theme.background
                        font.pixelSize: 13
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mediaService.togglePlaying()
                    }
                }

                Rectangle {
                    width: 34
                    height: 30
                    radius: 10
                    color: root.theme.surfaceHover

                    Text {
                        anchors.centerIn: parent
                        text: "⏭"
                        color: root.theme.textPrimary
                        font.pixelSize: 13
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mediaService.next()
                    }
                }
            }
        }
    }
}
