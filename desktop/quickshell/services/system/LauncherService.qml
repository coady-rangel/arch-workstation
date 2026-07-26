import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property var applications: DesktopEntries.applications

    function launch(entry) {
        if (!entry)
            return

        entry.execute()
    }
}
