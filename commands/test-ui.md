---
description: Run LLM user tests against your UI (requires /llm-user init first)
---

# Test UI

**Command:** `/test-ui [options]`

**Purpose:** Execute LLM user simulation tests against your deployed UI to validate promises and find UX issues.

**Prerequisites:**
- ✅ Workflow docs exist (intent, UX, architecture)
- ✅ `/llm-user init` has been run
- ✅ UI is deployed and accessible via URL
- ✅ Test spec and subagents generated

---

## Usage

```bash
# Test all scenarios against localhost
/test-ui

# Test against staging
/test-ui --url=https://staging.myapp.com

# Test specific scenario
/test-ui --scenario=first-scene-description

# Test with specific persona
/test-ui --persona=maria-beginner

# Test multiple scenarios
/test-ui --scenarios=first-scene,error-recovery

# Combination
/test-ui --url=https://staging.app.com --scenario=critical-flow --persona=expert-user
```

---

## Options

| Option | Description | Example |
|--------|-------------|---------|
| `--url=<URL>` | Base URL to test | `--url=https://staging.app.com` |
| `--scenario=<id>` | Run single scenario | `--scenario=first-scene-description` |
| `--scenarios=<ids>` | Run multiple scenarios (comma-separated) | `--scenarios=scene-1,scene-2` |
| `--persona=<id>` | Override scenario persona | `--persona=expert-user` |
| `--timeout=<sec>` | Override timeout | `--timeout=600` |
| `--no-screenshots` | Disable screenshot capture | `--no-screenshots` |
| `--parallel` | Run personas in parallel (experimental) | `--parallel` |

---

## Protocol

When you run `/test-ui`, Claude follows this protocol:

### Phase 1: Load Configuration

```yaml
load:
  test_spec: tests/llm-user/test-spec.yaml
  scenarios: tests/llm-user/scenarios/*.yaml
  personas: tests/llm-user/personas/*.yaml

determine:
  which_scenarios: all | specified
  which_personas: from scenarios | overridden
  base_url: from options | from test_spec
```

### Phase 2: Execute Scenarios

For each scenario:

1. **Load persona configuration**
   ```bash
   cat tests/llm-user/personas/{{persona-id}}.yaml
   ```

2. **Spawn project-specific LLM user subagent**
   ```
   Spawn: {{project}}-llm-user
   Pass: persona, scenario, base_url
   Tools: Read, Bash, Browser, Screenshot
   ```

3. **LLM user executes scenario**
   - Navigates to entry URL
   - Follows step intents
   - Records all actions/observations
   - Takes screenshots
   - Tracks persona state (frustration, motivation, confidence)
   - Completes or abandons based on thresholds

4. **Save session recording**
   ```
   results/llm-user/{{timestamp}}/recordings/{{scenario-id}}.json
   results/llm-user/{{timestamp}}/screenshots/{{scenario-id}}/
   ```

### Phase 3: Evaluate Results

1. **Spawn project-specific evaluator subagent**
   ```
   Spawn: {{project}}-evaluator
   Pass: all session recordings
   Tools: Read, Glob, Grep
   ```

2. **Evaluator analyzes sessions**
   - Score each criterion (domain + UX principles)
   - Calculate weighted overall score
   - Identify gaps (criterion score < 1.0)
   - Trace gaps to source docs
   - Generate recommendations

3. **Save gap analysis**
   ```
   results/llm-user/{{timestamp}}/gap-analysis.md
   results/llm-user/{{timestamp}}/gap-analysis.json
   ```

### Phase 4: Report Results

Display to user:
```
═══════════════════════════════════════════════════════════════
LLM USER TEST RESULTS
═══════════════════════════════════════════════════════════════

TEST RUN: {{timestamp}}
BASE URL: {{url}}

SCENARIOS EXECUTED: {{count}}
───────────────────────────────────────────────────────────────
✓ first-scene-description (maria-beginner) - PASS
✓ error-recovery (maria-beginner) - PASS
⚠ multi-scene-session (jake-teen) - PARTIAL
✗ advanced-description (sofia-heritage) - FAIL

OVERALL SCORE: 7.2/10 (Grade: C+)
VERDICT: PASS WITH RECOMMENDATIONS

PROMISE FULFILLMENT
───────────────────────────────────────────────────────────────
✓ P1: Users can describe scenes - FULFILLED
~ P2: Helpful corrections - PARTIAL (advanced users need more)
✗ P3: Users feel progress - NOT FULFILLED (no progress tracking)

CRITICAL GAPS (must fix before release)
───────────────────────────────────────────────────────────────
1. No progress tracking visible
   Affected: Jake (impatient teen)
   Location: Multi-scene session
   Recommendation: Add progress dashboard
   Priority: CRITICAL

HIGH PRIORITY GAPS
───────────────────────────────────────────────────────────────
2. Feedback not level-adaptive
   Affected: Sofia (advanced user)
   Location: All feedback interactions
   Recommendation: Detect level, calibrate feedback
   Priority: HIGH

MEDIUM PRIORITY GAPS
───────────────────────────────────────────────────────────────
3. Loading time >3s on scene 2
   Affected: Jake (impatient teen)
   Recommendation: Add skeleton loader, optimize
   Priority: MEDIUM

═══════════════════════════════════════════════════════════════

Full report: results/llm-user/{{timestamp}}/gap-analysis.md

NEXT STEPS:
1. Review critical gaps with team
2. Fix gap #1 (progress tracking)
3. Re-test: /test-ui --scenarios=multi-scene-session

View detailed analysis: /llm-user gaps
```

---

## Output Files

After test execution, you'll have:

