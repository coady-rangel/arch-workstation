#!/usr/bin/env bash

ROOT="$(git rev-parse --show-toplevel)"

# shellcheck disable=SC2034
# Configuration variables are intended to be sourced by other scripts.
# shellcheck disable=SC2034
README_FILE="$ROOT/README.md"
# shellcheck disable=SC2034
CHANGELOG_FILE="$ROOT/docs/roadmap/CHANGELOG.md"

# shellcheck disable=SC2034
RELEASE_TEMPLATE="$ROOT/docs/templates/RELEASE_NOTE_TEMPLATE.md"
# shellcheck disable=SC2034
RELEASE_NOTES_DIR="$ROOT/docs/roadmap/release_notes"
