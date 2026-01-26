#!/bin/bash

# Install claude-workflow-agents
# Usage: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/main/install.sh | bash

set -e

REPO_URL="https://github.com/dhamija/claude-workflow-agents"
INSTALL_DIR=".workflow"

echo ""
echo "Installing Claude Workflow Agents..."
echo ""

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
    echo "Workflow already installed in $INSTALL_DIR"
    echo ""
    echo "Options:"
    echo "  Update:    rm -rf $INSTALL_DIR && re-run install"
    echo "  Uninstall: ./$INSTALL_DIR/scripts/uninstall.sh"
    exit 1
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Clone or download
if command -v git &> /dev/null; then
    echo "Downloading via git..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR/tmp" 2>/dev/null
    mv "$INSTALL_DIR/tmp/agents" "$INSTALL_DIR/"
    mv "$INSTALL_DIR/tmp/commands" "$INSTALL_DIR/"
    mv "$INSTALL_DIR/tmp/templates" "$INSTALL_DIR/"
    mkdir -p "$INSTALL_DIR/scripts"
    mv "$INSTALL_DIR/tmp/scripts/verify.sh" "$INSTALL_DIR/scripts/"
    cp "$INSTALL_DIR/tmp/scripts/uninstall.sh" "$INSTALL_DIR/scripts/" 2>/dev/null || true
    rm -rf "$INSTALL_DIR/tmp"
else
    echo "Git not found. Please install git and retry."
    exit 1
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/scripts/"*.sh 2>/dev/null || true

# Handle CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    echo "Found existing CLAUDE.md - preserving your content"

    # Check if already has workflow marker
    if grep -q "<!-- workflow:" "CLAUDE.md"; then
        echo "Workflow marker already present"
    else
        # Add marker at top, preserve content
        TEMP=$(mktemp)
        echo "<!-- workflow: enabled -->" > "$TEMP"
        echo "" >> "$TEMP"
        cat "CLAUDE.md" >> "$TEMP"
        mv "$TEMP" "CLAUDE.md"
        echo "Added workflow marker to existing CLAUDE.md"
    fi
else
    # Create new CLAUDE.md
    cat > "CLAUDE.md" << 'EOF'
<!-- workflow: enabled -->

# My Project

> Describe your project here

## Project Context

Add notes, decisions, or context you want Claude to know.

## Notes

[Your notes here]
EOF
    echo "Created CLAUDE.md"
fi

# Create .gitignore entry if needed
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.workflow/$" ".gitignore" && ! grep -q "^# \.workflow/$" ".gitignore"; then
        echo "" >> ".gitignore"
        echo "# Claude Workflow Agents (optional - remove to commit)" >> ".gitignore"
        echo "# .workflow/" >> ".gitignore"
    fi
fi

echo ""
echo "✓ Installed successfully"
echo ""
echo "  Location:  .workflow/"
echo "  Status:    enabled"
echo ""
echo "  Commands:"
echo "    /workflow status   Check if enabled"
echo "    /workflow off      Disable workflow"
echo "    /workflow on       Enable workflow"
echo ""
echo "  Uninstall:"
echo "    ./.workflow/scripts/uninstall.sh"
echo ""
echo "  Get started:"
echo "    Just describe what you want to build!"
echo ""
