#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Documentation Internal Links"

# Check README links
README="$REPO_ROOT/README.md"

if [ -f "$README" ]; then
    info "Checking README.md links..."
    # Find markdown links [text](file.md)
    while IFS= read -r link; do
        # Extract file path
        file=$(echo "$link" | sed 's/.*](//' | sed 's/).*//' | sed 's/#.*//')

        # Skip external links
        if echo "$file" | grep -qE "^http|^mailto"; then
            continue
        fi

        # Skip anchor-only links
        if [ -z "$file" ]; then
            continue
        fi

        # Check file exists
        if [ -f "$REPO_ROOT/$file" ]; then
            pass "Link valid: $file"
        else
            fail "Broken link in README: $file"
        fi
    done < <(grep -oE '\[.*\]\([^)]+\)' "$README" 2>/dev/null || true)
fi

# Check GUIDE links
GUIDE="$REPO_ROOT/GUIDE.md"

if [ -f "$GUIDE" ]; then
    info "Checking GUIDE.md links..."
    while IFS= read -r link; do
        file=$(echo "$link" | sed 's/.*](//' | sed 's/).*//' | sed 's/#.*//')
        if echo "$file" | grep -qE "^http|^mailto|^$"; then
            continue
        fi
        if [ -f "$REPO_ROOT/$file" ]; then
            pass "Link valid: $file"
        else
            fail "Broken link in GUIDE: $file"
        fi
    done < <(grep -oE '\[.*\]\([^)]+\)' "$GUIDE" 2>/dev/null || true)
fi

summary
