#!/bin/bash

# Install claude-workflow-agents globally
# Usage: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/main/install.sh | bash

set -e

VERSION="1.0.0"
INSTALL_DIR="$HOME/.claude-workflow-agents"
REPO_URL="https://github.com/dhamija/claude-workflow-agents"

echo ""
echo "Claude Workflow Agents - Install"
echo "================================="
echo ""

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
    CURRENT_VERSION=$(cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown")
    echo "Already installed (version: $CURRENT_VERSION)"
    echo ""
    read -p "Update to version $VERSION? [y/N] " update
    if [[ "$update" =~ ^[Yy]$ ]]; then
        echo "Updating..."
        rm -rf "$INSTALL_DIR"
    else
        echo ""
        echo "Keeping current installation."
        echo "Use: workflow-init in your project to activate."
        exit 0
    fi
fi

# Download
echo "Downloading..."
if command -v git &> /dev/null; then
    git clone --depth 1 --quiet "$REPO_URL" "$INSTALL_DIR"
    rm -rf "$INSTALL_DIR/.git"
else
    echo "Error: git required. Install git and retry."
    exit 1
fi

# Create version file
echo "$VERSION" > "$INSTALL_DIR/version.txt"

# Create bin directory
mkdir -p "$INSTALL_DIR/bin"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-init
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-init" << 'SCRIPT'
#!/bin/bash

# Initialize workflow in current project

WORKFLOW_HOME="$HOME/.claude-workflow-agents"

if [ ! -d "$WORKFLOW_HOME" ]; then
    echo "Error: Workflow agents not installed globally."
    echo "Run: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/main/install.sh | bash"
    exit 1
fi

# Already initialized?
if [ -f "CLAUDE.md" ] && grep -q "<!-- workflow:" "CLAUDE.md"; then
    STATUS=$(grep "<!-- workflow:" "CLAUDE.md" | sed 's/.*: \(.*\) -->.*/\1/')
    echo "Already initialized (status: $STATUS)"
    echo ""
    echo "Commands:"
    echo "  /workflow on      Enable"
    echo "  /workflow off     Disable"
    echo "  /workflow status  Check status"
    exit 0
fi

# Create or update CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    echo "Found existing CLAUDE.md - preserving your content"
    TEMP=$(mktemp)
    echo "<!-- workflow: enabled -->" > "$TEMP"
    echo "<!-- workflow-home: $WORKFLOW_HOME -->" >> "$TEMP"
    echo "" >> "$TEMP"
    cat "CLAUDE.md" >> "$TEMP"
    mv "$TEMP" "CLAUDE.md"
else
    PROJECT_NAME=$(basename "$(pwd)")
    cat > "CLAUDE.md" << EOF
<!-- workflow: enabled -->
<!-- workflow-home: $WORKFLOW_HOME -->

# $PROJECT_NAME

> Describe your project here

## Project Context

Add notes, decisions, or context for Claude.

## Notes

[Your notes]
EOF
fi

echo ""
echo "✓ Workflow initialized"
echo ""
echo "  Status:  enabled"
echo "  Agents:  $WORKFLOW_HOME/agents/"
echo ""
echo "  Commands:"
echo "    /workflow off     Disable workflow"
echo "    /workflow on      Enable workflow"
echo "    /workflow status  Check status"
echo ""
echo "  Get started: Describe what you want to build!"
echo ""
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-init"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-remove
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-remove" << 'SCRIPT'
#!/bin/bash

# Remove workflow from current project

if [ ! -f "CLAUDE.md" ]; then
    echo "No CLAUDE.md in current directory"
    exit 1
fi

if ! grep -q "<!-- workflow:" "CLAUDE.md"; then
    echo "Workflow not active in this project"
    exit 0
fi

echo "Removing workflow from this project..."

# Remove workflow markers, keep content
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/^<!-- workflow:/d' "CLAUDE.md"
    sed -i '' '/^<!-- workflow-home:/d' "CLAUDE.md"
    # Remove leading blank lines
    sed -i '' '/./,$!d' "CLAUDE.md"
else
    sed -i '/^<!-- workflow:/d' "CLAUDE.md"
    sed -i '/^<!-- workflow-home:/d' "CLAUDE.md"
    # Remove leading blank lines
    sed -i '/./,$!d' "CLAUDE.md"
fi

echo ""
echo "✓ Workflow removed"
echo "  Your CLAUDE.md content is preserved."
echo ""
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-remove"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-update
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-update" << 'SCRIPT'
#!/bin/bash

# Update global installation

INSTALL_DIR="$HOME/.claude-workflow-agents"
REPO_URL="https://github.com/dhamija/claude-workflow-agents"

echo "Updating Claude Workflow Agents..."

CURRENT=$(cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown")
echo "Current version: $CURRENT"

# Download to temp
TEMP_DIR=$(mktemp -d)
git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR"
rm -rf "$TEMP_DIR/.git"

NEW_VERSION=$(cat "$TEMP_DIR/version.txt" 2>/dev/null || echo "unknown")
echo "Latest version:  $NEW_VERSION"

if [ "$CURRENT" = "$NEW_VERSION" ]; then
    echo "Already up to date."
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Preserve bin (has our scripts)
mkdir -p "$TEMP_DIR/bin"
cp -r "$INSTALL_DIR/bin/"* "$TEMP_DIR/bin/" 2>/dev/null || true

# Replace
rm -rf "$INSTALL_DIR"
mv "$TEMP_DIR" "$INSTALL_DIR"

echo ""
echo "✓ Updated to $NEW_VERSION"
echo ""
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-update"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-uninstall
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-uninstall" << 'SCRIPT'
#!/bin/bash

# Uninstall globally

INSTALL_DIR="$HOME/.claude-workflow-agents"

echo ""
echo "Uninstall Claude Workflow Agents"
echo ""
echo "This removes the global installation."
echo "CLAUDE.md files in your projects are NOT affected."
echo ""
read -p "Continue? [y/N] " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Remove from PATH in shell configs
for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [ -f "$rc" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/claude-workflow-agents/d' "$rc" 2>/dev/null || true
        else
            sed -i '/claude-workflow-agents/d' "$rc" 2>/dev/null || true
        fi
    fi
done

# Remove installation
rm -rf "$INSTALL_DIR"

echo ""
echo "✓ Uninstalled"
echo ""
echo "  To clean up projects, run in each project:"
echo "    Remove the workflow markers from CLAUDE.md"
echo "    (Your content is preserved)"
echo ""
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-uninstall"

# ─────────────────────────────────────────────────────────────────
# Add to PATH
# ─────────────────────────────────────────────────────────────────
PATH_LINE='export PATH="$HOME/.claude-workflow-agents/bin:$PATH"'

add_to_path() {
    local rc="$1"
    if [ -f "$rc" ]; then
        if ! grep -q "claude-workflow-agents" "$rc"; then
            echo "" >> "$rc"
            echo "# Claude Workflow Agents" >> "$rc"
            echo "$PATH_LINE" >> "$rc"
            return 0
        fi
    fi
    return 1
}

ADDED_TO=""
if add_to_path "$HOME/.zshrc"; then
    ADDED_TO="$HOME/.zshrc"
elif add_to_path "$HOME/.bashrc"; then
    ADDED_TO="$HOME/.bashrc"
elif add_to_path "$HOME/.profile"; then
    ADDED_TO="$HOME/.profile"
fi

# ─────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────
echo ""
echo "✓ Installed successfully"
echo ""
echo "  Location: $INSTALL_DIR"
echo "  Version:  $VERSION"
echo ""
echo "  Commands (after restarting terminal):"
echo "    workflow-init       Initialize in a project"
echo "    workflow-remove     Remove from a project"
echo "    workflow-update     Update to latest version"
echo "    workflow-uninstall  Remove global installation"
echo ""
if [ -n "$ADDED_TO" ]; then
    echo "  PATH updated in: $ADDED_TO"
    echo "  Run: source $ADDED_TO"
    echo "  Or restart your terminal."
else
    echo "  Add to your PATH:"
    echo "    $PATH_LINE"
fi
echo ""
echo "  Quick start:"
echo "    cd your-project"
echo "    workflow-init"
echo ""
