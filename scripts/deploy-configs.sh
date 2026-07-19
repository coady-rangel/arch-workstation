#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/configs"
TARGET_DIR="$HOME/.config"

error() {
    echo "Error: $*" >&2
    exit 1
}

[[ -d "$SOURCE_DIR" ]] || error "Configuration directory not found."

mkdir -p "$TARGET_DIR"

echo "Deploying configuration..."

for source in "$SOURCE_DIR"/*; do
    [[ -d "$source" ]] || continue

    name="$(basename "$source")"
    target="$TARGET_DIR/$name"

    echo
    echo "[+] $name"

    if [[ -L "$target" ]]; then
        current="$(readlink -f "$target")"

        if [[ "$current" == "$source" ]]; then
            echo "    Already linked."
            continue
        fi

        rm "$target"
    elif [[ -e "$target" ]]; then
        backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$backup"
        echo "    Backed up existing configuration to:"
        echo "    $backup"
    fi

    ln -s "$source" "$target"
    echo "    Symlink created."
done

echo
echo "Configuration deployment complete."
