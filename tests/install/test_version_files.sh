#!/bin/bash

# Test version files exist and are valid

source "$(dirname "$0")/../test_utils.sh"

section "Test: Version Files Exist"

# Check version.txt exists
if [ -f "$REPO_ROOT/version.txt" ]; then
    pass "version.txt exists"
else
    fail "version.txt missing"
fi

# Check CHANGELOG.md exists
if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
    pass "CHANGELOG.md exists"
else
    fail "CHANGELOG.md missing"
fi

# Check version.txt format (should be semver-like)
if [ -f "$REPO_ROOT/version.txt" ]; then
    VERSION=$(cat "$REPO_ROOT/version.txt")
    if echo "$VERSION" | grep -qE "^[0-9]+\.[0-9]+\.[0-9]+$"; then
        pass "version.txt is semver format ($VERSION)"
    else
        fail "version.txt not semver format (got: $VERSION)"
    fi
fi

# Check CHANGELOG has version entry
if [ -f "$REPO_ROOT/CHANGELOG.md" ] && [ -f "$REPO_ROOT/version.txt" ]; then
    VERSION=$(cat "$REPO_ROOT/version.txt")
    if grep -q "## \[$VERSION\]" "$REPO_ROOT/CHANGELOG.md"; then
        pass "CHANGELOG has current version entry [$VERSION]"
    else
        fail "CHANGELOG missing current version entry [$VERSION]"
    fi
fi

# Check CHANGELOG has proper sections
if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
    if grep -q "### Added" "$REPO_ROOT/CHANGELOG.md"; then
        pass "CHANGELOG has ### Added section"
    else
        warn "CHANGELOG missing ### Added section"
    fi
fi

summary
