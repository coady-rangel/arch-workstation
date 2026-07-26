#!/usr/bin/env bash

###############################################################################
# Release Management Module
###############################################################################

release_management_menu() {

    while true; do
        clear

        echo "========================================="
        echo "       Release Management"
        echo "========================================="

        echo "1) Release Status"
        echo "2) Validate Release"
        echo "3) Publish Release"
        echo "4) List GitHub Releases"
        echo "5) Backfill Missing Releases"
        echo "B) Back"

        read -rp "Select an option: " choice

        case "${choice}" in

            1)
                release_status
                ;;

            2)
                validate_release
                ;;

            3)
                publish_release
                ;;

            4)
                list_github_releases
                ;;

            5)
                backfill_releases
                ;;

            b|B)
                return
                ;;

            *)
                echo
                echo "Invalid selection."
                pause
                ;;

        esac
    done
}

###############################################################################
# Release Actions
###############################################################################

release_status() {
    clear

    echo "========================================="
    echo "          Release Status"
    echo "========================================="
    echo

    printf "%-18s %s\n" "Repository:" "$(basename "$(git rev-parse --show-toplevel)")"
    printf "%-18s %s\n" "Branch:" "$(git branch --show-current)"

    if git diff --quiet && git diff --cached --quiet; then
        status="Clean"
    else
        rc=$?
        echo
        echo "✗ Release validation failed (exit code: ${rc})."
    fi

    printf "%-18s %s\n" "Working Tree:" "$status"
    printf "%-18s %s\n" "HEAD:" "$(git rev-parse --short HEAD)"
    printf "%-18s %s\n" "Latest Tag:" "$(git describe --tags --abbrev=0 2>/dev/null || echo None)"
    printf "%-18s %s\n" "Latest Release:" "$(gh release view --json tagName -q '.tagName' 2>/dev/null || echo None)"

    echo
    pause
}

validate_release() {
    clear

    echo "========================================="
    echo "        Validate Release"
    echo "========================================="
    echo

    if [[ ! -x "${REPO_ROOT}/scripts/release.sh" ]]; then
        echo "Release script not found:"
        echo "  ${REPO_ROOT}/scripts/release.sh"
        pause
        return
    fi

    local latest_tag
    latest_tag="$(git -C "${REPO_ROOT}" describe --tags --abbrev=0 2>/dev/null || true)"

    if [[ -z "${latest_tag}" ]]; then
        echo "No Git tags found."
        pause
        return
    fi

    echo "Validating release: ${latest_tag}"
    echo

    if "${REPO_ROOT}/scripts/release.sh" --dry-run "${latest_tag}"; then
        echo "✓ Release validation completed successfully."
    else
        rc=$?
        echo
        echo "✗ Release validation failed (exit code: ${rc})."
    fi

    echo
    pause
}
publish_release() {
    echo
    echo "Coming Soon"
    pause
}

list_github_releases() {
    clear

    echo "========================================="
    echo "        GitHub Releases"
    echo "========================================="
    echo

    gh release list

    pause
}

backfill_releases() {
    echo
    echo "Coming Soon"
    pause
}

