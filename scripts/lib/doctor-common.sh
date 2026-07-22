#!/usr/bin/env bash

DOCTOR_FAILURES=0

PASS="✓"
FAIL="✗"

section() {
    local title="$1"

    echo
    echo "$title"
    printf '%*s\n' "${#title}" '' | tr ' ' '-'
}

check() {
    local description="$1"
    shift

    printf "%-40s" "$description"

    if "$@" >/dev/null 2>&1; then
        echo "$PASS"
    else
        echo "$FAIL"
        ((DOCTOR_FAILURES += 1))
    fi
}
