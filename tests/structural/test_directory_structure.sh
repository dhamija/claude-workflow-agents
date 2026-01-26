#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Directory Structure"

# Required directories
REQUIRED_DIRS=(
    "agents"
    "commands"
    "templates"
    "templates/project"
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
    "templates/infrastructure"
    "templates/infrastructure/scripts"
    "templates/infrastructure/github"
    "templates/infrastructure/github/workflows"
    "templates/release"
    "tests"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    assert_dir_exists "$REPO_ROOT/$dir"
done

# Check key templates
assert_file_exists "$REPO_ROOT/templates/project/CLAUDE.md.template"
assert_file_exists "$REPO_ROOT/templates/project/README.md.template"
assert_file_exists "$REPO_ROOT/templates/release/CHANGELOG.md.template"
assert_file_exists "$REPO_ROOT/templates/infrastructure/scripts/verify.sh.template"

summary
