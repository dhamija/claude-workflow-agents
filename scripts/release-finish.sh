#!/bin/bash

# Finish release: commit, tag, push
# Run after editing CHANGELOG.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VERSION=$(cat "$REPO_ROOT/version.txt")

echo "Finishing release v$VERSION"
echo ""

# Check CHANGELOG was edited
if grep -q "^- $" "$REPO_ROOT/CHANGELOG.md"; then
    echo "⚠ Warning: CHANGELOG.md has empty entries"
    read -p "Continue anyway? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Edit CHANGELOG.md first, then run this again."
        exit 0
    fi
fi

# Commit
echo "Committing version bump..."
git add version.txt CHANGELOG.md
git commit -m "release: v$VERSION"

# Tag
echo "Creating tag v$VERSION..."
git tag "v$VERSION"

# Push
echo ""
read -p "Push to origin? [Y/n] " push
if [[ ! "$push" =~ ^[Nn]$ ]]; then
    git push origin master --tags
    echo ""
    echo "✓ Released v$VERSION"
    echo ""
    echo "GitHub Actions will create the release automatically."
    echo "Check: https://github.com/dhamija/claude-workflow-agents/releases"
else
    echo ""
    echo "✓ Tagged locally. Push when ready:"
    echo "  git push origin master --tags"
fi
