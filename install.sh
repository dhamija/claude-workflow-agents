#!/bin/bash

# Install claude-workflow-agents globally
# Usage: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

set -e

VERSION="1.3.0"
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

# Create individual symlinks for each workflow agent and command
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"

echo "Creating symlinks for workflow agents and commands..."

# Symlink each agent file
for agent_file in "$INSTALL_DIR/agents"/*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        ln -sf "$agent_file" "$CLAUDE_DIR/agents/$filename"
    fi
done

# Symlink each command file
for command_file in "$INSTALL_DIR/commands"/*.md; do
    if [ -f "$command_file" ]; then
        filename=$(basename "$command_file")
        ln -sf "$command_file" "$CLAUDE_DIR/commands/$filename"
    fi
done

echo "✓ Created symlinks for workflow agents and commands"

# Create bin directory
mkdir -p "$INSTALL_DIR/bin"

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

INSTALL_DIR="$HOME/.claude-workflow-agents"

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
echo "  workflow-toggle on/off/status  Enable, disable, or check status"
echo "  workflow-update                Update installation"
echo "  workflow-version               Show version"
echo "  workflow-uninstall             Remove installation"
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

# Count workflow symlinks to determine status
count_workflow_symlinks() {
    local count=0
    if [ -d "$CLAUDE_DIR/agents" ]; then
        for file in "$CLAUDE_DIR/agents"/*; do
            if [ -L "$file" ]; then
                local target=$(readlink "$file")
                if [[ "$target" == *"workflow-agents"* ]]; then
                    ((count++))
                fi
            fi
        done
    fi
    echo $count
}

WORKFLOW_COUNT=$(count_workflow_symlinks)
if [ "$WORKFLOW_COUNT" -gt 0 ]; then
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
            agent_count=$(find "$CLAUDE_DIR/agents" -type l 2>/dev/null | wc -l | tr -d ' ')
            command_count=$(find "$CLAUDE_DIR/commands" -type l 2>/dev/null | wc -l | tr -d ' ')
            echo "  Workflow agents:   $agent_count symlinked"
            echo "  Workflow commands: $command_count symlinked"
            echo ""
            echo "Your own files coexist in the same directories."
            echo "To disable: workflow-toggle off"
        else
            echo "  No workflow symlinks found"
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

        # Create directories if they don't exist
        mkdir -p "$CLAUDE_DIR/agents"
        mkdir -p "$CLAUDE_DIR/commands"

        # Create symlinks for each workflow agent
        for agent_file in "$INSTALL_DIR/agents"/*.md; do
            if [ -f "$agent_file" ]; then
                filename=$(basename "$agent_file")
                ln -sf "$agent_file" "$CLAUDE_DIR/agents/$filename"
            fi
        done

        # Create symlinks for each workflow command
        for command_file in "$INSTALL_DIR/commands"/*.md; do
            if [ -f "$command_file" ]; then
                filename=$(basename "$command_file")
                ln -sf "$command_file" "$CLAUDE_DIR/commands/$filename"
            fi
        done

        echo "✓ Workflow enabled"
        echo "  Created individual symlinks for each agent and command"
        echo "  Your own files in ~/.claude/ remain untouched"
        ;;

    off|disable)
        if [ "$STATUS" = "disabled" ]; then
            echo "Already disabled"
            exit 0
        fi

        removed=0

        # Remove workflow agent symlinks
        if [ -d "$CLAUDE_DIR/agents" ]; then
            for file in "$CLAUDE_DIR/agents"/*; do
                if [ -L "$file" ]; then
                    target=$(readlink "$file")
                    if [[ "$target" == *"workflow-agents"* ]]; then
                        rm -f "$file"
                        ((removed++))
                    fi
                fi
            done
        fi

        # Remove workflow command symlinks
        if [ -d "$CLAUDE_DIR/commands" ]; then
            for file in "$CLAUDE_DIR/commands"/*; do
                if [ -L "$file" ]; then
                    target=$(readlink "$file")
                    if [[ "$target" == *"workflow-agents"* ]]; then
                        rm -f "$file"
                        ((removed++))
                    fi
                fi
            done
        fi

        echo "✓ Workflow disabled"
        echo "  Removed $removed workflow symlinks"
        echo "  Your own agents and commands remain in ~/.claude/"
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

# Remove workflow symlinks from ~/.claude/ (individual files only)
removed=0

if [ -d "$CLAUDE_DIR/agents" ]; then
    for file in "$CLAUDE_DIR/agents"/*; do
        if [ -L "$file" ]; then
            TARGET=$(readlink "$file")
            if [[ "$TARGET" == *"workflow-agents"* ]]; then
                rm -f "$file"
                ((removed++))
            fi
        fi
    done
fi

if [ -d "$CLAUDE_DIR/commands" ]; then
    for file in "$CLAUDE_DIR/commands"/*; do
        if [ -L "$file" ]; then
            TARGET=$(readlink "$file")
            if [[ "$TARGET" == *"workflow-agents"* ]]; then
                rm -f "$file"
                ((removed++))
            fi
        fi
    done
fi

if [ $removed -gt 0 ]; then
    echo "✓ Removed $removed workflow symlinks"
fi
echo "✓ Your own agents and commands in ~/.claude/ remain untouched"

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
echo "  Symlinks: Individual files in ~/.claude/agents/ and ~/.claude/commands/"
echo "  Version:  $VERSION"
echo ""
echo "  Workflow is now globally enabled for all Claude Code sessions."
echo ""
echo "  Commands (after restarting terminal):"
echo "    workflow-toggle on/off/status  Enable, disable, or check status"
echo "    workflow-update                Update to latest version"
echo "    workflow-version               Show version info"
echo "    workflow-uninstall             Remove global installation"
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
echo "  To disable workflow:"
echo "    workflow-toggle off"
echo ""
