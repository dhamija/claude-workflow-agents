---
description: Smart verification for gaps from unified system - uses appropriate method per gap type
argument-hint: <gap-id | --all | --source=X | --state=fixed | phase N>
---

## Smart Gap Verification System

Automatically selects the right verification method based on gap source:
- Reality gaps (GAP-R-XXX) → Run real tests
- User gaps (GAP-U-XXX) → Re-run LLM user scenarios
- Analysis gaps (GAP-A-XXX) → Check implementation exists
- Intent gaps (GAP-I-XXX) → Validate promises kept
- Technical gaps (GAP-T-XXX) → Run integration tests

## Parse Arguments

Target: $ARGUMENTS

### Specific Gap ID (e.g., "GAP-R-001"):
```bash
# Load and verify single gap
GAP_FILE="docs/gaps/gaps/GAP-R-001.yaml"
```

### All Fixed Gaps (--all or --state=fixed):
```bash
# Find all gaps in fixed state awaiting verification
grep -l "state: fixed" docs/gaps/gaps/*.yaml
```

### By Source (--source=reality):
```bash
# Verify all gaps from specific source
grep -l "source: reality-audit" docs/gaps/gaps/*.yaml | \
  xargs grep -l "state: fixed"
```

### Phase-based (phase N):
```bash
# Verify all gaps in a migration phase
cat docs/gaps/migration-plan.md | grep "Phase $N" -A 50 | \
  grep -oE "GAP-[A-Z]-[0-9]{3}"
```

### Default (no arguments):
```bash
# Show gaps needing verification
echo "Gaps awaiting verification:"
grep -l "state: fixed" docs/gaps/gaps/*.yaml | while read f; do
  basename $f .yaml
done
```

## Smart Verification Process

For each gap to verify:

### 1. Load Gap and Detect Verification Method

```bash
# Read gap file
GAP_DATA=$(cat docs/gaps/gaps/${GAP_ID}.yaml)

# Extract verification method
METHOD=$(echo "$GAP_DATA" | grep "method:" | head -1 | cut -d: -f2 | tr -d ' ')

echo "Gap: $GAP_ID"
echo "Source: ${gap.discovery.source}"
echo "Verification Method: $METHOD"
```

### 2. Execute Verification by Method

#### Reality Verification (Real Tests)

For gaps discovered by reality-audit:

```bash
echo "Running reality verification for $GAP_ID..."

# Get test commands from gap
TESTS=$(cat docs/gaps/gaps/${GAP_ID}.yaml | grep -A10 "reality_tests:" | grep "^    -")

# Run each test
for test in $TESTS; do
  echo "Running: $test"
  eval $test
  if [ $? -ne 0 ]; then
    echo "❌ Test failed: $test"
    VERIFICATION_FAILED=true
  else
    echo "✅ Test passed: $test"
  fi
done

# Also check integration tests if they exist
if [ -f "tests/integration/${GAP_ID}.test.js" ]; then
  npm test -- tests/integration/${GAP_ID}.test.js
fi
```

#### LLM User Verification (Simulated Users)

For gaps discovered by llm-user testing:

```bash
echo "Running LLM user verification for $GAP_ID..."

# Get scenarios and personas from gap
SCENARIO=$(grep "scenario:" docs/gaps/gaps/${GAP_ID}.yaml | cut -d: -f2)
PERSONA=$(grep "personas:" docs/gaps/gaps/${GAP_ID}.yaml | grep -oE "[a-z-]+")

# Re-run the specific scenario that failed
echo "Re-testing scenario: $SCENARIO with persona: $PERSONA"

# Invoke llm-user test for this specific case
/llm-user test --scenario=$SCENARIO --persona=$PERSONA --gap=$GAP_ID

# Check if gap is resolved in results
if grep -q "$GAP_ID.*RESOLVED" tests/llm-user/results/latest/gaps.json; then
  echo "✅ LLM user no longer experiences this issue"
else
  echo "❌ LLM user still experiencing issue"
  VERIFICATION_FAILED=true
fi
```

#### Manual Verification

For gaps requiring manual verification:

