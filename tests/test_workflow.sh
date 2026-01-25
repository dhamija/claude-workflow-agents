#!/bin/bash

# Test that workflows reference valid agents

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"
COMMANDS_DIR="$SCRIPT_DIR/commands"

PASS=0
FAIL=0

echo "Testing workflow consistency..."
echo ""

# Extract agent names from agents directory
AVAILABLE_AGENTS=()
for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        # Extract name from frontmatter
        NAME=$(grep "^name:" "$agent_file" | sed 's/name: *//')
        if [ -n "$NAME" ]; then
            AVAILABLE_AGENTS+=("$NAME")
        fi
    fi
done

echo "Available agents: ${AVAILABLE_AGENTS[*]}"
echo ""

# Check commands reference valid agents
for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [ -f "$cmd_file" ]; then
        BASENAME=$(basename "$cmd_file")

        # Find agent references (patterns like "use X subagent" or "X subagent")
        REFERENCED=$(grep -oE '[a-z]+-[a-z]+(-[a-z]+)? subagent' "$cmd_file" 2>/dev/null | sed 's/ subagent//' | sort -u || true)

        if [ -n "$REFERENCED" ]; then
            for ref in $REFERENCED; do
                # Check if referenced agent exists
                FOUND=false
                for available in "${AVAILABLE_AGENTS[@]}"; do
                    if [ "$ref" = "$available" ]; then
                        FOUND=true
                        break
                    fi
                done

                if [ "$FOUND" = true ]; then
                    echo "✓ $BASENAME → $ref (valid)"
                    ((PASS++))
                else
                    echo "✗ $BASENAME → $ref (NOT FOUND)"
                    ((FAIL++))
                fi
            done
        fi
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
