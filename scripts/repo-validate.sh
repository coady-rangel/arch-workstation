#!/usr/bin/env bash

set -Eeuo pipefail

## ============================================================================
## Configuration
## ============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

required_dirs=(
    "config"
    "configs"
    "packages"
    "scripts"
    "scripts/lib"
)

required_files=(
    "config/services/default.conf"
    "config/dependencies/default.conf"
    "packages/arch-packages.txt"
    "packages/aur-packages.txt"
    "scripts/lib/common.sh"
)

## ============================================================================
## Helper Functions
## ============================================================================

pass() {
    printf '[PASS] %s\n' "$*"
}

fail() {
    printf '[FAIL] %s\n' "$*" >&2
    ((failures += 1))
}

## ============================================================================
## Validation Functions
## ============================================================================

validate_repository_structure() {
    printf '%s\n\n' "Validating repository structure..."

    for directory in "${required_dirs[@]}"; do
        if [[ -d "$directory" ]]; then
            pass "$directory exists"
        else
            fail "$directory is missing"
        fi
    done

    echo
}

validate_required_files() {
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            pass "$file exists"
        else
            fail "$file is missing"
        fi
    done

    echo
}

validate_manifest() {
    local manifest="$1"
    local failures_before="$failures"

    printf 'Validating %s...\n' "$manifest"

    declare -A seen=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue

        if [[ "$line" != *"|"* ]]; then
            fail "$manifest: invalid format -> $line"
            continue
        fi

        IFS='|' read -r name policy extra <<< "$line"

        if [[ -n "${extra:-}" ]]; then
            fail "$manifest: too many fields -> $line"
            continue
        fi

        if [[ -z "$name" ]]; then
            fail "$manifest: empty name"
            continue
        fi

        case "$policy" in
            required|optional)
                ;;
            *)
                fail "$manifest: invalid policy '$policy'"
                continue
                ;;
        esac

        if [[ -n "${seen[$name]:-}" ]]; then
            fail "$manifest: duplicate entry '$name'"
            continue
        fi

        seen["$name"]=1
    done < "$manifest"

    if (( failures == failures_before )); then
        pass "$manifest manifest valid"
    fi

    echo
}

validate_manifests() {
    validate_manifest "config/services/default.conf"
    validate_manifest "config/dependencies/default.conf"
}

validate_script_permissions() {
    printf '%s\n\n' "Validating shell script permissions..."

    while IFS= read -r -d '' script; do
        if [[ -x "$script" ]]; then
            pass "$script is executable"
        else
            fail "$script is not executable"
        fi
    done < <(find scripts -type f -name '*.sh' -print0)

    echo
}

print_summary() {
    if (( failures > 0 )); then
        printf '[FAIL] Repository validation failed with %d issue(s).\n' \
            "$failures" >&2
        exit 1
    fi

    printf '[PASS] Repository validation completed successfully.\n'
}

## ============================================================================
## Main
## ============================================================================

main() {
    cd "$REPO_ROOT"

    validate_repository_structure
    validate_required_files
    validate_manifests
    validate_script_permissions
    print_summary
}

main "$@"
