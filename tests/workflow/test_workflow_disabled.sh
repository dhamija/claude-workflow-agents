#!/bin/bash

# Test: Workflow files exist but disabled

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Disabled State"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Disable
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
else
    sed -i 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
fi

# Verify files still exist
if [ -d ".workflow" ]; then pass ".workflow/ still exists"; else fail ".workflow/ removed"; fi
if [ -d ".workflow/agents" ]; then pass "agents/ still exists"; else fail "agents/ removed"; fi

# Verify toggle changed
if grep -q "<!-- workflow: disabled -->" "CLAUDE.md"; then pass "Toggle is disabled"; else fail "Toggle not disabled"; fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
