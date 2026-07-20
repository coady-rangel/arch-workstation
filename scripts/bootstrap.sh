#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

STEPS=(
    install.sh
    deploy-configs.sh
    fonts.sh
    themes.sh
    services.sh
    validate.sh
)

info "================================="
info "   Arch Workstation Bootstrap"
info "================================="

step=1
total=${#STEPS[@]}

for script in "${STEPS[@]}"; do
    path="$SCRIPT_DIR/$script"

    [[ -x "$path" ]] || error "$script not found or not executable."

    echo
    info "[$step/$total] Running $script"
    info "---------------------------------"

    "$path"

    ((step++))
done

echo
success "================================="
success "Bootstrap completed successfully."
success "================================="
