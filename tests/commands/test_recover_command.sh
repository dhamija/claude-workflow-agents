#!/bin/bash

# Test: Verify /recover command exists and has proper structure

set -e

echo "Testing /recover command..."

COMMAND_FILE="../../commands/recover.md"

# Check file exists
if [ ! -f "$COMMAND_FILE" ]; then
  echo "❌ /recover command file not found"
  exit 1
fi

echo "✓ Command file exists"

# Check has required frontmatter
if ! grep -q "^name: recover" "$COMMAND_FILE"; then
  echo "❌ Missing name in frontmatter"
  exit 1
fi

echo "✓ Has name in frontmatter"

# Check has description
if ! grep -q "^description:" "$COMMAND_FILE"; then
  echo "❌ Missing description in frontmatter"
  exit 1
fi

echo "✓ Has description"

# Check references all 5 phases
phases=("audit" "tests" "triage" "fix" "lock")
for phase in "${phases[@]}"; do
  if ! grep -q "$phase" "$COMMAND_FILE"; then
    echo "❌ Missing phase: $phase"
    exit 1
  fi
  echo "✓ Includes phase: $phase"
done

# Check emphasizes real validation
if ! grep -q "Bash tool" "$COMMAND_FILE"; then
  echo "❌ Doesn't mention using Bash tool"
  exit 1
fi

echo "✓ Emphasizes using Bash tool for real validation"

# Check links to reality-audit
if grep -q "reality.audit" "../commands/reality-audit.md"; then
  echo "✓ Reality-audit links back to recover"
fi

echo ""
echo "✅ /recover command properly configured"
echo ""
echo "The recovery workflow can be triggered with:"
echo "  /recover         - Start full recovery"
echo "  /recover audit   - Start with reality audit"
echo "  /recover tests   - Create test infrastructure"
echo "  /recover fix     - Fix broken features"