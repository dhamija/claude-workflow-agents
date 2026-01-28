---
name: gap-resolver
description: |
  Systematic gap resolution from LLM user testing. Prioritizes gaps, designs fixes,
  implements through workflow, and re-validates with LLM users. Drives promise
  validation through iterative test-fix-verify cycles.
version: 1.0.0
---

# Gap Resolver Skill

> **When to load:** After LLM user testing reveals gaps. Drives systematic fix implementation and re-validation.

## Overview

This skill takes gap analysis from LLM user testing and systematically:
1. Prioritizes gaps by severity and impact
2. Creates implementation tasks
3. Drives fixes through workflow (design → implement → test)
4. Re-runs LLM user tests to verify
5. Updates promise status

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         GAP → FIX → VERIFY CYCLE                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  GAP ANALYSIS          FIX IMPLEMENTATION           RE-VALIDATION              │
│  ════════════          ═══════════════════          ═════════════              │
│                                                                                 │
│  [CRITICAL] P3    ──▶  Design ──▶ Build ──▶ Test ──▶ /test-ui    ──▶ P3 ✓     │
│  [HIGH] P2        ──▶  Design ──▶ Build ──▶ Test ──▶ /test-ui    ──▶ P2 ✓     │
│  [MEDIUM] UX      ──▶  Build ──▶ Test        ──▶ /test-ui    ──▶ UX ✓     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/fix-gaps` | Start fixing gaps from last analysis |
| `/fix-gaps --priority=critical` | Fix only critical gaps |
| `/fix-gaps --gap=GAP-ID` | Fix specific gap |
| `/fix-gaps status` | Show fix progress |
| `/fix-gaps verify` | Re-run tests for fixed gaps |
| `/fix-gaps report` | Generate fix summary report |

---

## Phase 1: Load and Prioritize Gaps

### 1.1 Read Gap Analysis

```bash
# Find latest test results
ls -lt tests/llm-user/results/ | head -5

# Read gap analysis report
cat tests/llm-user/results/latest/report.md
```

### 1.2 Parse Gaps into Fix Queue

Create structured fix queue from gap analysis:

```yaml
# tests/llm-user/fix-queue.yaml

fix_queue:
  - id: GAP-001
    priority: CRITICAL
    promise: P3
    title: "No Progress Tracking"

    # From gap analysis
    observation: |
      Jake completed 3 scenes but had no indication of progress.
      Frustration reached 0.85 and he abandoned.

    root_cause: |
      No progress tracking UI was implemented despite being in intent doc.

    recommendation: |
      Add progress dashboard showing:
      - Scenes completed
      - Vocabulary learned
      - Skills improved
      - Streak/consistency

    # From gap analysis metadata
    affected_personas: [jake-teen, maria-beginner]
    failed_scenarios: [multi-scene-session]
    related_docs:
      - /docs/intent/product-intent.md#P3
      - /docs/ux/user-journeys.md#progress-tracking

    # Estimated effort (from gap analysis)
    effort: medium
    impact: high

    # Fix tracking
    status: pending  # pending, in_progress, implemented, verified, closed
    created_at: "2024-01-15T10:00:00Z"

  - id: GAP-002
    priority: HIGH
    promise: P2
    title: "Feedback Not Level-Adaptive"
    observation: |
      Sofia (heritage speaker) wrote advanced Spanish but received generic
      "¡Excelente!" feedback. No suggestions for improvement.
    root_cause: "No level detection or adaptive feedback system"
    recommendation: "Implement level detection + adaptive feedback"
    affected_personas: [sofia-heritage]
    failed_scenarios: [advanced-description]
    effort: high
    impact: high
    status: pending
```

### 1.3 Prioritization Rules

```
PRIORITY ORDER:
═══════════════════════════════════════════════════════════════

1. CRITICAL gaps (blocks release)
   - Core promise unfulfilled
   - User abandonment
   - Critical path broken

2. HIGH gaps (significant impact)
   - Important promise partial
   - High frustration
   - Affects multiple personas

3. MEDIUM gaps (quality improvement)
   - UX principle violations
   - Performance issues
   - Single persona affected

