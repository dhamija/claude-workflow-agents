#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: README.md Completeness"

README="$REPO_ROOT/README.md"

if [ ! -f "$README" ]; then
    fail "README.md not found"
    summary
    exit 1
fi

# Required sections
REQUIRED_SECTIONS=(
    "Quick Start"
    "Installation"
    "Usage"
    "Greenfield\|New Project"
    "Brownfield\|Existing"
    "Commands"
    "Agents\|agents"
    "FAQ\|Frequently"
)

for section in "${REQUIRED_SECTIONS[@]}"; do
    if grep -qiE "$section" "$README"; then
        pass "README has section: $section"
    else
        fail "README missing section: $section"
    fi
done

# Check for examples
example_count=$(grep -c '```' "$README")
if [ "$example_count" -ge 10 ]; then
    pass "README has sufficient code examples ($example_count blocks)"
else
    warn "README might need more code examples (found $example_count)"
fi

summary
