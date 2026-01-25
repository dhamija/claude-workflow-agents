#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: All Required Commands Exist"

COMMANDS_DIR="$REPO_ROOT/commands"

# Required commands
REQUIRED_COMMANDS=(
    "agent-wf-help"
    "analyze"
    "audit"
    "change"
    "debug"
    "docs"
    "gap"
    "implement"
    "improve"
    "intent"
    "intent-audit"
    "parallel"
    "plan"
    "replan"
    "review"
    "sync"
    "update"
    "ux"
    "ux-audit"
    "verify"
    "aa"
    "aa-audit"
)

# Check each command
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    assert_file_exists "$COMMANDS_DIR/$cmd.md"
done

summary
