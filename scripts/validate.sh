#!/usr/bin/env bash

set -Eeuo pipefail

# Name: validate.sh
# Purpose: Validate deployed configurations, services, and dependencies.
# Usage: ./scripts/validate.sh
# Dependencies: lib/common.sh, systemctl

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

readonly SOURCE_DIR="$REPO_ROOT/configs"
readonly TARGET_DIR="$HOME/.config"
readonly SERVICE_MANIFEST="$REPO_ROOT/config/services/default.conf"
readonly DEPENDENCY_MANIFEST="$REPO_ROOT/config/dependencies/default.conf"

failures=0

pass() {
    printf '[PASS] %s\n' "$*"
}

fail() {
    printf '[FAIL] %s\n' "$*" >&2
    ((failures += 1))
}

trim() {
    local value=$1

    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"

    printf '%s\n' "$value"
}

validate_config_links() {
    local source
    local name
    local target
    local resolved_target
    local resolved_source

    [[ -d $SOURCE_DIR ]] ||
        error "Configuration directory not found: $SOURCE_DIR"

    info "Validating deployed configuration links..."
    printf '\n'

    for source in "$SOURCE_DIR"/*; do
        [[ -d $source ]] || continue

        name=$(basename "$source")
        target="$TARGET_DIR/$name"

        if [[ ! -L $target ]]; then
            fail "$name is not a symlink"
            continue
        fi

        resolved_target=$(readlink -f "$target")
        resolved_source=$(readlink -f "$source")

        if [[ $resolved_target != "$resolved_source" ]]; then
            fail "$name points to $resolved_target"
            continue
        fi

        pass "$name"
    done
}

validate_services() {
    local service
    local policy

    [[ -f $SERVICE_MANIFEST ]] ||
        error "Service manifest not found: $SERVICE_MANIFEST"

    command_exists systemctl ||
        error "Required command not found: systemctl"

    info "Validating required system services..."
    printf '\n'

    while IFS='|' read -r service policy; do
        service=$(trim "$service")
        policy=$(trim "$policy")

        [[ -n $service ]] || continue
        [[ $service != \#* ]] || continue

        policy=${policy,,}

        case $policy in
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

validate_dependencies() {
    local dependency
    local requirement

    [[ -f $DEPENDENCY_MANIFEST ]] ||
        error "Dependency manifest not found: $DEPENDENCY_MANIFEST"

    info "Validating dependencies..."
    printf '\n'

    while IFS='|' read -r dependency requirement; do
        dependency=$(trim "$dependency")
        requirement=$(trim "$requirement")
        requirement=${requirement,,}

        [[ -n $dependency ]] || continue
        [[ $dependency != \#* ]] || continue

        case $requirement in
            required | optional)
                ;;
            *)
                fail "Unknown requirement '$requirement' for $dependency"
                continue
                ;;
        esac

        if command_exists "$dependency"; then
            pass "$dependency is installed"
        elif [[ $requirement == required ]]; then
            fail "$dependency is not installed"
        else
            info "$dependency is not installed (optional)"
        fi
    done < "$DEPENDENCY_MANIFEST"
}

main() {
    validate_config_links

    printf '\n'
    validate_services

    printf '\n'
    validate_dependencies

    printf '\n'

    if (( failures > 0 )); then
        error "Validation failed with $failures issue(s)."
    fi

    success "All workstation validation checks passed."
}

main "$@"
