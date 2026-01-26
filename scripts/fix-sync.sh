#!/bin/bash

# Helper to see what needs updating

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ""
echo "Current agents:"
for f in "$REPO_ROOT/agents"/*.md; do
    [ -f "$f" ] && echo "  - $(basename "$f" .md)"
done

echo ""
echo "Current commands:"
for f in "$REPO_ROOT/commands"/*.md; do
    [ -f "$f" ] && echo "  - $(basename "$f" .md)"
done

echo ""
echo "Files to update when adding/changing agents or commands:"
echo "  - CLAUDE.md (Current State section)"
echo "  - commands/help.md (agents/commands topics)"
echo "  - README.md (tables)"
echo "  - tests/structural/test_agents_exist.sh"
echo "  - tests/structural/test_commands_exist.sh"
echo ""
echo "Verify with: ./scripts/verify.sh"
echo ""
