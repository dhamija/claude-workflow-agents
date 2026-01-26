#!/bin/bash

# Project verification - checks docs are in sync
# Used by CI (real enforcement) and developers (convenience)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0

echo ""
echo "Verifying documentation sync..."
echo ""

# Count actual files
AGENT_COUNT=$(find "$REPO_ROOT/agents" -name "*.md" -type f | wc -l | tr -d ' ')
COMMAND_COUNT=$(find "$REPO_ROOT/commands" -name "*.md" -type f | wc -l | tr -d ' ')

echo "Found: $AGENT_COUNT agents, $COMMAND_COUNT commands"
echo ""

# Check 1: All agents in CLAUDE.md
echo "Checking CLAUDE.md..."
for agent in "$REPO_ROOT/agents"/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    if ! grep -qi "$name" "$REPO_ROOT/CLAUDE.md" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$name' not in CLAUDE.md${NC}"
        ((ERRORS++))
    fi
done

# Check 2: All agents in help
echo "Checking help..."
for agent in "$REPO_ROOT/agents"/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    if ! grep -qi "$name" "$REPO_ROOT/commands/help.md" 2>/dev/null; then
        echo -e "  ${RED}✗ Agent '$name' not in help${NC}"
        ((ERRORS++))
    fi
done

# Check 3: All agents in tests
echo "Checking tests..."
AGENT_TEST="$REPO_ROOT/tests/structural/test_agents_exist.sh"
if [ -f "$AGENT_TEST" ]; then
    for agent in "$REPO_ROOT/agents"/*.md; do
        [ -f "$agent" ] || continue
        name=$(basename "$agent" .md)
        if ! grep -q "\"$name\"" "$AGENT_TEST"; then
            echo -e "  ${RED}✗ Agent '$name' not in tests${NC}"
            ((ERRORS++))
        fi
    done
fi

# Check 4: All commands in tests
CMD_TEST="$REPO_ROOT/tests/structural/test_commands_exist.sh"
if [ -f "$CMD_TEST" ]; then
    for cmd in "$REPO_ROOT/commands"/*.md; do
        [ -f "$cmd" ] || continue
        name=$(basename "$cmd" .md)
        if ! grep -q "\"$name\"" "$CMD_TEST"; then
            echo -e "  ${RED}✗ Command '$name' not in tests${NC}"
            ((ERRORS++))
        fi
    done
fi

echo ""

# Result
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed${NC}"
    exit 0
else
    echo -e "${RED}✗ $ERRORS issue(s) found${NC}"
    echo ""
    echo "Fix these before pushing. CI will fail otherwise."
    exit 1
fi
