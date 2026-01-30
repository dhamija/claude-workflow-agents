---
name: reality-audit
description: Audit what ACTUALLY works in an existing project using real tests
---

# Reality Audit Command

For existing projects that need to discover what really works vs what's claimed to work.

## What This Command Does

Performs a brutal reality check on all promises using actual test execution.

## Process

### 1. Inventory Promises

Read the product-intent.md and list all promises:
```bash
# Find all promises
grep -E "PRM-[0-9]+" docs/intent/product-intent.md
```

### 2. Check Test Infrastructure

Determine what test commands are available:
```bash
# Check package.json for test scripts
cat package.json | grep -A5 '"scripts"'

# Try to run existing tests
npm test 2>&1 | head -20

# Check if integration tests exist
find . -name "*.test.js" -o -name "*.spec.js" | grep -E "integration|e2e|promise"
```

### 3. For Each Promise, Try to Validate

For each promise, attempt real validation:

```bash
# Example for PRM-007
echo "Validating PRM-007: Question-First Learning"

# Step 1: Check if test exists
if [ -f "tests/promises/PRM-007.test.js" ]; then
  echo "Test found, running..."
  npm test -- PRM-007
else
  echo "❌ No test exists for PRM-007"
fi

# Step 2: Try manual validation
echo "Starting app for manual check..."
npm run dev &
sleep 5

# Step 3: Try to use the feature
curl -X POST http://localhost:3001/api/conversation \
  -H "Content-Type: application/json" \
  -d '{"message": "What is that?"}' \
  | grep -q "questionDetected"

if [ $? -eq 0 ]; then
  echo "✓ Backend detects questions"
else
  echo "❌ Backend NOT detecting questions"
fi
```

### 4. Generate Reality Report

Create a reality report showing:

```markdown
# Reality Audit Report

## Summary
- Total Promises: 8
- Actually Working: 2 (25%)
- Partially Working: 1 (12.5%)
- Completely Broken: 5 (62.5%)

## Promise Status (Reality)

### ✅ Working (Can Demo Right Now)
- PRM-001: Visual vocabulary (basic version works)

### ⚠️ Partial (Some parts work)
- PRM-006: Auto-save (saves but no UI feedback)

### ❌ Broken (Would fail in demo)
- PRM-007: Question-First Learning
  - Issue: Backend doesn't detect questions
  - Missing: questionDetected logic in conversation-agent.js

- PRM-008: Response Length Matching
  - Issue: Accepts any length response
  - Missing: Validation logic

- PRM-004: Engagement Patterns
  - Issue: Not implemented at all
  - Missing: Entire feature

## Recommended Recovery Plan

1. STOP claiming these work
2. Create actual integration tests
3. Fix the broken features
4. Re-validate with real tests
```

## The Hard Truth

This command will likely reveal that 60-80% of "validated" promises are actually broken.

That's OK - knowing the truth is the first step to fixing it.