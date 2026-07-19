#!/usr/bin/env bash

selection="$(cliphist list | rofi -dmenu -i -p 'Clipboard')"

[ -z "$selection" ] && exit 0

printf '%s' "$selection" | cliphist decode | wl-copy
