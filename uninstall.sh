#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

UNINSTALL_USER=false
UNINSTALL_PROJECT=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --user|-u)
            UNINSTALL_USER=true
            shift
            ;;
        --project|-p)
            UNINSTALL_PROJECT=true
            shift
            ;;
        --help|-h)
            echo "Usage: ./uninstall.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --user, -u      Remove from ~/.claude/"
            echo "  --project, -p   Remove from ./.claude/"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

if [ "$UNINSTALL_USER" = false ] && [ "$UNINSTALL_PROJECT" = false ]; then
    echo "Specify --user and/or --project"
    exit 1
fi

uninstall_from() {
    local TARGET=$1
    local TARGET_NAME=$2

    echo -e "${YELLOW}Removing from ${TARGET_NAME}...${NC}"

    # Remove agents
    for agent in "$SCRIPT_DIR/agents/"*.md; do
        if [ -f "$agent" ]; then
            local BASENAME=$(basename "$agent")
            if [ -f "$TARGET/agents/$BASENAME" ]; then
                rm "$TARGET/agents/$BASENAME"
                echo "  ✓ Removed agents/$BASENAME"
            fi
        fi
    done

    # Remove commands
    for cmd in "$SCRIPT_DIR/commands/"*.md; do
        if [ -f "$cmd" ]; then
            local BASENAME=$(basename "$cmd")
            if [ -f "$TARGET/commands/$BASENAME" ]; then
                rm "$TARGET/commands/$BASENAME"
                echo "  ✓ Removed commands/$BASENAME"
            fi
        fi
    done

    echo -e "${GREEN}  Done${NC}"
}

if [ "$UNINSTALL_USER" = true ]; then
    uninstall_from "$HOME/.claude" "~/.claude"
fi

if [ "$UNINSTALL_PROJECT" = true ]; then
    uninstall_from "./.claude" "./.claude"
fi

echo ""
echo -e "${GREEN}✅ Uninstallation complete${NC}"
