#!/bin/bash

# Auto-update CLAUDE.md with current counts and structure
# Run this after adding/removing agents or commands

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║              AUTO-UPDATE CLAUDE.md                               ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Count files
AGENT_COUNT=$(ls -1 "$REPO_ROOT/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(ls -1 "$REPO_ROOT/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

echo "Current counts:"
echo "  Agents:   $AGENT_COUNT"
echo "  Commands: $COMMAND_COUNT"
echo ""

CLAUDE_MD="$REPO_ROOT/CLAUDE.md"

if [ ! -f "$CLAUDE_MD" ]; then
    echo "CLAUDE.md not found. Cannot auto-update."
    exit 1
fi

# Update placeholders
echo "Updating CLAUDE.md..."

# Create backup
cp "$CLAUDE_MD" "$CLAUDE_MD.bak"

# Update patterns like "Agents: X total" or "# X specialized agents"
sed -i '' -E "s/Agents: [0-9]+ total/Agents: $AGENT_COUNT total/g" "$CLAUDE_MD"
sed -i '' -E "s/Commands: [0-9]+ total/Commands: $COMMAND_COUNT total/g" "$CLAUDE_MD"
sed -i '' -E "s/# [0-9]+ specialized agents/# $AGENT_COUNT specialized agents/g" "$CLAUDE_MD"
sed -i '' -E "s/# [0-9]+ optional commands/# $COMMAND_COUNT optional commands/g" "$CLAUDE_MD"

echo "✓ Updated CLAUDE.md"
echo ""

# Update STATE.md if it exists
STATE_MD="$REPO_ROOT/STATE.md"
if [ -f "$STATE_MD" ]; then
    echo "Updating STATE.md..."
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    cp "$STATE_MD" "$STATE_MD.bak"

    sed -i '' "s/>.*Last updated.*:.*/>  **Last updated**: $TIMESTAMP/g" "$STATE_MD"
    sed -i '' -E "s/\| Agents \| [0-9]+ \|/| Agents | $AGENT_COUNT |/g" "$STATE_MD"
    sed -i '' -E "s/\| Commands \| [0-9]+ \|/| Commands | $COMMAND_COUNT |/g" "$STATE_MD"

    echo "✓ Updated STATE.md"
fi

echo ""
echo "Backups created:"
echo "  $CLAUDE_MD.bak"
[ -f "$STATE_MD.bak" ] && echo "  $STATE_MD.bak"
echo ""
echo "Done. Review changes with: git diff CLAUDE.md STATE.md"
echo ""
echo "⚠️  This only updates COUNTS. You still need to manually:"
echo "   - Add new agents/commands to the lists in CLAUDE.md"
echo "   - Update structure diagram in CLAUDE.md if needed"
echo "   - Update commands/agent-wf-help.md with new agents/commands"
echo "   - Update WORKFLOW.md if workflow changes"
echo "   - Update README.md and GUIDE.md"
echo "   - Update USAGE.md if new commands added"
echo ""
echo "To clean up backups: rm CLAUDE.md.bak STATE.md.bak"
