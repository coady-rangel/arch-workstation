import QtQuick

Item {
    id: root

    visible: false

    property date now: new Date()

    readonly property string timeText: Qt.formatTime(now, "hh:mm")
    readonly property string dateText: Qt.formatDate(now, "ddd, MMM d")

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: root.now = new Date()
    }
}
