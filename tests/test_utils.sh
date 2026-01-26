#!/bin/bash

# Shared test utilities

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
SKIP=0
WARNINGS=0

# Get repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Test result functions
pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASS++))
    return 0
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAIL++))
    return 1
}

skip() {
    echo -e "${YELLOW}⊘ SKIP${NC}: $1"
    ((SKIP++))
}

warn() {
    echo -e "${YELLOW}⚠ WARN${NC}: $1"
    ((WARNINGS++))
}

info() {
    echo -e "${BLUE}ℹ INFO${NC}: $1"
}

# Section header
section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${BLUE}$1${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Print summary
summary() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "                      TEST SUMMARY"
    echo "════════════════════════════════════════════════════════════"
    echo -e "  ${GREEN}Passed${NC}:   $PASS"
    echo -e "  ${RED}Failed${NC}:   $FAIL"
    echo -e "  ${YELLOW}Skipped${NC}:  $SKIP"
    echo -e "  ${YELLOW}Warnings${NC}: $WARNINGS"
    echo "════════════════════════════════════════════════════════════"

    if [ $FAIL -gt 0 ]; then
        echo -e "${RED}TESTS FAILED${NC}"
        return 1
    else
        echo -e "${GREEN}ALL TESTS PASSED${NC}"
        return 0
    fi
}

# Check file exists
assert_file_exists() {
    if [ -f "$1" ]; then
        pass "File exists: $1"
        return 0
    else
        fail "File missing: $1"
        return 1
    fi
}

# Check directory exists
assert_dir_exists() {
    if [ -d "$1" ]; then
        pass "Directory exists: $1"
        return 0
    else
        fail "Directory missing: $1"
        return 1
    fi
}

# Check file contains string
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local description="${3:-Pattern found}"

    if grep -q "$pattern" "$file" 2>/dev/null; then
        pass "$description"
        return 0
    else
        fail "$description (pattern not found: $pattern)"
        return 1
    fi
}

# Check file contains all strings
assert_file_contains_all() {
    local file="$1"
    shift
    local patterns=("$@")
    local all_found=true

    for pattern in "${patterns[@]}"; do
        if ! grep -q "$pattern" "$file" 2>/dev/null; then
            fail "Missing in $file: $pattern"
            all_found=false
        fi
    done

    if $all_found; then
        pass "All patterns found in $file"
        return 0
    fi
    return 1
}

# Check frontmatter exists and has field
assert_frontmatter_field() {
    local file="$1"
    local field="$2"

    # Check file starts with ---
    if ! head -1 "$file" | grep -q "^---$"; then
        fail "No frontmatter in $file"
        return 1
    fi

    # Check field exists in frontmatter
    if sed -n '/^---$/,/^---$/p' "$file" | grep -q "^${field}:"; then
        pass "Frontmatter field '$field' in $file"
        return 0
    else
        fail "Missing frontmatter field '$field' in $file"
        return 1
    fi
}

# Count occurrences
count_occurrences() {
    local file="$1"
    local pattern="$2"
    grep -c "$pattern" "$file" 2>/dev/null || echo "0"
}

# Export functions
export -f pass fail skip warn info section summary
export -f assert_file_exists assert_dir_exists assert_file_contains
export -f assert_file_contains_all assert_frontmatter_field count_occurrences
export REPO_ROOT PASS FAIL SKIP WARNINGS
export RED GREEN YELLOW BLUE NC
