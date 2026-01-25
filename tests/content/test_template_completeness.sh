#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Template Completeness"

TEMPLATE="$REPO_ROOT/templates/CLAUDE.md.template"

if [ ! -f "$TEMPLATE" ]; then
    fail "CLAUDE.md.template not found"
    summary
    exit 1
fi

# Check for required sections
REQUIRED_SECTIONS=(
    "AI Workflow Instructions"
    "Development Modes"
    "Sequential"
    "Parallel"
    "Detecting User Intent"
    "Greenfield"
    "Brownfield"
    "Document Structure"
    "Current State"
)

for section in "${REQUIRED_SECTIONS[@]}"; do
    assert_file_contains "$TEMPLATE" "$section" "Template has section: $section"
done

summary
