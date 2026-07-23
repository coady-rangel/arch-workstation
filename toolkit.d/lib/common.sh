#!/usr/bin/env bash

###############################################################################
# Common UI Functions
###############################################################################

print_header() {
    clear

    echo "========================================="
    echo "      Arch Workstation Toolkit"
    echo "========================================="
    echo
}

pause() {
    echo
    read -rp "Press Enter to continue..."
}

print_divider() {
    printf '%*s\n' 41 '' | tr ' ' '='
}

###############################################################################
# Status Formatting
###############################################################################

print_success() {
    printf '[PASS] %s\n' "$*"
}

print_failure() {
    printf '[FAIL] %s\n' "$*" >&2
}

print_warning() {
    printf '[WARN] %s\n' "$*"
}

###############################################################################
# Command Helpers
###############################################################################

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

confirm() {
    local prompt="${1:-Continue?}"
    local response

    read -rp "${prompt} [y/N]: " response

    case "${response}" in
        y|Y|yes|YES|Yes)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

###############################################################################
# External Script Runner
###############################################################################

run_script() {
    local script="$1"
    shift

    local rc=0

    echo

    if [[ ! -f "${script}" ]]; then
        print_failure "Script not found:"
        echo "${script}"
        pause
        return 0
    fi

    echo "Running:"
    printf '  %q' "${script}" "$@"
    printf '\n\n'

    if [[ -x "${script}" ]]; then
        "${script}" "$@" || rc=$?
    else
        bash "${script}" "$@" || rc=$?
    fi

    echo
    print_divider
    echo

    if (( rc == 0 )); then
        print_success "Command completed successfully."
    else
        print_warning "Command completed with exit code ${rc}."
    fi

    pause

    # A child script failure is reported to the user but must not terminate
    # the interactive Toolkit.
    return 0
}

###############################################################################
# Documentation Viewer
###############################################################################

view_document() {
    local file="$1"

    clear

    echo "========================================="
    echo "        Documentation Viewer"
    echo "========================================="
    echo

    if [[ ! -f "${file}" ]]; then
        print_failure "Document not found:"
        echo "${file}"
        pause
        return 0
    fi

    echo "The document will now open in your pager."
    echo
    echo "Navigation:"
    echo "  Up/Down or j/k  - Scroll"
    echo "  Space           - Next page"
    echo "  /               - Search"
    echo "  q               - Return to the previous menu"
    echo

    read -rp "Press Enter to continue..."

    if command_exists bat; then
        bat --paging=always "${file}"
    else
        less "${file}"
    fi
}

###############################################################################
# Module Registry
###############################################################################

declare -ag TOOLKIT_MODULE_NAMES=()
declare -ag TOOLKIT_MODULE_DESCRIPTIONS=()
declare -ag TOOLKIT_MODULE_ORDERS=()
declare -ag TOOLKIT_MODULE_FUNCTIONS=()

register_module() {
    local name="$1"
    local description="$2"
    local order="$3"
    local function="$4"

    TOOLKIT_MODULE_NAMES+=("${name}")
    TOOLKIT_MODULE_DESCRIPTIONS+=("${description}")
    TOOLKIT_MODULE_ORDERS+=("${order}")
    TOOLKIT_MODULE_FUNCTIONS+=("${function}")
}
