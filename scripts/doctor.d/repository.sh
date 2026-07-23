#!/usr/bin/env bash

section "Repository"

check "Inside Git repository" \
    git rev-parse --is-inside-work-tree

check "Working tree clean" \
    git diff --quiet

check "No staged changes" \
    git diff --cached --quiet

check "No untracked files" \
    test -z "$(git ls-files --others --exclude-standard)"
