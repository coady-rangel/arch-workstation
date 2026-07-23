#!/usr/bin/env bash

set -euo pipefail

################################################################################
# Arch Workstation Support Bundle
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_ROOT="${SCRIPT_DIR}/output"

# Shared helper functions
source "${SCRIPT_DIR}/lib/common.sh"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
OUTPUT_DIR="${OUTPUT_ROOT}/${TIMESTAMP}"

mkdir -p "${OUTPUT_DIR}"

echo
echo "=========================================="
echo " Arch Workstation Support Bundle"
echo "=========================================="
echo
echo "Output Directory:"
echo "  ${OUTPUT_DIR}"
echo

################################################################################
# Run Collectors
################################################################################

for collector in "${SCRIPT_DIR}"/collectors/*.sh; do

    # Summary runs after all other collectors.
    [[ "$(basename "${collector}")" == "summary.sh" ]] && continue

    log_info "Running $(basename "${collector}")..."

    if bash "${collector}" "${OUTPUT_DIR}"; then
        log_info "Completed successfully."
    else
        log_warn "Collector returned a non-zero exit code."
    fi

    echo

done

################################################################################
# Generate Summary
################################################################################

SUMMARY_COLLECTOR="${SCRIPT_DIR}/collectors/summary.sh"

log_info "Running $(basename "${SUMMARY_COLLECTOR}")..."

if bash "${SUMMARY_COLLECTOR}" "${OUTPUT_DIR}"; then
    log_info "Completed successfully."
else
    log_warn "Summary generator returned a non-zero exit code."
fi

echo

################################################################################
# Update latest symlink
################################################################################

ln -sfn "${OUTPUT_DIR}" "${OUTPUT_ROOT}/latest"

log_info "Latest bundle updated."

echo
log_info "Support bundle complete."
echo
