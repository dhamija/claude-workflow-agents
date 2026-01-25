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

    # Copy templates (used by agents like ci-cd-engineer)
    if [ -d "$SCRIPT_DIR/templates" ]; then
        mkdir -p "$TARGET/templates"

        # Copy CI/CD templates
        if [ -d "$SCRIPT_DIR/templates/ci" ]; then
            mkdir -p "$TARGET/templates/ci/validators"
            for template in "$SCRIPT_DIR/templates/ci/"*.template; do
                if [ -f "$template" ]; then
                    cp "$template" "$TARGET/templates/ci/"
                fi
            done
            for template in "$SCRIPT_DIR/templates/ci/validators/"*.template; do
                if [ -f "$template" ]; then
                    cp "$template" "$TARGET/templates/ci/validators/"
                fi
            done
        fi

        # Copy docs templates
        if [ -d "$SCRIPT_DIR/templates/docs" ]; then
            mkdir -p "$TARGET/templates/docs/plans/overview"
            mkdir -p "$TARGET/templates/docs/plans/features"
            mkdir -p "$TARGET/templates/docs/changes"
            # Note: Most docs templates are created by agents, not copied
        fi

        # Copy CLAUDE.md template
        if [ -f "$SCRIPT_DIR/templates/CLAUDE.md.template" ]; then
            cp "$SCRIPT_DIR/templates/CLAUDE.md.template" "$TARGET/templates/"
        fi
    fi

    echo -e "${GREEN}  Installed $AGENT_COUNT agents, $COMMAND_COUNT commands, and templates to $TARGET_NAME${NC}"

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
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$INSTALL_PROJECT" = true ]; then
    echo -e "${GREEN}🎯 Quick Start${NC}"
    echo ""
    echo "Just talk naturally to Claude:"
    echo "  ${YELLOW}\"Build me a recipe app\"${NC}"
    echo "  ${YELLOW}\"Analyze this codebase\"${NC}"
    echo "  ${YELLOW}\"Add user authentication\"${NC}"
    echo "  ${YELLOW}\"The dashboard is slow\"${NC}"
    echo ""
    echo "Claude will automatically:"
    echo "  • Understand what you want"
    echo "  • Select the right agents"
    echo "  • Create plans and build features"
    echo "  • Write tests and verify everything works"
    echo ""
    echo -e "${GREEN}📚 Learning Resources${NC}"
    echo ""
    echo "Start here:"
    echo "  • README.md - Progressive guide (5 min read)"
    echo "  • GUIDE.md - Quick reference card (2 min)"
    echo ""
    echo "Go deeper:"
    echo "  • WORKFLOW.md - How it works internally (15 min)"
    echo "  • EXAMPLES.md - 7 real-world scenarios (10 min)"
    echo ""
    echo "In-app help:"
    echo "  • /agent-wf-help - Quick overview"
    echo "  • /agent-wf-help examples - Practical examples"
    echo "  • /agent-wf-help patterns - Common patterns"
    echo ""
    echo -e "${GREEN}⚙️  Customization${NC}"
    echo ""
    echo "Edit CLAUDE.md to customize:"
    echo "  • Tech stack preferences"
    echo "  • Code conventions"
    echo "  • Agent behavior"
    echo ""
    echo -e "${GREEN}🚀 Ready to Go!${NC}"
    echo ""
    echo "Try it now:"
    echo "  ${YELLOW}\"Build me a [describe your app]\"${NC}"
    echo ""
else
    echo -e "${GREEN}🎯 Next Steps${NC}"
    echo ""
    echo "1. Install to a project:"
    echo "   ${YELLOW}cd your-project${NC}"
    echo "   ${YELLOW}$(realpath "$SCRIPT_DIR")/install.sh --project${NC}"
    echo ""
    echo "2. Start Claude in your project"
    echo ""
    echo "3. Just talk:"
    echo "   ${YELLOW}\"Build me a task manager\"${NC}"
    echo ""
    echo -e "${GREEN}📚 Documentation${NC}"
    echo ""
    echo "  • README.md - Start here (5 min)"
    echo "  • GUIDE.md - Quick reference (2 min)"
    echo "  • EXAMPLES.md - Real-world scenarios (10 min)"
    echo "  • WORKFLOW.md - Deep dive (15 min)"
    echo ""
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
