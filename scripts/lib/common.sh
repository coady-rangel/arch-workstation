#!/usr/bin/env bash

# =============================================================================
# Common utilities for workstation scripts
# =============================================================================

# Resolve the real path of the calling script, even when launched via symlinks.
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[1]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
# shellcheck disable=SC2034
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
# shellcheck disable=SC2034
readonly REPO_ROOT

###############################################################################
# Logging
###############################################################################

info() {
    printf '[INFO] %s\n' "$*"
}

success() {
    printf '[ OK ] %s\n' "$*"
}

warn() {
    printf '[WARN] %s\n' "$*" >&2
}

error() {
    printf '[FAIL] %s\n' "$*" >&2
    exit 1
}

###############################################################################
# Utilities
###############################################################################

command_exists() {
    command -v "$1" >/dev/null 2>&1
}
