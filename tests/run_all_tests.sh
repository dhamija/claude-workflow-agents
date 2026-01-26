#!/bin/bash

# Master test runner for claude-workflow-agents

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          CLAUDE WORKFLOW AGENTS - TEST SUITE                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_SKIP=0
FAILED_TESTS=()

# Run a test file and capture results
run_test() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .sh)

    echo -e "${BLUE}Running: $test_name${NC}"

    if bash "$test_file"; then
        echo -e "${GREEN}✓ $test_name completed${NC}"
    else
        echo -e "${RED}✗ $test_name had failures${NC}"
        FAILED_TESTS+=("$test_name")
    fi
    echo ""
}

# Run all tests in a category
run_category() {
    local category="$1"
    local category_dir="$SCRIPT_DIR/$category"

    if [ ! -d "$category_dir" ]; then
        echo -e "${YELLOW}Skipping $category (directory not found)${NC}"
        return
    fi

    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo -e "${BLUE}Category: $(echo $category | tr '[:lower:]' '[:upper:]')${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo ""

    for test_file in "$category_dir"/test_*.sh; do
        if [ -f "$test_file" ]; then
            run_test "$test_file"
        fi
    done
}

# Parse arguments
CATEGORIES=("structural" "content" "consistency" "documentation" "integration" "install" "workflow")
SELECTED_CATEGORIES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --structural)
            SELECTED_CATEGORIES+=("structural")
            shift
            ;;
        --content)
            SELECTED_CATEGORIES+=("content")
            shift
            ;;
        --consistency)
            SELECTED_CATEGORIES+=("consistency")
            shift
            ;;
        --documentation)
            SELECTED_CATEGORIES+=("documentation")
            shift
            ;;
        --integration)
            SELECTED_CATEGORIES+=("integration")
            shift
            ;;
        --install)
            SELECTED_CATEGORIES+=("install")
            shift
            ;;
        --workflow)
            SELECTED_CATEGORIES+=("workflow")
            shift
            ;;
        --all)
            SELECTED_CATEGORIES=("${CATEGORIES[@]}")
            shift
            ;;
        --help)
            echo "Usage: ./run_all_tests.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --structural      Run structural tests"
            echo "  --content         Run content tests"
            echo "  --consistency     Run consistency tests"
            echo "  --documentation   Run documentation tests"
            echo "  --integration     Run integration tests"
            echo "  --install         Run install/uninstall tests"
            echo "  --workflow        Run workflow toggle tests"
            echo "  --all             Run all tests (default)"
            echo "  --help            Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Default to all
if [ ${#SELECTED_CATEGORIES[@]} -eq 0 ]; then
    SELECTED_CATEGORIES=("${CATEGORIES[@]}")
fi

# Run selected categories
for category in "${SELECTED_CATEGORIES[@]}"; do
    run_category "$category"
done

# Final summary
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    FINAL SUMMARY                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
    echo -e "${GREEN}All test categories passed!${NC}"
    exit 0
else
    echo -e "${RED}Failed test files:${NC}"
    for test in "${FAILED_TESTS[@]}"; do
        echo -e "  ${RED}✗${NC} $test"
    done
    echo ""
    echo -e "${RED}Some tests failed. Please fix issues and re-run.${NC}"
    exit 1
fi
