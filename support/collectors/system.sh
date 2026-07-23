#!/usr/bin/env bash

################################################################################
# System Collector
################################################################################

set -euo pipefail

OUTPUT_DIR="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

COLLECTOR_DIR="$(create_collector_dir "${OUTPUT_DIR}" "system")"

log_info "Collecting system information..."

################################################################################
# Host Information
################################################################################

capture_command "${COLLECTOR_DIR}/hostname.txt" hostname
capture_command "${COLLECTOR_DIR}/kernel.txt" uname -r
capture_command "${COLLECTOR_DIR}/architecture.txt" uname -m
capture_command "${COLLECTOR_DIR}/uptime.txt" uptime

################################################################################
# Operating System
################################################################################

capture_command "${COLLECTOR_DIR}/os-release.txt" cat /etc/os-release

################################################################################
# CPU / Memory
################################################################################

capture_command "${COLLECTOR_DIR}/cpu.txt" lscpu
capture_command "${COLLECTOR_DIR}/memory.txt" free -h

################################################################################
# Storage
################################################################################

capture_command "${COLLECTOR_DIR}/disk.txt" df -h

################################################################################
# Environment
################################################################################

capture_command "${COLLECTOR_DIR}/environment.txt" env

################################################################################
# Installed Packages
################################################################################

if command_exists pacman; then
    capture_command "${COLLECTOR_DIR}/packages.txt" pacman -Q
fi

write_status "${COLLECTOR_DIR}" "OK" \
    "System information collected successfully."

log_info "System collection complete."

exit 0
