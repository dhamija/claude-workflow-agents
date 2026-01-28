---
description: Systematic gap resolution from LLM user testing (fix, verify, track)
---

# Fix Gaps

**Command Family:** `/fix-gaps <subcommand>`

**Purpose:** Systematically resolve gaps identified by LLM user testing through structured fix-verify cycles.

---

## Prerequisites

Before using `/fix-gaps`:

1. ✅ LLM user testing infrastructure exists (`/llm-user init` completed)
2. ✅ At least one test run completed (`/test-ui` executed)
3. ✅ Gap analysis available (`results/llm-user/{timestamp}/gap-analysis.json`)

**Quick Start:**
```bash
/test-ui                    # Run tests first
/llm-user gaps              # Review gaps found
/fix-gaps                   # Start fixing systematically
```

---

## Subcommands

### `/fix-gaps`

**Purpose:** Start systematic gap resolution process.

**Usage:**
```bash
/fix-gaps [options]
```

**What it does:**
1. Loads most recent gap analysis
2. Prioritizes gaps (CRITICAL > HIGH > MEDIUM > LOW)
3. Creates fix specification for top priority gap
4. Implements fix using workflow agents
5. Verifies fix by re-running failed scenarios
6. Updates promise status
7. Moves to next gap automatically

**Options:**
- `--priority=critical` - Only fix CRITICAL gaps
- `--priority=high` - Fix CRITICAL and HIGH gaps
- `--limit=N` - Stop after N gaps fixed
- `--gap=GAP-XXX` - Fix specific gap by ID

**Example:**
```bash
/fix-gaps

# Output:
# 📊 Gap Analysis Loaded
#   - 1 CRITICAL gap
#   - 2 HIGH gaps
#   - 3 MEDIUM gaps
#
# 🎯 Fixing GAP-001 (CRITICAL): No progress tracking
#   Promise: P2 (Real-time visual feedback)
#   Affected Personas: maria-beginner, jake-teen
#
# 📋 Creating fix specification...
# ✓ Fix spec created: tests/llm-user/fixes/GAP-001-progress-tracking.yaml
#
# 🔧 Implementing 3 tasks...
#   [1/3] Add progress tracking state (backend)
#   [2/3] Create progress dashboard component (frontend)
#   [3/3] Add tests for progress tracking (testing)
#
# ✅ Fix implemented
#
# 🧪 Verifying fix...
#   Re-running scenario: multi-scene-session
#   Testing with: maria-beginner, jake-teen
#
# ✓ Verification passed
#   Promise P2: FAILED → VALIDATED
#   Overall score: 7.2 → 8.5
#
# 🎯 Moving to next gap: GAP-002 (HIGH)...
```

**Workflow:**
```
Load Gap Analysis
    ↓
Prioritize Gaps
    ↓
For each gap:
    ↓
Create Fix Spec (templates/skills/gap-resolver/templates/fix-spec.template.yaml)
    ↓
Implement Tasks (use backend-engineer, frontend-engineer, test-engineer)
    ↓
Code Review (use code-reviewer)
    ↓
Verify Fix (re-run failed scenarios with same personas)
    ↓
Update Promise Status (in CLAUDE.md)
    ↓
Update Gap Status (CLOSED)
    ↓
Continue to next gap
```

---

### `/fix-gaps status`

**Purpose:** Show current gap resolution progress.

**Usage:**
```bash
/fix-gaps status [--run=<timestamp>]
```

**What it does:**
1. Reads gap analysis and fix specifications
2. Shows progress for each gap
3. Displays promise validation status
4. Highlights blockers

**Options:**
- `--run=<timestamp>` - Show status for specific test run

