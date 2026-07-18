#!/bin/bash

set -e

echo "Starting Arch workstation package installation..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

PACKAGE_FILE="$REPO_ROOT/packages/arch-packages.txt"

if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Package manifest not found:"
    echo "$PACKAGE_FILE"
    exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing packages..."

grep -v '^#' "$PACKAGE_FILE" | grep -v '^$' | while read -r package; do
    sudo pacman -S --needed --noconfirm "$package"
done

echo "Package installation complete."

