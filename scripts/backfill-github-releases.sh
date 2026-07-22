#!/usr/bin/env bash
set -euo pipefail

notes_dir="docs/roadmap/release_notes"

for notes in "${notes_dir}"/v*.md; do
    tag="$(basename "$notes" .md)"

    if gh release view "$tag" >/dev/null 2>&1; then
        echo "✓ $tag already exists"
        continue
    fi

    if ! git rev-parse "$tag" >/dev/null 2>&1; then
        echo "✗ Missing git tag: $tag"
        continue
    fi

    title="$(head -n1 "$notes" | sed 's/^# //')"

    echo "Creating release for $tag..."

    gh release create "$tag" \
        --verify-tag \
        --title "$title" \
        --notes-file "$notes"

    echo "✓ Published $tag"
    echo
done
