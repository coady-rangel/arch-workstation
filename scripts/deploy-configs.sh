#!/usr/bin/env bash

set -Eeuo pipefail

# Name: deploy-configs.sh
# Purpose: Deploy configuration directories into ~/.config using symlinks.
# Usage: ./scripts/deploy-configs.sh
# Dependencies: lib/common.sh

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib/common.sh"

readonly SOURCE_DIR="$REPO_ROOT/configs"
readonly TARGET_DIR="$HOME/.config"

deploy_config() {
    local source=$1
    local name
    local target
    local current
    local backup

    name=$(basename "$source")
    target="$TARGET_DIR/$name"

    printf '\n'
    info "[+] $name"

    if [[ -L $target ]]; then
        current=$(readlink -f "$target")

        if [[ $current == "$source" ]]; then
            info "Already linked."
            return
        fi

        rm "$target"

    elif [[ -e $target ]]; then
        backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$backup"

        warn "Backed up existing configuration:"
        printf '  %s\n' "$backup"
    fi

    ln -s "$source" "$target"
    success "Symlink created."
}

main() {
    local source

    [[ -d $SOURCE_DIR ]] ||
        error "Configuration directory not found."

    mkdir -p "$TARGET_DIR"

    info "Deploying configuration..."

    for source in "$SOURCE_DIR"/*; do
        [[ -d $source ]] || continue
        deploy_config "$source"
    done

    printf '\n'
    success "Configuration deployment complete."
    info "Repository root: $REPO_ROOT"
    info "If this repository is moved or renamed, rerun deploy-configs.sh to refresh symlinks."
}

main "$@"

