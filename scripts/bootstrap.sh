#!/usr/bin/env bash

set -Eeuo pipefail

# Name: bootstrap.sh
# Purpose: Execute the complete Arch Workstation deployment workflow.
# Usage: ./scripts/bootstrap.sh
# Dependencies: lib/common.sh

# shellcheck source=lib/common.sh
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

readonly STEPS=(
    install.sh
    deploy-configs.sh
    fonts.sh
    themes.sh
    services.sh
    validate.sh
)

main() {
    local step=1
    local total=${#STEPS[@]}
    local script
    local path

    info "================================="
    info "   Arch Workstation Bootstrap"
    info "================================="

    for script in "${STEPS[@]}"; do
        path="$SCRIPT_DIR/$script"

        [[ -x "$path" ]] || error "$script not found or not executable."

        printf '\n'
        info "[$step/$total] Running $script"
        info "---------------------------------"

        "$path"

        ((step++))
    done

    printf '\n'
    success "================================="
    success "Bootstrap completed successfully."
    success "================================="
}

main "$@"
