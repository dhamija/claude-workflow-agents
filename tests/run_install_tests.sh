#!/bin/bash

# Run all install/uninstall tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Running Install/Uninstall Tests"
echo "================================"
echo ""

FAILED=0

for test in "$SCRIPT_DIR"/install/test_*.sh; do
    [ -f "$test" ] || continue
    echo "Running: $(basename "$test")"
    if bash "$test"; then
        echo "  PASSED"
    else
        echo "  FAILED"
        ((FAILED++))
    fi
    echo ""
done

for test in "$SCRIPT_DIR"/workflow/test_*.sh; do
    [ -f "$test" ] || continue
    echo "Running: $(basename "$test")"
    if bash "$test"; then
        echo "  PASSED"
    else
        echo "  FAILED"
        ((FAILED++))
    fi
    echo ""
done

echo "================================"
if [ $FAILED -eq 0 ]; then
    echo "All tests passed ✓"
    exit 0
else
    echo "$FAILED test(s) failed ✗"
    exit 1
fi
