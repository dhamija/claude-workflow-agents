#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Complete Documentation Sync"

# ============================================================
# CLAUDE.md checks
# ============================================================

info "Checking CLAUDE.md..."

CLAUDE_MD="$REPO_ROOT/CLAUDE.md"

if [ ! -f "$CLAUDE_MD" ]; then
    fail "CLAUDE.md not found"
else
    pass "CLAUDE.md exists"

    # Check all agents listed
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        if grep -q "$agent_name" "$CLAUDE_MD"; then
            pass "CLAUDE.md lists agent: $agent_name"
        else
            fail "CLAUDE.md missing agent: $agent_name"
        fi
    done

    # Check all commands listed
    for cmd_file in "$REPO_ROOT/commands"/*.md; do
        cmd_name=$(basename "$cmd_file" .md)
        if grep -q "$cmd_name" "$CLAUDE_MD"; then
            pass "CLAUDE.md lists command: $cmd_name"
        else
            fail "CLAUDE.md missing command: $cmd_name"
        fi
    done
fi

# ============================================================
# Help command checks
# ============================================================

info "Checking help command..."

HELP_FILE="$REPO_ROOT/commands/agent-wf-help.md"

for agent_file in "$REPO_ROOT/agents"/*.md; do
    agent_name=$(basename "$agent_file" .md)
    # Convert hyphens to spaces for matching
    agent_display=$(echo "$agent_name" | sed 's/-/ /g')
    if grep -qiE "$agent_name|$agent_display" "$HELP_FILE" 2>/dev/null; then
        pass "Help includes agent: $agent_name"
    else
        fail "Help missing agent: $agent_name"
    fi
done

for cmd_file in "$REPO_ROOT/commands"/*.md; do
    cmd_name=$(basename "$cmd_file" .md)
    [ "$cmd_name" = "agent-wf-help" ] && continue
    if grep -qiE "/$cmd_name|$cmd_name" "$HELP_FILE" 2>/dev/null; then
        pass "Help includes command: $cmd_name"
    else
        warn "Help missing command: $cmd_name"
    fi
done

# ============================================================
# README checks
# ============================================================

info "Checking README.md..."

README="$REPO_ROOT/README.md"

# Check for key agents (not all, as README may be selective)
KEY_AGENTS=("intent-guardian" "ux-architect" "backend-engineer" "ci-cd-engineer")
for agent in "${KEY_AGENTS[@]}"; do
    if grep -qi "$agent" "$README" 2>/dev/null; then
        pass "README includes key agent: $agent"
    else
        warn "README missing key agent: $agent"
    fi
done

# ============================================================
# Test file checks
# ============================================================

info "Checking test files..."

AGENTS_TEST="$REPO_ROOT/tests/structural/test_agents_exist.sh"

if [ -f "$AGENTS_TEST" ]; then
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        if grep -q "\"$agent_name\"" "$AGENTS_TEST"; then
            pass "Tests include agent: $agent_name"
        else
            fail "Tests missing agent: $agent_name"
        fi
    done
else
    skip "Agent test file not found"
fi

COMMANDS_TEST="$REPO_ROOT/tests/structural/test_commands_exist.sh"

if [ -f "$COMMANDS_TEST" ]; then
    for cmd_file in "$REPO_ROOT/commands"/*.md; do
        cmd_name=$(basename "$cmd_file" .md)
        if grep -q "\"$cmd_name\"" "$COMMANDS_TEST"; then
            pass "Tests include command: $cmd_name"
        else
            fail "Tests missing command: $cmd_name"
        fi
    done
else
    skip "Command test file not found"
fi

# ============================================================
# STATE.md checks
# ============================================================

info "Checking STATE.md..."

STATE_MD="$REPO_ROOT/STATE.md"

if [ ! -f "$STATE_MD" ]; then
    warn "STATE.md not found"
else
    pass "STATE.md exists"

    # Check all agents in state
    for agent_file in "$REPO_ROOT/agents"/*.md; do
        agent_name=$(basename "$agent_file" .md)
        if grep -q "$agent_name" "$STATE_MD"; then
            pass "STATE.md lists agent: $agent_name"
        else
            fail "STATE.md missing agent: $agent_name"
        fi
    done
fi

summary
