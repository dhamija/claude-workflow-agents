---
description: LLM user testing commands (init, gaps, refresh)
---

# LLM User Testing

**Command Family:** `/llm-user <subcommand>`

**Purpose:** Initialize, execute, and manage domain-specific LLM user testing for your project.

---

## Subcommands

### `/llm-user init`

**Purpose:** Analyze workflow docs and generate LLM user testing infrastructure.

**Usage:**
```bash
/llm-user init [--force]
```

**What it does:**
1. Scans for workflow documentation (intent, UX, architecture)
2. Validates docs contain testable content
3. Generates unified test specification
4. Creates project-specific test subagents
5. Sets up test infrastructure

**Prerequisites:**
- ✅ `docs/intent/product-intent.md` exists
- ✅ `docs/ux/user-journeys.md` exists
- ✅ `docs/architecture/agent-design.md` (or `system-design.md`) exists

**Outputs:**
```
tests/llm-user/
├── test-spec.yaml
├── personas/
│   ├── {{persona-id}}.yaml
│   └── ...
└── scenarios/
    ├── {{scenario-id}}.yaml
    └── ...

.claude/agents/
├── {{project}}-llm-user.md
└── {{project}}-evaluator.md
```

**Options:**
- `--force`: Regenerate even if files exist

**Example:**
```bash
# After L1 planning complete
/llm-user init

# Output shows:
# - 3 personas extracted
# - 5 scenarios generated
# - Evaluation rubric created
# Ready to test!
```

---

### `/llm-user gaps`

**Purpose:** Display gap analysis from most recent test run.

**Usage:**
```bash
/llm-user gaps [--run=<timestamp>] [--format=md|html|json]
```

**What it does:**
1. Finds most recent test run (or specified run)
2. Reads gap analysis report
3. Displays prioritized recommendations
4. Shows traceability to original docs

**Options:**
- `--run=<timestamp>`: View specific test run
- `--format=md`: Markdown (default)
- `--format=html`: HTML report
- `--format=json`: Machine-readable

**Example:**
```bash
/llm-user gaps

# Output shows:
# Overall Score: 7.2/10
# Critical Gaps: 1
# High Priority: 2
# ...
```

**Output format:**
- Executive summary
- Promise fulfillment status
- Detailed gap analysis by severity
- Recommendations with priority
- Traceability matrix

---

### `/llm-user refresh`

**Purpose:** Regenerate test artifacts after workflow doc changes.

**Usage:**
```bash
/llm-user refresh [--what=all|spec|agents|scenarios]
```

**When to use:**
- After updating `product-intent.md` (new promises)
- After updating `user-journeys.md` (new personas/journeys)
- After updating architecture (behavior changes)
- After modifying acceptance criteria in plans

**What it does:**
1. Compares file hashes in test-spec.yaml to current docs
2. Detects which docs changed
3. Re-runs llm-user-testing skill protocol for changed components
4. Shows diff of changes
5. Asks for confirmation before overwriting

**Options:**
- `--what=all`: Regenerate everything
- `--what=spec`: Only test-spec.yaml
- `--what=agents`: Only subagent prompts
- `--what=scenarios`: Only scenario files

**Example:**
```bash
# Added new promise P4 to intent doc
/llm-user refresh

# Output shows:
# Changed docs:
#   - docs/intent/product-intent.md (new promise P4)
#
# Will update:
#   - test-spec.yaml (add P4 to success criteria)
#   - {{project}}-evaluator.md (add P4 scoring)
#
# Confirm? [Y/n]
```

---

## Complete Workflow

### 1. Initial Setup

```bash
# After L1 planning
/llm-user init

# Generates:
# ✓ test-spec.yaml
# ✓ 3 personas
# ✓ 5 scenarios
# ✓ {{project}}-llm-user.md
# ✓ {{project}}-evaluator.md
```

### 2. Run Tests

```bash
# Test against staging
/test-ui --url=https://staging.app.com

# Results:
# ✓ 4 scenarios passed
# ✗ 1 scenario failed
# Overall: 7.2/10
# 1 critical gap found
```

### 3. Review Gaps

```bash
/llm-user gaps

# Shows:
# [CRITICAL] No progress tracking
# Recommendation: Add progress dashboard
# Priority: CRITICAL (blocks release)
```

### 4. Fix and Re-test