4. LOW gaps (nice to have)
   - Minor polish
   - Edge cases
   - Enhancement ideas


WITHIN SAME PRIORITY:
─────────────────────────────────────────────────────────────────
Sort by: Impact (high→low) → Effort (low→high) → Dependencies

BLOCKING RULES:
─────────────────────────────────────────────────────────────────
- CRITICAL gaps must be fixed before release
- HIGH gaps should be fixed before new features
- MEDIUM/LOW can be backlogged
```

---

## Phase 2: Design Fix

For each gap, create a fix specification before implementing.

### 2.1 Fix Specification Template

Use template from `templates/skills/gap-resolver/templates/fix-spec.template.yaml`

```yaml
# tests/llm-user/fixes/GAP-001-progress-tracking.yaml

fix_specification:
  gap_id: GAP-001
  title: "Add Progress Tracking"
  promise: P3
  priority: CRITICAL
  created_at: "2024-01-15T10:30:00Z"

  # ═══════════════════════════════════════════════════════════════
  # PROBLEM ANALYSIS
  # ═══════════════════════════════════════════════════════════════

  problem:
    observation: |
      Jake (impatient teen) completed 3 scenes but saw no progress.
      His thoughts: "How many more? Am I getting better?"
      Frustration: 0.4 → 0.85 → ABANDONED

    root_cause: |
      - No progress state tracked in backend
      - No progress UI component
      - No feedback on improvement over time

    acceptance_criteria_failed:
      - "Users feel they are making progress"
      - "Progress is visible after each activity"

    affected_personas:
      - jake-teen: "Abandoned at scene 3 due to no visible progress"
      - maria-beginner: "Completed but expressed confusion about progress"

  # ═══════════════════════════════════════════════════════════════
  # FIX DESIGN
  # ═══════════════════════════════════════════════════════════════

  design:
    # What changes are needed?
    backend:
      - component: "Progress Service"
        location: "src/services/progress.ts"
        changes:
          - "Track scenes completed per user"
          - "Track vocabulary encountered/mastered"
          - "Calculate skill improvements"
          - "Maintain streak data"

      - component: "API Endpoints"
        location: "src/api/routes/progress.ts"
        changes:
          - "GET /api/user/progress - Return progress summary"
          - "POST /api/user/progress/scene - Record scene completion"

    frontend:
      - component: "ProgressDashboard"
        location: "src/components/Progress/ProgressDashboard.tsx"
        features:
          - "Scenes completed counter"
          - "Vocabulary progress bar"
          - "Skills radar chart"
          - "Streak indicator"
          - "Encouraging messages"

      - component: "SceneComplete"
        location: "src/components/Scene/SceneComplete.tsx"
        changes:
          - "Show mini progress update after each scene"
          - "Link to full dashboard"

    integration:
      - "Show ProgressDashboard after every 3rd scene"
      - "Show mini progress after every scene"
      - "Accessible from main nav"

    ux_considerations:
      - "Use encouraging language (not judgmental)"
      - "Focus on growth, not perfection"
      - "Celebrate small wins"

  # ═══════════════════════════════════════════════════════════════
  # IMPLEMENTATION TASKS
  # ═══════════════════════════════════════════════════════════════

  tasks:
    - id: GAP-001-T1
      name: "Create Progress Service"
      type: backend
      agent: backend-engineer
      description: |
        Create service to track and calculate user progress.
        Should persist data to database and provide summary calculations.
      acceptance:
        - "Tracks scenes completed per user"
        - "Calculates vocabulary mastery percentage"
        - "Returns progress summary with timestamps"
      files:
        - "src/services/progress.ts"
        - "src/models/progress.ts"
      effort: 4h

    - id: GAP-001-T2
      name: "Add Progress API Endpoints"
      type: backend
      agent: backend-engineer
      depends_on: [GAP-001-T1]
      description: |
        Expose progress data via REST API.
        Requires authentication.
      acceptance:
        - "GET /api/user/progress returns summary"
        - "POST /api/user/progress/scene records completion"
        - "Authenticated users only"
        - "Returns 401 if not authenticated"
      files:
        - "src/api/routes/progress.ts"
      effort: 2h

    - id: GAP-001-T3
      name: "Create ProgressDashboard Component"
      type: frontend
      agent: frontend-engineer
      depends_on: [GAP-001-T2]
      description: |
        Build visual progress dashboard with charts and stats.
        Must feel encouraging, not judgmental.
      acceptance:
        - "Shows scenes completed"
        - "Shows vocabulary progress with percentage"
        - "Shows streak"
        - "Uses encouraging messages"
        - "Responsive design"
      files:
        - "src/components/Progress/ProgressDashboard.tsx"
        - "src/components/Progress/ProgressChart.tsx"
      effort: 4h

    - id: GAP-001-T4
      name: "Integrate Progress into Scene Flow"
      type: frontend
      agent: frontend-engineer
      depends_on: [GAP-001-T3]
      description: |
        Show progress after scene completion.
        Mini-progress after each, full dashboard every 3rd scene.
      acceptance:
        - "Mini progress shown after each scene"
        - "Full dashboard shown after every 3rd scene"
        - "Smooth transitions"
        - "Can dismiss and continue"
      files:
        - "src/components/Scene/SceneComplete.tsx"
        - "src/pages/PracticePage.tsx"
      effort: 2h

    - id: GAP-001-T5
      name: "Write Tests"
      type: testing
      agent: test-engineer
      depends_on: [GAP-001-T4]
      description: |
        Unit and integration tests for progress feature.
      acceptance:
        - "Progress service unit tests"
        - "API endpoint tests"
        - "Component tests for ProgressDashboard"
        - "Integration test for scene flow"
      files:
        - "tests/services/progress.test.ts"
        - "tests/api/progress.test.ts"
        - "tests/components/Progress.test.tsx"
      effort: 2h

  # ═══════════════════════════════════════════════════════════════
  # VERIFICATION PLAN
  # ═══════════════════════════════════════════════════════════════

  verification:
    # Re-run the scenarios that failed
    scenarios_to_rerun:
      - multi-scene-session

    # With the personas that were affected
    personas_to_test:
      - jake-teen
      - maria-beginner

    # Success criteria for verification
    success_criteria:
      - name: "Jake completes 5+ scenes"
        metric: "completion_count >= 5"

      - name: "Jake's frustration stays low"
        metric: "final_frustration < 0.5"

      - name: "Jake mentions progress"
        metric: "mentions_keyword('progress', 'improvement', 'growing')"

      - name: "Maria feels encouraged"
        metric: "satisfaction > 0.7"

    # Expected promise outcome
    promise_validation:
      P3:
        before: FAILED
        expected_after: VALIDATED
        evidence_required:
          - "User completed more scenes than before fix"
          - "Frustration lower than before fix"
          - "User mentions seeing progress"

  # ═══════════════════════════════════════════════════════════════
  # STATUS TRACKING
  # ═══════════════════════════════════════════════════════════════

  status: pending  # pending, in_progress, implemented, verifying, verified, closed, failed

  timeline:
    created_at: "2024-01-15T10:30:00Z"
    started_at: null
    implemented_at: null
    verified_at: null
    closed_at: null

  resolution: null  # Filled after verification
