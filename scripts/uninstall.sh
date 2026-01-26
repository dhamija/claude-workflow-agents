#!/bin/bash

# Uninstall claude-workflow-agents
# Preserves user content (CLAUDE.md content, docs/, code)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_DIR="$(cd "$WORKFLOW_DIR/.." && pwd)"

echo ""
echo "Uninstall Claude Workflow Agents"
echo ""

# Confirm
read -p "Remove workflow system? Your CLAUDE.md content will be preserved. [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Remove workflow marker from CLAUDE.md but keep content
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    # Remove the workflow marker line
    sed -i.bak '/^<!-- workflow:.*-->$/d' "$PROJECT_DIR/CLAUDE.md"
    # Remove empty lines at start
    sed -i.bak '/./,$!d' "$PROJECT_DIR/CLAUDE.md"
    rm -f "$PROJECT_DIR/CLAUDE.md.bak"
    echo "✓ Cleaned CLAUDE.md (your content preserved)"
fi

# Remove workflow directory
cd "$PROJECT_DIR"
rm -rf ".workflow"
echo "✓ Removed .workflow/"

echo ""
echo "Uninstalled. Your CLAUDE.md and docs/ are preserved."
echo ""
echo "To reinstall: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/main/install.sh | bash"
echo ""
