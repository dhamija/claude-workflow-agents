#!/bin/bash

# Test: Double install blocked

source "$(dirname "$0")/../test_utils.sh"

section "Test: Double Install Blocked"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# First install
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Second install should fail/warn
OUTPUT=$("$REPO_ROOT/install.sh" 2>&1) || true

if echo "$OUTPUT" | grep -qi "already installed"; then
    pass "Double install blocked"
else
    fail "Double install not blocked"
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