```

### 2.2 Design Review Checklist

Before implementing, verify the fix design:

```
FIX DESIGN REVIEW: GAP-001
═══════════════════════════════════════════════════════════════

□ Root cause correctly identified?
  ✓ Yes - no progress tracking exists

□ Fix actually addresses root cause (not symptoms)?
  ✓ Yes - adds progress tracking at source

□ Design aligns with existing architecture?
  ✓ Yes - follows service/API/component pattern

□ No new UX problems introduced?
  ✓ Yes - progress is optional/non-blocking

□ Effort estimate reasonable?
  ✓ Yes - 14h total (backend 6h, frontend 6h, tests 2h)

□ Dependencies identified?
  ✓ Yes - tasks ordered by dependency

□ Verification plan covers failed scenarios?
  ✓ Yes - will re-run multi-scene-session with jake-teen

VERDICT: Approved for implementation ✓
```

---

## Phase 3: Implement Fix

Execute tasks in dependency order.

### 3.1 Implementation Protocol

```
FOR EACH TASK:
═══════════════════════════════════════════════════════════════

1. ANNOUNCE
   ───────────────────────────────────────────────────────────
   "Fixing GAP-001: Progress Tracking

    Task: GAP-001-T1 - Create Progress Service
    Type: Backend
    Agent: backend-engineer
    Effort: ~4h"

