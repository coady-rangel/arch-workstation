#!/usr/bin/env bash

set -Eeuo pipefail

echo "Starting Arch workstation package installation..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

PACKAGE_FILE="$REPO_ROOT/packages/arch-packages.txt"
AUR_PACKAGE_FILE="$REPO_ROOT/packages/aur-packages.txt"

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

echo "Found ${#packages[@]} official packages."

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing official packages..."
sudo pacman -S --needed --noconfirm "${packages[@]}"

###############################################################################
# Install AUR packages
###############################################################################

if [[ -f "$AUR_PACKAGE_FILE" ]]; then
    mapfile -t aur_packages < <(
        sed \
            -e 's/[[:space:]]*#.*$//' \
            -e '/^[[:space:]]*$/d' \
            "$AUR_PACKAGE_FILE"
    )

    if (( ${#aur_packages[@]} > 0 )); then
        command -v paru >/dev/null 2>&1 \
            || error "paru is required to install AUR packages."

        echo "Installing ${#aur_packages[@]} AUR packages..."
        paru -S --needed --noconfirm "${aur_packages[@]}"
    else
        echo "No AUR packages found."
    fi
else
    echo "No AUR package manifest found. Skipping."
fi

###############################################################################
# Install helper commands
###############################################################################

echo "Installing helper commands..."

mkdir -p "$HOME/.local/bin"

find "$REPO_ROOT/scripts" -maxdepth 1 -type f -executable | while read -r script; do
    name="$(basename "$script" .sh)"
    ln -sf "$script" "$HOME/.local/bin/$name"
done

echo "✓ Helper commands installed"

echo "Package installation complete."
