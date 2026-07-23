#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false
VERSION=""

show_usage() {
    cat <<'EOF'
Usage:
  ./scripts/release.sh [options] <version>

Options:
  -n, --dry-run   Run all release checks without creating a release
  -h, --help      Show this help message

Examples:
  ./scripts/release.sh 4.0.0
  ./scripts/release.sh v4.0.0
  ./scripts/release.sh --dry-run 4.0.0
  ./scripts/release.sh -n v4.0.0
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            echo "ERROR: Unknown option: $1"
            echo
            show_usage
            exit 1
            ;;
        *)
            if [[ -n "$VERSION" ]]; then
                echo "ERROR: Only one version may be provided."
                echo
                show_usage
                exit 1
            fi

            VERSION="$1"
            shift
            ;;
    esac
done

if [[ -z "$VERSION" ]]; then
    echo "ERROR: Version is required."
    echo
    show_usage
    exit 1
fi

# Normalize input so both "4.0.0" and "v4.0.0" become "v4.0.0".
TAG="v${VERSION#v}"

echo "========================================="
echo " Arch Workstation Release Utility"
echo "========================================="
echo
echo "Repository : $(basename "$(pwd)")"
echo "Version    : ${TAG}"

if [[ "$DRY_RUN" == true ]]; then
    echo "Mode       : DRY RUN"
else
    echo "Mode       : RELEASE VALIDATION"
fi

echo

#
# Verify repository is clean
#

echo "[1/6] Checking git status..."

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo
    echo "ERROR: Repository has uncommitted changes."
    echo
    git status --short
    echo
    echo "Commit or stash your changes before creating a release."
    exit 1
fi

#
# Verify release notes exist
#

echo "[2/6] Checking release notes..."

RELEASE_NOTES="docs/roadmap/release_notes/${TAG}.md"

if [[ ! -f "$RELEASE_NOTES" ]]; then
    echo
    echo "ERROR: Missing release notes."
    echo "Expected: ${RELEASE_NOTES}"
    exit 1
fi

#
# Run repository health checks
#

echo "[3/6] Running repository health checks..."

make doctor

#
# Validate repository
#

echo "[4/6] Running repository validation..."

make validate

#
# Generate README
#

echo "[5/6] Generating README..."

make readme

#
# Confirm README generation did not modify tracked files
#

echo "[6/6] Checking generated documentation..."

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo
    echo "ERROR: Generated documentation is not up to date."
    echo
    git status --short
    echo
    echo "Review and commit the generated changes before releasing."
    exit 1
fi

echo
echo "========================================="
echo " Release Summary"
echo "========================================="
echo
echo "Repository : $(basename "$(pwd)")"
echo "Version    : ${TAG}"

if [[ "$DRY_RUN" == true ]]; then
    echo "Status     : DRY RUN PASSED"
    echo
    echo "All release checks completed successfully."
    echo "No tags were created or pushed."
else
    echo "Status     : READY"
    echo
    echo "Next steps:"
    echo "  git tag -a ${TAG} -m \"Release ${TAG}\""
    echo "  git push origin ${TAG}"
fi

echo
echo "Release validation completed successfully."
