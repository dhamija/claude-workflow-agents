#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: EXAMPLES.md Validity"

EXAMPLES="$REPO_ROOT/EXAMPLES.md"

if [ ! -f "$EXAMPLES" ]; then
    fail "EXAMPLES.md not found"
    summary
    exit 1
fi

# Count examples
example_headers=$(grep -c "^## Example" "$EXAMPLES")
if [ "$example_headers" -ge 5 ]; then
    pass "EXAMPLES has sufficient examples ($example_headers)"
else
    fail "EXAMPLES needs more examples (found $example_headers, need at least 5)"
fi

# Check for variety
EXAMPLE_TYPES=(
    "Simple\|Todo\|Basic"
    "Complex\|E-Commerce\|Platform"
    "Brownfield\|Existing\|Improve"
    "Bug\|Debug\|Fix"
    "Review\|Release"
)

for type in "${EXAMPLE_TYPES[@]}"; do
    if grep -qiE "$type" "$EXAMPLES"; then
        pass "EXAMPLES covers: $type"
    else
        warn "EXAMPLES might not cover: $type"
    fi
done

# Check examples have both user and claude responses
if grep -qE "^You:|^User:" "$EXAMPLES" && grep -qE "^Claude:" "$EXAMPLES"; then
    pass "EXAMPLES show conversation format"
else
    fail "EXAMPLES should show conversation format (You/Claude)"
fi

summary
