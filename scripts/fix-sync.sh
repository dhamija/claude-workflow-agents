#!/bin/bash

# Helper script to generate copy-paste content for documentation updates
# Makes it easy to fix sync issues detected by verify-sync.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║               FIX-SYNC HELPER                                    ║"
echo "║  Generates copy-paste content for documentation updates          ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================
# 1. Generate test array content
# ============================================================

echo "═══ 1. FOR tests/structural/test_agents_exist.sh ═══"
echo ""
echo "REQUIRED_AGENTS=("

for file in "$REPO_ROOT/agents"/*.md; do
    agent_name=$(basename "$file" .md)
    echo "    \"$agent_name\""
done

echo ")"
echo ""
echo ""

echo "═══ 2. FOR tests/structural/test_commands_exist.sh ═══"
echo ""
echo "REQUIRED_COMMANDS=("

for file in "$REPO_ROOT/commands"/*.md; do
    cmd_name=$(basename "$file" .md)
    echo "    \"$cmd_name\""
done

echo ")"
echo ""
echo ""

# ============================================================
# 2. Generate markdown list for README/GUIDE
# ============================================================

echo "═══ 3. FOR README.md / GUIDE.md (Agent List) ═══"
echo ""

for file in "$REPO_ROOT/agents"/*.md; do
    agent_name=$(basename "$file" .md)
    # Try to extract description from frontmatter
    description=$(grep -A 3 "^description:" "$file" | tail -n +2 | sed 's/^  //' | tr '\n' ' ' | sed 's/  */ /g')

    if [ -z "$description" ]; then
        description="[Add description]"
    fi

    echo "- **$agent_name**: $description"
done

echo ""
echo ""

echo "═══ 4. FOR README.md / GUIDE.md (Command List) ═══"
echo ""

for file in "$REPO_ROOT/commands"/*.md; do
    cmd_name=$(basename "$file" .md)
    # Try to extract description from frontmatter
    description=$(grep -A 3 "^description:" "$file" | tail -n +2 | sed 's/^  //' | tr '\n' ' ' | sed 's/  */ /g')

    if [ -z "$description" ]; then
        description="[Add description]"
    fi

    echo "- **/$cmd_name**: $description"
done

echo ""
echo ""

# ============================================================
# 3. Generate CLAUDE.md list format
# ============================================================

echo "═══ 5. FOR CLAUDE.md (Current State) ═══"
echo ""

AGENT_COUNT=$(ls -1 "$REPO_ROOT/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(ls -1 "$REPO_ROOT/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')

echo "Agents: $AGENT_COUNT total"
echo ""

for file in "$REPO_ROOT/agents"/*.md; do
    agent_name=$(basename "$file" .md)
    echo "- $agent_name"
done

echo ""
echo "Commands: $COMMAND_COUNT total"
echo ""

for file in "$REPO_ROOT/commands"/*.md; do
    cmd_name=$(basename "$file" .md)
    echo "- /$cmd_name"
done

echo ""
echo ""

# ============================================================
# 4. Usage instructions
# ============================================================

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                      USAGE INSTRUCTIONS                          ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "1. Copy the relevant section above"
echo "2. Paste it into the corresponding file"
echo "3. Run: ./scripts/verify-sync.sh to confirm"
echo "4. Stage all changes: git add -A"
echo "5. Commit: git commit -m \"docs: update documentation sync\""
echo ""