```bash
echo "Manual verification required for $GAP_ID"

# Display manual steps
echo "Please verify the following:"
grep -A20 "manual_steps:" docs/gaps/gaps/${GAP_ID}.yaml | grep "^    -" | sed 's/^    - /  ☐ /'

echo ""
echo "After manual verification, confirm:"
echo "  [P]ass - All steps verified successfully"
echo "  [F]ail - Some steps failed"
echo "  [S]kip - Cannot verify right now"
```

#### Automated Verification

For gaps with automated checks:

```bash
echo "Running automated verification for $GAP_ID..."

# Run verification script if it exists
if [ -f "scripts/verify-${GAP_ID}.sh" ]; then
  bash scripts/verify-${GAP_ID}.sh
else
  # Generic automated checks based on category
  case ${gap.category} in
    functionality)
      npm test -- --grep "${gap.affected.features}"
      ;;
    performance)
      npm run perf-test
      ;;
    security)
      npm audit
      npm run security-scan
      ;;
  esac
fi
```

### 3. Check Success Criteria

```bash
# Extract and verify success criteria
echo "Checking success criteria..."

SUCCESS_COUNT=0
TOTAL_COUNT=0

# Read success criteria from gap
while read -r criterion; do
  TOTAL_COUNT=$((TOTAL_COUNT + 1))
  echo "Checking: $criterion"

  # Run verification for this criterion
  # (Implementation depends on criterion format)

  if [ $? -eq 0 ]; then
    echo "  ✅ Met"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    echo "  ❌ Not met"
  fi
done < <(grep -A10 "success_criteria:" docs/gaps/gaps/${GAP_ID}.yaml | grep "^    -")

echo "Success criteria: $SUCCESS_COUNT/$TOTAL_COUNT met"
```

### 4. Update Gap Status

Based on verification results:

```yaml
# Update docs/gaps/gaps/GAP-XXX.yaml

# If verification passed:
status:
  state: verified  # was: fixed
  verified_at: "2024-01-30T12:00:00Z"
  verification_result: "PASS"
  verification_evidence:
    - "All tests pass without mocks"
    - "LLM user completes scenario successfully"
    - "Success criteria met: 3/3"

# If verification failed:
status:
  state: in_progress  # was: fixed (back to work)
  verification_attempted_at: "2024-01-30T12:00:00Z"
  verification_result: "FAIL"
  failure_reason:
    - "Test still uses mocks"
    - "LLM user still encounters issue"
```

### 5. Update Registry

```yaml
# Update docs/gaps/gap-registry.yaml
registry:
  summary:
    by_state:
      verified: 3  # was: 2
      fixed: 4     # was: 5

  gaps:
    - id: GAP-R-001
      state: verified  # was: fixed
```

## Verification Report

After verification, generate report:

```markdown
# Gap Verification Report

Date: 2024-01-30T12:00:00Z
Gaps Verified: 3

## Verification Results

### ✅ PASSED (2 gaps)

**[GAP-R-001]** Question-First Learning
- Method: Reality tests
- Result: All tests pass without mocks
- Evidence: npm test output shows real implementation

**[GAP-U-003]** User Abandonment
- Method: LLM user re-test
- Result: Jake now completes 5 scenes
- Evidence: Frustration reduced from 0.85 to 0.35

### ❌ FAILED (1 gap)

**[GAP-R-002]** Response Validation
- Method: Reality tests
- Result: Still accepts invalid responses
- Issue: Validation logic incomplete
- Action: Returned to in_progress state

## Summary

- Verification Success Rate: 67% (2/3)
- Ready to close: GAP-R-001, GAP-U-003
- Needs more work: GAP-R-002

## Next Steps

1. Close verified gaps
2. Continue work on GAP-R-002
3. Run `/verify --all` after next fix cycle
```

## Special Verification Modes

### Regression Check

After fixing gaps, ensure nothing else broke:

```bash
/verify --regression

# Runs:
# - All existing tests
# - All previously verified gaps
# - Smoke tests for critical paths
```

### Phase Verification

For migration plan phases:

```bash
/verify phase 1

# Verifies all gaps in Phase 1
# Generates phase completion report
# Confirms ready for Phase 2
```

### Final Verification

Before release:

```bash
/verify --final

# Comprehensive verification:
# - All gaps closed or verified
# - All promises validated
# - All tests passing
# - No known critical issues
```