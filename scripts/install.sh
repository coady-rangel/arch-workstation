#!/usr/bin/env bash

set -Eeuo pipefail

# Name: install.sh
# Purpose: Install official and AUR packages and register helper commands.
# Usage: ./scripts/install.sh [--update]
# Dependencies: bash, sudo, pacman, git, makepkg

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

readonly PACKAGE_FILE="$REPO_ROOT/packages/arch-packages.txt"
readonly AUR_PACKAGE_FILE="$REPO_ROOT/packages/aur-packages.txt"

UPDATE_SYSTEM=false
TEMP_DIR=""

usage() {
    cat <<'USAGE_EOF'
Usage: install.sh [OPTIONS]

Options:
  --update    Update system packages before installing
  --help      Show this help message
USAGE_EOF
}

cleanup() {
    if [[ -n $TEMP_DIR && -d $TEMP_DIR ]]; then
        rm -rf -- "$TEMP_DIR"
    fi
}

parse_args() {
    while (( $# > 0 )); do
        case $1 in
            --update)
                UPDATE_SYSTEM=true
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac

        shift
    done
}

validate_environment() {
    [[ -r /etc/os-release ]] ||
        error "Unable to identify the operating system."

    # shellcheck disable=SC1091
    source /etc/os-release

    [[ ${ID:-} == "arch" ]] ||
        error "Unsupported operating system: ${PRETTY_NAME:-unknown}. This installer requires Arch Linux."

    (( EUID != 0 )) ||
        error "Do not run this installer as root. Run it as a regular user with sudo access."

    command_exists sudo ||
        error "Required command not found: sudo"

    command_exists pacman ||
        error "Required command not found: pacman"
}

read_package_manifest() {
    local manifest=$1

    sed \
        -e 's/[[:space:]]*#.*$//' \
        -e '/^[[:space:]]*$/d' \
        "$manifest"
}

install_official_packages() {
    local -a packages=()

    [[ -f $PACKAGE_FILE ]] ||
        error "Package manifest not found: $PACKAGE_FILE"

    mapfile -t packages < <(read_package_manifest "$PACKAGE_FILE")

    (( ${#packages[@]} > 0 )) ||
        error "No packages were found in $PACKAGE_FILE"

    if [[ $UPDATE_SYSTEM == true ]]; then
        info "Updating system packages..."
        sudo pacman -Syu --noconfirm
    fi

    info "Installing official packages..."
    sudo pacman -S --needed --noconfirm "${packages[@]}"
}

install_paru() {
    warn "paru not found. Installing..."

    sudo pacman -S --needed --noconfirm base-devel git

    TEMP_DIR=$(mktemp -d)
    trap cleanup EXIT

    git clone https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"

    (
        cd "$TEMP_DIR/paru"
        makepkg -si --noconfirm
    )
}

install_aur_packages() {
    local -a aur_packages=()

    if [[ ! -f $AUR_PACKAGE_FILE ]]; then
        info "No AUR package manifest found. Skipping."
        return
    fi

    mapfile -t aur_packages < <(
        read_package_manifest "$AUR_PACKAGE_FILE"
    )

    if (( ${#aur_packages[@]} == 0 )); then
        info "No AUR packages found."
        return
    fi

    if ! command_exists paru; then
        install_paru
    fi

    info "Installing ${#aur_packages[@]} AUR packages..."
    paru -S --needed --noconfirm "${aur_packages[@]}"
}

helper_command_name() {
    local script_name=$1

    case $script_name in
        install)
            printf '%s\n' "workstation-install"
            ;;
        bootstrap)
            printf '%s\n' "workstation-bootstrap"
            ;;
        deploy-configs)
            printf '%s\n' "workstation-deploy"
            ;;
        validate)
            printf '%s\n' "workstation-validate"
            ;;
        *)
            printf '%s\n' "$script_name"
            ;;
    esac
}

install_helper_commands() {
    local script
    local script_name
    local command_name

    info "Installing helper commands..."

    mkdir -p "$HOME/.local/bin"

    while IFS= read -r script; do
        script_name=$(basename "$script" .sh)
        command_name=$(helper_command_name "$script_name")

        ln -sf "$script" "$HOME/.local/bin/$command_name"
    done < <(
        find "$REPO_ROOT/scripts" \
            -maxdepth 1 \
            -type f \
            -executable
    )

    success "Helper commands installed"
}

main() {
    parse_args "$@"
    validate_environment

    info "Starting Arch workstation package installation..."

    install_official_packages
    install_aur_packages
    install_helper_commands

    success "Package installation complete."
}

main "$@"
