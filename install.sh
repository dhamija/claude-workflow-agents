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
echo "Next steps:"
echo "  1. Restart Claude Code to load new commands"
echo "  2. Try: /analyze <your app idea>"
echo ""
echo "Documentation:"
echo "  - README.md   - Quick start"
echo "  - WORKFLOW.md - Workflow details"
echo "  - USAGE.md    - Usage examples"
