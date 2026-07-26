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
        status="Modified"
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
    clear

    echo "========================================="
    echo "         Publish Release"
    echo "========================================="
    echo

    local version
    local tag
    local notes
    local current_release

    current_release="$(gh release view --json tagName -q '.tagName' 2>/dev/null || echo None)"

    echo "Current Release : ${current_release}"
    echo

    read -rp "New version (example: 4.2.0): " version

    if [[ -z "${version}" ]]; then
        echo
        echo "No version provided."
        echo
        pause
        return
    fi

    tag="v${version#v}"
    notes="${REPO_ROOT}/docs/roadmap/release_notes/${tag}.md"

    if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo
        echo "Invalid version format: ${tag}"
        echo "Expected semantic version format, for example: v4.2.0"
        echo
        pause
        return
    fi

    if git -C "${REPO_ROOT}" show-ref --verify --quiet "refs/tags/${tag}"; then
        echo
        echo "Local Git tag already exists: ${tag}"
        echo
        pause
        return
    fi

    if git -C "${REPO_ROOT}" ls-remote --exit-code --tags origin "refs/tags/${tag}" >/dev/null 2>&1; then
        echo
        echo "Remote Git tag already exists: ${tag}"
        echo
        pause
        return
    fi

    if ! gh auth status >/dev/null 2>&1; then
        echo
        echo "GitHub authentication check failed."
        echo "Run: gh auth status"
        echo
        pause
        return
    fi

    if gh release view "${tag}" >/dev/null 2>&1; then
        echo
        echo "GitHub Release already exists: ${tag}"
        echo
        pause
        return
    fi

    if [[ ! -f "${notes}" ]]; then
        echo
        echo "Release notes not found:"
        echo "  ${notes}"
        echo
        pause
        return
    fi

    echo
    echo "Running release validation..."
    echo

    if (
        cd "${REPO_ROOT}"
        ./scripts/release.sh --dry-run "${tag}"
    ); then
        :
    else
        rc=$?
        echo
        echo "-----------------------------------------"
        echo "Publish Preflight"
        echo "-----------------------------------------"
        echo "Status    : FAILED"
        echo "Exit Code : ${rc}"
        echo "-----------------------------------------"
        echo
        pause
        return
    fi

    echo
    echo "-----------------------------------------"
    echo "Publish Summary"
    echo "-----------------------------------------"
    echo "Repository : $(basename "${REPO_ROOT}")"
    echo "Version    : ${tag}"
    echo "Notes      : docs/roadmap/release_notes/${tag}.md"
    echo "-----------------------------------------"
    echo

    read -rp "Publish release ${tag}? [y/N]: " confirm

    case "${confirm}" in
        y|Y|yes|YES)
            ;;
        *)
            echo
            echo "Release cancelled."
            echo
            pause
            return
            ;;
    esac

    echo
    echo "Creating tag ${tag}..."

    if ! git -C "${REPO_ROOT}" tag -a "${tag}" -m "Release ${tag}"; then
        echo
        echo "Failed to create Git tag."
        echo
        pause
        return
    fi

    echo "Pushing tag ${tag}..."

    if ! git -C "${REPO_ROOT}" push origin "${tag}"; then
        echo
        echo "Failed to push Git tag."
        echo "Local tag ${tag} was created and may require cleanup."
        echo
        pause
        return
    fi

    local title
    title="$(head -n1 "${notes}" | sed 's/^# //')"

    echo "Creating GitHub Release..."

    if gh release create "${tag}" \
        --verify-tag \
        --title "${title}" \
        --notes-file "${notes}"; then

        echo
        echo "-----------------------------------------"
        echo "Publish Summary"
        echo "-----------------------------------------"
        echo "Status    : PASSED"
        echo "Version   : ${tag}"
        echo "-----------------------------------------"
    else
        rc=$?
        echo
        echo "-----------------------------------------"
        echo "Publish Summary"
        echo "-----------------------------------------"
        echo "Status    : FAILED"
        echo "Exit Code : ${rc}"
        echo "-----------------------------------------"
    fi

    echo
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