2. LOAD CONTEXT
   ───────────────────────────────────────────────────────────
   - Read related docs (architecture, existing services)
   - Review existing code patterns
   - Understand data models

3. IMPLEMENT
   ───────────────────────────────────────────────────────────
   [Write code following existing patterns]
   [Reference architecture docs]
   [Follow project conventions]
   [Use backend skill for backend tasks]
   [Use frontend skill for frontend tasks]

4. VERIFY TASK
   ───────────────────────────────────────────────────────────
   - Does it meet task acceptance criteria?
   - Does it compile/run?
   - Basic sanity check

5. CODE REVIEW (automatic)
   ───────────────────────────────────────────────────────────
   [Invoke code-reviewer subagent on changed files]
   [Fix any issues found]

6. UPDATE STATUS
   ───────────────────────────────────────────────────────────
   Update fix-spec.yaml:
     tasks[0].status: pending → completed
     tasks[0].completed_at: timestamp

7. CONTINUE TO NEXT TASK
   ───────────────────────────────────────────────────────────
   [Respect dependencies]
   [If task has depends_on, ensure those are complete first]
```

### 3.2 After All Tasks Complete

```
GAP IMPLEMENTATION COMPLETE: GAP-001
═══════════════════════════════════════════════════════════════

Gap: GAP-001 - Progress Tracking
Status: Implemented (pending verification)

Tasks completed:
  ✓ GAP-001-T1: Progress Service (completed in 3.5h)
  ✓ GAP-001-T2: API Endpoints (completed in 1.5h)
  ✓ GAP-001-T3: ProgressDashboard (completed in 4h)
  ✓ GAP-001-T4: Scene Integration (completed in 2h)
  ✓ GAP-001-T5: Tests (completed in 2h)

Files changed:
  + src/services/progress.ts (new)
  + src/models/progress.ts (new)
  + src/api/routes/progress.ts (new)
  + src/components/Progress/ProgressDashboard.tsx (new)
  + src/components/Progress/ProgressChart.tsx (new)
  ~ src/components/Scene/SceneComplete.tsx (modified)
  ~ src/pages/PracticePage.tsx (modified)
  + tests/services/progress.test.ts (new)
  + tests/api/progress.test.ts (new)
  + tests/components/Progress.test.tsx (new)

Tests: 12 passing

Implementation complete at: 2024-01-15T14:00:00Z
Total time: 13h (estimated: 14h)

Ready for verification. Run:
  /fix-gaps verify --gap=GAP-001
```

---

## Phase 4: Verify Fix

Re-run LLM user tests to confirm gap is resolved.

### 4.1 Verification Protocol

```
VERIFICATION: GAP-001 - Progress Tracking
═══════════════════════════════════════════════════════════════

1. LOAD FIX SPECIFICATION
   ───────────────────────────────────────────────────────────
   Read tests/llm-user/fixes/GAP-001-progress-tracking.yaml
   Extract verification.scenarios_to_rerun
   Extract verification.personas_to_test

2. RUN FAILED SCENARIOS
   ───────────────────────────────────────────────────────────
   For each (scenario, persona) combination:

   Load llm-user-testing skill
   Execute: /test-ui --scenario=multi-scene-session --persona=jake-teen

