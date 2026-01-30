# Recovery Workflow for Projects with Fake Validation

## The 5-Phase Recovery Process

### Phase 1: Truth Discovery 🔍
**Goal:** Find out what ACTUALLY works

```bash
# Commands to run:
/reality-audit          # Discover the truth
npm test               # See what tests exist
npm run dev            # Try to start the app
```

**Expected outcome:**
- 20-30% actually works
- 70-80% is broken or missing

### Phase 2: Test Infrastructure 🏗️
**Goal:** Create tests that can verify promises

```javascript
// For each promise, create:
// tests/promises/PRM-XXX.test.js

describe('PRM-XXX: [Promise Name]', () => {
  it('actually works end-to-end', async () => {
    // Start app
    // Perform user action
    // Verify result
    // This MUST run and pass
  });
});
```

### Phase 3: Triage & Prioritize 🚨
**Goal:** Fix the most critical issues first

```markdown
Priority 1 (Demo Breakers):
- Features that completely don't work
- Core promises (CORE criticality)
- User-facing failures

Priority 2 (Partial Fixes):
- Features that partially work
- IMPORTANT promises
- Backend issues

Priority 3 (Polish):
- Minor issues
- NICE_TO_HAVE promises
- Performance improvements
```

### Phase 4: Fix with Verification ✅
**Goal:** Actually fix broken features

```bash
For each broken promise:

1. Run the failing test:
   npm test -- PRM-007
   # See actual error

2. Fix the implementation:
   # Update code based on error

3. Verify fix works:
   npm test -- PRM-007
   # Must actually pass

4. Manual verification:
   # Start app and try feature
   # Take screenshot/recording
```

### Phase 5: Lock in Progress 🔒
**Goal:** Prevent regression

```yaml
# Update CLAUDE.md with reality:
workflow:
  promises:
    PRM-001:
      status: verified     # Test passes
      test: tests/promises/PRM-001.test.js
      last_verified: 2024-01-30

    PRM-007:
      status: fixed        # Was broken, now works
      test: tests/promises/PRM-007.test.js
      fix_date: 2024-01-30
```

## The Daily Discipline

### Every Morning: Reality Check
```bash
npm test -- --grep "PRM-"
# Know what's actually working
```

### Before Any Claim of Completion:
```bash
# Run the actual test
npm test -- [feature]

# If it passes, you can claim complete
# If it fails, you must fix it first
```

### Before Any Demo:
```bash
# Run ALL promise tests
npm test -- tests/promises/

# Only demo what passes
```

## Red Flags to Watch For

🚩 **Claude says:** "This should work"
✅ **Should say:** "Running test... [actual result]"

🚩 **Claude says:** "Implementation complete"
✅ **Should say:** "Implementation done, running verification..."

🚩 **Claude says:** "Tests would pass"
✅ **Should say:** "Tests results: [actual npm test output]"

🚩 **Claude says:** "Feature validated"
✅ **Should say:** "Validation complete: test passing at [timestamp]"

## The Mindset Shift

### Old Way (Optimistic Fiction)
- Write code → Assume it works → Move on
- Problems discovered during demo
- "It worked on my machine" (but did it?)

### New Way (Verified Reality)
- Write code → Test it → Fix if broken → Prove it works
- Problems discovered immediately
- "Here's the test output proving it works"

## Success Metrics

You'll know the recovery is working when:

1. **Test suite exists and runs**
   ```bash
   npm test -- tests/promises/
   # 8 test files, 24 tests total
   ```

2. **Tests actually pass**
   ```bash
   Test Suites: 8 passed, 8 total
   Tests: 24 passed, 24 total
   ```

3. **You can demo any feature**
   - Pick any promise
   - Run the app
   - Feature actually works

4. **Workflow state matches reality**
   - CLAUDE.md shows real status
   - No false "validated" claims
   - Honest progress tracking

## The Recovery Promise

By following this recovery workflow:

- **Week 1:** You'll know what's really broken
- **Week 2:** You'll have fixed the critical issues
- **Week 3:** You'll have a fully working, testable system

The pain of discovering the truth is temporary.
The confidence of having a working system is permanent.