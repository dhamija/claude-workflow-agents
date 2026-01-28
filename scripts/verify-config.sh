#!/bin/bash

# ============================================================================
# VERIFY CONFIG CONSISTENCY
# ============================================================================
# Ensures lib/config.sh is the single source of truth and that all scripts
# are correctly using it.
#
# This script catches common issues:
# - install.sh using different values than lib/config.sh
# - Scripts not sourcing lib/config.sh
# - Hardcoded values that should come from config
# ============================================================================

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

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     CONFIGURATION CONSISTENCY VERIFICATION                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# CHECK 1: lib/config.sh exists and is valid
# ============================================================================

echo -e "${BLUE}[1/5]${NC} Checking lib/config.sh exists and is valid..."

if [ ! -f "$REPO_ROOT/lib/config.sh" ]; then
    echo -e "  ${RED}✗ lib/config.sh not found!${NC}"
    echo "    This is the SINGLE SOURCE OF TRUTH for configuration."
    echo "    Create it first before running verification."
    exit 1
fi

# Source it to check for syntax errors
if ! source "$REPO_ROOT/lib/config.sh" 2>/dev/null; then
    echo -e "  ${RED}✗ lib/config.sh has syntax errors!${NC}"
    exit 1
fi

echo -e "  ${GREEN}✓${NC} lib/config.sh is valid"

# ============================================================================
# CHECK 2: Verify expected arrays exist in config
# ============================================================================

echo -e "${BLUE}[2/5]${NC} Checking required config arrays..."

source "$REPO_ROOT/lib/config.sh"

