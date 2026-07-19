#!/usr/bin/env bash

set -euo pipefail

selection=$(
    cliphist list |
    rofi -dmenu \
        -i \
        -p "Clipboard"
)

[ -z "$selection" ] && exit 0

cliphist decode <<< "$selection" | wl-copy
