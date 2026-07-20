#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

info "Starting Arch workstation package installation..."

PACKAGE_FILE="$REPO_ROOT/packages/arch-packages.txt"
AUR_PACKAGE_FILE="$REPO_ROOT/packages/aur-packages.txt"
UPDATE_SYSTEM=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --update)
            UPDATE_SYSTEM=true
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
    shift
done

command_exists pacman || error "pacman was not found. This script is intended for Arch Linux."

[[ -f "$PACKAGE_FILE" ]] || error "Package manifest not found: $PACKAGE_FILE"

mapfile -t packages < <(
    sed \
        -e 's/[[:space:]]*#.*$//' \
        -e '/^[[:space:]]*$/d' \
        "$PACKAGE_FILE"
)

(( ${#packages[@]} > 0 )) || error "No packages were found in $PACKAGE_FILE"


if $UPDATE_SYSTEM; then
    info "Updating system packages..."
    sudo pacman -Syu --noconfirm
fi

info "Installing official packages..."
sudo pacman -S --needed --noconfirm "${packages[@]}"

###############################################################################
# Install AUR packages
###############################################################################

if [[ -f "$AUR_PACKAGE_FILE" ]]; then
    mapfile -t aur_packages < <(
        sed \
            -e 's/[[:space:]]*#.*$//' \
            -e '/^[[:space:]]*$/d' \
            "$AUR_PACKAGE_FILE"
    )

    if (( ${#aur_packages[@]} > 0 )); then
        if ! command_exists paru; then
            warn "paru not found. Installing..."

            sudo pacman -S --needed --noconfirm base-devel git

            tmpdir="$(mktemp -d)"

            cleanup() {
                rm -rf "$tmpdir"
            }

            trap cleanup EXIT
			
            git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"

            (
                cd "$tmpdir/paru"
                makepkg -si --noconfirm
            )

        fi

        info "Installing ${#aur_packages[@]} AUR packages..."
        paru -S --needed --noconfirm "${aur_packages[@]}"
    else
        info "No AUR packages found."
    fi
else
    info "No AUR package manifest found. Skipping."
fi

###############################################################################
# Install helper commands
###############################################################################

info "Installing helper commands..."

mkdir -p "$HOME/.local/bin"

find "$REPO_ROOT/scripts" -maxdepth 1 -type f -executable | while read -r script; do
    name="$(basename "$script" .sh)"

    case "$name" in
        install)
            command_name="workstation-install"
            ;;
        bootstrap)
            command_name="workstation-bootstrap"
            ;;
        deploy-configs)
            command_name="workstation-deploy"
            ;;
        validate)
            command_name="workstation-validate"
            ;;
        *)
            command_name="$name"
            ;;
    esac

    ln -sf "$script" "$HOME/.local/bin/$command_name"
done

success "Helper commands installed"
success "Package installation complete."
