#!/bin/bash

# Test that git workflow documentation exists in correct files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"
COMMANDS_DIR="$SCRIPT_DIR/commands"

PASS=0
FAIL=0

echo "Testing git workflow documentation..."
echo ""

# Test 1: Check agents/project-ops.md has Git Workflow section
echo "Checking agents/project-ops.md..."
if grep -q "## Git Workflow" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has Git Workflow section"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING Git Workflow section"
    ((FAIL++))
fi

if grep -q "### Commit Conventions" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has Commit Conventions subsection"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING Commit Conventions subsection"
    ((FAIL++))
fi

if grep -q "### Branch Naming" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has Branch Naming subsection"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING Branch Naming subsection"
    ((FAIL++))
fi

if grep -q "### Commit Helper" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has Commit Helper subsection"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING Commit Helper subsection"
    ((FAIL++))
fi

if grep -q "### PR Helper" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has PR Helper subsection"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING PR Helper subsection"
    ((FAIL++))
fi

echo ""

# Test 2: Check commands/project.md has git subcommands
echo "Checking commands/project.md..."
if grep -q "/project commit" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md documents /project commit"
    ((PASS++))
else
    echo "✗ project.md MISSING /project commit"
    ((FAIL++))
fi

if grep -q "/project push" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md documents /project push"
    ((PASS++))
else
    echo "✗ project.md MISSING /project push"
    ((FAIL++))
fi

if grep -q "/project pr" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md documents /project pr"
    ((PASS++))
else
    echo "✗ project.md MISSING /project pr"
    ((FAIL++))
fi

if grep -q "### /project commit" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md has /project commit section"
    ((PASS++))
else
    echo "✗ project.md MISSING /project commit section"
    ((FAIL++))
fi

if grep -q "### /project push" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md has /project push section"
    ((PASS++))
else
    echo "✗ project.md MISSING /project push section"
    ((FAIL++))
fi

if grep -q "### /project pr" "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md has /project pr section"
    ((PASS++))
else
    echo "✗ project.md MISSING /project pr section"
    ((FAIL++))
fi

# Check routing logic includes git commands
if grep -q 'subcommand == "commit"' "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md routing includes commit"
    ((PASS++))
else
    echo "✗ project.md routing MISSING commit"
    ((FAIL++))
fi

if grep -q 'subcommand == "push"' "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md routing includes push"
    ((PASS++))
else
    echo "✗ project.md routing MISSING push"
    ((FAIL++))
fi

if grep -q 'subcommand == "pr"' "$COMMANDS_DIR/project.md"; then
    echo "✓ project.md routing includes pr"
    ((PASS++))
else
    echo "✗ project.md routing MISSING pr"
    ((FAIL++))
fi

echo ""

# Test 3: Check commands/help.md has git topic
echo "Checking commands/help.md..."
if grep -q '| `git`' "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md lists git topic in Available Topics"
    ((PASS++))
else
    echo "✗ help.md MISSING git topic in Available Topics"
    ((FAIL++))
fi

if grep -q '/help git' "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md references /help git"
    ((PASS++))
else
    echo "✗ help.md MISSING /help git reference"
    ((FAIL++))
fi

if grep -q 'If topic = "git":' "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md has git topic section"
    ((PASS++))
else
    echo "✗ help.md MISSING git topic section"
    ((FAIL++))
fi

if grep -q "CONVENTIONAL COMMITS" "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md git section has CONVENTIONAL COMMITS"
    ((PASS++))
else
    echo "✗ help.md git section MISSING CONVENTIONAL COMMITS"
    ((FAIL++))
fi

if grep -q "BRANCH NAMING" "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md git section has BRANCH NAMING"
    ((PASS++))
else
    echo "✗ help.md git section MISSING BRANCH NAMING"
    ((FAIL++))
fi

if grep -q "PULL REQUEST HELPER" "$COMMANDS_DIR/help.md"; then
    echo "✓ help.md git section has PULL REQUEST HELPER"
    ((PASS++))
else
    echo "✗ help.md git section MISSING PULL REQUEST HELPER"
    ((FAIL++))
fi

echo ""

# Test 4: Check commit type examples
echo "Checking commit type documentation..."
for type in feat fix refactor docs test chore; do
    if grep -q "\`$type\`" "$AGENTS_DIR/project-ops.md" || grep -q "| \`$type\`" "$AGENTS_DIR/project-ops.md"; then
        echo "✓ project-ops.md documents commit type: $type"
        ((PASS++))
    else
        echo "✗ project-ops.md MISSING commit type: $type"
        ((FAIL++))
    fi
done

echo ""

# Test 5: Check branch naming examples
echo "Checking branch naming documentation..."
if grep -q "feature/" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has feature/ branch examples"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING feature/ branch examples"
    ((FAIL++))
fi

if grep -q "fix/" "$AGENTS_DIR/project-ops.md"; then
    echo "✓ project-ops.md has fix/ branch examples"
    ((PASS++))
else
    echo "✗ project-ops.md MISSING fix/ branch examples"
    ((FAIL++))
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
