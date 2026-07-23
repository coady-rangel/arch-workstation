#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/common.sh"

OUTPUT_ROOT="$1"

COLLECTOR_DIR="$(create_collector_dir "${OUTPUT_ROOT}" "waybar")"

log_info "Collecting Waybar diagnostics..."

#
# Version
#
capture_command \
    "${COLLECTOR_DIR}/version.txt" \
    waybar --version

#
# Running Process
#
capture_command \
    "${COLLECTOR_DIR}/process.txt" \
    pgrep -a waybar

#
# Configuration
#
CONFIG_FILE=""

if [[ -f "${HOME}/.config/waybar/config.jsonc" ]]; then
    CONFIG_FILE="${HOME}/.config/waybar/config.jsonc"
elif [[ -f "${HOME}/.config/waybar/config.json" ]]; then
    CONFIG_FILE="${HOME}/.config/waybar/config.json"
elif [[ -f "${HOME}/.config/waybar/config" ]]; then
    CONFIG_FILE="${HOME}/.config/waybar/config"
fi

if [[ -n "${CONFIG_FILE}" ]]; then
    capture_command \
        "${COLLECTOR_DIR}/config.txt" \
        cat "${CONFIG_FILE}"
else
    echo "Waybar configuration not found." > "${COLLECTOR_DIR}/config.txt"
fi

#
# Stylesheet
#
STYLE_FILE="${HOME}/.config/waybar/style.css"

if [[ -f "${STYLE_FILE}" ]]; then
    capture_command \
        "${COLLECTOR_DIR}/style.css" \
        cat "${STYLE_FILE}"
else
    echo "Waybar stylesheet not found." > "${COLLECTOR_DIR}/style.css"
fi

#
# Journal
#
capture_command \
    "${COLLECTOR_DIR}/journal.log" \
    journalctl --user -u waybar --no-pager -n 200

#
# Status
#
write_status \
    "${COLLECTOR_DIR}" \
    "OK" \
    "Waybar collector completed successfully."