```
results/llm-user/{{timestamp}}/
├── recordings/
│   ├── first-scene-description.json
│   ├── error-recovery.json
│   ├── multi-scene-session.json
│   └── advanced-description.json
│
├── screenshots/
│   ├── first-scene-description/
│   │   ├── step-1-action-1-before.png
│   │   ├── step-1-action-1-after.png
│   │   └── ...
│   └── ...
│
├── gap-analysis.md      # Human-readable report
├── gap-analysis.json    # Machine-readable
└── test-summary.json    # Execution metadata
```

---

## Recording Format

Each session recording contains:

```json
{
  "session_id": "uuid",
  "scenario_id": "first-scene-description",
  "persona_id": "maria-beginner",
  "timestamp_start": "ISO-8601",
  "timestamp_end": "ISO-8601",
  "duration_sec": 120,
  "success": true,

  "steps": [
    {
      "step_id": "step-1",
      "actions": [
        {
          "action_number": 1,
          "observation": "...",
          "decision": "...",
          "action": "...",
          "outcome": "...",
          "reaction": "...",
          "state_after": {
            "frustration": 0.15,
            "motivation": 0.80,
            "confidence": 0.70
          }
        }
      ]
    }
  ],

  "final_state": {
    "frustration": 0.20,
    "motivation": 0.75,
    "would_return": true,
    "would_recommend": true
  },

  "promise_assessment": [
    {
      "promise_id": "P1",
      "fulfilled": true,
      "evidence": "..."
    }
  ]
}
```

---

## Examples

### Example 1: Initial Test Run

```bash
# After L2 implementation, test staging deployment
/test-ui --url=https://staging.spanish-app.com
```

**Result:**
- 4 scenarios run
- Overall score: 6.8/10
- 1 critical gap found (no progress tracking)
- 2 high priority gaps
- Detailed recommendations generated

### Example 2: Re-test After Fixes

```bash
# After fixing progress tracking, re-test that scenario
/test-ui --url=https://staging.spanish-app.com --scenario=multi-scene-session
```

**Result:**
- Progress tracking now visible
- Jake's frustration reduced
- Gap resolved
- Score improved to 8.5/10

### Example 3: Test Specific User Type

```bash
# Focus on beginner experience
/test-ui --persona=maria-beginner
```

**Result:**
- Runs all scenarios from Maria's perspective
- Identifies beginner-specific issues
- Validates beginner-focused promises

### Example 4: Production Smoke Test

```bash
# Quick validation after production deploy
/test-ui --url=https://app.myproduct.com --scenarios=critical-flow,checkout
```

**Result:**
- Fast targeted test
- Validates critical paths work
- Catches regressions

---

## When to Run Tests

**Recommended testing points:**

1. **After L2 feature implementation** - Validate promise fulfilled
2. **Before production deploy** - Smoke test critical paths
3. **After bug fixes** - Regression test
4. **Before release** - Full test suite
5. **After UX changes** - Validate improvements

**Test frequency:**

- **Development:** After major UI changes
- **Staging:** Daily or before each deploy
- **Production:** After deploys (smoke tests)

---

## Troubleshooting

### "Test spec not found"

**Problem:** Haven't run `/llm-user init`

**Solution:**
```bash
/llm-user init
```

### "Subagent not found"

**Problem:** Generated subagents not in `.claude/agents/`

**Solution:**
Check that `/llm-user init` completed successfully. Regenerate if needed.

### "Browser tool not available"

**Problem:** Testing UI requires browser automation

**Solution:**
Currently requires Browser tool (experimental). Alternative: Use screenshot-based testing.

### "All scenarios timing out"

**Problem:** URL not accessible or app not responding

**Solution:**
- Verify URL is correct and accessible
- Check app is running
- Increase timeout: `--timeout=600`

### "Scores always 10/10 but users complain"

**Problem:** Test criteria not strict enough or personas not authentic

**Solution:**
- Review test-spec.yaml criteria
- Regenerate with `/llm-user refresh`
- Check persona frustration triggers are realistic

---

## Advanced Usage

### Custom Base URL in Test Spec

Edit `tests/llm-user/test-spec.yaml`:

```yaml
execution:
  base_url: "https://staging.myapp.com"  # Default
  timeout_sec: 300
```

### Parallel Testing (Experimental)

```bash
# Run multiple personas simultaneously
/test-ui --parallel
```

**Warning:** May cause race conditions if personas share state.

### Continuous Integration

```bash
# In CI pipeline
/test-ui --url=$STAGING_URL --no-screenshots
if [ $? -eq 0 ]; then
  echo "Tests passed"
else
  echo "Tests failed, check gap-analysis.md"
  exit 1
fi
```

---

## Related Commands

- `/llm-user init` - Initialize testing (run this first)
- `/llm-user gaps` - View detailed gap analysis
- `/llm-user refresh` - Regenerate after doc changes
- `/review` - Code review (different from UX testing)
- `/verify final` - Manual acceptance testing

---

## Success Criteria

**This command is successful if:**

1. ✅ Finds real UX problems humans missed
2. ✅ Gaps trace to specific promises/docs
3. ✅ Recommendations are actionable
4. ✅ Re-testing shows improvement after fixes
5. ✅ Different personas have different experiences
6. ✅ Execution completes in reasonable time (<10 min for typical suite)

---

## Notes

- **LLM user testing complements traditional testing** - Use both unit tests AND LLM user tests
- **Not a replacement for real users** - LLM users find issues but real user feedback still essential
- **Domain-specific by design** - Tests are generated from YOUR docs, not generic templates
- **Promise-focused** - Tests validate what you promised users, not just that code doesn't crash
