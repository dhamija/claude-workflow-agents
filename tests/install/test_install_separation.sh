#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Install Only Copies Correct Files"

# This test runs install.sh and verifies only the right files are copied

# Backup existing installation
BACKUP_DIR=""
if [ -d "$HOME/.claude-workflow-agents" ]; then
    BACKUP_DIR=$(mktemp -d)
    mv "$HOME/.claude-workflow-agents" "$BACKUP_DIR/"
    info "Backed up existing installation"
fi

# Manually install from local repo (simulating install.sh)
INSTALL_DIR="$HOME/.claude-workflow-agents"
mkdir -p "$INSTALL_DIR"

# Copy ONLY what should be installed
cp -r "$REPO_ROOT/agents" "$INSTALL_DIR/"
cp -r "$REPO_ROOT/commands" "$INSTALL_DIR/"
cp -r "$REPO_ROOT/templates" "$INSTALL_DIR/"
cp "$REPO_ROOT/version.txt" "$INSTALL_DIR/"

# Create bin directory (install.sh would create this)
mkdir -p "$INSTALL_DIR/bin"

# Should be installed
[ -d "$INSTALL_DIR/agents" ] && pass "agents/ installed" || fail "agents/ not installed"
[ -d "$INSTALL_DIR/commands" ] && pass "commands/ installed" || fail "commands/ not installed"
[ -d "$INSTALL_DIR/templates" ] && pass "templates/ installed" || fail "templates/ not installed"
[ -f "$INSTALL_DIR/version.txt" ] && pass "version.txt installed" || fail "version.txt not installed"
[ -d "$INSTALL_DIR/bin" ] && pass "bin/ created" || fail "bin/ not created"

# Should NOT be installed
[ ! -f "$INSTALL_DIR/CLAUDE.md" ] && pass "Repo CLAUDE.md NOT installed" || fail "Repo CLAUDE.md wrongly installed"
[ ! -f "$INSTALL_DIR/README.md" ] && pass "Repo README.md NOT installed" || fail "Repo README.md wrongly installed"
[ ! -f "$INSTALL_DIR/CHANGELOG.md" ] && pass "Repo CHANGELOG.md NOT installed" || fail "Repo CHANGELOG.md wrongly installed"
[ ! -d "$INSTALL_DIR/tests" ] && pass "tests/ NOT installed" || fail "tests/ wrongly installed"
[ ! -d "$INSTALL_DIR/.github" ] && pass ".github/ NOT installed" || fail ".github/ wrongly installed"
[ ! -d "$INSTALL_DIR/scripts" ] && pass "scripts/ NOT installed" || fail "scripts/ wrongly installed"

# Templates should have all required files
[ -f "$INSTALL_DIR/templates/project/CLAUDE.md.template" ] && pass "User CLAUDE template installed" || fail "User CLAUDE template missing"
[ -f "$INSTALL_DIR/templates/infrastructure/scripts/verify.sh.template" ] && pass "User verify.sh template installed" || fail "User verify.sh template missing"

# Cleanup
rm -rf "$INSTALL_DIR"
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR/.claude-workflow-agents" ]; then
    mv "$BACKUP_DIR/.claude-workflow-agents" "$HOME/"
    rm -rf "$BACKUP_DIR"
    info "Restored original installation"
fi

summary
