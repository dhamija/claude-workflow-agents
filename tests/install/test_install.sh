#!/bin/bash

# Test: Fresh install

source "$(dirname "$0")/../test_utils.sh"

section "Test: Fresh Install"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Run install
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Verify
if [ -d ".workflow" ]; then pass ".workflow/ created"; else fail ".workflow/ missing"; fi
if [ -d ".workflow/agents" ]; then pass "agents/ present"; else fail "agents/ missing"; fi
if [ -d ".workflow/commands" ]; then pass "commands/ present"; else fail "commands/ missing"; fi
if [ -f ".workflow/scripts/verify.sh" ]; then pass "verify.sh present"; else fail "verify.sh missing"; fi
if [ -f "CLAUDE.md" ]; then pass "CLAUDE.md created"; else fail "CLAUDE.md missing"; fi

# Check toggle
if grep -q "<!-- workflow: enabled -->" "CLAUDE.md"; then pass "Toggle present"; else fail "Toggle missing"; fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
