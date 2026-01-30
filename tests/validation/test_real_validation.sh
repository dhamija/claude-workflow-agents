#!/bin/bash

# Test: Prove that real validation using Bash tool actually works
# This demonstrates the difference between fake and real validation

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           REAL VALIDATION TEST                                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Create a simple test project
TEST_DIR="/tmp/validation-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Creating test project..."

# Create a simple package.json
cat > package.json << 'EOF'
{
  "name": "validation-test",
  "version": "1.0.0",
  "scripts": {
    "test": "node test.js",
    "test:fail": "node test-fail.js"
  }
}
EOF

# Create a passing test
cat > test.js << 'EOF'
console.log("Running tests...");
console.log("✓ Test 1: Promise validation works");
console.log("✓ Test 2: Feature actually functions");
console.log("✓ Test 3: User can use the feature");
console.log("\nAll tests passed!");
process.exit(0);
EOF

# Create a failing test
cat > test-fail.js << 'EOF'
console.log("Running tests...");
console.log("✓ Test 1: Promise validation works");
console.error("✗ Test 2: Feature is BROKEN!");
console.error("  Error: Backend API returns 500");
console.error("  Expected: 200 OK");
console.error("  Actual: 500 Internal Server Error");
console.log("\nTests FAILED!");
process.exit(1);
EOF

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "DEMONSTRATION: Fake vs Real Validation"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "1. FAKE VALIDATION (what agents currently do):"
echo "───────────────────────────────────────────────"
echo "Agent says: 'Running tests...'"
echo "Agent says: '✓ All tests would pass'"
echo "Agent says: '✓ Feature implementation successful'"
echo "Agent says: '✓ Promise PRM-001 validated'"
echo ""
echo "Result: Everything looks great! (but it's fiction)"
echo ""

echo "2. REAL VALIDATION (using Bash tool):"
echo "───────────────────────────────────────────────"
echo "Actually running passing tests..."
npm test 2>&1 || true
echo ""

echo "3. REAL VALIDATION catching actual failures:"
echo "───────────────────────────────────────────────"
echo "Actually running failing tests..."
npm run test:fail 2>&1 || true
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "THE DIFFERENCE:"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✗ FAKE: Always reports success (dangerous illusion)"
echo "✓ REAL: Shows actual results (truth)"
echo ""
echo "With real validation:"
echo "- We know when things actually work"
echo "- We catch real failures immediately"
echo "- No illusion of progress"
echo "- Honest feedback loop"
echo ""

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo "Test complete. Real validation is possible and necessary!"