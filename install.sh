#!/bin/bash

# Install claude-workflow-agents globally
# Usage: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

set -e

VERSION="1.2.0"
INSTALL_DIR="$HOME/.claude-workflow-agents"
CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/dhamija/claude-workflow-agents"

echo ""
echo "Claude Workflow Agents - Install"
echo "================================="
echo ""

# Check if workflow agents already installed
if [ -d "$INSTALL_DIR" ]; then
    CURRENT_VERSION=$(cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown")
    echo "Already installed (version: $CURRENT_VERSION)"
    echo ""
    read -p "Update to version $VERSION? [y/N] " update
    if [[ "$update" =~ ^[Yy]$ ]]; then
        echo "Updating..."
        # Remove symlinks
        [ -L "$CLAUDE_DIR/agents" ] && rm -f "$CLAUDE_DIR/agents"
        [ -L "$CLAUDE_DIR/commands" ] && rm -f "$CLAUDE_DIR/commands"
        # Remove installation
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
TEMP_DIR=$(mktemp -d)
if command -v git &> /dev/null; then
    git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR"
else
    echo "Error: git required. Install git and retry."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Copy ONLY what users need (not repo meta files)
echo "Installing..."
cp -r "$TEMP_DIR/agents" "$INSTALL_DIR/"
cp -r "$TEMP_DIR/commands" "$INSTALL_DIR/"
cp -r "$TEMP_DIR/templates" "$INSTALL_DIR/"
cp "$TEMP_DIR/version.txt" "$INSTALL_DIR/"

# Cleanup temp
rm -rf "$TEMP_DIR"

# Create symlinks for Claude Code to find agents and commands
mkdir -p "$CLAUDE_DIR"

# Handle agents directory/symlink
if [ -d "$CLAUDE_DIR/agents" ] && [ ! -L "$CLAUDE_DIR/agents" ]; then
    # Real directory exists with user's own agents - back it up
    echo ""
    echo "⚠ Found existing agents in ~/.claude/agents/"
    echo "  Moving to ~/.claude/agents.user (preserving your files)"
    mv "$CLAUDE_DIR/agents" "$CLAUDE_DIR/agents.user"
fi
# Remove old workflow symlink or create new
[ -L "$CLAUDE_DIR/agents" ] && rm -f "$CLAUDE_DIR/agents"
ln -sf "$INSTALL_DIR/agents" "$CLAUDE_DIR/agents"

# Handle commands directory/symlink
if [ -d "$CLAUDE_DIR/commands" ] && [ ! -L "$CLAUDE_DIR/commands" ]; then
    # Real directory exists with user's own commands - back it up
    echo ""
    echo "⚠ Found existing commands in ~/.claude/commands/"
    echo "  Moving to ~/.claude/commands.user (preserving your files)"
    mv "$CLAUDE_DIR/commands" "$CLAUDE_DIR/commands.user"
fi
# Remove old workflow symlink or create new
[ -L "$CLAUDE_DIR/commands" ] && rm -f "$CLAUDE_DIR/commands"
ln -sf "$INSTALL_DIR/commands" "$CLAUDE_DIR/commands"

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
    echo "Run: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash"
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
PROJECT_NAME=$(basename "$(pwd)")
TEMPLATE="$WORKFLOW_HOME/templates/project/CLAUDE.md.template"

if [ -f "CLAUDE.md" ]; then
    echo "Found existing CLAUDE.md - adding workflow markers"
    TEMP=$(mktemp)
    echo "<!-- workflow: enabled -->" > "$TEMP"
    echo "<!-- workflow-home: $WORKFLOW_HOME -->" >> "$TEMP"
    echo "" >> "$TEMP"
    cat "CLAUDE.md" >> "$TEMP"
    mv "$TEMP" "CLAUDE.md"
else
    # Use template
    if [ -f "$TEMPLATE" ]; then
        sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            -e "s/{{PROJECT_DESCRIPTION}}/Describe your project here/g" \
            "$TEMPLATE" > "CLAUDE.md"
    else
        # Fallback if template missing
        cat > "CLAUDE.md" << EOF
<!-- workflow: enabled -->
<!-- workflow-home: $WORKFLOW_HOME -->

# $PROJECT_NAME

> Describe your project here

## Project Context

[Your project notes, decisions, context for Claude]
EOF
    fi
fi

echo ""
echo "✓ Workflow initialized"
echo ""
echo "  Status:  enabled"
echo "  Agents:  $WORKFLOW_HOME/agents/"
echo ""
echo "  Other files created on demand:"
echo "    /project setup    → scripts/, .github/"
echo "    /project docs     → README.md, /docs/"
echo "    /project release  → CHANGELOG.md, version.txt"
echo ""
echo "  Commands:"
echo "    /workflow off     Disable workflow"
echo "    /workflow on      Enable workflow"
echo "    /workflow status  Check status"
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

INSTALL_DIR="$HOME/.claude"
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
# Create: workflow-version
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-version" << 'SCRIPT'
#!/bin/bash

# Show version information

INSTALL_DIR="$HOME/.claude"

echo ""
echo "Claude Workflow Agents"
echo "──────────────────────"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Status: Not installed"
    exit 1
fi

VERSION=$(cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown")
AGENTS=$(find "$INSTALL_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
COMMANDS=$(find "$INSTALL_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

echo "Version:   v$VERSION"
echo "Location:  $INSTALL_DIR"
echo "Agents:    $AGENTS"
echo "Commands:  $COMMANDS"
echo ""
echo "Commands:"
echo "  workflow-init       Initialize project"
echo "  workflow-remove     Remove from project"
echo "  workflow-update     Update installation"
echo "  workflow-version    Show version"
echo "  workflow-uninstall  Remove installation"
echo ""
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-version"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-toggle
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-toggle" << 'SCRIPT'
#!/bin/bash

# Toggle workflow agents/commands on or off

INSTALL_DIR="$HOME/.claude-workflow-agents"
CLAUDE_DIR="$HOME/.claude"

# Check installation
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Error: Workflow not installed"
    exit 1
fi

# Check current status
if [ -L "$CLAUDE_DIR/agents" ] && readlink "$CLAUDE_DIR/agents" | grep -q "workflow-agents"; then
    STATUS="enabled"
else
    STATUS="disabled"
fi

# Parse command
CMD="${1:-status}"

case "$CMD" in
    status)
        echo ""
        echo "Workflow Status: $STATUS"
        if [ "$STATUS" = "enabled" ]; then
            echo "  Agents:   ~/.claude/agents/ -> workflow agents"
            echo "  Commands: ~/.claude/commands/ -> workflow commands"
            echo ""
            echo "To disable: workflow-toggle off"
        else
            echo "  Agents:   not linked"
            echo "  Commands: not linked"
            echo ""
            echo "To enable: workflow-toggle on"
        fi
        echo ""
        ;;

    on|enable)
        if [ "$STATUS" = "enabled" ]; then
            echo "Already enabled"
            exit 0
        fi

        # Check for user's own agents/commands
        if [ -d "$CLAUDE_DIR/agents" ] && [ ! -L "$CLAUDE_DIR/agents" ]; then
            echo "Warning: ~/.claude/agents/ exists (not a symlink)"
            echo "Moving to ~/.claude/agents.user"
            mv "$CLAUDE_DIR/agents" "$CLAUDE_DIR/agents.user"
        fi
        if [ -d "$CLAUDE_DIR/commands" ] && [ ! -L "$CLAUDE_DIR/commands" ]; then
            echo "Warning: ~/.claude/commands/ exists (not a symlink)"
            echo "Moving to ~/.claude/commands.user"
            mv "$CLAUDE_DIR/commands" "$CLAUDE_DIR/commands.user"
        fi

        # Create symlinks
        ln -sf "$INSTALL_DIR/agents" "$CLAUDE_DIR/agents"
        ln -sf "$INSTALL_DIR/commands" "$CLAUDE_DIR/commands"

        echo "✓ Workflow enabled"
        echo "  Agents and commands are now active"
        ;;

    off|disable)
        if [ "$STATUS" = "disabled" ]; then
            echo "Already disabled"
            exit 0
        fi

        # Remove only workflow symlinks
        if [ -L "$CLAUDE_DIR/agents" ]; then
            TARGET=$(readlink "$CLAUDE_DIR/agents")
            if [[ "$TARGET" == *"workflow-agents"* ]]; then
                rm -f "$CLAUDE_DIR/agents"
            fi
        fi
        if [ -L "$CLAUDE_DIR/commands" ]; then
            TARGET=$(readlink "$CLAUDE_DIR/commands")
            if [[ "$TARGET" == *"workflow-agents"* ]]; then
                rm -f "$CLAUDE_DIR/commands"
            fi
        fi

        # Restore user's files if backed up
        [ -d "$CLAUDE_DIR/agents.user" ] && mv "$CLAUDE_DIR/agents.user" "$CLAUDE_DIR/agents"
        [ -d "$CLAUDE_DIR/commands.user" ] && mv "$CLAUDE_DIR/commands.user" "$CLAUDE_DIR/commands"

        echo "✓ Workflow disabled"
        echo "  Standard Claude Code mode"
        ;;

    *)
        echo "Usage: workflow-toggle [on|off|status]"
        exit 1
        ;;
