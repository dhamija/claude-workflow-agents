#!/bin/bash

# Test UI Debugger Agent exists and has correct structure

source "$(dirname "$0")/../test_utils.sh"

section "Test: UI Debugger Agent"

AGENT_FILE="$REPO_ROOT/agents/ui-debugger.md"

# Check agent exists
if [ -f "$AGENT_FILE" ]; then
    pass "ui-debugger.md exists"
else
    fail "ui-debugger.md missing"
    summary
    exit 1
fi

# Check required content
if grep -q "puppeteer" "$AGENT_FILE"; then
    pass "Mentions puppeteer MCP"
else
    fail "Missing puppeteer reference"
fi

if grep -q "screenshot" "$AGENT_FILE"; then
    pass "Has screenshot capability"
else
    fail "Missing screenshot capability"
fi

if grep -q "console" "$AGENT_FILE"; then
    pass "Has console capture"
else
    fail "Missing console capture"
fi

if grep -q "DOM" "$AGENT_FILE"; then
    pass "Has DOM inspection"
else
    fail "Missing DOM inspection"
fi

if grep -q "network" "$AGENT_FILE"; then
    pass "Has network monitoring"
else
    fail "Missing network monitoring"
fi

if grep -q "responsive" "$AGENT_FILE"; then
    pass "Has responsive testing"
else
    fail "Missing responsive testing"
fi

# Check /debug command updated
COMMAND_FILE="$REPO_ROOT/commands/debug.md"

if grep -q "ui.*url" "$COMMAND_FILE"; then
    pass "/debug ui command documented"
else
    fail "/debug ui not in commands"
fi

if grep -q "console.*url" "$COMMAND_FILE"; then
    pass "/debug console command documented"
else
    fail "/debug console not in commands"
fi

# Check help updated
HELP_FILE="$REPO_ROOT/commands/help.md"

if grep -q "UI DEBUGGING" "$HELP_FILE"; then
    pass "Help has UI debugging section"
else
    fail "Help missing UI debugging"
fi

summary
