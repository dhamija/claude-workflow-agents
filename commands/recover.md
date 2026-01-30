---
name: recover
description: Start recovery process for projects with fake validation issues
argument-hint: "[phase]"
---

# Recovery Command

Initiates the 5-phase recovery process for projects suffering from "illusion of progress" - where features are marked complete but don't actually work.

## Usage

```
/recover              # Start full recovery process
/recover audit        # Phase 1: Run reality audit
/recover tests        # Phase 2: Create test infrastructure
/recover triage       # Phase 3: Prioritize fixes
/recover fix          # Phase 4: Fix with verification
/recover lock         # Phase 5: Lock in progress
```

## When to Use

Use this command when you discover:
- Features marked "complete" don't actually work
- Tests are missing or fake
- Promises to users aren't being kept
- You can't demo features that should work

## The Recovery Process (Using Unified Gap System)

### Phase 1: Truth Discovery (audit)

Run reality audit which creates gaps in unified format:

```bash
echo "Starting reality audit (creates gaps in unified format)..."

# Run reality audit command
/reality-audit

# Check what gaps were discovered
echo ""
echo "Gaps discovered:"
ls -la docs/gaps/gaps/GAP-R-*.yaml 2>/dev/null | wc -l
echo ""

# Show critical gaps
echo "Critical gaps that block release:"
grep -l "severity: CRITICAL" docs/gaps/gaps/GAP-R-*.yaml | while read f; do
  GAP_ID=$(basename $f .yaml)
  TITLE=$(grep "title:" $f | cut -d'"' -f2)
  echo "  $GAP_ID: $TITLE"
done

# Show gap summary
cat docs/gaps/gap-registry.yaml | grep -A10 "summary:"
```

The reality audit automatically:
- Tests all promises
- Creates GAP-R-XXX entries for broken features
- Writes to unified gap system at `docs/gaps/`
- Provides verification methods for each gap

### Phase 2: Test Infrastructure (tests)

Create REAL tests that can validate promises:

```bash
# Create test directory structure
mkdir -p tests/promises
mkdir -p tests/integration
mkdir -p tests/e2e

# For each promise, generate test template
echo "Creating test infrastructure..."
```

Generate actual test files that MUST run and pass:
```javascript
// tests/promises/PRM-XXX.test.js
describe('PRM-XXX: [Promise Name]', () => {
  it('actually works end-to-end', async () => {
    // This must REALLY test the feature
    // Not mock or pretend
  });
});
```

### Phase 3: Triage & Prioritize (triage)

Use the unified gap system's built-in prioritization:

```bash
echo "Analyzing gaps for prioritization..."

# Show gaps by severity
echo "Gap Prioritization:"
echo ""
echo "CRITICAL (Must fix before release):"
grep -l "severity: CRITICAL" docs/gaps/gaps/GAP-R-*.yaml | while read f; do
  GAP_ID=$(basename $f .yaml)
  EFFORT=$(grep "effort:" $f | cut -d: -f2 | tr -d ' ')
  echo "  $GAP_ID - Effort: $EFFORT"
done

echo ""
echo "HIGH (Fix this week):"
grep -l "severity: HIGH" docs/gaps/gaps/GAP-R-*.yaml | while read f; do
  GAP_ID=$(basename $f .yaml)
  EFFORT=$(grep "effort:" $f | cut -d: -f2 | tr -d ' ')
  echo "  $GAP_ID - Effort: $EFFORT"
done

# Generate or update migration plan
cat > docs/gaps/migration-plan.md << 'EOF'
# Recovery Migration Plan

## Phase 0: Critical Fixes (Immediate)
[List CRITICAL gaps]

## Phase 1: Core Functionality (Week 1)
[List HIGH priority gaps]

## Phase 2: Polish (Week 2)
[List MEDIUM gaps]
EOF
```

### Phase 4: Fix with Verification (fix)

Use the unified gap system to fix systematically:

