#!/usr/bin/env bash

set -euo pipefail

choice=$(printf " Lock\n󰍃 Logout\n󰤄 Suspend\n Reboot\n⏻ Shutdown" | \
    rofi -dmenu \
         -i \
         -p "Power" \
         -theme-str 'window {width: 300px;}')

case "$choice" in
    " Lock")
        loginctl lock-session
        ;;
    "󰍃 Logout")
        hyprctl dispatch exit
        ;;
    "󰤄 Suspend")
        systemctl suspend
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
esac
