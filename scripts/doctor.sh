#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/doctor-common.sh
source "$SCRIPT_DIR/lib/doctor-common.sh"

# shellcheck source=scripts/lib/repo-config.sh
source "$SCRIPT_DIR/lib/repo-config.sh"

echo
echo "======================================="
echo " Arch Workstation Repository Doctor"
echo "======================================="

for module in "$SCRIPT_DIR"/doctor.d/*.sh; do
    # shellcheck source=/dev/null
    source "$module"
done

echo
echo "Summary"
echo "-------"

if (( DOCTOR_FAILURES == 0 )); then
    echo "✓ Repository healthy."
    exit 0
fi

echo "✗ ${DOCTOR_FAILURES} check(s) failed."
exit 1
