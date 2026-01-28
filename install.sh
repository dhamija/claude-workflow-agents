#!/bin/bash

# Install claude-workflow-agents globally
# Usage: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

set -e

VERSION="3.1.0"
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

# Create directories
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/skills"

echo "Installing skills and subagents..."

# Copy skills directly (loaded on-demand by Claude)
cp -r "$INSTALL_DIR/templates/skills"/* "$CLAUDE_DIR/skills/"

# Symlink ONLY core subagents (isolated-context agents)
# Other expertise is now in skills (on-demand loading)
CORE_AGENTS=("code-reviewer" "debugger" "ui-debugger")
for agent_name in "${CORE_AGENTS[@]}"; do
    agent_file="$INSTALL_DIR/agents/${agent_name}.md"
    if [ -f "$agent_file" ]; then
        ln -sf "$agent_file" "$CLAUDE_DIR/agents/${agent_name}.md"
    fi
done

# Symlink each command file
for command_file in "$INSTALL_DIR/commands"/*.md; do
    if [ -f "$command_file" ]; then
        filename=$(basename "$command_file")
        ln -sf "$command_file" "$CLAUDE_DIR/commands/$filename"
    fi
done

echo "✓ Installed skills and subagents"

# Create bin directory
mkdir -p "$INSTALL_DIR/bin"

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

# Preserve generated bin scripts (workflow-update, workflow-version, etc.)
# Copy only the generated scripts, keep new scripts from repo (workflow-patch, workflow-fix-hooks)
mkdir -p "$TEMP_DIR/bin"
for script in workflow-update workflow-version workflow-toggle workflow-uninstall workflow-init; do
    if [ -f "$INSTALL_DIR/bin/$script" ]; then
        cp "$INSTALL_DIR/bin/$script" "$TEMP_DIR/bin/$script"
    fi
done

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
echo "  workflow-init                  Initialize workflow in a project"
echo "  workflow-toggle on/off/status  Enable, disable, or check status"
echo "  workflow-update                Update installation"
echo "  workflow-patch                 Update project CLAUDE.md (v2.0+)"
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
# Create: workflow-init
# ─────────────────────────────────────────────────────────────────
cat > "$INSTALL_DIR/bin/workflow-init" << 'SCRIPT'
#!/bin/bash

# Initialize workflow in a project
# Detects greenfield vs brownfield and creates appropriate CLAUDE.md

set -e

WORKFLOW_HOME="$HOME/.claude-workflow-agents"
TEMPLATES_DIR="$WORKFLOW_HOME/templates/project"
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PROJECT_NAME=$(basename "$(pwd)")

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║              CLAUDE WORKFLOW AGENTS - PROJECT INIT                        ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Check global install
if [ ! -d "$WORKFLOW_HOME/agents" ]; then
    echo "ERROR: Workflow agents not installed."
    echo ""
    echo "Install first with:"
    echo "  curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash"
    exit 1
fi

# Check if already initialized
if [ -f "CLAUDE.md" ] && grep -q "WORKFLOW BOOTSTRAP" "CLAUDE.md"; then
    echo "✓ Workflow already initialized in this project."
    echo ""

    # Show current state
    if grep -q "type: greenfield" "CLAUDE.md"; then
        echo "  Type: Greenfield"
    elif grep -q "type: brownfield" "CLAUDE.md"; then
        echo "  Type: Brownfield"
    fi

    if grep -q "phase: L1" "CLAUDE.md"; then
        echo "  Phase: L1 (Planning)"
    elif grep -q "phase: L2" "CLAUDE.md"; then
        echo "  Phase: L2 (Building)"
    elif grep -q "phase: analysis" "CLAUDE.md"; then
        echo "  Phase: Analysis"
    fi

    echo ""
    echo "  To reset: Remove CLAUDE.md and run workflow-init again"
    exit 0
fi

# Detect project type
echo "Analyzing project..."
echo ""

HAS_CODE=false
CODE_INDICATORS=0

# Check for source code
[ -d "src" ] && ((CODE_INDICATORS++))
[ -d "app" ] && ((CODE_INDICATORS++))
[ -d "lib" ] && ((CODE_INDICATORS++))
[ -d "pkg" ] && ((CODE_INDICATORS++))
[ -n "$(ls *.py 2>/dev/null | head -1)" ] && ((CODE_INDICATORS++))
[ -n "$(ls *.js 2>/dev/null | head -1)" ] && ((CODE_INDICATORS++))
[ -n "$(ls *.ts 2>/dev/null | head -1)" ] && ((CODE_INDICATORS++))
[ -n "$(ls *.go 2>/dev/null | head -1)" ] && ((CODE_INDICATORS++))
[ -n "$(ls *.rs 2>/dev/null | head -1)" ] && ((CODE_INDICATORS++))

# Check for package files (indicates real project, not just scripts)
[ -f "package.json" ] && ((CODE_INDICATORS++))
[ -f "requirements.txt" ] && ((CODE_INDICATORS++))
[ -f "pyproject.toml" ] && ((CODE_INDICATORS++))
[ -f "Cargo.toml" ] && ((CODE_INDICATORS++))
[ -f "go.mod" ] && ((CODE_INDICATORS++))

if [ $CODE_INDICATORS -ge 2 ]; then
    HAS_CODE=true
fi

# Check for existing CLAUDE.md (user content to preserve)
HAS_EXISTING_CLAUDE_MD=false
EXISTING_CONTENT=""
if [ -f "CLAUDE.md" ]; then
    HAS_EXISTING_CLAUDE_MD=true
    EXISTING_CONTENT=$(cat "CLAUDE.md")
fi

echo "  Project name:     $PROJECT_NAME"
echo "  Has code:         $HAS_CODE"
echo "  Has CLAUDE.md:    $HAS_EXISTING_CLAUDE_MD"
echo ""

# Determine project type
if [ "$HAS_CODE" = true ]; then
    PROJECT_TYPE="brownfield"
    echo "📦 BROWNFIELD PROJECT"
    echo ""
    echo "   Existing code detected."
    echo "   Claude will analyze the codebase first to understand what's built."
else
    PROJECT_TYPE="greenfield"
    echo "🌱 GREENFIELD PROJECT"
    echo ""
    echo "   New project."
    echo "   Claude will start L1 planning from scratch."
fi

echo ""
read -p "Continue with $PROJECT_TYPE setup? [Y/n] " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Create CLAUDE.md from template
echo ""
echo "Creating CLAUDE.md..."

if [ "$PROJECT_TYPE" = "greenfield" ]; then
    TEMPLATE="$TEMPLATES_DIR/CLAUDE.md.minimal.template"
else
    TEMPLATE="$TEMPLATES_DIR/CLAUDE.md.minimal-brownfield.template"
fi

if [ -f "$TEMPLATE" ]; then
    # Use template
    sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{DATE}}|$DATE|g" \
        -e "s|{{WORKFLOW_HOME}}|$WORKFLOW_HOME|g" \
        -e "s|{{PROJECT_DESCRIPTION}}|Describe your project here|g" \
        "$TEMPLATE" > "CLAUDE.md"
else
    echo "Warning: Template not found at $TEMPLATE"
    echo "Creating basic CLAUDE.md..."

    # Fallback - create inline
    cat > "CLAUDE.md" << EOF
<!--
═══════════════════════════════════════════════════════════════════════════════
WORKFLOW BOOTSTRAP - CLAUDE MUST READ THIS FIRST
═══════════════════════════════════════════════════════════════════════════════

Project Type: ${PROJECT_TYPE^^}
Initialized: $DATE

INSTRUCTIONS FOR CLAUDE:

1. READ the orchestrator agent FIRST:
   $WORKFLOW_HOME/agents/workflow-orchestrator.md

2. CHECK the "Workflow State" section at the bottom of this file

3. FOLLOW the orchestrator's protocol for ${PROJECT_TYPE} projects

4. AUTO-CHAIN agents - Do NOT ask user to manually invoke agents

5. UPDATE the state section after each significant action

═══════════════════════════════════════════════════════════════════════════════
-->

# $PROJECT_NAME

## 🔄 WORKFLOW ACTIVE

This project uses Claude Workflow Agents.

**Claude: Read the bootstrap comment above before responding.**

---

## Project Context

> Describe your project here

### Notes

- [Add your notes]

---

## Workflow State

\`\`\`yaml
workflow:
  version: 1.0
  type: $PROJECT_TYPE
  phase: $([ "$PROJECT_TYPE" = "brownfield" ] && echo "analysis" || echo "L1")
  status: not_started
  mode: auto
  initialized: $DATE

$([ "$PROJECT_TYPE" = "brownfield" ] && cat << BROWNFIELD
analysis:
  status: pending

BROWNFIELD
)
l1:
  intent:
    status: pending
  ux:
    status: pending
  architecture:
    status: pending
  planning:
    status: pending

l2:
  current_feature: null
  current_step: null
  features: {}

session:
  last_updated: $DATE
  last_action: "Project initialized"
  next_action: "$([ "$PROJECT_TYPE" = "brownfield" ] && echo "Run brownfield-analyzer to scan existing code" || echo "User describes project → Begin L1 with intent-guardian")"
  session_count: 0
\`\`\`
EOF
fi

# If there was existing content, append it
if [ "$HAS_EXISTING_CLAUDE_MD" = true ]; then
    echo ""
    echo "Preserving your existing CLAUDE.md content..."

    echo "" >> "CLAUDE.md"
    echo "---" >> "CLAUDE.md"
    echo "" >> "CLAUDE.md"
    echo "## Previous Content (Preserved)" >> "CLAUDE.md"
    echo "" >> "CLAUDE.md"
    echo "$EXISTING_CONTENT" >> "CLAUDE.md"
fi

# Optional: Setup hooks for quality gates
echo ""
read -p "Enable automatic quality gate reminders via hooks? [Y/n] " setup_hooks
if [[ ! "$setup_hooks" =~ ^[Nn]$ ]]; then
    HOOKS_TEMPLATE="$WORKFLOW_HOME/templates/hooks/settings.json.template"
    HOOKS_DIR=".claude"

    if [ -f "$HOOKS_TEMPLATE" ]; then
        mkdir -p "$HOOKS_DIR"
        cp "$HOOKS_TEMPLATE" "$HOOKS_DIR/settings.json"
        echo "  ✓ Hooks configured (.claude/settings.json)"
        echo "    - Reminds to run code-reviewer after code changes"
        echo "    - Completion checklist before marking tasks done"
    fi
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                         INITIALIZATION COMPLETE                           ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "  ✓ CLAUDE.md created (~80 lines, context-efficient)"
echo "  ✓ Workflow state initialized"
echo "  ✓ Type: $PROJECT_TYPE"
echo ""
echo "  Skills location: ~/.claude/skills/"
echo "  Subagents: code-reviewer, debugger, ui-debugger"
echo ""

if [ "$PROJECT_TYPE" = "brownfield" ]; then
    echo "  NEXT STEPS:"
    echo "  1. Open Claude in this project"
    echo "  2. Claude will automatically analyze your codebase"
    echo "  3. Confirm the analysis"
    echo "  4. Continue development from inferred state"
else
    echo "  NEXT STEPS:"
    echo "  1. Open Claude in this project"
    echo "  2. Describe what you want to build"
    echo "  3. Claude will run L1 planning automatically"
fi

echo ""
SCRIPT

chmod +x "$INSTALL_DIR/bin/workflow-init"

# Copy additional bin scripts from repository (workflow-patch, workflow-fix-hooks, etc.)
if [ -d "$TEMP_DIR/bin" ]; then
    for script in "$TEMP_DIR/bin"/*; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            # Only copy scripts that weren't generated inline above
            if [[ ! "$script_name" =~ ^(workflow-update|workflow-version|workflow-toggle|workflow-uninstall|workflow-init)$ ]]; then
                cp "$script" "$INSTALL_DIR/bin/$script_name"
                chmod +x "$INSTALL_DIR/bin/$script_name"
            fi
        fi
    done
fi

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
echo "    workflow-init                  Initialize workflow in a project"
echo "    workflow-toggle on/off/status  Enable, disable, or check status"
echo "    workflow-update                Update to latest version"
echo "    workflow-patch                 Update project CLAUDE.md (v2.0+)"
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
