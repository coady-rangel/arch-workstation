#!/usr/bin/env bash

set -Eeuo pipefail

main() {
    if [[ $# -ne 1 ]]; then
        printf 'Usage: %s <script-name>\n' "$0"
        exit 1
    fi

    local script_name=$1
    local target_path="scripts/$script_name"

    cat > "$target_path" <<EOF
#!/usr/bin/env bash

set -Eeuo pipefail

# Name: $script_name
# Purpose: TODO
# Usage: ./$target_path

main() {
    printf 'Hello from %s\n' "$script_name"
}

main "\$@"
EOF

    chmod +x "$target_path"

    printf 'Created %s\n' "$target_path"
}

main "$@"