```bash
# Fix all CRITICAL gaps
/improve --severity=critical

# Or fix specific gaps
/improve GAP-R-001
/improve GAP-R-002

# The improve command will:
# 1. Load gap from unified system
# 2. Run failing tests to see actual error
# 3. Fix the implementation (not the test!)
# 4. Update gap status to 'fixed'
```

For each gap being fixed:

1. **See the actual failure**
   ```bash
   # Reality gaps have real test commands
   npm test -- tests/promises/PRM-007.test.js
   # Shows: ACTUAL failure, not mock
   ```

2. **Fix the real implementation**
   - Gap file contains resolution approach
   - Fix code based on actual error
   - Never just make tests pass with mocks

3. **Verify with smart verification**
   ```bash
   # Verify knows how to test each gap type
   /verify GAP-R-001
   # Runs appropriate verification method
   ```

**The gap is only closed when `/verify` passes!**

### Phase 5: Lock in Progress (lock)

Update project state to reflect reality:

```yaml
# In CLAUDE.md
workflow:
  recovery:
    started: [date]
    phase: 5
    status: "Recovered from fake validation"

  promises:
    PRM-001:
      status: verified
      test: tests/promises/PRM-001.test.js
      verification_date: [date]
      verification_method: "Real test execution"
```

Add CI/CD to prevent regression:
```yaml
# .github/workflows/promises.yml
on: push
jobs:
  validate-promises:
    runs-on: ubuntu-latest
    steps:
      - run: npm test -- tests/promises/
```

## Implementation with Unified Gap System

When user runs `/recover`, you should:

1. **Check for existing gaps**
   ```bash
   # See if gaps already exist
   if [ -d "docs/gaps/gaps" ] && [ "$(ls docs/gaps/gaps/GAP-R-*.yaml 2>/dev/null | wc -l)" -gt 0 ]; then
     echo "Found existing reality gaps. Skipping audit."
     SKIP_AUDIT=true
   fi
   ```

2. **Run or skip audit**
   ```bash
   if [ "$SKIP_AUDIT" != "true" ]; then
     /reality-audit  # Creates GAP-R-XXX gaps
   fi
   ```

3. **Show gap summary**
   ```bash
   # Display what was found
   echo "Recovery Assessment:"
   echo "==================="
   cat docs/gaps/gap-registry.yaml | grep -A15 "summary:"
   ```

4. **Start recovery based on gaps**
   ```bash
   # Count critical gaps
   CRITICAL_COUNT=$(grep -l "severity: CRITICAL" docs/gaps/gaps/GAP-R-*.yaml | wc -l)

   if [ $CRITICAL_COUNT -gt 0 ]; then
     echo "Starting with $CRITICAL_COUNT critical gaps..."
     /improve --severity=critical
   else
     echo "No critical gaps. Starting with high priority..."
     /improve --severity=high
   fi
   ```

5. **Track recovery progress**
   ```yaml
   # In CLAUDE.md workflow state
   recovery:
     started_at: "2024-01-30"
     using_unified_gaps: true

     gaps_discovered: 8
     gaps_fixed: 0
     gaps_verified: 0

     phase_1_audit: complete  # Created GAP-R-XXX gaps
     phase_2_tests: pending   # Will create as part of gap fixes
     phase_3_triage: complete # Gap system auto-prioritizes
     phase_4_fix: in_progress # Using /improve command
     phase_5_lock: pending    # After all gaps verified
   ```

6. **Use unified commands**
   - `/improve` to fix gaps
   - `/verify` to verify fixes
   - No need for separate recovery-specific commands

## Expected Timeline

- **Day 1-2**: Reality audit (painful discovery)
- **Day 3-5**: Test infrastructure creation
- **Week 2**: Fixing critical issues
- **Week 3**: Fixing remaining issues
- **Week 4**: Fully recovered with real validation

## Success Criteria

Recovery is complete when:
- All promises have real tests
- All tests actually pass
- You can demo every feature
- Workflow state matches reality
- No more "illusion of progress"

## The Recovery Commitment

By starting recovery, you commit to:
- Accepting the painful truth about broken features
- Creating real tests that must pass
- Fixing what's actually broken
- Never again claiming false success

The pain is temporary. The confidence of real validation is permanent.