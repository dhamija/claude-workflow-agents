#!/bin/bash

# Test: Uninstall preserves user content

source "$(dirname "$0")/../test_utils.sh"

section "Test: Uninstall Preserves Content"

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Install first
"$REPO_ROOT/install.sh" > /dev/null 2>&1 || true

# Add user content
cat >> "CLAUDE.md" << 'EOF'

## My Custom Section

This content must survive uninstall.
EOF

# Create user docs
mkdir -p docs
echo "My documentation" > docs/notes.md

# Uninstall (auto-confirm)
echo "y" | ./.workflow/scripts/uninstall.sh > /dev/null 2>&1 || true

# Verify workflow removed
if [ ! -d ".workflow" ]; then pass ".workflow/ removed"; else fail ".workflow/ still exists"; fi

# Verify user content preserved
if grep -q "My Custom Section" "CLAUDE.md"; then pass "Custom section preserved"; else fail "Custom section lost"; fi
if grep -q "This content must survive" "CLAUDE.md"; then pass "Content preserved"; else fail "Content lost"; fi
if [ -f "docs/notes.md" ]; then pass "docs/ preserved"; else fail "docs/ removed"; fi

# Verify toggle removed
if ! grep -q "<!-- workflow:" "CLAUDE.md"; then pass "Toggle removed"; else fail "Toggle still present"; fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

summary
