#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/common.sh"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <output-root>" >&2
    exit 2
fi

OUTPUT_ROOT="$1"
SUMMARY_FILE="${OUTPUT_ROOT}/summary.md"

log_info "Generating support bundle summary..."

OK_COUNT=0
WARNING_COUNT=0
ERROR_COUNT=0
MISSING_COUNT=0
COLLECTOR_COUNT=0

{
    echo "# Support Bundle Summary"
    echo
    echo "Generated: $(date --iso-8601=seconds)"
    echo
    echo "| Collector | Status |"
    echo "|---|---|"

    for collector_dir in "${OUTPUT_ROOT}"/*; do
        [[ -d "${collector_dir}" ]] || continue

        collector_name="$(basename "${collector_dir}")"
        status_file="${collector_dir}/status.txt"

        ((COLLECTOR_COUNT += 1))

        if [[ ! -f "${status_file}" ]]; then
            printf '| %s | %s |\n' "${collector_name}" "MISSING"
            ((MISSING_COUNT += 1))
            ((ERROR_COUNT += 1))
            continue
        fi

        status="$(
            awk -F ': *' '
                $1 == "Status" {
                    print $2
                    exit
                }
            ' "${status_file}"
        )"

        if [[ -z "${status}" ]]; then
            status="UNKNOWN"
        fi

        printf '| %s | %s |\n' "${collector_name}" "${status}"

        case "${status}" in
            OK)
                ((OK_COUNT += 1))
                ;;
            WARNING)
                ((WARNING_COUNT += 1))
                ;;
            ERROR)
                ((ERROR_COUNT += 1))
                ;;
            *)
                ((ERROR_COUNT += 1))
                ;;
        esac
    done

    echo
    echo "## Totals"
    echo
    echo "- Collectors: ${COLLECTOR_COUNT}"
    echo "- OK: ${OK_COUNT}"
    echo "- WARNING: ${WARNING_COUNT}"
    echo "- ERROR: ${ERROR_COUNT}"
    echo "- Missing status files: ${MISSING_COUNT}"
} > "${SUMMARY_FILE}"

log_info "Summary written to ${SUMMARY_FILE}"
