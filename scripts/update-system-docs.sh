#!/bin/bash

# Auto-update workflow system documentation
# This script detects new agents/commands and updates all relevant docs
# Run this after adding/removing agents or commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║           AUTO-UPDATE SYSTEM DOCUMENTATION                       ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Count files
AGENT_COUNT=$(ls -1 "$REPO_ROOT/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(ls -1 "$REPO_ROOT/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

# Get actual lists
AGENTS=($(ls -1 "$REPO_ROOT/agents"/*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//'))
COMMANDS=($(ls -1 "$REPO_ROOT/commands"/*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//'))

echo "Current state:"
echo "  Agents:   $AGENT_COUNT"
echo "  Commands: $COMMAND_COUNT"
echo ""

# Function to check if a command is documented in a file
check_documented() {
    local file=$1
    local item=$2
    local type=$3  # "command" or "agent"

    if [ "$type" = "command" ]; then
        # Check for ### /command or | /command | patterns (section headers or table rows)
        grep -qE "^###\s+/$item(\s|$)|\|\s+/$item\s+\||^##\s+/$item(\s|$)" "$file" 2>/dev/null
    else
        # Check for agent-name.md or agent-name in headers
        grep -qE "$item\.md|^###?\s+$item(\s|$)" "$file" 2>/dev/null
    fi
}

# Collect undocumented items
UNDOC_IN_README=()
UNDOC_IN_COMMANDS=()
UNDOC_IN_HELP=()

echo "Checking documentation coverage..."
echo ""

# Check README.md
if [ -f "$REPO_ROOT/README.md" ]; then
    for cmd in "${COMMANDS[@]}"; do
        if ! check_documented "$REPO_ROOT/README.md" "$cmd" "command"; then
            UNDOC_IN_README+=("/$cmd")
        fi
    done
fi

# Check COMMANDS.md
if [ -f "$REPO_ROOT/COMMANDS.md" ]; then
    for cmd in "${COMMANDS[@]}"; do
        # Skip agent-wf-help as it's meta
        [ "$cmd" = "agent-wf-help" ] && continue
        if ! check_documented "$REPO_ROOT/COMMANDS.md" "$cmd" "command"; then
            UNDOC_IN_COMMANDS+=("/$cmd")
        fi
    done
fi

# Check agent-wf-help.md
if [ -f "$REPO_ROOT/commands/agent-wf-help.md" ]; then
    for cmd in "${COMMANDS[@]}"; do
        if ! check_documented "$REPO_ROOT/commands/agent-wf-help.md" "$cmd" "command"; then
            UNDOC_IN_HELP+=("/$cmd (help topic)")
        fi
    done
fi

# Report findings
HAS_GAPS=false

if [ ${#UNDOC_IN_README[@]} -gt 0 ]; then
    HAS_GAPS=true
    echo "⚠️  README.md - Missing documentation:"
    for item in "${UNDOC_IN_README[@]}"; do
        echo "     - $item"
    done
    echo ""
fi

if [ ${#UNDOC_IN_COMMANDS[@]} -gt 0 ]; then
    HAS_GAPS=true
    echo "⚠️  COMMANDS.md - Missing documentation:"
    for item in "${UNDOC_IN_COMMANDS[@]}"; do
        echo "     - $item"
    done
    echo ""
fi

if [ ${#UNDOC_IN_HELP[@]} -gt 0 ]; then
    HAS_GAPS=true
    echo "⚠️  commands/agent-wf-help.md - Missing help topics:"
    for item in "${UNDOC_IN_HELP[@]}"; do
        echo "     - $item"
    done
    echo ""
fi

if [ "$HAS_GAPS" = true ]; then
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║              POTENTIAL DOCUMENTATION GAPS                        ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "⚠️  NOTE: Some items above may be false positives (already documented"
    echo "   but not detected by grep patterns). Claude should verify manually."
    echo ""
    echo "Claude should check and update if needed:"
    echo ""

    [ ${#UNDOC_IN_README[@]} -gt 0 ] && echo "  • README.md - Verify commands table is complete"
    [ ${#UNDOC_IN_COMMANDS[@]} -gt 0 ] && echo "  • COMMANDS.md - Verify detailed documentation exists"
    [ ${#UNDOC_IN_HELP[@]} -gt 0 ] && echo "  • commands/agent-wf-help.md - Verify help topics exist"

    echo ""
    echo "Follow the checklist in CLAUDE.md section:"
    echo "  '## 🔄 Self-Maintenance System - Adding Components'"
    echo ""
else
    echo "✅ Basic documentation check passed"
    echo "   (Manual verification still recommended)"
    echo ""
fi

# Now run the count updates
echo "Updating counts in CLAUDE.md and STATE.md..."
"$SCRIPT_DIR/update-claude-md.sh"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                  DOCUMENTATION UPDATE COMPLETE                   ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
