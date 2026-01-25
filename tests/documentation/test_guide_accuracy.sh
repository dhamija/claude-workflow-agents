#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: GUIDE.md Accuracy"

GUIDE="$REPO_ROOT/GUIDE.md"

if [ ! -f "$GUIDE" ]; then
    fail "GUIDE.md not found"
    summary
    exit 1
fi

# Check it's concise (quick reference should be < 300 lines)
line_count=$(wc -l < "$GUIDE")
if [ "$line_count" -lt 300 ]; then
    pass "GUIDE.md is concise ($line_count lines)"
else
    warn "GUIDE.md might be too long for quick reference ($line_count lines)"
fi

# Check essential content
ESSENTIAL=(
    "/agent-wf-help"
    "Greenfield\|New"
    "Brownfield\|Existing"
    "agents"
    "commands"
)

for item in "${ESSENTIAL[@]}"; do
    if grep -qE "$item" "$GUIDE"; then
        pass "GUIDE mentions: $item"
    else
        fail "GUIDE missing: $item"
    fi
done

summary
