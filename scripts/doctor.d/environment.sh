#!/usr/bin/env bash

section "Environment"

check "Git installed" command -v git
check "GitHub CLI installed" command -v gh
check "ShellCheck installed" command -v shellcheck
check "Bash installed" command -v bash
check "GitHub authentication" gh auth status
