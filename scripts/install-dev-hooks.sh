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
echo "🔒 ENFORCEMENT ACTIVE:"
echo ""
echo "The pre-commit hook will BLOCK commits that:"
echo "  ✗ Change agents/*.md without updating:"
echo "      - CLAUDE.md"
echo "      - commands/agent-wf-help.md"
echo "      - README.md"
echo "      - GUIDE.md"
echo "      - tests/structural/test_agents_exist.sh"
echo ""
echo "  ✗ Change commands/*.md without updating:"
echo "      - CLAUDE.md"
echo "      - commands/agent-wf-help.md"
echo "      - README.md"
echo "      - GUIDE.md"
echo "      - tests/structural/test_commands_exist.sh"
echo ""
echo "Helper scripts:"
echo "  ./scripts/verify-sync.sh  - Check documentation sync"
echo "  ./scripts/fix-sync.sh     - Generate copy-paste content"
echo ""
echo "Emergency bypass (use only if absolutely necessary):"
echo "  git commit --no-verify"
echo ""
