#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Template Completeness"

TEMPLATE="$REPO_ROOT/templates/project/CLAUDE.md.template"

if [ ! -f "$TEMPLATE" ]; then
    fail "CLAUDE.md.template not found"
    summary
    exit 1
fi

# Check for required markers and sections
REQUIRED_SECTIONS=(
    "workflow:"
    "workflow-home:"
    "{{PROJECT_NAME}}"
    "{{PROJECT_DESCRIPTION}}"
    "Project Context"
    "Workflow"
)

for section in "${REQUIRED_SECTIONS[@]}"; do
    assert_file_contains "$TEMPLATE" "$section" "Template has: $section"
done

summary
