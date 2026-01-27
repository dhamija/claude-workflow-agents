#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Init - Greenfield"

# Backup existing installation
BACKUP_DIR=""
if [ -d "$HOME/.claude-workflow-agents" ]; then
    BACKUP_DIR=$(mktemp -d)
    mv "$HOME/.claude-workflow-agents" "$BACKUP_DIR/"
    info "Backed up existing installation"
fi

# Manually install from local repo
INSTALL_DIR="$HOME/.claude-workflow-agents"
mkdir -p "$INSTALL_DIR"

cp -r "$REPO_ROOT/agents" "$INSTALL_DIR/"
cp -r "$REPO_ROOT/commands" "$INSTALL_DIR/"
cp -r "$REPO_ROOT/templates" "$INSTALL_DIR/"
cp "$REPO_ROOT/version.txt" "$INSTALL_DIR/"

# Create bin directory and copy workflow-init script
mkdir -p "$INSTALL_DIR/bin"

# Extract workflow-init from install.sh
# Find the heredoc content between 'SCRIPT' markers
sed -n '/^cat > "\$INSTALL_DIR\/bin\/workflow-init" << .SCRIPT./,/^SCRIPT$/p' "$REPO_ROOT/install.sh" | \
    sed '1d;$d' > "$INSTALL_DIR/bin/workflow-init"
chmod +x "$INSTALL_DIR/bin/workflow-init"

# Create empty project
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Run init
"$HOME/.claude-workflow-agents/bin/workflow-init" << EOF
y
EOF

# Verify
[ -f "CLAUDE.md" ] && pass "CLAUDE.md created" || fail "CLAUDE.md missing"
grep -q "WORKFLOW BOOTSTRAP" "CLAUDE.md" && pass "Has bootstrap comment" || fail "Missing bootstrap"
grep -q "type: greenfield" "CLAUDE.md" && pass "Detected as greenfield" || fail "Wrong type"
grep -q "intent-guardian" "CLAUDE.md" && pass "References intent-guardian" || fail "Missing agent reference"
grep -q "workflow-orchestrator" "CLAUDE.md" && pass "References orchestrator" || fail "Missing orchestrator"
grep -q "status: not_started" "CLAUDE.md" && pass "Initial status correct" || fail "Wrong status"
grep -q "phase: L1" "CLAUDE.md" && pass "Phase set to L1" || fail "Wrong phase"

# Cleanup
rm -rf "$TEST_DIR"

# Restore installation
rm -rf "$HOME/.claude-workflow-agents"
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR/.claude-workflow-agents" ]; then
    mv "$BACKUP_DIR/.claude-workflow-agents" "$HOME/"
    rm -rf "$BACKUP_DIR"
    info "Restored original installation"
fi

summary