**Example:**
```bash
/fix-gaps status

# Output:
# 📊 Gap Resolution Status (2026-01-28T10:30:00Z)
#
# Overall Progress: 2/6 gaps fixed (33%)
# Promise Validation: 4/5 promises passing (80%)
#
# 🟢 CLOSED (2)
#   ✓ GAP-001: No progress tracking (P2: VALIDATED)
#   ✓ GAP-004: Unclear error messages (P4: VALIDATED)
#
# 🟡 IN_PROGRESS (1)
#   ⏳ GAP-002: Audio quality issues
#      Status: Implemented, verifying
#      Tasks: 3/3 complete
#      Waiting: Re-test results
#
# 🔴 PENDING (3)
#   • GAP-003 (HIGH): Slow response time
#   • GAP-005 (MEDIUM): No dark mode
#   • GAP-006 (LOW): Missing tooltips
#
# 🚫 FAILED (0)
#
# ⚠️ Blockers: None
#
# Next Action: Wait for GAP-002 verification, then fix GAP-003
```

---

### `/fix-gaps verify`

**Purpose:** Re-run verification for implemented fixes.

**Usage:**
```bash
/fix-gaps verify [--gap=GAP-XXX] [--all]
```

**What it does:**
1. Finds gaps with status IN_PROGRESS or IMPLEMENTED
2. Re-runs failed scenarios with affected personas
3. Compares results with original test run
4. Updates gap and promise status

**Options:**
- `--gap=GAP-XXX` - Verify specific gap
- `--all` - Verify all implemented gaps

**Example:**
```bash
/fix-gaps verify --gap=GAP-002

# Output:
# 🧪 Verifying GAP-002: Audio quality issues
#
# Re-running scenarios:
#   ✓ audio-playback (maria-beginner) - PASS
#   ✓ audio-playback (sofia-heritage) - PASS
#
# Comparing results:
#   Before: 2/2 scenarios failed
#   After:  2/2 scenarios passed
#
# Promise Validation:
#   P3 (High-quality audio): FAILED → VALIDATED
#
# Overall Score Change:
#   Before: 7.2/10
#   After:  8.5/10
#   Improvement: +1.3
#
# ✅ Gap successfully resolved
# Status: IMPLEMENTED → CLOSED
```

---

### `/fix-gaps report`

**Purpose:** Generate comprehensive gap resolution report.

**Usage:**
```bash
/fix-gaps report [--format=md|html|json] [--run=<timestamp>]
```

**What it does:**
1. Aggregates all gap resolution data
2. Shows before/after comparison
3. Tracks promise validation journey
4. Calculates ROI metrics

**Options:**
- `--format=md` - Markdown (default)
- `--format=html` - HTML report
- `--format=json` - Machine-readable
- `--run=<timestamp>` - Report on specific test run

**Example:**
```bash
/fix-gaps report

# Output:
# 📊 Gap Resolution Report
# Test Run: 2026-01-28T10:30:00Z
# Generated: 2026-01-28T15:45:00Z
#
# Executive Summary
# ─────────────────
# • Total Gaps: 6
# • Resolved: 2 (33%)
# • In Progress: 1 (17%)
# • Pending: 3 (50%)
# • Failed: 0 (0%)
#
# Score Improvement
# ─────────────────
# Initial Score: 7.2/10
# Current Score: 8.5/10
# Improvement: +1.3 (+18%)
#
# Promise Validation
# ─────────────────
# P1: ✓ VALIDATED (was: FAILED)
# P2: ✓ VALIDATED (was: FAILED)
# P3: ⏳ IN_PROGRESS (was: FAILED)
# P4: ✓ VALIDATED (always passing)
# P5: ✓ VALIDATED (always passing)
#
# Overall: 4/5 promises validated (80%)
#
# Critical Gaps Resolved
# ─────────────────────
# ✓ GAP-001: No progress tracking
#   Impact: Blocked user progress visibility
#   Fix: Added real-time progress dashboard
#   Tasks: 3 (2 backend, 1 frontend)
#   Effort: 8h
#   Verification: PASSED (2/2 scenarios)
#
# High Priority Gaps
# ─────────────────
# ⏳ GAP-002: Audio quality issues (IN_PROGRESS)
#   Status: Implemented, awaiting verification
#
# • GAP-003: Slow response time (PENDING)
#   Blocks: P1 (Instant feedback)
#
# ROI Metrics
# ─────────────
# Time to identify gaps: 15 min (automated)
# Time to fix critical gaps: 4h (2 gaps)
# Promises validated: 2 → 4 (+100%)
# Release readiness: 70% → 90%
#
# Next Actions
# ─────────────
# 1. Verify GAP-002 (audio quality)
# 2. Fix GAP-003 (slow response) - CRITICAL blocker
# 3. Consider fixing GAP-005 (dark mode) before release
#
# Traceability
# ─────────────
# Gaps → docs/intent/product-intent.md (promises)
# Gaps → docs/ux/user-journeys.md (personas)
# Gaps → results/llm-user/2026-01-28T10:30:00Z/gap-analysis.json
# Fixes → tests/llm-user/fixes/*.yaml
```

