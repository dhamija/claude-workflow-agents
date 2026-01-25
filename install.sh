#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default options
INSTALL_USER=false
INSTALL_PROJECT=false
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --user|-u)
            INSTALL_USER=true
            shift
            ;;
        --project|-p)
            INSTALL_PROJECT=true
            shift
            ;;
        --force|-f)
            FORCE=true
            shift
            ;;
        --help|-h)
            echo "Usage: ./install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --user, -u      Install to ~/.claude/ (available globally)"
            echo "  --project, -p   Install to ./.claude/ (current project only)"
            echo "  --force, -f     Overwrite existing files"
            echo "  --help, -h      Show this help"
            echo ""
            echo "When installing to --project, also creates CLAUDE.md orchestrator config"
            echo ""
            echo "Examples:"
            echo "  ./install.sh --user           # Global installation"
            echo "  ./install.sh --project        # Project installation"
            echo "  ./install.sh --user --project # Both"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Default to user install if nothing specified
if [ "$INSTALL_USER" = false ] && [ "$INSTALL_PROJECT" = false ]; then
    echo -e "${YELLOW}No installation target specified. Use --user or --project${NC}"
    echo ""
    echo "  --user      Install to ~/.claude/ (available in all projects)"
    echo "  --project   Install to ./.claude/ (current project only)"
    echo ""
    read -p "Install globally for all projects? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_USER=true
    else
        INSTALL_PROJECT=true
    fi
fi

# Function to install to a target
install_to() {
    local TARGET=$1
    local TARGET_NAME=$2

    echo -e "${GREEN}Installing to ${TARGET_NAME}...${NC}"

    # Create directories
    mkdir -p "$TARGET/agents"
    mkdir -p "$TARGET/commands"

    # Copy agents
    local AGENT_COUNT=0
    for agent in "$SCRIPT_DIR/agents/"*.md; do
        if [ -f "$agent" ]; then
            local BASENAME=$(basename "$agent")
            if [ -f "$TARGET/agents/$BASENAME" ] && [ "$FORCE" = false ]; then
                echo -e "${YELLOW}  Skipping agents/$BASENAME (exists, use --force to overwrite)${NC}"
            else
                cp "$agent" "$TARGET/agents/"
                echo "  ✓ agents/$BASENAME"
                ((AGENT_COUNT++))
            fi
        fi
    done

    # Copy commands
    local COMMAND_COUNT=0
    for cmd in "$SCRIPT_DIR/commands/"*.md; do
        if [ -f "$cmd" ]; then
            local BASENAME=$(basename "$cmd")
            if [ -f "$TARGET/commands/$BASENAME" ] && [ "$FORCE" = false ]; then
                echo -e "${YELLOW}  Skipping commands/$BASENAME (exists, use --force to overwrite)${NC}"
            else
                cp "$cmd" "$TARGET/commands/"
                echo "  ✓ commands/$BASENAME"
                ((COMMAND_COUNT++))
            fi
        fi
    done

    echo -e "${GREEN}  Installed $AGENT_COUNT agents, $COMMAND_COUNT commands to $TARGET_NAME${NC}"

    # If installing to project, also install CLAUDE.md template
    if [[ "$TARGET" == "./.claude" ]]; then
        install_claude_md
    fi
}

# Function to install CLAUDE.md orchestrator
install_claude_md() {
    local CLAUDE_MD="./CLAUDE.md"

    if [ -f "$CLAUDE_MD" ] && [ "$FORCE" = false ]; then
        echo -e "${YELLOW}  CLAUDE.md already exists (use --force to overwrite)${NC}"
        echo -e "${YELLOW}  To use conversation-driven mode, ensure CLAUDE.md includes AI Workflow Instructions${NC}"
    else
        echo -e "${GREEN}Creating CLAUDE.md orchestrator...${NC}"

        # Try to detect project name and type
        local PROJECT_NAME=$(basename "$PWD")
        local ONE_LINE_DESC="[Describe your project in one line]"
        local TECH_STACK="[Your tech stack - e.g., TypeScript, React, Node.js, PostgreSQL]"
        local CONVENTIONS="[Your code conventions - e.g., Use functional components, Prisma for DB, Zod for validation]"

        # Try to detect tech stack from package.json
        if [ -f "package.json" ]; then
            if grep -q '"react"' package.json; then
                TECH_STACK="TypeScript, React"
            fi
            if grep -q '"express"' package.json; then
                TECH_STACK="$TECH_STACK, Express"
            fi
            if grep -q '"fastapi"' package.json || [ -f "requirements.txt" ]; then
                TECH_STACK="Python, FastAPI"
            fi
        fi

        # Copy template and replace placeholders
        sed -e "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" \
            -e "s/\[ONE_LINE_DESCRIPTION\]/$ONE_LINE_DESC/g" \
            -e "s/\[TECH_STACK_PLACEHOLDER[^]]*\]/$TECH_STACK/g" \
            -e "s/\[CONVENTIONS_PLACEHOLDER[^]]*\]/$CONVENTIONS/g" \
            -e "s/\[CUSTOMIZATIONS_PLACEHOLDER[^]]*\]/[Specify any agent customizations]/g" \
            "$SCRIPT_DIR/templates/CLAUDE.md.template" > "$CLAUDE_MD"

        echo -e "${GREEN}  ✓ Created CLAUDE.md${NC}"
        echo -e "${YELLOW}  📝 Edit CLAUDE.md to customize for your project${NC}"
    fi
}

# Install to user directory
if [ "$INSTALL_USER" = true ]; then
    install_to "$HOME/.claude" "~/.claude (global)"
fi

# Install to project directory
if [ "$INSTALL_PROJECT" = true ]; then
    install_to "./.claude" "./.claude (project)"
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""

if [ "$INSTALL_PROJECT" = true ]; then
    echo "Conversation-driven mode is ready!"
    echo ""
    echo "You can now just talk to Claude naturally:"
    echo "  'I want to build a task manager with AI suggestions'"
    echo "  'Help me improve this codebase'"
    echo "  'The login endpoint is broken'"
    echo ""
    echo "Claude will automatically select and run the right agents."
    echo ""
    echo "Optional: Edit CLAUDE.md to customize for your project"
    echo ""
    echo "Power users can still use slash commands:"
    echo "  /analyze, /plan, /implement, /debug, /review, etc."
else
    echo "Next steps:"
    echo "  1. Restart Claude Code to load new agents"
    echo "  2. Install to a project: cd your-project && ./install.sh --project"
    echo "  3. Start a conversation: 'I want to build...'"
fi

echo ""
echo "Documentation:"
echo "  - README.md   - Quick start"
echo "  - WORKFLOW.md - Workflow details"
echo "  - USAGE.md    - Usage examples"
