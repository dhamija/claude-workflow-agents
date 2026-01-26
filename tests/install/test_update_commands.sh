#!/bin/bash

# Test update commands exist in install.sh

source "$(dirname "$0")/../test_utils.sh"

section "Test: Update Commands in install.sh"

INSTALL_SCRIPT="$REPO_ROOT/install.sh"

# Check install.sh exists
if [ -f "$INSTALL_SCRIPT" ]; then
    pass "install.sh exists"
else
    fail "install.sh missing"
    summary
    exit 1
fi

# Check each command is defined
if grep -q "workflow-init" "$INSTALL_SCRIPT"; then
    pass "workflow-init defined in install.sh"
else
    fail "workflow-init missing from install.sh"
fi

if grep -q "workflow-remove" "$INSTALL_SCRIPT"; then
    pass "workflow-remove defined in install.sh"
else
    fail "workflow-remove missing from install.sh"
fi

if grep -q "workflow-update" "$INSTALL_SCRIPT"; then
    pass "workflow-update defined in install.sh"
else
    fail "workflow-update missing from install.sh"
fi

if grep -q "workflow-version" "$INSTALL_SCRIPT"; then
    pass "workflow-version defined in install.sh"
else
    fail "workflow-version missing from install.sh"
fi

if grep -q "workflow-uninstall" "$INSTALL_SCRIPT"; then
    pass "workflow-uninstall defined in install.sh"
else
    fail "workflow-uninstall missing from install.sh"
fi

# Check workflow-version has proper structure
if grep -A 5 "workflow-version" "$INSTALL_SCRIPT" | grep -q "Show version information"; then
    pass "workflow-version has description"
else
    warn "workflow-version missing description comment"
fi

if grep -A 20 "workflow-version" "$INSTALL_SCRIPT" | grep -q "INSTALL_DIR"; then
    pass "workflow-version references INSTALL_DIR"
else
    fail "workflow-version missing INSTALL_DIR reference"
fi

if grep -A 20 "workflow-version" "$INSTALL_SCRIPT" | grep -q "version.txt"; then
    pass "workflow-version reads version.txt"
else
    fail "workflow-version doesn't read version.txt"
fi

# Check workflow-update references version.txt
if grep -A 20 "workflow-update" "$INSTALL_SCRIPT" | grep -q "version.txt"; then
    pass "workflow-update reads version.txt"
else
    fail "workflow-update doesn't read version.txt"
fi

summary
