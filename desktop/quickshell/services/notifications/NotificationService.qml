import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Item {
    id: root

    property var popupNotifications: []
    property var history: []

    readonly property int unreadCount: history.length

    NotificationServer {
        id: server

        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true

            // Transient notifications may pop up, but should not be kept
            // in persistent history.
            if (!notification.transient) {
                const historyEntry = {
                    id: notification.id,
                    appName: notification.appName || "",
                    appIcon: notification.appIcon || "",
                    summary: notification.summary || "",
                    body: notification.body || "",
                    timestamp: new Date()
                }

                const updatedHistory = root.history.slice()
                updatedHistory.unshift(historyEntry)
                root.history = updatedHistory
            }

            const updatedPopups = root.popupNotifications.slice()
            updatedPopups.unshift(notification)

            // Keep the popup stack intentionally small.
            root.popupNotifications = updatedPopups.slice(0, 3)
        }
    }

    function removePopup(notification) {
        if (!notification)
            return

        const updated = []

        for (const item of root.popupNotifications) {
            if (item !== notification)
                updated.push(item)
        }

        root.popupNotifications = updated
    }

    function expirePopup(notification) {
        if (!notification)
            return

        removePopup(notification)

        if (notification.tracked)
            notification.expire()
    }

    function dismissPopup(notification) {
        if (!notification)
            return

        removePopup(notification)

        if (notification.tracked)
            notification.dismiss()
    }

    function dismissHistory(index) {
        if (index < 0 || index >= root.history.length)
            return

        const updated = root.history.slice()
        updated.splice(index, 1)
        root.history = updated
    }

    function clearHistory() {
        root.history = []
    }
}
