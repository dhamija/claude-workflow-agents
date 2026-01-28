#!/bin/bash

# Comprehensive documentation verification
# Ensures ALL .md files are in sync when agents/commands change

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     COMPREHENSIVE DOCUMENTATION VERIFICATION                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Count actual files
AGENT_COUNT=$(find "$REPO_ROOT/agents" -name "*.md" -type f | wc -l | tr -d ' ')
COMMAND_COUNT=$(find "$REPO_ROOT/commands" -name "*.md" -type f | wc -l | tr -d ' ')

echo "Found: $AGENT_COUNT agents, $COMMAND_COUNT commands"
echo ""

# ==============================================================================
# CHECK 1: Agent/Command counts consistent across all files
# ==============================================================================

echo -e "${BLUE}[1/6]${NC} Checking agent/command counts..."

# Check CLAUDE.md (v3.0 structure)
if ! grep -q "# $AGENT_COUNT agent files" "$REPO_ROOT/CLAUDE.md"; then
    echo -e "  ${RED}✗ CLAUDE.md has wrong agent count (expected $AGENT_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} CLAUDE.md agent count"
fi

if ! grep -q "# $COMMAND_COUNT command" "$REPO_ROOT/CLAUDE.md"; then
    echo -e "  ${RED}✗ CLAUDE.md has wrong command count (expected $COMMAND_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} CLAUDE.md command count"
fi

# Check STATE.md (v3.0 structure)
if ! grep -q "| Agent Files (for Task tool invocation) | $AGENT_COUNT |" "$REPO_ROOT/STATE.md"; then
    echo -e "  ${RED}✗ STATE.md has wrong agent count (expected $AGENT_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} STATE.md agent count"
fi

if ! grep -q "| Commands | $COMMAND_COUNT |" "$REPO_ROOT/STATE.md"; then
    echo -e "  ${RED}✗ STATE.md has wrong command count (expected $COMMAND_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} STATE.md command count"
fi

# Check README.md (v3.0: skills + subagents architecture, no unified "agent" count)
# Count subagents (4 in v3.0) and commands
SUBAGENT_COUNT=4
SKILL_COUNT=10
if ! grep -q "\*\*$SUBAGENT_COUNT subagents\*\*" "$REPO_ROOT/README.md"; then
    echo -e "  ${RED}✗ README.md has wrong subagent count (expected $SUBAGENT_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} README.md subagent count"
fi

if ! grep -q "\*\*$SKILL_COUNT skills\*\*" "$REPO_ROOT/README.md"; then
    echo -e "  ${RED}✗ README.md has wrong skill count (expected $SKILL_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} README.md skill count"
fi

if ! grep -q "\*\*$COMMAND_COUNT commands\*\*" "$REPO_ROOT/README.md"; then
    echo -e "  ${RED}✗ README.md has wrong command count (expected $COMMAND_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} README.md command count"
fi

# Check help.md (v3.0: no longer has "THE X AGENTS" header, check counts in architecture section)
if ! grep -q "Count: $SKILL_COUNT skills" "$REPO_ROOT/commands/help.md"; then
    echo -e "  ${RED}✗ help.md has wrong skill count (expected $SKILL_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} help.md skill count"
fi

if ! grep -q "Count: $SUBAGENT_COUNT subagents" "$REPO_ROOT/commands/help.md"; then
    echo -e "  ${RED}✗ help.md has wrong subagent count (expected $SUBAGENT_COUNT)${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} help.md subagent count"
fi

echo ""

# ==============================================================================
# CHECK 2: All agents in CLAUDE.md
# ==============================================================================

echo -e "${BLUE}[2/6]${NC} Checking all agents in CLAUDE.md..."
for agent in "$REPO_ROOT/agents"/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    if ! grep -qi "$name" "$REPO_ROOT/CLAUDE.md" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$name' not in CLAUDE.md${NC}"
        ((ERRORS++))
    fi
done
echo -e "  ${GREEN}✓${NC} All agents in CLAUDE.md"
echo ""

# ==============================================================================
# CHECK 3: All user-facing agents in help.md
# ==============================================================================

echo -e "${BLUE}[3/6]${NC} Checking all user-facing agents in help.md..."
# Exclude workflow-orchestrator (reference docs only in v3.0)
for agent in "$REPO_ROOT/agents"/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)

    # Skip workflow-orchestrator (contributor reference docs only)
    if [ "$name" = "workflow-orchestrator" ]; then
        continue
    fi

    # Convert to uppercase with hyphens for display name
    display_name=$(echo "$name" | tr '[:lower:]' '[:upper:]')
    if ! grep -qi "$display_name" "$REPO_ROOT/commands/help.md" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$name' not in help.md${NC}"
        ((ERRORS++))
    fi
