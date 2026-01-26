#!/bin/bash

# Test release scripts exist and are executable

source "$(dirname "$0")/../test_utils.sh"

section "Test: Release Scripts Exist"

# Check release.sh
if [ -f "$REPO_ROOT/scripts/release.sh" ]; then
    pass "release.sh exists"
else
    fail "release.sh missing"
fi

if [ -x "$REPO_ROOT/scripts/release.sh" ]; then
    pass "release.sh executable"
else
    fail "release.sh not executable"
fi

# Check release-finish.sh
if [ -f "$REPO_ROOT/scripts/release-finish.sh" ]; then
    pass "release-finish.sh exists"
else
    fail "release-finish.sh missing"
fi

if [ -x "$REPO_ROOT/scripts/release-finish.sh" ]; then
    pass "release-finish.sh executable"
else
    fail "release-finish.sh not executable"
fi

# Check scripts have proper structure
if grep -q "major|minor|patch" "$REPO_ROOT/scripts/release.sh"; then
    pass "release.sh supports version bump types"
else
    fail "release.sh missing version bump types"
fi

if grep -q "version.txt" "$REPO_ROOT/scripts/release.sh"; then
    pass "release.sh reads version.txt"
else
    fail "release.sh doesn't read version.txt"
fi

if grep -q "CHANGELOG.md" "$REPO_ROOT/scripts/release.sh"; then
    pass "release.sh updates CHANGELOG.md"
else
    fail "release.sh doesn't update CHANGELOG.md"
fi

if grep -q "git tag" "$REPO_ROOT/scripts/release-finish.sh"; then
    pass "release-finish.sh creates git tag"
else
    fail "release-finish.sh doesn't create git tag"
fi

if grep -q "git push" "$REPO_ROOT/scripts/release-finish.sh"; then
    pass "release-finish.sh pushes to remote"
else
    fail "release-finish.sh doesn't push to remote"
fi

summary
