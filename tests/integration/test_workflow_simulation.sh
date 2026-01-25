#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Simulation (Static Analysis)"

# This test simulates workflow by checking that all pieces connect

AGENTS_DIR="$REPO_ROOT/agents"
COMMANDS_DIR="$REPO_ROOT/commands"
TEMPLATE="$REPO_ROOT/templates/CLAUDE.md.template"

info "Testing Greenfield workflow chain..."

# Level 1 agents should exist
L1_AGENTS=("intent-guardian" "ux-architect" "agentic-architect" "implementation-planner")
for agent in "${L1_AGENTS[@]}"; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        pass "L1 agent exists: $agent"
    else
        fail "L1 agent missing: $agent"
    fi
done

# Level 2 agents should exist
L2_AGENTS=("backend-engineer" "frontend-engineer" "test-engineer")
for agent in "${L2_AGENTS[@]}"; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        pass "L2 agent exists: $agent"
    else
        fail "L2 agent missing: $agent"
    fi
done

info "Testing Brownfield workflow chain..."

# Brownfield-specific checks
BROWNFIELD_AGENTS=("gap-analyzer" "change-analyzer")
for agent in "${BROWNFIELD_AGENTS[@]}"; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        pass "Brownfield agent exists: $agent"
    else
        fail "Brownfield agent missing: $agent"
    fi
done

# Check L1 agents have audit mode
for agent in "intent-guardian" "ux-architect" "agentic-architect"; do
    if grep -qiE "audit|AUDIT|brownfield|existing|INFERRED" "$AGENTS_DIR/$agent.md"; then
        pass "$agent has audit mode"
    else
        fail "$agent missing audit mode for brownfield"
    fi
done

info "Testing parallel workflow..."

# Check parallel command
if [ -f "$COMMANDS_DIR/parallel.md" ]; then
    pass "Parallel command exists"
else
    fail "Parallel command missing"
fi

summary
