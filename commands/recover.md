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

## The Recovery Process

### Phase 1: Truth Discovery (audit)

First, discover what ACTUALLY works:

```bash
# Run comprehensive reality check
echo "Starting reality audit..."

# Check if tests exist
if [ -f "package.json" ]; then
  echo "Found package.json, checking test scripts..."
  npm test --version 2>/dev/null || echo "❌ No test command found"
fi

# Try to run existing tests
echo "Attempting to run tests..."
npm test 2>&1 | head -20

# Check for promise tests
echo "Looking for promise validation tests..."
find . -name "*test*" -o -name "*spec*" | grep -i promise || echo "❌ No promise tests found"

# Audit each promise
for promise in $(grep -oE "PRM-[0-9]+" docs/intent/product-intent.md 2>/dev/null); do
  echo "Checking $promise..."
  npm test -- $promise 2>/dev/null && echo "✓ Has test" || echo "❌ No test"
done
```

Output a reality report showing what's actually broken.

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

Analyze and prioritize what to fix first:

```markdown
Priority Matrix:

CRITICAL (Fix immediately):
- Complete failures that break core functionality
- Promises with CORE criticality
- Demo blockers

HIGH (Fix this week):
- Partial failures affecting user experience
- IMPORTANT promises
- Integration issues

MEDIUM (Fix this sprint):
- Minor issues
- NICE_TO_HAVE promises
- Performance problems
```

### Phase 4: Fix with Verification (fix)

For each broken promise:

1. **Run the failing test** (using Bash tool)
   ```bash
   npm test -- PRM-XXX
   # Show ACTUAL failure
   ```

2. **Fix the implementation**
   - Update code based on real error
   - Don't guess - use test feedback

3. **Verify the fix** (using Bash tool)
   ```bash
   npm test -- PRM-XXX
   # Must ACTUALLY pass
   ```

4. **Manual verification**
   ```bash
   npm run dev
   # Actually test the feature
   ```

**NEVER mark fixed without test passing!**

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

## Implementation

When user runs `/recover`, you should:

1. **Assess current state**
   - Check if tests exist
   - Try to run existing tests
   - Count broken vs working features

2. **Start appropriate phase**
   - If no tests: Start with Phase 2 (create tests)
   - If tests exist but fail: Start with Phase 4 (fix)
   - If unsure: Start with Phase 1 (audit)

3. **Use Bash tool for EVERYTHING**
   - Actually run commands
   - Show real output
   - Never pretend or assume

4. **Be brutally honest**
   - "70% of your features are broken"
   - "This will take 2 weeks to fix"
   - "You cannot demo most features"

5. **Track progress**
   ```yaml
   recovery_status:
     phase_1_audit: complete
     phase_2_tests: in_progress
     phase_3_triage: pending
     phase_4_fix: pending
     phase_5_lock: pending
   ```

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