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

### 4. Generate Unified Gap Report

Create gaps in unified format and write to gap registry:

```bash
# Create gap directory structure
mkdir -p docs/gaps/discovered docs/gaps/gaps docs/gaps/artifacts

# Save raw audit results
echo "Saving reality audit artifact..."
cat > docs/gaps/artifacts/reality-audit-$(date +%Y%m%d-%H%M%S).json << 'EOF'
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "total_promises": 8,
  "working": 2,
  "partial": 1,
  "broken": 5,
  "git_commit": "$(git rev-parse HEAD)",
  "test_command": "npm test"
}
EOF
```

For each broken promise, create a gap entry:

```yaml
# docs/gaps/gaps/GAP-R-001.yaml
gap_id: GAP-R-001
title: "Question-First Learning Completely Broken"
category: functionality
severity: CRITICAL
priority: 1

discovery:
  source: reality-audit
  discovered_at: "2024-01-30T10:00:00Z"
  discovered_by: "/reality-audit command"

problem:
  description: |
    PRM-007 claims app supports question-first learning, but backend
    doesn't detect questions at all. Tests are mocked to always pass.

  evidence:
    - type: test_failure
      detail: "curl test shows no questionDetected in response"
    - type: missing_code
      detail: "No question detection logic in conversation-agent.js"
    - type: promise_violation
      detail: "Core promise PRM-007 completely unfulfilled"

  affected:
    promises: [PRM-007]
    features: [question-detection, adaptive-learning]

  root_cause: |
    Feature marked complete without implementation.
    Tests written with mocks instead of real functionality.

expected:
  description: |
    System should detect when users ask questions and adapt the
    learning experience accordingly.

  acceptance_criteria:
    - "Backend detects questions in user input"
    - "System responds appropriately to questions"
    - "Learning path adapts based on questions asked"

  references:
    - "docs/intent/product-intent.md#PRM-007"

resolution:
  approach: |
    Implement question detection logic in conversation agent.
    Add real integration tests for question scenarios.

  effort: medium
  risk: low

  tasks:
    - "Add question detection to conversation-agent.js"
    - "Create question response logic"
    - "Write real integration tests"
    - "Remove mocked tests"

verification:
  method: reality

  reality_tests:
    - "npm test -- tests/promises/PRM-007.test.js"
    - "curl -X POST http://localhost:3001/api/conversation -d '{\"message\": \"What is that?\"}' | grep questionDetected"

  success_criteria:
    - "Question detection returns true for questions"
    - "Non-questions return false"
    - "Integration tests pass without mocks"

status:
  state: open
  notes: "Blocking release - core promise violation"
```

Update the gap registry:

```yaml
# docs/gaps/gap-registry.yaml
registry:
  version: "1.0"
  last_updated: "2024-01-30T10:00:00Z"

  summary:
    total: 5
    by_state:
      open: 5
    by_severity:
      critical: 3
      high: 2
    by_source:
      reality_audit: 5

  gaps:
    - id: GAP-R-001
      title: "Question-First Learning Completely Broken"
      severity: CRITICAL
      state: open
      promise: PRM-007
      file: gaps/GAP-R-001.yaml

    - id: GAP-R-002
      title: "Response Length Matching Not Implemented"
      severity: CRITICAL
      state: open
      promise: PRM-008
      file: gaps/GAP-R-002.yaml

    - id: GAP-R-003
      title: "Engagement Patterns Missing"
      severity: HIGH
      state: open
      promise: PRM-004
      file: gaps/GAP-R-003.yaml
```

Generate human-readable report:

```markdown
# Reality Audit Report

Generated: 2024-01-30T10:00:00Z
Method: Real test execution

## Summary
- Total Promises: 8
- Actually Working: 2 (25%)
- Partially Working: 1 (12.5%)
- Completely Broken: 5 (62.5%)

## Gaps Discovered

### Critical Gaps (Must Fix Before Release)

**[GAP-R-001]** Question-First Learning Completely Broken
- Promise: PRM-007
- Issue: Backend doesn't detect questions at all
- Impact: Core learning mode unavailable
- Evidence: Test returns no questionDetected field

**[GAP-R-002]** Response Length Matching Not Implemented
- Promise: PRM-008
- Issue: Accepts any length response
- Impact: No adaptive difficulty
- Evidence: Validation always returns true

### High Priority Gaps

**[GAP-R-003]** Engagement Patterns Missing
- Promise: PRM-004
- Issue: Feature not implemented
- Impact: No personalized learning paths

## Gaps Written to Unified System

✅ Created 5 gaps in unified format
📁 Location: docs/gaps/
🔧 Fix with: /improve --source=reality
✓ Verify with: /verify --source=reality

## Next Steps

1. Run `/improve --severity=critical` to fix blocking issues
2. Or run `/recover` for guided 5-phase recovery process
3. After fixes, run `/verify` to confirm resolution
```

## The Hard Truth

This command will likely reveal that 60-80% of "validated" promises are actually broken.

That's OK - knowing the truth is the first step to fixing it.

## Next Steps

After running reality audit, start the recovery process:

```
/recover           # Start full 5-phase recovery
/recover tests     # Jump to creating test infrastructure
/recover fix       # Start fixing broken features
```

See `/recover` command for the complete recovery workflow.