3. COMPARE RESULTS
   ───────────────────────────────────────────────────────────

   BEFORE FIX (from original gap analysis):
   │ Scenario: multi-scene-session
   │ Persona: jake-teen
   │ Result: ABANDONED at scene 3
   │ Frustration: 0.85
   │ Jake's thoughts: "How many more? This is pointless."
   │
   │ Success criteria failed:
   │ ✗ Complete 5+ scenes
   │ ✗ Frustration < 0.5
   │ ✗ User feels progress

   AFTER FIX (from re-test):
   │ Scenario: multi-scene-session
   │ Persona: jake-teen
   │ Result: COMPLETED (5 scenes)
   │ Frustration: 0.35
   │ Jake's thoughts: "Cool, I've done 5 scenes!
   │                   My vocabulary is growing."
   │
   │ Success criteria:
   │ ✓ Complete 5+ scenes
   │ ✓ Frustration < 0.5
   │ ✓ User mentions progress

4. CHECK SUCCESS CRITERIA
   ───────────────────────────────────────────────────────────
   From fix-spec.yaml verification.success_criteria:

   ✓ Jake completes 5+ scenes (actual: 5)
   ✓ Jake's frustration stays low (actual: 0.35 < 0.5)
   ✓ Jake mentions progress (keywords: "growing", "5 scenes")

   All success criteria met: YES ✓

5. VERIFY PROMISE
   ───────────────────────────────────────────────────────────
   P3: "Users feel progress in learning"

   Before fix: FAILED
   After fix:  VALIDATED ✓

   Evidence:
   - Jake completed 5 scenes (was: 3 then abandoned)
   - Frustration 0.35 (was: 0.85, -59%)
   - Jake said: "I can see I'm improving"
   - Maria also tested: "I love seeing my progress!"

6. RUN REGRESSION CHECK
   ───────────────────────────────────────────────────────────
   Ensure fix didn't break other scenarios:

   /test-ui --scenario=all --personas=all

   Results:
   ✓ first-scene-description (Maria) - PASS
   ✓ learning-from-corrections (Maria) - PASS
   ✓ multi-scene-session (Jake) - PASS (was: FAIL)
   ✓ advanced-description (Sofia) - PASS

   No regressions detected ✓

VERIFICATION RESULT: PASS ✓
```

### 4.2 Verification Outcomes

Record verification results:

```yaml
# Append to tests/llm-user/fixes/GAP-001-progress-tracking.yaml

verification_result:
  verified_at: "2024-01-15T14:30:00Z"
  status: VERIFIED

  scenario_results:
    - scenario: multi-scene-session
      persona: jake-teen
      before:
        result: abandoned
        frustration: 0.85
        completion: "3/5 scenes"
      after:
        result: completed
        frustration: 0.35
        completion: "5/5 scenes"
      improvement: "+67% completion, -59% frustration"
      verdict: PASS

    - scenario: multi-scene-session
      persona: maria-beginner
      before:
        result: completed
        frustration: 0.5
        satisfaction: 0.6
      after:
        result: completed
        frustration: 0.3
        satisfaction: 0.8
      improvement: "+33% satisfaction, -40% frustration"
      verdict: PASS

  success_criteria_met:
    - "Jake completes 5+ scenes": true
    - "Jake's frustration stays low": true
    - "Jake mentions progress": true
    - "Maria feels encouraged": true

  promise_validation:
    P3:
      before: FAILED
      after: VALIDATED
      evidence:
        - "Jake completed 5 scenes (was: 3 then abandoned)"
        - "Frustration 0.35 (was: 0.85, improvement: -59%)"
        - "Jake said: 'I can see I'm improving'"
        - "Maria said: 'I love seeing my progress!'"

  regression_check:
    scenarios_tested: 4
    scenarios_passed: 4
    new_issues: []
    verdict: PASS

  final_verdict: GAP RESOLVED ✓
```

### 4.3 If Verification Fails

```
VERIFICATION FAILED: GAP-001
═══════════════════════════════════════════════════════════════

Expected: Jake completes 5+ scenes
Actual: Jake completed 4 scenes, frustration 0.6

Analysis:
  - Progress dashboard helped (frustration lower than before: 0.85 → 0.6)
  - But "vocabulary learned" section confusing
  - Jake: "What do these numbers mean? 15/20 what?"
  - Still abandoned at scene 4 (was: scene 3)

Root cause of failure:
  - Progress UI not intuitive enough
  - Numbers without context
  - No explanatory labels

