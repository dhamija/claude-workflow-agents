#!/bin/bash

# Verification script for claude-workflow-agents installation
# Checks system state vs expected state and detects issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="$HOME/.claude-workflow-agents"
CLAUDE_DIR="$HOME/.claude"

ISSUES_FOUND=0
WARNINGS_FOUND=0

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     WORKFLOW INSTALLATION VERIFICATION                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}✗ Installation not found${NC}"
    echo "  Expected: $INSTALL_DIR"
    echo "  Run: curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash"
    exit 1
fi

VERSION=$(cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown")
echo -e "${GREEN}✓ Installation found${NC}"
echo "  Version: $VERSION"
echo "  Location: $INSTALL_DIR"
echo ""

# Expected state for v3.1+
EXPECTED_SUBAGENTS=("code-reviewer" "debugger" "ui-debugger")
EXPECTED_SKILLS=("backend" "brownfield" "code-quality" "debugging" "frontend" "llm-user-testing" "testing" "ux-design" "validation" "workflow")
OLD_AGENTS=("acceptance-validator" "agentic-architect" "backend-engineer" "brownfield-analyzer" "change-analyzer" "frontend-engineer" "gap-analyzer" "implementation-planner" "intent-guardian" "project-ops" "test-engineer" "ux-architect" "workflow-orchestrator")

echo -e "${BLUE}Checking subagents (should be 3 symlinks)...${NC}"
echo ""

SUBAGENT_COUNT=0
for agent in "${EXPECTED_SUBAGENTS[@]}"; do
    agent_path="$CLAUDE_DIR/agents/${agent}.md"
    if [ -L "$agent_path" ]; then
        target=$(readlink "$agent_path")
        if [[ "$target" == *"workflow-agents"* ]]; then
            echo -e "  ${GREEN}✓${NC} $agent → symlink OK"
            ((SUBAGENT_COUNT++))
        else
            echo -e "  ${YELLOW}⚠${NC} $agent → symlink points to wrong location: $target"
            ((WARNINGS_FOUND++))
        fi
    elif [ -f "$agent_path" ]; then
        echo -e "  ${RED}✗${NC} $agent → regular file (should be symlink)"
        ((ISSUES_FOUND++))
    else
        echo -e "  ${RED}✗${NC} $agent → MISSING"
        ((ISSUES_FOUND++))
    fi
done

echo ""
if [ $SUBAGENT_COUNT -eq 3 ]; then
    echo -e "${GREEN}✓ All 3 subagents present and correctly symlinked${NC}"
else
    echo -e "${RED}✗ Expected 3 subagents, found $SUBAGENT_COUNT${NC}"
fi
echo ""

echo -e "${BLUE}Checking for zombie agents (should not exist)...${NC}"
echo ""

ZOMBIE_COUNT=0
for agent in "${OLD_AGENTS[@]}"; do
    agent_path="$CLAUDE_DIR/agents/${agent}.md"
    if [ -f "$agent_path" ] || [ -L "$agent_path" ]; then
        echo -e "  ${RED}✗${NC} $agent → ZOMBIE FILE (should not exist in v3.1+)"
        ((ZOMBIE_COUNT++))
        ((ISSUES_FOUND++))
    fi
done

if [ $ZOMBIE_COUNT -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No zombie agents found"
else
    echo -e "  ${RED}✗${NC} Found $ZOMBIE_COUNT zombie agents"
    echo ""
    echo -e "${YELLOW}  These are old agent files from v2.0 that should have been cleaned up.${NC}"
    echo -e "${YELLOW}  Run: workflow-toggle off && workflow-toggle on${NC}"
fi
echo ""

echo -e "${BLUE}Checking skills (should be 10 directories)...${NC}"
echo ""

SKILL_COUNT=0
for skill in "${EXPECTED_SKILLS[@]}"; do
    skill_path="$CLAUDE_DIR/skills/$skill"
    if [ -d "$skill_path" ]; then
        echo -e "  ${GREEN}✓${NC} $skill"
        ((SKILL_COUNT++))
    else
        echo -e "  ${RED}✗${NC} $skill → MISSING"
        ((ISSUES_FOUND++))
    fi
done

echo ""
if [ $SKILL_COUNT -eq 10 ]; then
    echo -e "${GREEN}✓ All 10 skills present${NC}"
else
    echo -e "${RED}✗ Expected 10 skills, found $SKILL_COUNT${NC}"
fi
echo ""

echo -e "${BLUE}Checking commands...${NC}"
echo ""

COMMAND_COUNT=0
if [ -d "$CLAUDE_DIR/commands" ]; then
    for cmd_file in "$CLAUDE_DIR/commands"/*.md; do
        if [ -L "$cmd_file" ]; then
            target=$(readlink "$cmd_file")
            if [[ "$target" == *"workflow-agents"* ]]; then
                ((COMMAND_COUNT++))
            fi
        fi
    done
fi

echo -e "  ${GREEN}✓${NC} Found $COMMAND_COUNT workflow commands"
echo ""

echo -e "${BLUE}Checking bin scripts...${NC}"
echo ""

BIN_SCRIPTS=("workflow-init" "workflow-update" "workflow-version" "workflow-toggle" "workflow-uninstall" "workflow-patch" "workflow-fix-hooks")
BIN_COUNT=0
for script in "${BIN_SCRIPTS[@]}"; do
    script_path="$INSTALL_DIR/bin/$script"
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        echo -e "  ${GREEN}✓${NC} $script"
        ((BIN_COUNT++))
    else
        echo -e "  ${RED}✗${NC} $script → MISSING or not executable"
        ((ISSUES_FOUND++))
    fi
done

echo ""
if [ $BIN_COUNT -eq ${#BIN_SCRIPTS[@]} ]; then
    echo -e "${GREEN}✓ All ${#BIN_SCRIPTS[@]} bin scripts present and executable${NC}"
else
    echo -e "${RED}✗ Expected ${#BIN_SCRIPTS[@]} scripts, found $BIN_COUNT${NC}"
fi
echo ""

# Check if bin directory is in PATH
echo -e "${BLUE}Checking PATH...${NC}"
echo ""

if echo "$PATH" | grep -q "$INSTALL_DIR/bin"; then
    echo -e "  ${GREEN}✓${NC} $INSTALL_DIR/bin is in PATH"
else
    echo -e "  ${YELLOW}⚠${NC} $INSTALL_DIR/bin is NOT in PATH"
    echo "    Add to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"\$HOME/.claude-workflow-agents/bin:\$PATH\""
    ((WARNINGS_FOUND++))
fi
echo ""

# Summary
echo "════════════════════════════════════════════════════════════════"
echo ""

if [ $ISSUES_FOUND -eq 0 ] && [ $WARNINGS_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓ VERIFICATION PASSED${NC}"
    echo ""
    echo "  Your installation is correctly configured."
    exit 0
elif [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${YELLOW}⚠ VERIFICATION PASSED WITH WARNINGS${NC}"
    echo ""
    echo "  Issues: $ISSUES_FOUND"
    echo "  Warnings: $WARNINGS_FOUND"
    echo ""
    echo "  Your installation works but has minor issues."
    exit 0
else
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo ""
    echo "  Issues: $ISSUES_FOUND"
    echo "  Warnings: $WARNINGS_FOUND"
    echo ""
    echo "  RECOMMENDED ACTIONS:"
    echo ""

    if [ $ZOMBIE_COUNT -gt 0 ]; then
        echo "  1. Clean up zombie agents:"
        echo "     workflow-toggle off && workflow-toggle on"
        echo ""
    fi

    if [ $SUBAGENT_COUNT -lt 4 ] || [ $SKILL_COUNT -lt 10 ]; then
        echo "  2. Reinstall to get missing files:"
        echo "     workflow-update"
        echo ""
    fi

    if [ $BIN_COUNT -lt ${#BIN_SCRIPTS[@]} ]; then
        echo "  3. Missing bin scripts - reinstall:"
        echo "     curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash"
        echo ""
    fi

    exit 1
fi
