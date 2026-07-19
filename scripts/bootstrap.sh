#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"
DEPLOY_SCRIPT="$SCRIPT_DIR/deploy-configs.sh"

error() {
    echo "Error: $*" >&2
    exit 1
}

[[ -x "$INSTALL_SCRIPT" ]] || error "install.sh not found or not executable."
[[ -x "$DEPLOY_SCRIPT" ]] || error "deploy-configs.sh not found or not executable."

echo "================================="
echo " Arch Workstation Bootstrap"
echo "================================="

echo
echo "[1/3] Installing packages..."
echo

"$INSTALL_SCRIPT"

echo
echo "[2/3] Configuration deployment"
echo

"$DEPLOY_SCRIPT"

echo
echo "[3/3] System validation"
echo

echo "System validation has not been implemented yet."

echo
echo "Bootstrap completed successfully."
