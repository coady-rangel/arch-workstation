#!/usr/bin/env bash

set -Eeuo pipefail

# Name: build-readme.sh
# Purpose: Generate README.md from modular markdown files.
# Usage: ./scripts/build-readme.sh
# Dependencies: none

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

readonly README_DIR="$REPO_ROOT/docs/readme.d"
readonly OUTPUT_FILE="$REPO_ROOT/README.md"

[[ -d "$README_DIR" ]] || {
    echo "Error: $README_DIR does not exist."
    exit 1
}

cat > "$OUTPUT_FILE" <<'EOF'
<!--
=============================================================================
AUTO-GENERATED FILE

This README is built from the markdown files in:
    docs/readme.d/

To update this README:
    ./scripts/build-readme.sh

Do not edit README.md directly.
=============================================================================
-->

EOF

for file in "$README_DIR"/*.md; do
    [[ -f "$file" ]] || continue

    cat "$file" >> "$OUTPUT_FILE"
    printf "\n\n" >> "$OUTPUT_FILE"
done

echo "Generated README.md successfully."
