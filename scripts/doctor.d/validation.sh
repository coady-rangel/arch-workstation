#!/usr/bin/env bash

section "Validation"

while IFS= read -r script; do
    rel="${script#"$ROOT"/}"

    check "Syntax: $rel" \
        bash -n "$script"

    check "ShellCheck: $rel" \
        shellcheck -x -P "$ROOT/scripts" "$script"

done < <(find "$ROOT/scripts" -type f -name "*.sh" | sort)
