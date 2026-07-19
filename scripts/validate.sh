#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/configs"
TARGET_DIR="$HOME/.config"

failures=0

pass() {
    echo "[PASS] $*"
}

fail() {
    echo "[FAIL] $*" >&2
    ((failures += 1))
}

[[ -d "$SOURCE_DIR" ]] || {
    echo "Error: Configuration directory not found: $SOURCE_DIR" >&2
    exit 1
}

echo "Validating deployed configuration..."
echo

for source in "$SOURCE_DIR"/*; do
    [[ -d "$source" ]] || continue

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

echo

if (( failures > 0 )); then
    echo "Validation failed with $failures issue(s)." >&2
    exit 1
fi

echo "All configuration links are valid."
