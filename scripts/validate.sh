#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

SOURCE_DIR="$REPO_ROOT/configs"
TARGET_DIR="$HOME/.config"
SERVICE_MANIFEST="$REPO_ROOT/config/services/default.conf"

failures=0

pass() {
    printf '[PASS] %s\n' "$*"
}

fail() {
    printf '[FAIL] %s\n' "$*" >&2
    ((failures += 1))
}

validate_config_links() {
    [[ -d "$SOURCE_DIR" ]] || error "Configuration directory not found: $SOURCE_DIR"

    info "Validating deployed configuration links..."
    echo

    for source in "$SOURCE_DIR"/*; do
        [[ -d "$source" ]] || continue

        local name
        local target
        local resolved_target
        local resolved_source

        name="$(basename "$source")"
        target="$TARGET_DIR/$name"

        if [[ ! -L "$target" ]]; then
            fail "$name is not a symlink"
            continue
        fi

        resolved_target="$(readlink -f "$target")"
        resolved_source="$(readlink -f "$source")"

        if [[ "$resolved_target" != "$resolved_source" ]]; then
            fail "$name points to $resolved_target"
            continue
        fi

        pass "$name"
    done
}

validate_services() {
    [[ -f "$SERVICE_MANIFEST" ]] \
        || error "Service manifest not found: $SERVICE_MANIFEST"

    command_exists systemctl || error "systemctl not found."

    info "Validating required system services..."
    echo

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
                info "Skipping optional service validation: ${service}.service"
                continue
                ;;
            *)
                fail "Unknown policy '$policy' for ${service}.service"
                continue
                ;;
        esac

        if ! systemctl list-unit-files "${service}.service" --no-legend \
            2>/dev/null | grep -q "^${service}\.service"; then
            fail "${service}.service is not installed"
            continue
        fi

        if systemctl is-enabled "${service}.service" >/dev/null 2>&1; then
            pass "${service}.service is enabled"
        else
            fail "${service}.service is not enabled"
        fi

        if systemctl is-active "${service}.service" >/dev/null 2>&1; then
            pass "${service}.service is running"
        else
            fail "${service}.service is not running"
        fi
    done < "$SERVICE_MANIFEST"
}

validate_config_links

echo
validate_services

echo

if (( failures > 0 )); then
    error "Validation failed with $failures issue(s)."
fi

success "All workstation validation checks passed."
