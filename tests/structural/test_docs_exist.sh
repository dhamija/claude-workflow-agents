#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: All Documentation Files Exist"

# Required documentation
REQUIRED_DOCS=(
    "README.md"
    "GUIDE.md"
    "WORKFLOW.md"
    "EXAMPLES.md"
    "LICENSE"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    assert_file_exists "$REPO_ROOT/$doc"
done

summary
