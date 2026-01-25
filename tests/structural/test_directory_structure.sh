#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Directory Structure"

# Required directories
REQUIRED_DIRS=(
    "agents"
    "commands"
    "templates"
    "templates/docs"
    "templates/docs/intent"
    "templates/docs/ux"
    "templates/docs/architecture"
    "templates/docs/plans"
    "templates/docs/plans/overview"
    "templates/docs/plans/features"
    "templates/docs/gaps"
    "templates/docs/changes"
    "templates/docs/verification"
    "tests"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    assert_dir_exists "$REPO_ROOT/$dir"
done

# Check templates
assert_file_exists "$REPO_ROOT/templates/CLAUDE.md.template"

summary