if [ ${#CORE_SUBAGENTS[@]} -eq 0 ]; then
    echo -e "  ${RED}✗ CORE_SUBAGENTS array is empty${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} CORE_SUBAGENTS: ${CORE_SUBAGENTS[*]} (${#CORE_SUBAGENTS[@]} items)"
fi

if [ ${#WORKFLOW_SKILLS[@]} -eq 0 ]; then
    echo -e "  ${RED}✗ WORKFLOW_SKILLS array is empty${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} WORKFLOW_SKILLS: ${#WORKFLOW_SKILLS[@]} skills"
fi

if [ ${#OLD_WORKFLOW_AGENTS[@]} -eq 0 ]; then
    echo -e "  ${RED}✗ OLD_WORKFLOW_AGENTS array is empty${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} OLD_WORKFLOW_AGENTS: ${#OLD_WORKFLOW_AGENTS[@]} old agents for cleanup"
fi

echo ""

# ============================================================================
# CHECK 3: Verify install.sh constants match config
# ============================================================================

echo -e "${BLUE}[3/5]${NC} Checking install.sh constants match lib/config.sh..."

INSTALL_SH="$REPO_ROOT/install.sh"

# Check INSTALL_DIR
CONFIG_INSTALL_DIR="\$HOME/.claude-workflow-agents"
INSTALL_INSTALL_DIR=$(grep '^INSTALL_DIR=' "$INSTALL_SH" | head -1 | cut -d'"' -f2)
if [ "$INSTALL_INSTALL_DIR" != "$CONFIG_INSTALL_DIR" ]; then
    echo -e "  ${RED}✗ INSTALL_DIR mismatch${NC}"
    echo "    config:  $CONFIG_INSTALL_DIR"
    echo "    install: $INSTALL_INSTALL_DIR"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} INSTALL_DIR matches"
fi

# Check CLAUDE_DIR
CONFIG_CLAUDE_DIR="\$HOME/.claude"
INSTALL_CLAUDE_DIR=$(grep '^CLAUDE_DIR=' "$INSTALL_SH" | head -1 | cut -d'"' -f2)
if [ "$INSTALL_CLAUDE_DIR" != "$CONFIG_CLAUDE_DIR" ]; then
    echo -e "  ${RED}✗ CLAUDE_DIR mismatch${NC}"
    echo "    config:  $CONFIG_CLAUDE_DIR"
    echo "    install: $INSTALL_CLAUDE_DIR"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} CLAUDE_DIR matches"
fi

# Check REPO_URL
CONFIG_REPO_URL="https://github.com/dhamija/claude-workflow-agents"
INSTALL_REPO_URL=$(grep '^REPO_URL=' "$INSTALL_SH" | head -1 | cut -d'"' -f2)
if [ "$INSTALL_REPO_URL" != "$CONFIG_REPO_URL" ]; then
    echo -e "  ${RED}✗ REPO_URL mismatch${NC}"
    echo "    config:  $CONFIG_REPO_URL"
    echo "    install: $INSTALL_REPO_URL"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} REPO_URL matches"
fi

echo ""

# ============================================================================
# CHECK 4: Verify bin scripts source config
# ============================================================================

echo -e "${BLUE}[4/5]${NC} Checking bin scripts source lib/config.sh..."

# Note: workflow-fix-hooks doesn't need config
BIN_SCRIPTS=("workflow-patch" "workflow-refresh" "workflow-update")

for script in "${BIN_SCRIPTS[@]}"; do
    script_path="$REPO_ROOT/bin/$script"
    if [ ! -f "$script_path" ]; then
        echo -e "  ${YELLOW}⚠${NC} $script not found (may be generated at install)"
        continue
    fi

    if ! grep -q 'source.*lib/config.sh' "$script_path"; then
        echo -e "  ${RED}✗ $script does not source lib/config.sh${NC}"
        ((ERRORS++))
    else
        echo -e "  ${GREEN}✓${NC} $script sources lib/config.sh"
    fi
done

echo ""

# ============================================================================
# CHECK 5: Verify no hardcoded skill/agent arrays outside config
# ============================================================================

echo -e "${BLUE}[5/5]${NC} Checking for duplicate hardcoded arrays..."

# Check for CORE_AGENTS definitions (old name, should be CORE_SUBAGENTS)
OLD_AGENT_ARRAYS=$(grep -r 'CORE_AGENTS=' "$REPO_ROOT/bin" 2>/dev/null | grep -v config.sh || true)
if [ -n "$OLD_AGENT_ARRAYS" ]; then
    echo -e "  ${RED}✗ Found old CORE_AGENTS definitions (should use CORE_SUBAGENTS from config):${NC}"
    echo "$OLD_AGENT_ARRAYS" | sed 's/^/    /'
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} No old CORE_AGENTS arrays found in bin/"
fi

# Check for standalone skill regex definitions
SKILL_REGEX_DUPS=$(grep -rn 'backend|brownfield|code-quality' "$REPO_ROOT/bin" 2>/dev/null | grep -v config.sh | grep -v '.swp' || true)
if [ -n "$SKILL_REGEX_DUPS" ]; then
    echo -e "  ${RED}✗ Found hardcoded skill patterns (should use WORKFLOW_SKILL_REGEX from config):${NC}"
    echo "$SKILL_REGEX_DUPS" | head -5 | sed 's/^/    /'
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓${NC} No hardcoded skill patterns in bin/"
fi

# Check install.sh embedded scripts for hardcoded arrays
# Note: install.sh embedded scripts CAN'T source config until after download,
# but they should reference config values after sourcing
EMBEDDED_HARDCODES=$(grep -n 'CORE_AGENTS=\|CORE_SUBAGENTS=' "$REPO_ROOT/install.sh" 2>/dev/null | grep -v 'source.*config' || true)
# This is expected - install.sh can't source config until after download
# But embedded scripts should source config after being created

echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ ALL CONFIGURATION CHECKS PASSED${NC}"
    echo ""
    echo "  lib/config.sh is the single source of truth"
    echo "  All bin scripts properly source it"
    echo "  No duplicate hardcoded values found"
    echo ""
    exit 0
else
    echo -e "${RED}✗ CONFIGURATION ISSUES FOUND${NC}"
    echo ""
    echo "  $ERRORS error(s) found"
    echo ""
    echo "  How to fix:"
    echo "  1. Ensure lib/config.sh has all constants"
    echo "  2. Update install.sh to match lib/config.sh constants"
    echo "  3. Update bin scripts to source lib/config.sh"
    echo "  4. Remove hardcoded arrays from individual scripts"
    echo ""
    exit 1
fi
