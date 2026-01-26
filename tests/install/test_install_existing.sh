#!/bin/bash

# Test: Install with existing CLAUDE.md

source "$(dirname "$0")/../test_utils.sh"

section "Test: Install with Existing CLAUDE.md"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Create existing CLAUDE.md with user content
cat > "CLAUDE.md" << 'EOF'
# My Existing Project

This is my important content.

## My Notes

- Note 1
- Note 2
EOF

ORIGINAL_CONTENT=$(cat CLAUDE.md)

# Run install
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Verify toggle added
if grep -q "<!-- workflow: enabled -->" "CLAUDE.md"; then pass "Toggle added"; else fail "Toggle missing"; fi

# Verify content preserved
if grep -q "My Existing Project" "CLAUDE.md"; then pass "Title preserved"; else fail "Title lost"; fi
if grep -q "This is my important content" "CLAUDE.md"; then pass "Content preserved"; else fail "Content lost"; fi
if grep -q "Note 1" "CLAUDE.md"; then pass "Notes preserved"; else fail "Notes lost"; fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
