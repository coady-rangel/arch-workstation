#!/usr/bin/env bash

set -Eeuo pipefail

echo "Starting Arch workstation package installation..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PACKAGE_FILE="$REPO_ROOT/packages/arch-packages.txt"

error() {
    echo "Error: $*" >&2
    exit 1
}

command -v pacman >/dev/null 2>&1 || error "pacman was not found. This script is intended for Arch Linux."

[[ -f "$PACKAGE_FILE" ]] || error "Package manifest not found: $PACKAGE_FILE"

mapfile -t packages < <(
    sed \
        -e 's/[[:space:]]*#.*$//' \
        -e '/^[[:space:]]*$/d' \
        "$PACKAGE_FILE"
)

(( ${#packages[@]} > 0 )) || error "No packages were found in $PACKAGE_FILE"

echo "Found ${#packages[@]} packages."

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${packages[@]}"

echo "Package installation complete."
