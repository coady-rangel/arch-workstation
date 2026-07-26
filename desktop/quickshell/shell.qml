import Quickshell
import QtQuick
import "services/system"
import "services/audio"
import "services/network"
import "services/notifications"
import "services/media"
import "panels/topbar"
import "panels/control_center"
import "panels/notifications"
import "launcher"
import "theme"

ShellRoot {
    id: root

    Theme {
        id: theme
    }

    ClockService {
        id: clockService
    }

    HyprlandService {
        id: hyprlandService
    }

    AudioService {
        id: audioService
    }

    NetworkService {
        id: networkService
    }

    NotificationService {
        id: notificationService
    }

    MediaService {
        id: mediaService
    }

    SessionService {
        id: sessionService
    }

    LauncherService {
        id: launcherService
    }

    TopBar {
        clockService: clockService
        hyprlandService: hyprlandService
        audioService: audioService
        networkService: networkService
        notificationService: notificationService
        theme: theme

        onLauncherToggled: {
            const wasVisible = launcherPanel.visible

            notificationCenter.closePanel()
            controlCenter.closePanel()
            sessionMenu.visible = false

            if (wasVisible)
                launcherPanel.closeLauncher()
            else
                launcherPanel.openLauncher()
        }

        onNotificationCenterToggled: {
            const wasVisible = notificationCenter.visible

            launcherPanel.closeLauncher()
            controlCenter.closePanel()
            sessionMenu.visible = false

            if (wasVisible)
                notificationCenter.closePanel()
            else
                notificationCenter.openPanel()
        }

        onControlCenterToggled: {
            const wasVisible = controlCenter.visible

            launcherPanel.closeLauncher()
            notificationCenter.closePanel()
            sessionMenu.visible = false

            if (wasVisible)
                controlCenter.closePanel()
            else
                controlCenter.openPanel()
        }

        onPowerMenuToggled: {
            const wasVisible = sessionMenu.visible

            launcherPanel.closeLauncher()
            notificationCenter.closePanel()
            controlCenter.closePanel()

            if (wasVisible)
                sessionMenu.closeMenu()
            else
                sessionMenu.openMenu()
        }
    }

    SessionMenu {
        id: sessionMenu
        sessionService: sessionService
        theme: theme
    }

    ControlCenter {
        id: controlCenter
        audioService: audioService
        networkService: networkService
        mediaService: mediaService
        sessionService: sessionService
        theme: theme
    }

    NotificationToast {
        id: notificationToast
        notificationService: notificationService
        theme: theme
    }

    NotificationCenter {
        id: notificationCenter
        notificationService: notificationService
        theme: theme
    }

    LauncherPanel {
        id: launcherPanel
        launcherService: launcherService
        theme: theme
    }
}