---

### `/fix-gaps list`

**Purpose:** List all gaps with filtering and sorting.

**Usage:**
```bash
/fix-gaps list [--priority=<level>] [--status=<status>] [--promise=<id>]
```

**What it does:**
1. Reads gap analysis
2. Filters by criteria
3. Sorts by priority/status
4. Shows one-line summary per gap

**Options:**
- `--priority=critical|high|medium|low` - Filter by priority
- `--status=pending|in_progress|closed|failed` - Filter by status
- `--promise=P#` - Filter by affected promise

**Example:**
```bash
/fix-gaps list --priority=critical --status=pending

# Output:
# 🔴 CRITICAL Gaps (Pending)
#
# GAP-003: Slow response time
#   Promise: P1 (Instant feedback)
#   Personas: maria-beginner, jake-teen, sofia-heritage
#   Impact: 100% abandonment rate for maria-beginner
#   Recommendation: Optimize API response time to <500ms
#
# Total: 1 critical gap pending
```

---

## Complete Workflow

### Gap-Driven Development Cycle

```bash
# 1. Plan Phase
/intent              # Define promises
/ux                  # Define personas & journeys
/architect           # Design system

# 2. Implement Phase
# ... build features with workflow agents ...

# 3. Test Phase
/llm-user init       # Generate test infrastructure
/test-ui             # Run LLM user tests

# 4. Analyze Phase
/llm-user gaps       # Review gap analysis
/fix-gaps list       # List all gaps

# 5. Fix Phase
/fix-gaps            # Fix gaps systematically
# or
/fix-gaps --priority=critical --limit=3

# 6. Verify Phase
/fix-gaps verify     # Re-run tests
/fix-gaps report     # Generate report

# 7. Iterate
# Repeat 3-6 until all promises validated
```

---

## File Structure

After running `/fix-gaps`:

```
project/
├── tests/llm-user/
│   ├── test-spec.yaml
│   ├── personas/
│   ├── scenarios/
│   └── fixes/                                    # NEW: Fix specifications
│       ├── GAP-001-progress-tracking.yaml
│       ├── GAP-002-audio-quality.yaml
│       └── GAP-003-slow-response.yaml
│
├── results/llm-user/
│   └── 2026-01-28T10-30-00Z/
│       ├── gap-analysis.json                     # Input: Gaps to fix
│       ├── gap-analysis.md
│       ├── gap-resolution-status.json            # NEW: Fix progress
│       └── gap-resolution-report.md              # NEW: Final report
│
└── docs/
    └── intent/
        └── product-intent.md                     # Updated: Promise status
```

---

## Integration with LLM User Testing

The two skills work together:

```
┌─────────────────────────────────────────────────────────────┐
│ LLM User Testing (llm-user-testing skill)                   │
│                                                              │
│ /llm-user init    → Generate test infrastructure            │
│ /test-ui          → Execute tests with personas             │
│ /llm-user gaps    → Analyze and report gaps                 │
└────────────────────────────┬────────────────────────────────┘
                             │
                             │ gap-analysis.json
                             ↓
┌─────────────────────────────────────────────────────────────┐
│ Gap Resolver (gap-resolver skill)                           │
│                                                              │
│ /fix-gaps         → Systematic gap resolution               │
│ /fix-gaps verify  → Re-run failed scenarios                 │
│ /fix-gaps report  → Track improvements                      │
└────────────────────────────┬────────────────────────────────┘
                             │
                             │ Verified fixes
                             ↓
                    Updated promise status
                    Release readiness achieved
```

