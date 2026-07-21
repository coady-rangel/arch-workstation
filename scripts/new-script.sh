#!/usr/bin/env bash

set -Eeuo pipefail

# Name: new-script.sh
# Purpose: Create standardized executable Bash scripts in scripts/.
# Usage: ./scripts/new-script.sh [--force] <script-name.sh>
# Dependencies: bash, chmod

readonly SCRIPT_DIR="scripts"

usage() {
    cat <<'USAGE_EOF'
Usage:
  ./scripts/new-script.sh [--force] <script-name.sh>

Options:
  -f, --force  Overwrite an existing script
  -h, --help   Show this help message

Examples:
  ./scripts/new-script.sh backup.sh
  ./scripts/new-script.sh --force backup.sh
USAGE_EOF
}

die() {
    local message=$1
    local exit_code=${2:-1}

    printf 'Error: %s\n' "$message" >&2
    exit "$exit_code"
}

write_template() {
    local target_path=$1
    local script_name=$2

    cat > "$target_path" <<TEMPLATE_EOF
#!/usr/bin/env bash

set -Eeuo pipefail

# Name: $script_name
# Purpose: TODO
# Usage: ./$target_path
# Dependencies: bash

main() {
    printf 'Hello from %s\n' "$script_name"
}

main "\$@"
TEMPLATE_EOF
}

main() {
    local force=false
    local script_name=""

    while (( $# > 0 )); do
        case $1 in
            -f|--force)
                force=true
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                die "Unknown option: $1"
                ;;
            *)
                if [[ -n $script_name ]]; then
                    die "Only one script name may be provided."
                fi

                script_name=$1
                ;;
        esac

        shift
    done

    [[ -n $script_name ]] || {
        usage >&2
        exit 1
    }

    [[ $script_name == *.sh ]] ||
        die "Script name must end with .sh"

    [[ $script_name != */* ]] ||
        die "Provide a filename only, not a path"

    local target_path="$SCRIPT_DIR/$script_name"

    [[ -d $SCRIPT_DIR ]] ||
        die "Required directory does not exist: $SCRIPT_DIR"

    if [[ -e $target_path && $force != true ]]; then
        die "$target_path already exists. Use --force to overwrite it."
    fi

    write_template "$target_path" "$script_name"
    chmod +x "$target_path"

    printf 'Created %s\n' "$target_path"
}

main "$@"
