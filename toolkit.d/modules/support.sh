#!/usr/bin/env bash

###############################################################################
# Support Module
###############################################################################

register_module \
    "Support" \
    "Diagnostics and support bundle generation" \
    10 \
    module_menu

###############################################################################
# Repository Paths
###############################################################################

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

SUPPORT_SCRIPT="${REPO_ROOT}/support/support.sh"
SUPPORT_README="${REPO_ROOT}/support/README.md"

###############################################################################
# Support Menu
###############################################################################

module_menu() {

    while true; do

        clear

        echo "========================================="
        echo "               Support"
        echo "========================================="
        echo
        echo "1) Generate Support Bundle"
        echo "2) View Support README"
        echo
        echo "B) Back"
        echo

        read -rp "Select an option: " choice

        case "${choice}" in

            1)
                if [[ ! -f "${SUPPORT_SCRIPT}" ]]; then
                    echo
                    echo "Support script not found:"
                    echo "${SUPPORT_SCRIPT}"
                    pause
                    continue
                fi

                if [[ -x "${SUPPORT_SCRIPT}" ]]; then
                    "${SUPPORT_SCRIPT}"
                else
                    bash "${SUPPORT_SCRIPT}"
                fi

                pause
                ;;

            2)
                if [[ ! -f "${SUPPORT_README}" ]]; then
                    echo
                    echo "Support README not found:"
                    echo "${SUPPORT_README}"
                    pause
                    continue
                fi

                view_document "${SUPPORT_README}"
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
