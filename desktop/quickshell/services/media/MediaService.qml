import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    readonly property var players: Mpris.players.values

    property var activePlayer: null

    readonly property bool available: activePlayer !== null

    readonly property string title:
        available ? (activePlayer.trackTitle || "Unknown Title") : ""

    readonly property string artist:
        available ? (activePlayer.trackArtist || "Unknown Artist") : ""

    readonly property string album:
        available ? (activePlayer.trackAlbum || "") : ""

    readonly property string artwork:
        available ? (activePlayer.trackArtUrl || "") : ""

    readonly property bool playing:
        available ? activePlayer.isPlaying : false

    function refreshActivePlayer() {
        const currentPlayers = root.players

        if (!currentPlayers || currentPlayers.length === 0) {
            root.activePlayer = null
            return
        }

        for (let i = 0; i < currentPlayers.length; i++) {
            const player = currentPlayers[i]

            if (player && player.isPlaying) {
                root.activePlayer = player
                return
            }
        }

        root.activePlayer = currentPlayers[0] || null
    }

    function togglePlaying() {
        if (!root.available || !root.activePlayer)
            return

        if (root.activePlayer.canTogglePlaying) {
            root.activePlayer.togglePlaying()
            return
        }

        if (root.activePlayer.isPlaying && root.activePlayer.canPause) {
            root.activePlayer.pause()
            return
        }

        if (!root.activePlayer.isPlaying && root.activePlayer.canPlay)
            root.activePlayer.play()
    }

    function previous() {
        if (
            root.available &&
            root.activePlayer &&
            root.activePlayer.canGoPrevious
        ) {
            root.activePlayer.previous()
        }
    }

    function next() {
        if (
            root.available &&
            root.activePlayer &&
            root.activePlayer.canGoNext
        ) {
            root.activePlayer.next()
        }
    }

    onPlayersChanged: refreshActivePlayer()

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: root.refreshActivePlayer()
    }

    Component.onCompleted: refreshActivePlayer()
}
