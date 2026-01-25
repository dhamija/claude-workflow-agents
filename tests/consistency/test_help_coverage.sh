#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Help Command Coverage"

HELP_CMD="$REPO_ROOT/commands/help.md"
AGENTS_DIR="$REPO_ROOT/agents"

if [ ! -f "$HELP_CMD" ]; then
    fail "help.md not found"
    summary
    exit 1
fi

# Check all agents mentioned in help
for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        name=$(grep "^name:" "$agent_file" | sed 's/name: *//' | tr -d '\r')
        if [ -n "$name" ]; then
            # Convert to searchable pattern
            pattern=$(echo "$name" | tr '-' ' ' | sed 's/\b\w/\u&/g')
            upper=$(echo "$name" | tr '[:lower:]' '[:upper:]' | tr '-' '-')

            if grep -qi "$name\|$pattern\|$upper" "$HELP_CMD"; then
                pass "Help mentions agent: $name"
            else
                warn "Help might not mention agent: $name"
            fi
        fi
    fi
done

# Check all help topics exist
HELP_TOPICS=(
    "workflow"
    "agents"
    "commands"
    "patterns"
    "parallel"
    "brownfield"
    "examples"
)

for topic in "${HELP_TOPICS[@]}"; do
    if grep -qi "\"$topic\"\|: \"$topic\"\|If.*$topic" "$HELP_CMD"; then
        pass "Help has topic: $topic"
    else
        fail "Help missing topic: $topic"
    fi
done

summary
