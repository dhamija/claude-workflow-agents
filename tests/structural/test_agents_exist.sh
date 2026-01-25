#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: All Required Agents Exist"

AGENTS_DIR="$REPO_ROOT/agents"

# Required agents
REQUIRED_AGENTS=(
    "intent-guardian"
    "ux-architect"
    "agentic-architect"
    "implementation-planner"
    "change-analyzer"
    "gap-analyzer"
    "backend-engineer"
    "frontend-engineer"
    "test-engineer"
    "code-reviewer"
    "debugger"
    "ci-cd-engineer"
)

# Check each agent
for agent in "${REQUIRED_AGENTS[@]}"; do
    assert_file_exists "$AGENTS_DIR/$agent.md"
done

# Check for unexpected files (warnings only)
for file in "$AGENTS_DIR"/*.md; do
    if [ -f "$file" ]; then
        basename="${file##*/}"
        name="${basename%.md}"
        found=false
        for agent in "${REQUIRED_AGENTS[@]}"; do
            if [ "$name" = "$agent" ]; then
                found=true
                break
            fi
        done
        if ! $found; then
            warn "Unexpected agent file: $basename"
        fi
    fi
done

summary