```bash
# After implementing progress dashboard
/test-ui --url=https://staging.app.com --scenario=multi-scene-session

# Results:
# ✓ Gap resolved
# Score improved: 7.2 → 8.5
```

### 5. Update Docs and Refresh

```bash
# Added new promise to intent doc
/llm-user refresh

# Regenerates test artifacts with new promise
# Re-run tests to validate new promise
/test-ui
```

---

## File Structure

After initialization:

```
project/
├── tests/llm-user/
│   ├── test-spec.yaml              # Generated: unified spec
│   ├── personas/
│   │   ├── maria-beginner.yaml
│   │   ├── jake-teen.yaml
│   │   └── sofia-heritage.yaml
│   └── scenarios/
│       ├── first-scene.yaml
│       ├── error-recovery.yaml
│       └── multi-scene.yaml
│
├── .claude/agents/
│   ├── spanish-app-llm-user.md     # Generated: domain-specific user
│   └── spanish-app-evaluator.md    # Generated: domain-specific evaluator
│
├── results/llm-user/
│   └── 2026-01-27T10-20-00Z/
│       ├── recordings/
│       ├── screenshots/
│       ├── gap-analysis.md
│       └── gap-analysis.json
│
└── docs/                           # Source docs (in version control)
    ├── intent/product-intent.md
    ├── ux/user-journeys.md
    └── architecture/agent-design.md
```

---

## Best Practices

### DO

✅ **Run init after L1 complete** - Docs must exist first
✅ **Test early and often** - Find issues before production
✅ **Fix critical gaps first** - They block releases
✅ **Re-test after fixes** - Verify improvements
✅ **Refresh after doc changes** - Keep tests in sync

### DON'T

❌ **Don't commit generated files** - Only commit source docs
❌ **Don't skip init** - `/test-ui` requires setup
❌ **Don't ignore critical gaps** - They're release blockers
❌ **Don't test without docs** - Garbage in, garbage out

---

## Troubleshooting

### "Required docs not found"

**Problem:** Missing intent, UX, or architecture docs

**Solution:**
Run L1 agents first:
```bash
/intent    # Creates product-intent.md
/ux        # Creates user-journeys.md
/architect # Creates agent-design.md
/llm-user init
```

### "Generated artifacts out of date"

**Problem:** Docs changed since last init

**Solution:**
```bash
/llm-user refresh
```

### "Subagents not found during /test-ui"

**Problem:** Init didn't complete or files deleted

**Solution:**
```bash
/llm-user init --force
```

### "Tests always pass but issues exist"

**Problem:** Criteria not strict enough or personas not realistic

**Solution:**
- Review test-spec.yaml
- Check persona frustration triggers
- Ensure promises are measurable
- Run `/llm-user refresh` after fixing docs

---

## Integration with Workflow

### L1 Phase (Planning)

```
intent-guardian    → Defines testable promises
ux-architect       → Defines personas & journeys
agentic-architect  → Defines system behavior
implementation-planner → Defines acceptance criteria

                ↓
         /llm-user init
                ↓
  Test infrastructure ready
```

### L2 Phase (Building)

```
backend-engineer   → Implements features
frontend-engineer  → Implements UI
test-engineer      → Writes unit tests

                ↓
            /test-ui
                ↓
      Validates promises in UI
                ↓
         Gap analysis
                ↓
       Fix critical gaps
```

### Post-L2 (Validation)

```
acceptance-validator → Manual validation
/test-ui            → Automated validation

                ↓
       Both must pass
                ↓
      Feature complete
```

---

## Success Indicators

**LLM user testing is working if:**

1. ✅ Setup takes <5 minutes (vs days for manual test writing)
2. ✅ Tests find real UX issues humans missed
3. ✅ Gaps trace to specific promises
4. ✅ Recommendations are actionable
5. ✅ Re-testing shows improvement
6. ✅ Different personas have different experiences

---

## Related Commands

- `/test-ui` - Execute LLM user tests
- `/intent` - Create promises that tests validate
- `/ux` - Create personas and journeys for tests
- `/verify final` - Manual acceptance testing
- `/review` - Code quality review (different focus)

---

## Notes

- **Auto-generated artifacts** - Don't edit generated files directly
- **Source docs in version control** - Only commit docs/, not tests/llm-user/
- **Regenerate after clone** - Run `/llm-user init` after cloning repo
- **Complements manual testing** - Use both automated and real user testing
- **Domain-specific by design** - Tests generated from YOUR docs, not generic templates