DECISION: Additional fix needed

Creating follow-up tasks:
  GAP-001-T6: Add explanatory labels to progress UI
  GAP-001-T7: Use visual indicators instead of raw numbers
  GAP-001-T8: Add tooltips for metrics

Status: VERIFIED → IN_PROGRESS (iteration)

[Continue fix cycle...]
```

---

## Phase 5: Update State

After verification passes, update tracking.

### 5.1 Update Gap Status in Fix Spec

```yaml
# tests/llm-user/fixes/GAP-001-progress-tracking.yaml

fix_specification:
  # ... (previous content)

  status: closed  # was: verified

  timeline:
    created_at: "2024-01-15T10:30:00Z"
    started_at: "2024-01-15T11:00:00Z"
    implemented_at: "2024-01-15T14:00:00Z"
    verified_at: "2024-01-15T14:30:00Z"
    closed_at: "2024-01-15T14:35:00Z"

  resolution:
    verified_at: "2024-01-15T14:30:00Z"

    tasks_completed: 5
    total_time: "13h"

    verification_results:
      scenarios_passed: [multi-scene-session]
      personas_satisfied: [jake-teen, maria-beginner]
      promise_validated: P3

    summary: |
      Added progress tracking with dashboard showing scenes completed,
      vocabulary learned, and skills improved. Jake now completes
      5+ scenes with low frustration (0.35 vs 0.85 before).
      Maria also reports feeling encouraged by seeing progress.
```

### 5.2 Update Promise Status in CLAUDE.md

```yaml
# In project's CLAUDE.md workflow state

promises:
  P3:
    statement: "Users feel progress in learning"
    status: validated  # was: failed
    validated_at: "2024-01-15T14:30:00Z"
    validated_by: "LLM user re-test"

    evidence:
      - "Jake completed 5 scenes (was: 3 then abandoned)"
      - "Frustration 0.35 (was: 0.85, -59%)"
      - "Progress dashboard well-received"
      - "Maria: 'I love seeing my progress!'"

    fix_history:
      - gap_id: GAP-001
        fixed_at: "2024-01-15T14:35:00Z"
        summary: "Added progress tracking dashboard"
        tasks: 5
        time: "13h"
```

### 5.3 Update Gap Analysis Summary

```yaml
# tests/llm-user/results/latest/summary.yaml

gap_summary:
  last_updated: "2024-01-15T14:35:00Z"

  total_gaps: 5

  by_status:
    closed: 2
    verified: 0
    in_progress: 1
    pending: 2

  by_priority:
    critical:
      total: 1
      closed: 1  # GAP-001 ✓
    high:
      total: 2
      closed: 1
      in_progress: 1  # GAP-002
    medium:
      total: 2
      pending: 2

  promises:
    validated: [P1, P3]  # P3 was FAILED, now VALIDATED
    partial: [P2]
    failed: []

  overall_score:
    initial: 6.3/10
    current: 7.8/10
    target: 8.0/10

  history:
    - timestamp: "2024-01-15T10:00:00Z"
      score: 6.3
      event: "Initial test"
    - timestamp: "2024-01-15T14:35:00Z"
      score: 7.8
      event: "GAP-001 closed (Progress Tracking)"
```

---

## Phase 6: Continue to Next Gap

After closing a gap, automatically continue to next priority.

```
GAP-001: Progress Tracking ──────────────────────────── CLOSED ✓

Score improved: 6.3 → 7.8 (+1.5)
Promise P3: FAILED → VALIDATED

Continuing to next gap...

═══════════════════════════════════════════════════════════════

GAP-002: Feedback Not Level-Adaptive
Priority: HIGH
Promise: P2 (partial)
Affected: Sofia (heritage speaker)

Observation:
  Sofia wrote advanced Spanish but received generic "¡Excelente!"
  No suggestions for improvement, no advanced vocabulary.
  Sofia: "I wanted to learn something new. This is too basic."

Root cause:
  No level detection or adaptive feedback system

Recommendation:
  Implement level detection + adaptive feedback
  - Analyze user input complexity
  - Provide level-appropriate suggestions
  - Introduce advanced vocabulary for capable users

