#!/usr/bin/env bash

################################################################################
# Hyprland Collector
################################################################################

set -euo pipefail

OUTPUT_DIR="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

COLLECTOR_DIR="$(create_collector_dir "${OUTPUT_DIR}" "hyprland")"

log_info "Collecting Hyprland information..."

################################################################################
# Verify Hyprland is Available
################################################################################

if ! command_exists hyprctl; then
    log_warn "hyprctl not found. Skipping Hyprland collection."

    write_status "${COLLECTOR_DIR}" "WARNING" \
        "hyprctl not found." \
        "Hyprland is not installed."

    exit 0
fi

################################################################################
# General Information
################################################################################

capture_command "${COLLECTOR_DIR}/version.txt" hyprctl version
capture_command "${COLLECTOR_DIR}/monitors.txt" hyprctl monitors all
capture_command "${COLLECTOR_DIR}/workspaces.txt" hyprctl workspaces
capture_command "${COLLECTOR_DIR}/clients.txt" hyprctl clients
capture_command "${COLLECTOR_DIR}/devices.txt" hyprctl devices
capture_command "${COLLECTOR_DIR}/binds.txt" hyprctl binds
capture_command "${COLLECTOR_DIR}/config.txt" hyprctl config description

################################################################################
# Process Information
################################################################################

capture_command "${COLLECTOR_DIR}/process.txt" pgrep -af Hyprland

################################################################################
# User Journal
################################################################################

capture_command "${COLLECTOR_DIR}/journal.log" \
    journalctl --user --no-pager -n 250

log_info "Hyprland collection complete."
write_status "${COLLECTOR_DIR}" "OK" \
    "Hyprland collector completed."

exit 0
