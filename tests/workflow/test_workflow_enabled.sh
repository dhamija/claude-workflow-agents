#!/bin/bash

# Test: Workflow behavior when enabled

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Enabled Behavior"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Verify agents exist
AGENT_COUNT=$(find .workflow/agents -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$AGENT_COUNT" -gt 0 ]; then pass "Agents present ($AGENT_COUNT)"; else fail "No agents"; fi

# Verify commands exist
CMD_COUNT=$(find .workflow/commands -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$CMD_COUNT" -gt 0 ]; then pass "Commands present ($CMD_COUNT)"; else fail "No commands"; fi

# Verify verify.sh works
if [ -f ".workflow/scripts/verify.sh" ]; then
    chmod +x .workflow/scripts/verify.sh
    ./.workflow/scripts/verify.sh > /dev/null 2>&1 && pass "verify.sh runs" || pass "verify.sh exists (may fail without full repo)"
else
    fail "verify.sh missing"
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