Effort: High (5 days)
Impact: High (affects user retention)

Proceed with fix design? [Y/n]
```

---

## Integration with Workflow

### Post-Test Hook

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": {
        "tool_name": "Bash",
        "content": "test-ui"
      },
      "hooks": [{
        "type": "command",
        "command": "echo '[GAP-RESOLVER] Tests complete. Run /fix-gaps to address issues.'"
      }]
    }]
  }
}
```

### Feature Completion Checklist

```
FEATURE COMPLETION CHECKLIST (Updated)
═══════════════════════════════════════════════════════════════

□ Implementation complete
□ Unit tests pass
□ Integration tests pass
□ Code reviewed
□ LLM user tests run (/test-ui)
□ Gaps identified and prioritized
□ Critical gaps fixed (/fix-gaps --priority=critical)  ← REQUIRED
□ All scenarios pass
□ Promise validated
□ Documentation updated

CANNOT release with unfixed CRITICAL gaps
```

---

## Commands Reference

### `/fix-gaps` (Main Command)

Start fixing gaps from latest analysis.

```bash
# Fix all gaps in priority order
/fix-gaps

# Only critical gaps (blocks release)
/fix-gaps --priority=critical

# Critical and high priority
/fix-gaps --priority=high

# Specific gap only
/fix-gaps --gap=GAP-001

# Show what would be fixed (dry run)
/fix-gaps --dry-run

# Limit number of gaps to fix
/fix-gaps --limit=3
```

### `/fix-gaps status`

Show current fix progress.

```
GAP FIX STATUS
═══════════════════════════════════════════════════════════════

Last updated: 2024-01-15T14:35:00Z

Overall Progress: 2/5 gaps closed (40%)
Score: 7.8/10 (target: 8.0/10, +0.2 needed)

CRITICAL:
  ✓ GAP-001: Progress Tracking          CLOSED (13h)

HIGH:
  ◐ GAP-002: Level-Adaptive Feedback    IN PROGRESS (T3/T5, ~6h remaining)
  ○ GAP-003: Error Recovery             PENDING (~4h)

MEDIUM:
  ○ GAP-004: Scene Load Time            PENDING (~2h)
  ○ GAP-005: Navigation Clarity         PENDING (~3h)

Promises:
  ✓ P1: Scene presentation      VALIDATED
  ✓ P3: Progress tracking       VALIDATED (was: FAILED)
  ~ P2: Spanish conversation    PARTIAL (GAP-002 in progress)

Next: Complete GAP-002 verification, then fix GAP-003
```

### `/fix-gaps verify`

Re-run tests for implemented fixes.

```bash
# Verify all implemented gaps
/fix-gaps verify

# Verify specific gap
/fix-gaps verify --gap=GAP-001

# Verify and show detailed results
/fix-gaps verify --verbose
```

### `/fix-gaps report`

Generate summary report of all fixes.

```
GAP FIX REPORT
═══════════════════════════════════════════════════════════════

Session: 2024-01-15
Duration: 4h 35min

Gaps Addressed: 3
Gaps Verified: 2
Gaps Closed: 2
Gaps Failed Verification: 1 (needs iteration)

Score Improvement: 6.3 → 7.8 (+1.5)

Promises Updated:
  P3: FAILED → VALIDATED
  P2: PARTIAL → PARTIAL (improved but not complete yet)

Time Breakdown:
  GAP-001 (Progress Tracking): 13h
  GAP-002 (Adaptive Feedback): 8h (in progress)

Remaining Work:
  - GAP-002: Complete T4, T5 and verify (~6h)
  - GAP-003: Error Recovery (~4h)
  - GAP-004: Scene Load Time (~2h)
  - GAP-005: Navigation Clarity (~3h)

Estimated Time to 8.0 Score: ~6 hours
Estimated Time to Complete All Gaps: ~15 hours
```

---

## File Structure

