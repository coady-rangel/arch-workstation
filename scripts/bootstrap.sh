#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STEPS=(
    install.sh
    deploy-configs.sh
    fonts.sh
    themes.sh
    services.sh
    validate.sh
)

error() {
    echo "Error: $*" >&2
    exit 1
}

echo "================================="
echo "   Arch Workstation Bootstrap"
echo "================================="

step=1
total=${#STEPS[@]}

for script in "${STEPS[@]}"; do
    path="$SCRIPT_DIR/$script"

    [[ -x "$path" ]] || error "$script not found or not executable."

    echo
    echo "[$step/$total] Running $script"
    echo "---------------------------------"

    "$path"

    ((step++))
done

echo
echo "================================="
echo "Bootstrap completed successfully."
echo "================================="
