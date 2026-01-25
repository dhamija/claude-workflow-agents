#!/bin/bash

# Install git hooks for development

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║              INSTALL DEVELOPMENT HOOKS                           ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Check if we're in a git repo
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "Installing development hooks..."
echo ""

# Create hooks directory if needed
mkdir -p "$HOOKS_DIR"

# Pre-commit hook
if [ -f "$SCRIPT_DIR/hooks/pre-commit" ]; then
    cp "$SCRIPT_DIR/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
    chmod +x "$HOOKS_DIR/pre-commit"
    echo "✓ Installed pre-commit hook"
else
    echo "⚠️  pre-commit hook not found at $SCRIPT_DIR/hooks/pre-commit"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "                    INSTALLATION COMPLETE"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "The pre-commit hook will:"
echo "  - Check if CLAUDE.md is staged when agents/commands change"
echo "  - Run verify-sync.sh to check documentation"
echo "  - Block commit if documentation is out of sync"
echo ""
echo "To bypass: git commit --no-verify"
echo ""
