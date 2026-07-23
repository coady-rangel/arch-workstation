#!/usr/bin/env bash

section "Documentation"

check "README.md exists" \
    test -f "$README_FILE"

check "CHANGELOG.md exists" \
    test -f "$CHANGELOG_FILE"

check "Release template exists" \
    test -f "$RELEASE_TEMPLATE"

check "Release notes directory exists" \
    test -d "$RELEASE_NOTES_DIR"
