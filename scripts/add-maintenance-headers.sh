#!/bin/bash

# Add maintenance reminder headers to all agent and command files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

AGENT_HEADER='<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (agent count, list)           ║
║   □ commands/agent-wf-help.md → "agents" topic                               ║
║   □ README.md        → agents table                                          ║
║   □ GUIDE.md         → agents list                                           ║
║   □ tests/structural/test_agents_exist.sh → REQUIRED_AGENTS array            ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->'

COMMAND_HEADER='<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/agent-wf-help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->'

add_header_if_missing() {
    local file="$1"
    local header="$2"

    # Check if file already has maintenance header
    if grep -q "MAINTENANCE REQUIRED" "$file" 2>/dev/null; then
        echo "  ⏭️  $file (already has header)"
        return
    fi

    # Add header at the top
    local temp_file=$(mktemp)
    echo "$header" > "$temp_file"
    echo "" >> "$temp_file"
    cat "$file" >> "$temp_file"
    mv "$temp_file" "$file"
    echo "  ✅ $file (header added)"
}

echo "Adding maintenance headers..."
echo ""
echo "Agents:"

for file in "$REPO_ROOT"/agents/*.md; do
    [ -f "$file" ] && add_header_if_missing "$file" "$AGENT_HEADER"
done

echo ""
echo "Commands:"

for file in "$REPO_ROOT"/commands/*.md; do
    [ -f "$file" ] && add_header_if_missing "$file" "$COMMAND_HEADER"
done

echo ""
echo "Done! All files now have maintenance reminders."
