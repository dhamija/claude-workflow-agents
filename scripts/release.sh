#!/bin/bash

# Release a new version
# Usage: ./scripts/release.sh [major|minor|patch]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Get current version
CURRENT=$(cat "$REPO_ROOT/version.txt")
echo "Current version: v$CURRENT"

# Parse version
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

# Determine bump type
BUMP_TYPE="${1:-patch}"

case "$BUMP_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Usage: $0 [major|minor|patch]"
        echo "  major: Breaking changes (1.0.0 → 2.0.0)"
        echo "  minor: New features (1.0.0 → 1.1.0)"
        echo "  patch: Bug fixes (1.0.0 → 1.0.1)"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version:     v$NEW_VERSION"
echo ""

# Confirm
read -p "Release v$NEW_VERSION? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Check for uncommitted changes
if ! git diff --quiet; then
    echo "Error: Uncommitted changes. Commit or stash first."
    exit 1
fi

# Update version.txt
echo "$NEW_VERSION" > "$REPO_ROOT/version.txt"

# Update CHANGELOG.md
DATE=$(date +%Y-%m-%d)
TEMP=$(mktemp)

# Insert new version section after header
awk -v ver="$NEW_VERSION" -v date="$DATE" '
    /^## \[/ && !inserted {
        print "## [" ver "] - " date
        print ""
        print "### Added"
        print "- "
        print ""
        print "### Changed"
        print "- "
        print ""
        print "### Fixed"
        print "- "
        print ""
        print "---"
        print ""
        inserted=1
    }
    { print }
' "$REPO_ROOT/CHANGELOG.md" > "$TEMP"
mv "$TEMP" "$REPO_ROOT/CHANGELOG.md"

echo ""
echo "✓ Updated version.txt and CHANGELOG.md"
echo ""
echo "Next steps:"
echo "  1. Edit CHANGELOG.md with actual changes"
echo "  2. Run: ./scripts/release-finish.sh"
echo ""
echo "Or do it manually:"
echo "  git add version.txt CHANGELOG.md"
echo "  git commit -m 'release: v$NEW_VERSION'"
echo "  git tag v$NEW_VERSION"
echo "  git push origin master --tags"
echo ""
