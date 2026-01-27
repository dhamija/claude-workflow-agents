#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Workflow Init - Brownfield"

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

# Create project with code
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

mkdir -p src/components src/api
echo '{"name": "test", "dependencies": {"react": "^18.0.0"}}' > package.json
echo "export function App() { return <div>Hello</div> }" > src/components/App.tsx
echo "export function auth() {}" > src/api/auth.ts

# Run init
"$HOME/.claude-workflow-agents/bin/workflow-init" << EOF
y
EOF

# Verify
[ -f "CLAUDE.md" ] && pass "CLAUDE.md created" || fail "CLAUDE.md missing"
grep -q "type: brownfield" "CLAUDE.md" && pass "Detected as brownfield" || fail "Wrong type"
grep -q "brownfield.*- Existing codebase" "CLAUDE.md" && pass "References brownfield skill" || fail "Missing brownfield skill reference"
grep -q "phase: analysis" "CLAUDE.md" && pass "Starts in analysis phase" || fail "Wrong phase"
grep -q "Load brownfield skill" "CLAUDE.md" && pass "Instructions to analyze" || fail "Missing analysis instructions"

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
