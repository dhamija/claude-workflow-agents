#!/bin/bash

# Test that all command files are valid

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/commands"

PASS=0
FAIL=0

echo "Testing command files..."
echo ""

# Required commands
REQUIRED_COMMANDS=(
    "analyze"
    "plan"
    "implement"
    "audit"
    "gap"
    "improve"
    "verify"
    "aa"
    "aa-audit"
    "ux"
    "ux-audit"
    "intent"
    "intent-audit"
    "review"
    "debug"
    "auto"
)

# Check each required command exists
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if [ -f "$COMMANDS_DIR/$cmd.md" ]; then
        echo "✓ $cmd.md exists"
        ((PASS++))
    else
        echo "✗ $cmd.md MISSING"
        ((FAIL++))
    fi
done

echo ""

# Validate command file format
for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [ -f "$cmd_file" ]; then
        BASENAME=$(basename "$cmd_file")

        # Check frontmatter exists
        if head -1 "$cmd_file" | grep -q "^---$"; then
            # Check required field
            if grep -q "^description:" "$cmd_file"; then
                echo "✓ $BASENAME has valid frontmatter"
                ((PASS++))
            else
                echo "✗ $BASENAME missing description field"
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
