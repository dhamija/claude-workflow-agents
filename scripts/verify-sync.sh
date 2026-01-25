#!/bin/bash

# Comprehensive sync verification for claude-workflow-agents
# Checks that all documentation is in sync with source files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Quiet mode flag
QUIET=false
[ "$1" = "--quiet" ] && QUIET=true

ERRORS=0
WARNINGS=0

# Logging functions
log() {
    [ "$QUIET" = false ] && echo -e "$1"
}

log_always() {
    echo -e "$1"
}

log ""
log "╔══════════════════════════════════════════════════════════════════╗"
log "║           DOCUMENTATION SYNC VERIFICATION                        ║"
log "╚══════════════════════════════════════════════════════════════════╝"
log ""

# ============================================================
# Count actual files
# ============================================================

ACTUAL_AGENTS=$(ls -1 "$REPO_ROOT/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
ACTUAL_COMMANDS=$(ls -1 "$REPO_ROOT/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

log "Found: $ACTUAL_AGENTS agents, $ACTUAL_COMMANDS commands"
log ""

# ============================================================
# Check 1: CLAUDE.md exists and has current counts
# ============================================================

log "${BLUE}[1/7] Checking CLAUDE.md...${NC}"

CLAUDE_MD="$REPO_ROOT/CLAUDE.md"

if [ ! -f "$CLAUDE_MD" ]; then
    log_always "${RED}  ✗ CLAUDE.md not found${NC}"
    ((ERRORS++))
else
    log "${GREEN}  ✓ CLAUDE.md exists${NC}"

    # Check if counts match reality
    if grep -q "Agents: $ACTUAL_AGENTS total" "$CLAUDE_MD"; then
        log "${GREEN}  ✓ Agent count is current ($ACTUAL_AGENTS)${NC}"
    else
        log_always "${YELLOW}  ⚠ Agent count may be outdated (expected $ACTUAL_AGENTS)${NC}"
        ((WARNINGS++))
    fi

    if grep -q "Commands: $ACTUAL_COMMANDS total" "$CLAUDE_MD"; then
        log "${GREEN}  ✓ Command count is current ($ACTUAL_COMMANDS)${NC}"
    else
        log_always "${YELLOW}  ⚠ Command count may be outdated (expected $ACTUAL_COMMANDS)${NC}"
        ((WARNINGS++))
    fi

    # Check all agents mentioned
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        if grep -q "$agent_name" "$CLAUDE_MD"; then
            log "${GREEN}  ✓ Agent '$agent_name' in CLAUDE.md${NC}"
        else
            log_always "${RED}  ✗ Agent '$agent_name' NOT in CLAUDE.md${NC}"
            ((ERRORS++))
        fi
    done
fi

# ============================================================
# Check 2: Help command covers all agents
# ============================================================

log ""
log "${BLUE}[2/7] Checking help command...${NC}"

HELP_FILE="$REPO_ROOT/commands/agent-wf-help.md"

if [ ! -f "$HELP_FILE" ]; then
    log_always "${RED}  ✗ agent-wf-help.md not found${NC}"
    ((ERRORS++))
else
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        # Convert hyphens to spaces for matching
        agent_display=$(echo "$agent_name" | sed 's/-/ /g')
        if grep -qiE "$agent_name|$agent_display" "$HELP_FILE"; then
            log "${GREEN}  ✓ Agent '$agent_name' in help${NC}"
        else
            log_always "${RED}  ✗ Agent '$agent_name' NOT in help${NC}"
            ((ERRORS++))
        fi
    done

    for cmd_file in "$REPO_ROOT/commands"/*.md; do
        cmd_name=$(basename "$cmd_file" .md)
        [ "$cmd_name" = "agent-wf-help" ] && continue
        if grep -qiE "/$cmd_name|$cmd_name" "$HELP_FILE"; then
            log "${GREEN}  ✓ Command '/$cmd_name' in help${NC}"
        else
            log_always "${YELLOW}  ⚠ Command '/$cmd_name' NOT in help${NC}"
            ((WARNINGS++))
        fi
    done
fi

# ============================================================
# Check 3: README has all components
# ============================================================

log ""
log "${BLUE}[3/7] Checking README.md...${NC}"

README="$REPO_ROOT/README.md"

if [ ! -f "$README" ]; then
    log_always "${RED}  ✗ README.md not found${NC}"
    ((ERRORS++))
else
    # Check for key agents (not all, as README may be selective)
    KEY_AGENTS=("intent-guardian" "ux-architect" "backend-engineer" "ci-cd-engineer")
    for agent in "${KEY_AGENTS[@]}"; do
        if grep -qi "$agent" "$README"; then
            log "${GREEN}  ✓ Key agent '$agent' in README${NC}"
        else
            log_always "${YELLOW}  ⚠ Key agent '$agent' NOT in README${NC}"
            ((WARNINGS++))
        fi
    done
fi

# ============================================================
# Check 4: GUIDE has essential content
# ============================================================

log ""
log "${BLUE}[4/7] Checking GUIDE.md...${NC}"

GUIDE="$REPO_ROOT/GUIDE.md"

if [ ! -f "$GUIDE" ]; then
    log_always "${YELLOW}  ⚠ GUIDE.md not found${NC}"
    ((WARNINGS++))
else
    if grep -qi "agent" "$GUIDE"; then
        log "${GREEN}  ✓ GUIDE mentions agents${NC}"
    else
        log_always "${RED}  ✗ GUIDE missing agents${NC}"
        ((ERRORS++))
    fi

    if grep -qiE "/status|/next|command" "$GUIDE"; then
        log "${GREEN}  ✓ GUIDE mentions commands${NC}"
    else
        log_always "${RED}  ✗ GUIDE missing commands${NC}"
        ((ERRORS++))
    fi
fi

# ============================================================
# Check 5: Tests cover all components
# ============================================================

log ""
log "${BLUE}[5/7] Checking test coverage...${NC}"

AGENTS_TEST="$REPO_ROOT/tests/structural/test_agents_exist.sh"
COMMANDS_TEST="$REPO_ROOT/tests/structural/test_commands_exist.sh"

if [ -f "$AGENTS_TEST" ]; then
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        if grep -q "\"$agent_name\"" "$AGENTS_TEST"; then
            log "${GREEN}  ✓ Agent '$agent_name' in tests${NC}"
        else
            log_always "${RED}  ✗ Agent '$agent_name' NOT in tests${NC}"
            ((ERRORS++))
        fi
    done
else
    log_always "${YELLOW}  ⚠ Agents test file not found${NC}"
    ((WARNINGS++))
fi

if [ -f "$COMMANDS_TEST" ]; then
    for cmd_file in "$REPO_ROOT/commands"/*.md; do
        cmd_name=$(basename "$cmd_file" .md)
        if grep -q "\"$cmd_name\"" "$COMMANDS_TEST"; then
            log "${GREEN}  ✓ Command '$cmd_name' in tests${NC}"
        else
            log_always "${RED}  ✗ Command '$cmd_name' NOT in tests${NC}"
            ((ERRORS++))
        fi
    done
else
    log_always "${YELLOW}  ⚠ Commands test file not found${NC}"
    ((WARNINGS++))
fi

# ============================================================
# Check 6: Help topics exist
# ============================================================

log ""
log "${BLUE}[6/7] Checking help topics...${NC}"

REQUIRED_TOPICS=("workflow" "agents" "commands" "patterns" "parallel" "brownfield" "cicd")

for topic in "${REQUIRED_TOPICS[@]}"; do
    if grep -qiE "### If.*topic.*=.*\"$topic\"|If topic.*\"$topic\"" "$HELP_FILE" 2>/dev/null; then
        log "${GREEN}  ✓ Help topic '$topic' exists${NC}"
    else
        log_always "${RED}  ✗ Help topic '$topic' MISSING${NC}"
        ((ERRORS++))
    fi
done

# ============================================================
# Check 7: Template has required sections
# ============================================================

log ""
log "${BLUE}[7/7] Checking template...${NC}"

TEMPLATE="$REPO_ROOT/templates/CLAUDE.md.template"

if [ ! -f "$TEMPLATE" ]; then
    log_always "${RED}  ✗ CLAUDE.md.template not found${NC}"
    ((ERRORS++))
else
    TEMPLATE_SECTIONS=("Sequential" "Parallel" "Greenfield" "Brownfield")
    for section in "${TEMPLATE_SECTIONS[@]}"; do
        if grep -qi "$section" "$TEMPLATE"; then
            log "${GREEN}  ✓ Template has '$section'${NC}"
        else
            log_always "${RED}  ✗ Template missing '$section'${NC}"
            ((ERRORS++))
        fi
    done
fi

# ============================================================
# Summary
# ============================================================

log ""
log "════════════════════════════════════════════════════════════════"
log "                          SUMMARY"
log "════════════════════════════════════════════════════════════════"
log ""
log "  Agents:   $ACTUAL_AGENTS"
log "  Commands: $ACTUAL_COMMANDS"
log "  Errors:   $ERRORS"
log "  Warnings: $WARNINGS"
log ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    log_always "${GREEN}✓ All documentation is in sync!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    log_always "${YELLOW}⚠ Documentation in sync with $WARNINGS warnings${NC}"
    log "  Warnings should be addressed but don't block."
    exit 0
else
    log_always "${RED}✗ Documentation OUT OF SYNC!${NC}"
    log_always ""
    log_always "  Fix the errors above, then run this script again."
    log_always "  See CLAUDE.md for the maintenance checklist."
    exit 1
fi