done
echo -e "  ${GREEN}✓${NC} All user-facing agents in help.md"
echo ""

# ==============================================================================
# CHECK 4: All agents in tests
# ==============================================================================

echo -e "${BLUE}[4/6]${NC} Checking all agents in tests..."
AGENT_TEST="$REPO_ROOT/tests/structural/test_agents_exist.sh"
if [ -f "$AGENT_TEST" ]; then
    for agent in "$REPO_ROOT/agents"/*.md; do
        [ -f "$agent" ] || continue
        name=$(basename "$agent" .md)
        if ! grep -q "\"$name\"" "$AGENT_TEST"; then
            echo -e "  ${RED}✗ Agent '$name' not in test_agents_exist.sh${NC}"
            ((ERRORS++))
        fi
    done
fi
echo -e "  ${GREEN}✓${NC} All agents in tests"
echo ""

# ==============================================================================
# CHECK 5: All commands in tests
# ==============================================================================

echo -e "${BLUE}[5/6]${NC} Checking all commands in tests..."
CMD_TEST="$REPO_ROOT/tests/structural/test_commands_exist.sh"
if [ -f "$CMD_TEST" ]; then
    for cmd in "$REPO_ROOT/commands"/*.md; do
        [ -f "$cmd" ] || continue
        name=$(basename "$cmd" .md)
        if ! grep -q "\"$name\"" "$CMD_TEST"; then
            echo -e "  ${RED}✗ Command '$name' not in test_commands_exist.sh${NC}"
            ((ERRORS++))
        fi
    done
fi
echo -e "  ${GREEN}✓${NC} All commands in tests"
echo ""

# ==============================================================================
# CHECK 6: STATE.md agents list matches actual agents
# ==============================================================================

echo -e "${BLUE}[6/7]${NC} Checking STATE.md agents list..."
for agent in "$REPO_ROOT/agents"/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    if ! grep -q "| $name |" "$REPO_ROOT/STATE.md" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$name' not in STATE.md agents list${NC}"
        ((ERRORS++))
    fi
done
echo -e "  ${GREEN}✓${NC} All agents in STATE.md"
echo ""

# ==============================================================================
# CHECK 7: workflow-orchestrator.md knows about all agents
# ==============================================================================

echo -e "${BLUE}[7/7]${NC} Checking workflow-orchestrator knows all agents..."

ORCHESTRATOR="$REPO_ROOT/agents/workflow-orchestrator.md"
MISSING_IN_ORCHESTRATOR=()

# Agents that orchestrator should explicitly mention
COORDINATED_AGENTS=(
    "intent-guardian"
    "ux-architect"
    "agentic-architect"
    "implementation-planner"
    "change-analyzer"
    "gap-analyzer"
    "brownfield-analyzer"
    "backend-engineer"
    "frontend-engineer"
    "test-engineer"
    "code-reviewer"
    "debugger"
    "ui-debugger"
    "acceptance-validator"
    "project-ops"
)

for agent in "${COORDINATED_AGENTS[@]}"; do
    if ! grep -q "$agent" "$ORCHESTRATOR" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$agent' not mentioned in workflow-orchestrator.md${NC}"
        MISSING_IN_ORCHESTRATOR+=("$agent")
        ((ERRORS++))
    fi
done

if [ ${#MISSING_IN_ORCHESTRATOR[@]} -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} workflow-orchestrator knows all coordinated agents"
else
    echo -e "  ${YELLOW}⚠${NC} Missing agents in orchestrator: ${MISSING_IN_ORCHESTRATOR[*]}"
fi
echo ""

# ==============================================================================
# SUMMARY
# ==============================================================================

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ ALL DOCUMENTATION IN SYNC${NC}"
    echo -e "${GREEN}  • All agent/command counts consistent${NC}"
    echo -e "${GREEN}  • All files reference each other correctly${NC}"
    echo -e "${GREEN}  • Ready to commit${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ DOCUMENTATION OUT OF SYNC${NC}"
    echo -e "${RED}  • $ERRORS error(s) found${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}  • $WARNINGS warning(s)${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Fix these before committing:${NC}"
    echo "  1. Update counts in CLAUDE.md, STATE.md, README.md, help.md"
    echo "  2. Add missing agents/commands to documentation"
    echo "  3. Update tests"
    echo "  4. Run this script again to verify"
    echo ""
    echo -e "${RED}CI will fail if documentation is out of sync.${NC}"
    echo ""
    exit 1
fi