```
tests/llm-user/
├── results/
│   ├── latest/                 # Symlink to most recent
│   │   ├── report.md           # Gap analysis (from llm-user-testing)
│   │   └── summary.yaml        # Machine-readable summary
│   └── 2024-01-15T10-00-00/
│       ├── report.md
│       ├── summary.yaml
│       └── recordings/
│
├── fixes/
│   ├── GAP-001-progress-tracking.yaml
│   ├── GAP-002-adaptive-feedback.yaml
│   └── ...
│
└── fix-queue.yaml              # Current fix queue and overall status
```

---

## Error Handling

### If Gap Analysis Not Found

```
ERROR: No gap analysis found
═══════════════════════════════════════════════════════════════

Expected: tests/llm-user/results/latest/report.md
Found: None

You must run LLM user tests first:
  1. /llm-user init    (if not done)
  2. /test-ui          (run tests)
  3. /fix-gaps         (fix gaps)

Or specify a specific results directory:
  /fix-gaps --results=tests/llm-user/results/2024-01-15T10-00-00/
```

### If No Gaps Found

```
✓ No gaps found!
═══════════════════════════════════════════════════════════════

All scenarios passed
All promises validated
Overall score: 9.2/10

Your app meets all acceptance criteria from LLM user testing.

Consider:
  - Running tests with different personas
  - Testing edge cases
  - Adding more scenarios
```

### If Dependency Missing

```
ERROR: Cannot implement GAP-001-T3
═══════════════════════════════════════════════════════════════

Task: GAP-001-T3 - Create ProgressDashboard Component
Depends on: GAP-001-T2 (Add Progress API Endpoints)
Status: GAP-001-T2 is PENDING (not complete)

You must complete GAP-001-T2 first, or remove the dependency.
```

---

## Best Practices

### 1. Fix One Gap at a Time

Don't parallelize gap fixes - they may interact.

```
GOOD:
  Fix GAP-001 → Verify → Close → Fix GAP-002 → Verify → Close

BAD:
  Start GAP-001, GAP-002, GAP-003 all at once
  (May have conflicting changes, hard to debug verification failures)
```

### 2. Always Verify Before Moving On

```
GOOD:
  Implement GAP-001 → Verify passes → Close → Continue to GAP-002

BAD:
  Implement GAP-001 → Implement GAP-002 → Verify both
  (If verification fails, unclear which fix caused the issue)
```

### 3. Update State Immediately After Verification

Don't batch state updates.

```
GOOD:
  Verify GAP-001 → Update CLAUDE.md → Update summary.yaml → Continue

BAD:
  Verify GAP-001, GAP-002, GAP-003 → Update all state at once
  (Lose track of what's been validated)
```

### 4. Re-test Regression After Each Fix

Even small fixes can break other scenarios.

```
ALWAYS:
  After closing gap → Run /test-ui --scenario=all
  Ensure no new failures introduced
```

### 5. Document Why Fixes Work

In resolution summary, explain why the fix resolved the gap.

```
GOOD:
  "Added progress dashboard. Jake now completes 5 scenes because
   he can see he's making progress (frustration 0.85 → 0.35)."

BAD:
  "Added progress dashboard."
```

---

## Troubleshooting

### Verification Keeps Failing

**Symptom:** Fix looks correct but verification fails.

**Diagnosis:**
1. Is the root cause correctly identified?
2. Does the fix actually address the root cause?
3. Are success criteria realistic?
4. Is there a different underlying issue?

**Solution:**
- Re-read original gap analysis carefully
- Run test manually and observe LLM user behavior
- May need to iterate on fix design

### Score Not Improving

**Symptom:** Gaps closed but overall score barely improves.

**Diagnosis:**
- Fixing low-impact gaps (MEDIUM/LOW priority)
- Original test scenarios not comprehensive
- Need more diverse personas

**Solution:**
- Focus on CRITICAL and HIGH gaps first
- Consider adding more test scenarios
- Test with different personas

### Task Dependencies Blocking Progress

**Symptom:** Can't start next task because dependency not met.

**Diagnosis:**
- Task order not optimized
- Circular dependencies

**Solution:**
- Re-order tasks in fix spec
- Break circular dependencies
- Implement in smaller increments
