#!/bin/bash

# Test GitHub Actions release workflow

source "$(dirname "$0")/../test_utils.sh"

section "Test: Release Workflow Exists"

WORKFLOW="$REPO_ROOT/.github/workflows/release.yml"

# Check workflow exists
if [ -f "$WORKFLOW" ]; then
    pass "release.yml exists"
else
    fail "release.yml missing"
    summary
    exit 1
fi

# Check has push trigger
if grep -q "push:" "$WORKFLOW"; then
    pass "Has push trigger"
else
    fail "Missing push trigger"
fi

# Check has tags filter
if grep -q "tags:" "$WORKFLOW"; then
    pass "Has tags filter"
else
    fail "Missing tags filter"
fi

# Check creates GitHub release
if grep -q "gh-release\|action-gh-release" "$WORKFLOW"; then
    pass "Creates GitHub release"
else
    fail "Missing release action"
fi

# Check extracts changelog
if grep -q "CHANGELOG" "$WORKFLOW"; then
    pass "Extracts changelog"
else
    warn "Doesn't extract changelog"
fi

# Check sets version
if grep -q "version" "$WORKFLOW" || grep -q "VERSION" "$WORKFLOW"; then
    pass "Sets version from tag"
else
    fail "Doesn't set version"
fi

# Check permissions
if grep -q "contents: write" "$WORKFLOW"; then
    pass "Has write permissions"
else
    warn "Missing write permissions (may fail to create release)"
fi

summary
