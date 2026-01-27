#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Init - Preserves Existing Content"

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

# Create project with existing CLAUDE.md
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

cat > "CLAUDE.md" << 'EXISTING_CONTENT'
# My Project

Important content that must be preserved.

## My Notes

- Note 1
- Note 2
EXISTING_CONTENT

# Run init
"$HOME/.claude-workflow-agents/bin/workflow-init" << EOF
y
EOF

# Verify workflow added
grep -q "🔄 Workflow Active" "CLAUDE.md" && pass "Workflow marker added" || fail "Workflow marker missing"
grep -q "type: greenfield" "CLAUDE.md" && pass "Type set" || fail "Type missing"
grep -q "Skills (Loaded On-Demand)" "CLAUDE.md" && pass "Skills section added" || fail "Missing skills section"

# Verify content preserved
grep -q "Important content that must be preserved" "CLAUDE.md" && pass "Content preserved" || fail "Content lost"
grep -q "Note 1" "CLAUDE.md" && pass "Notes preserved" || fail "Notes lost"

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
