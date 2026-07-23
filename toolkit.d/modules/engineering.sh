#!/usr/bin/env bash

###############################################################################
# Engineering Module
###############################################################################

register_module \
    "Engineering" \
    "Repository engineering tools and workflows" \
    5 \
    engineering_menu

###############################################################################
# Repository Paths
###############################################################################

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

DOCTOR_SCRIPT="${REPO_ROOT}/scripts/doctor.sh"
REPO_VALIDATE_SCRIPT="${REPO_ROOT}/scripts/repo-validate.sh"
WORKSTATION_VALIDATE_SCRIPT="${REPO_ROOT}/scripts/validate.sh"
RELEASE_SCRIPT="${REPO_ROOT}/scripts/release.sh"

###############################################################################
# Repository Helpers
###############################################################################

ensure_git_repository() {
    if git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree \
        >/dev/null 2>&1; then
        return 0
    fi

    echo
    print_failure "Not inside a Git repository:"
    echo "${REPO_ROOT}"
    pause

    return 1
}

repository_branch() {
    local branch

    branch="$(git -C "${REPO_ROOT}" branch --show-current 2>/dev/null)"

    if [[ -n "${branch}" ]]; then
        printf '%s\n' "${branch}"
    else
        printf '%s\n' "detached HEAD"
    fi
}

repository_latest_tag() {
    git -C "${REPO_ROOT}" describe \
        --tags \
        --abbrev=0 \
        2>/dev/null ||
        printf '%s\n' "No tags"
}

repository_upstream() {
    git -C "${REPO_ROOT}" rev-parse \
        --abbrev-ref \
        --symbolic-full-name \
        '@{upstream}' \
        2>/dev/null ||
        printf '%s\n' "Not configured"
}

repository_ahead_behind() {
    local upstream
    local counts
    local behind
    local ahead

    if ! upstream="$(
        git -C "${REPO_ROOT}" rev-parse \
            --abbrev-ref \
            --symbolic-full-name \
            '@{upstream}' \
            2>/dev/null
    )"; then
        printf '%s\n' "Not available"
        return 0
    fi

    if ! counts="$(
        git -C "${REPO_ROOT}" rev-list \
            --left-right \
            --count \
            "${upstream}...HEAD" \
            2>/dev/null
    )"; then
        printf '%s\n' "Not available"
        return 0
    fi

    read -r behind ahead <<< "${counts}"

    printf '%s ahead / %s behind\n' "${ahead}" "${behind}"
}

repository_change_counts() {
    local staged=0
    local modified=0
    local untracked=0

    staged="$(
        git -C "${REPO_ROOT}" diff \
            --cached \
            --name-only \
            2>/dev/null |
            awk 'NF { count += 1 } END { print count + 0 }'
    )"

    modified="$(
        git -C "${REPO_ROOT}" diff \
            --name-only \
            2>/dev/null |
            awk 'NF { count += 1 } END { print count + 0 }'
    )"

    untracked="$(
        git -C "${REPO_ROOT}" ls-files \
            --others \
            --exclude-standard \
            2>/dev/null |
            awk 'NF { count += 1 } END { print count + 0 }'
    )"

    printf '%s|%s|%s\n' "${staged}" "${modified}" "${untracked}"
}

###############################################################################
# Engineering Dashboard
###############################################################################

print_engineering_dashboard() {
    local branch
    local latest_tag
    local upstream
    local sync_status
    local counts
    local staged
    local modified
    local untracked
    local repository_state

    if ! ensure_git_repository; then
        return 1
    fi

    branch="$(repository_branch)"
    latest_tag="$(repository_latest_tag)"
    upstream="$(repository_upstream)"
    sync_status="$(repository_ahead_behind)"

    counts="$(repository_change_counts)"
    IFS='|' read -r staged modified untracked <<< "${counts}"

    if (( staged == 0 && modified == 0 && untracked == 0 )); then
        repository_state="Clean"
    else
        repository_state="Changes detected"
    fi

    echo "Repository"
    echo "----------"
    printf '%-16s %s\n' "Path" "${REPO_ROOT}"
    printf '%-16s %s\n' "Branch" "${branch}"
    printf '%-16s %s\n' "Latest tag" "${latest_tag}"
    printf '%-16s %s\n' "Upstream" "${upstream}"
    printf '%-16s %s\n' "Synchronization" "${sync_status}"

    echo
    echo "Working Tree"
    echo "------------"
    printf '%-16s %s\n' "State" "${repository_state}"
    printf '%-16s %s\n' "Staged" "${staged}"
    printf '%-16s %s\n' "Modified" "${modified}"
    printf '%-16s %s\n' "Untracked" "${untracked}"
}

###############################################################################
# Repository Status
###############################################################################

repository_status() {
    if ! ensure_git_repository; then
        return 0
    fi

    clear

    echo "========================================="
    echo "         Repository Status"
    echo "========================================="
    echo

    print_engineering_dashboard

    echo
    print_divider
    echo

    git -C "${REPO_ROOT}" status --short --branch

    pause
}

###############################################################################
# Review Changes
###############################################################################

review_changes() {
    if ! ensure_git_repository; then
        return 0
    fi

    clear

    echo "========================================="
    echo "          Review Changes"
    echo "========================================="
    echo

    echo "Git status"
    echo "----------"
    git -C "${REPO_ROOT}" status

    echo
    print_divider
    echo

    echo "Unstaged change summary"
    echo "-----------------------"
    git -C "${REPO_ROOT}" diff --stat

    echo
    echo "Staged change summary"
    echo "---------------------"
    git -C "${REPO_ROOT}" diff --cached --stat

    echo
    print_divider
    echo

    echo "Recent commits"
    echo "--------------"
    git -C "${REPO_ROOT}" log \
        --decorate \
        --oneline \
        -10

    pause
}

###############################################################################
# Engineering Menu
###############################################################################

engineering_menu() {
    while true; do
        clear

        echo "========================================="
        echo "         Engineering Console"
        echo "========================================="
        echo

        if ensure_git_repository; then
            print_engineering_dashboard
        fi

        echo
        print_divider
        echo

        echo "1) Repository Status"
        echo "2) Review Changes"
        echo "3) Repository Doctor"
        echo "4) Repository Validation"
        echo "5) Workstation Validation"
        echo "6) Release Assistant"
        echo
        echo "B) Back"
        echo

        read -rp "Select an option: " choice

        case "${choice}" in
            1)
                repository_status
                ;;
            2)
                review_changes
                ;;
            3)
                run_script "${DOCTOR_SCRIPT}"
                ;;
            4)
                run_script "${REPO_VALIDATE_SCRIPT}"
                ;;
            5)
                run_script "${WORKSTATION_VALIDATE_SCRIPT}"
                ;;
            6)
                run_script "${RELEASE_SCRIPT}"
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
