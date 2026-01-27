#!/bin/bash

# Test Workflow Orchestrator Agent and /auto command

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Orchestrator"

AGENT_FILE="$REPO_ROOT/agents/workflow-orchestrator.md"
COMMAND_FILE="$REPO_ROOT/commands/auto.md"

# Check orchestrator agent exists
if [ -f "$AGENT_FILE" ]; then
    pass "workflow-orchestrator.md exists"
else
    fail "workflow-orchestrator.md missing"
    summary
    exit 1
fi

# Check required content in orchestrator
if grep -qi "chain.*automatically\|auto.*chain" "$AGENT_FILE"; then
    pass "Mentions auto-chaining"
else
    fail "Missing auto-chain reference"
fi

if grep -q "quality.*gate" "$AGENT_FILE"; then
    pass "Has quality gates"
else
    fail "Missing quality gates"
fi

if grep -q "PHASE_COMPLETE\|STEP_COMPLETE" "$AGENT_FILE"; then
    pass "Has completion signal protocol"
else
    fail "Missing completion signals"
fi

if grep -q "L1.*Workflow\|L2.*Workflow" "$AGENT_FILE"; then
    pass "Has L1/L2 orchestration"
else
    fail "Missing L1/L2 workflows"
fi

# Check /auto command exists
if [ -f "$COMMAND_FILE" ]; then
    pass "/auto command exists"
else
    fail "/auto command missing"
fi

# Check /auto command content
if grep -q "on.*off.*status" "$COMMAND_FILE"; then
    pass "/auto has on/off/status modes"
else
    fail "/auto missing modes"
fi

# Check L1 agents have orchestration sections
L1_AGENTS=("intent-guardian" "ux-architect" "agentic-architect" "implementation-planner")

for agent in "${L1_AGENTS[@]}"; do
    AGENT_PATH="$REPO_ROOT/agents/$agent.md"
    if grep -q "Orchestration Integration" "$AGENT_PATH"; then
        pass "$agent has orchestration section"
    else
        fail "$agent missing orchestration"
    fi

    if grep -q "PHASE_COMPLETE" "$AGENT_PATH"; then
        pass "$agent has completion signal"
    else
        fail "$agent missing completion signal"
    fi
done

# Check L2 agents have orchestration sections
L2_AGENTS=("backend-engineer" "frontend-engineer" "test-engineer")

for agent in "${L2_AGENTS[@]}"; do
    AGENT_PATH="$REPO_ROOT/agents/$agent.md"
    if grep -q "Orchestration Integration" "$AGENT_PATH"; then
        pass "$agent has orchestration section"
    else
        fail "$agent missing orchestration"
    fi

    if grep -q "STEP_COMPLETE" "$AGENT_PATH"; then
        pass "$agent has completion signal"
    else
        fail "$agent missing completion signal"
    fi
done

summary