esac
SCRIPT
chmod +x "$INSTALL_DIR/bin/workflow-toggle"

# ─────────────────────────────────────────────────────────────────
# Create: workflow-uninstall
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-uninstall" << 'SCRIPT'
#!/bin/bash

# Uninstall globally

INSTALL_DIR="$HOME/.claude-workflow-agents"
CLAUDE_DIR="$HOME/.claude"

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

# Remove symlinks from ~/.claude/ (only if they're workflow symlinks)
if [ -L "$CLAUDE_DIR/agents" ]; then
    TARGET=$(readlink "$CLAUDE_DIR/agents")
    if [[ "$TARGET" == *"workflow-agents"* ]]; then
        rm -f "$CLAUDE_DIR/agents"
        echo "✓ Removed agents symlink"
    fi
fi

if [ -L "$CLAUDE_DIR/commands" ]; then
    TARGET=$(readlink "$CLAUDE_DIR/commands")
    if [[ "$TARGET" == *"workflow-agents"* ]]; then
        rm -f "$CLAUDE_DIR/commands"
        echo "✓ Removed commands symlink"
    fi
fi

# Restore user's backed up files if they exist
if [ -d "$CLAUDE_DIR/agents.user" ]; then
    echo "✓ Restoring your agents from backup"
    mv "$CLAUDE_DIR/agents.user" "$CLAUDE_DIR/agents"
fi

if [ -d "$CLAUDE_DIR/commands.user" ]; then
    echo "✓ Restoring your commands from backup"
    mv "$CLAUDE_DIR/commands.user" "$CLAUDE_DIR/commands"
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
echo "  Symlinks: ~/.claude/agents/ -> $INSTALL_DIR/agents/"
echo "            ~/.claude/commands/ -> $INSTALL_DIR/commands/"
echo "  Version:  $VERSION"
echo ""
echo "  Commands (after restarting terminal):"
echo "    workflow-init       Initialize in a project"
echo "    workflow-remove     Remove from a project"
echo "    workflow-update     Update to latest version"
echo "    workflow-version    Show version info"
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
