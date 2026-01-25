#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Agent References Are Valid"

AGENTS_DIR="$REPO_ROOT/agents"
COMMANDS_DIR="$REPO_ROOT/commands"
TEMPLATE="$REPO_ROOT/templates/CLAUDE.md.template"

# Get list of valid agent names
VALID_AGENTS=()
for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        name=$(grep "^name:" "$agent_file" | sed 's/name: *//' | tr -d '\r')
        if [ -n "$name" ]; then
            VALID_AGENTS+=("$name")
        fi
    fi
done

info "Valid agents: ${VALID_AGENTS[*]}"

# Check template references valid agents
for agent in "${VALID_AGENTS[@]}"; do
    if grep -q "$agent" "$TEMPLATE" 2>/dev/null; then
        pass "Template references: $agent"
    else
        warn "Template might not reference: $agent"
    fi
done

summary
