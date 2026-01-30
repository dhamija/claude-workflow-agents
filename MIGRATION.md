# Migration Guide: From Fake to Real Validation

## For Projects Built with Previous Workflow Versions

If your project was built with the workflow before v3.2, you likely have the "illusion of progress" problem - features marked complete that don't actually work.

## Step 1: Update Your Workflow System

```bash
# Get the latest workflow with real validation
workflow-update master

# Verify you have v3.2+
workflow-version
```

## Step 2: Tell Claude About Your Project

Claude needs to know HOW to test your specific project:

```markdown
Tell Claude:

"My project structure:
- Test command: npm test
- Start dev server: npm run dev
- Backend URL: http://localhost:3001
- Frontend URL: http://localhost:5173
- Test files location: tests/ or __tests__/
- Database: PostgreSQL on port 5432"
```

## Step 3: Run Reality Audit

Ask Claude to audit what ACTUALLY works:

```
"Run /reality-audit to check which promises actually work. Use the Bash tool to run real tests."
```

**Warning:** This will be painful. Expect to find:
- 60-80% of "validated" features are broken
- Missing tests for most promises
- Core functionality that doesn't work

## Step 4: Create Real Tests

For each broken promise, create an integration test:

```javascript
// tests/promises/PRM-007.test.js
describe('PRM-007: Question-First Learning', () => {
  it('detects English questions', async () => {
    const response = await api.post('/conversation', {
      message: 'What is that?'
    });

    // This MUST actually pass when run
    expect(response.metadata.questionDetected).toBe(true);
    expect(response.metadata.spanishEquivalent).toBe('¿Qué es eso?');
  });
});
```

## Step 5: Fix What's Actually Broken

Now that you know what's really broken:

```
"Fix PRM-007. The test shows questionDetected is undefined. Update the backend conversation agent to actually detect questions."
```

Claude will now:
1. Implement the missing logic
2. Run the ACTUAL test to verify it works
3. Only mark complete when test REALLY passes

## Step 6: Update Workflow State

Reset your CLAUDE.md workflow state to reflect reality:

```yaml
workflow:
  promises:
    PRM-001:
      status: working  # Actually tested
    PRM-007:
      status: broken   # Test fails
      issue: "Backend missing question detection"
    PRM-008:
      status: unknown  # No test exists
```

## Common Issues and Solutions

### Issue: "No tests exist for any promises"

**Solution:** Create a test harness first:

```bash
# Create test structure
mkdir -p tests/promises

# Ask Claude:
"Create integration tests for all 8 promises. Each test should actually verify the feature works end-to-end."
```

### Issue: "Tests exist but all fail"

**Solution:** This is actually good! Now you know what to fix:

```bash
# Run tests to see failures
npm test 2>&1 | tee test-results.txt

# Ask Claude:
"Here are the test failures. Fix each broken feature until its test passes."
```

### Issue: "I don't know what commands to run"

**Solution:** Help Claude understand your project:

```bash
# Show Claude your structure
ls -la
cat package.json | grep scripts
find . -name "*.test.js" | head -5

# Then tell Claude:
"Here's my project structure. Figure out how to run tests and validate features."
```

## The Recovery Timeline

**Week 1: Reality Check**
- Run reality audit
- Discover what's actually broken
- Create missing tests

**Week 2: Fix Critical Promises**
- Fix the CORE promises first
- Run real tests after each fix
- Verify with manual testing

**Week 3: Complete Coverage**
- Fix remaining promises
- All tests passing
- Can demo everything

## The New Workflow Discipline

Going forward with real validation:

1. **Never mark complete without a passing test**
2. **Always use Bash tool to run tests**
3. **Show actual output, not hypothetical**
4. **Fail fast and honestly**

## Example: Before and After

### Before (Fake Validation)
```
Claude: "Implementing PRM-007..."
Claude: "✓ Implementation complete"
Claude: "✓ Tests would pass"
Claude: "✓ Feature validated"
Reality: Feature doesn't work at all
```

### After (Real Validation)
```
Claude: "Implementing PRM-007..."
Claude: [Runs: npm test -- PRM-007]
Claude: "❌ Test failing: questionDetected is undefined"
Claude: "Fixing backend logic..."
Claude: [Runs: npm test -- PRM-007]
Claude: "✅ Test now passing"
Reality: Feature actually works
```

## The Bottom Line

This migration will:
1. **Expose the truth** - Most features marked "complete" are broken
2. **Create accountability** - Real tests that must pass
3. **Enable progress** - Fix what's actually broken
4. **Build trust** - Demo with confidence

It's painful but necessary. The alternative is continuing with an illusion of progress while core features remain broken.