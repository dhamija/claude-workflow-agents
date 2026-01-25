#!/bin/bash

# Test that all agent files are valid

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"

PASS=0
FAIL=0

echo "Testing agent files..."
echo ""

# Required agents
REQUIRED_AGENTS=(
    "intent-guardian"
    "ux-architect"
    "agentic-architect"
    "implementation-planner"
    "gap-analyzer"
    "backend-engineer"
    "frontend-engineer"
    "test-engineer"
    "code-reviewer"
    "debugger"
)

# Check each required agent exists
for agent in "${REQUIRED_AGENTS[@]}"; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        echo "✓ $agent.md exists"
        ((PASS++))
    else
        echo "✗ $agent.md MISSING"
        ((FAIL++))
    fi
done

echo ""

# Validate agent file format
for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        BASENAME=$(basename "$agent_file")

        # Check frontmatter exists
        if head -1 "$agent_file" | grep -q "^---$"; then
            # Check required fields
            if grep -q "^name:" "$agent_file" && \
               grep -q "^description:" "$agent_file" && \
               grep -q "^tools:" "$agent_file"; then
                echo "✓ $BASENAME has valid frontmatter"
                ((PASS++))
            else
                echo "✗ $BASENAME missing required frontmatter fields (name, description, tools)"
                ((FAIL++))
            fi
        else
            echo "✗ $BASENAME missing frontmatter"
            ((FAIL++))
        fi
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
