#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

MANIFEST="$REPO_ROOT/config/services/default.conf"
ENABLE_OPTIONAL=false

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]

Enable and start services defined in:

  $MANIFEST

Options:
  --enable-optional    Enable optional services
  -h, --help           Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --enable-optional)
            ENABLE_OPTIONAL=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

command_exists systemctl || error "systemctl not found."
command_exists sudo || error "sudo not found."

[[ -f "$MANIFEST" ]] || error "Service manifest not found: $MANIFEST"

sudo -v >/dev/null || error "Unable to validate sudo access."

while IFS='|' read -r service policy; do
    service="${service#"${service%%[![:space:]]*}"}"
    service="${service%"${service##*[![:space:]]}"}"
    policy="${policy#"${policy%%[![:space:]]*}"}"
    policy="${policy%"${policy##*[![:space:]]}"}"

    [[ -z "$service" ]] && continue
    [[ "$service" == \#* ]] && continue

    policy="${policy,,}"

    case "$policy" in
        required)
            ;;
        optional)
            if [[ "$ENABLE_OPTIONAL" != true ]]; then
                info "Skipping optional service: ${service}.service"
                continue
            fi
            ;;
        *)
            error "Unknown policy '$policy' for ${service}.service"
            ;;
    esac

    if ! systemctl list-unit-files "${service}.service" --no-legend \
        2>/dev/null | grep -q "^${service}\.service"; then
        error "${service}.service is not installed."
    fi

    if systemctl is-enabled "${service}.service" >/dev/null 2>&1; then
        success "${service}.service already enabled."
    else
        info "Enabling ${service}.service..."
        sudo systemctl enable "${service}.service"
        success "${service}.service enabled."
    fi

    if systemctl is-active "${service}.service" >/dev/null 2>&1; then
        success "${service}.service already running."
    else
        info "Starting ${service}.service..."
        sudo systemctl start "${service}.service"
        success "${service}.service started."
    fi
done < "$MANIFEST"

success "Service configuration complete."
