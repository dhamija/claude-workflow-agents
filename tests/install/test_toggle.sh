#!/bin/bash

# Test: Enable/disable toggle

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Toggle"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Install
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Check initial state
if grep -q "<!-- workflow: enabled -->" "CLAUDE.md"; then pass "Initially enabled"; else fail "Not initially enabled"; fi

# Disable
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
else
    sed -i 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
fi
if grep -q "<!-- workflow: disabled -->" "CLAUDE.md"; then pass "Disabled successfully"; else fail "Disable failed"; fi

# Verify content preserved after disable
if grep -q "Project Context" "CLAUDE.md"; then pass "Content preserved after disable"; else fail "Content lost after disable"; fi

# Re-enable
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/<!-- workflow: disabled -->/<!-- workflow: enabled -->/' CLAUDE.md
else
    sed -i 's/<!-- workflow: disabled -->/<!-- workflow: enabled -->/' CLAUDE.md
fi
if grep -q "<!-- workflow: enabled -->" "CLAUDE.md"; then pass "Re-enabled successfully"; else fail "Re-enable failed"; fi

# Verify content preserved after re-enable
if grep -q "Project Context" "CLAUDE.md"; then pass "Content preserved after re-enable"; else fail "Content lost after re-enable"; fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