**Command Flow:**
1. `/test-ui` finds gaps → generates `gap-analysis.json`
2. `/llm-user gaps` displays human-readable gaps
3. `/fix-gaps` consumes `gap-analysis.json` → creates fix specs
4. `/fix-gaps` implements fixes → uses workflow agents
5. `/fix-gaps verify` re-runs tests → validates fixes
6. `/test-ui` final run → confirms all promises validated
7. `/fix-gaps report` shows complete journey

---

## Best Practices

### DO

✅ **Fix critical gaps first** - They're release blockers
✅ **Verify after each fix** - Ensure gap is actually resolved
✅ **Re-run full test suite** - Check for regressions
✅ **Update fix specs** - Document why changes were made
✅ **Track promise status** - Know which promises are validated
✅ **Use --limit for large gap lists** - Focus on high-impact fixes

### DON'T

❌ **Don't skip verification** - Unverified fixes may not work
❌ **Don't fix low-priority gaps first** - Focus on critical/high
❌ **Don't ignore failed verifications** - Understand why they failed
❌ **Don't manually edit gap-analysis.json** - Source is test results
❌ **Don't commit fix specs to version control** - They're generated artifacts

---

## Troubleshooting

### "No gap analysis found"

**Problem:** `/fix-gaps` can't find gap analysis to fix

**Solution:**
```bash
# Run LLM user tests first
/test-ui

# Then fix gaps
/fix-gaps
```

### "Gap already closed"

**Problem:** Trying to fix a gap that's already resolved

**Solution:**
```bash
# Check status first
/fix-gaps status

# Fix only pending gaps
/fix-gaps list --status=pending
/fix-gaps --gap=GAP-XXX
```

### "Verification failed after fix"

**Problem:** Fix was implemented but test still fails

**Solution:**
```bash
# Check fix specification
cat tests/llm-user/fixes/GAP-XXX-*.yaml

# Review what was implemented
git log --oneline -5

# Check if acceptance criteria match gap requirements
# May need to:
# 1. Review fix design
# 2. Re-implement with different approach
# 3. Update acceptance criteria if they were wrong
```

### "Gaps keep appearing after fixes"

**Problem:** Same gaps reappear in subsequent test runs

**Solution:**
- Fix may not address root cause - review fix specification
- May be a different gap with similar symptoms - check gap IDs
- Tests may be too strict - review personas' frustration thresholds
- May need architecture change, not just implementation fix

### "Too many gaps to fix"

**Problem:** Test found 20+ gaps, overwhelming to fix

**Solution:**
```bash
# Focus on critical gaps only
/fix-gaps --priority=critical

# Then high-priority
/fix-gaps --priority=high --limit=5

# Check if low-priority gaps are actually important
/llm-user gaps
# Review recommendations and deprioritize non-essential gaps
```

---

## Success Indicators

**Gap resolution is working if:**

1. ✅ Critical gaps get fixed within 1 iteration
2. ✅ Verification confirms gap is resolved
3. ✅ Promise status improves after fixes
4. ✅ Overall test score increases
5. ✅ No regression in previously passing scenarios
6. ✅ Fix specifications are clear and actionable

---

## Related Commands

- `/test-ui` - Execute LLM user tests (generates gaps)
- `/llm-user gaps` - Display gap analysis (human-readable)
- `/llm-user init` - Initialize LLM user testing
- `/verify final` - Manual acceptance testing
- `/review` - Code quality review

---

## Notes

- **Gap IDs are stable** - Same gap gets same ID across test runs if not fixed
- **Fix specs are documentation** - They explain why changes were made
- **Verification is automatic** - Re-runs exact scenarios that failed
- **Promise status is tracked** - Know which promises are fulfilled
- **Works with workflow agents** - Uses backend-engineer, frontend-engineer, test-engineer
- **Complements manual fixes** - Can also fix gaps manually and verify with `/fix-gaps verify`
- **Release readiness metric** - When all critical gaps closed, ready to ship
