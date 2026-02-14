#!/bin/bash

# Test script for Workflow UI
# Ensures all testing standards are met

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     Workflow UI Test Suite                                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Navigate to UI directory
cd "$(dirname "$0")/.."

# Function to run a test with status
run_test() {
    local name=$1
    local command=$2

    echo -n "Running $name... "

    if eval $command > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        return 1
    fi
}

# 1. Type checking
echo "1. Type Checking"
run_test "TypeScript compilation" "npm run typecheck"

# 2. Linting
echo ""
echo "2. Code Quality"
run_test "ESLint" "npm run lint"
run_test "Prettier formatting" "npx prettier --check 'src/**/*.{ts,tsx}'"

# 3. Unit tests
echo ""
echo "3. Unit Tests"
if npm test -- --run 2>&1 | grep -q "FAIL"; then
    echo -e "${RED}✗ Unit tests failed${NC}"
    npm test -- --run
    exit 1
else
    echo -e "${GREEN}✓ All unit tests passed${NC}"
fi

# 4. Test coverage
echo ""
echo "4. Test Coverage"
npm run test:coverage > coverage.tmp 2>&1
COVERAGE=$(grep "All files" coverage.tmp | awk '{print $10}')
rm coverage.tmp

if [ -z "$COVERAGE" ]; then
    echo -e "${YELLOW}⚠ Could not determine coverage${NC}"
else
    COVERAGE_NUM=${COVERAGE%\%}
    if (( $(echo "$COVERAGE_NUM > 80" | bc -l) )); then
        echo -e "${GREEN}✓ Coverage: $COVERAGE (meets 80% threshold)${NC}"
    else
        echo -e "${RED}✗ Coverage: $COVERAGE (below 80% threshold)${NC}"
        exit 1
    fi
fi

# 5. Build test
echo ""
echo "5. Production Build"
run_test "Vite build" "npm run build"

# 6. Dependencies check
echo ""
echo "6. Dependencies"
run_test "No missing dependencies" "npm ls --depth=0"
run_test "No security vulnerabilities" "npm audit --audit-level=high"

# 7. Documentation check
echo ""
echo "7. Documentation"
if [ -f "README.md" ]; then
    echo -e "${GREEN}✓ README.md exists${NC}"
else
    echo -e "${RED}✗ README.md missing${NC}"
    exit 1
fi

if [ -d "docs" ]; then
    echo -e "${GREEN}✓ Documentation directory exists${NC}"
else
    echo -e "${YELLOW}⚠ Documentation directory missing${NC}"
fi

# Summary
echo ""
echo "════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ All tests passed!${NC}"
echo ""
echo "Next steps:"
echo "  1. Start development server: npm run dev"
echo "  2. Start backend server: cd server && npm run dev"
echo "  3. Connect Claude Code: workflow-ui connect"
echo "════════════════════════════════════════════════════════════════"