#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Install Script"

INSTALL="$REPO_ROOT/install.sh"

if [ ! -f "$INSTALL" ]; then
    fail "install.sh not found"
    summary
    exit 1
fi

# Check it's executable
if [ -x "$INSTALL" ]; then
    pass "install.sh is executable"
else
    fail "install.sh is not executable"
fi

# Check for required functionality
assert_file_contains "$INSTALL" "--user" "install.sh supports --user flag"
assert_file_contains "$INSTALL" "--project" "install.sh supports --project flag"
assert_file_contains "$INSTALL" "--force" "install.sh supports --force flag"
assert_file_contains "$INSTALL" "--help" "install.sh supports --help flag"

# Check it copies agents
assert_file_contains "$INSTALL" "agents" "install.sh handles agents"

# Check it creates CLAUDE.md
assert_file_contains "$INSTALL" "CLAUDE.md" "install.sh handles CLAUDE.md"

# Test --help doesn't fail
if "$INSTALL" --help > /dev/null 2>&1; then
    pass "install.sh --help works"
else
    fail "install.sh --help failed"
fi

summary
