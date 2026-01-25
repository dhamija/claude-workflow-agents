#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: All Required Commands Exist"

COMMANDS_DIR="$REPO_ROOT/commands"

# Required commands
REQUIRED_COMMANDS=(
    "agent-wf-help"
    "analyze"
    "plan"
    "implement"
    "audit"
    "gap"
    "improve"
    "verify"
    "review"
    "debug"
    "parallel"
)

# Check each command
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    assert_file_exists "$COMMANDS_DIR/$cmd.md"
done

summary
