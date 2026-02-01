---
name: workflow
description: |
  Development workflow orchestration. Use when:
  - Starting a new project
  - User asks about workflow status
  - Need to determine next steps
  - Coordinating between phases
---

# Workflow Orchestration

## 🚨 MANDATORY: PLANNING-FIRST PRINCIPLE

**STOP! Before implementing ANYTHING, you MUST:**

1. **CREATE A PLAN** using TodoWrite tool:
   ```
   - List EXACT workflow commands to use
   - List SPECIFIC skills to load
   - List FILES to create/modify
   - List TESTS to run for validation
   ```

2. **SHOW THE PLAN** to the user:
   ```
   "Here's my workflow plan:
   1. /intent-audit to analyze gaps
   2. Load ux-design skill for multi-panel UI
   3. /gap to create GAP-A-XXX entries
   4. /improve --severity=critical
   5. /verify to validate fixes

   Shall I proceed with this plan?"
   ```

3. **EXECUTE STEP-BY-STEP**:
   - Mark each todo as in_progress when starting
   - Mark as completed when done
   - Show actual command output
   - Update state in CLAUDE.md

**NEVER jump straight into coding without a plan!**

### Smart Mode Detection

**When user requests enhancements, CHECK FOR EXISTING ARTIFACTS FIRST:**

```bash
# Before creating plan, check:
ls docs/intent/product-intent.md 2>/dev/null
ls docs/ux/user-journeys.md 2>/dev/null
ls docs/architecture/system-design.md 2>/dev/null
grep "features:" CLAUDE.md
```

**If artifacts exist:**
```
📊 Detected existing system with completed features
📈 This appears to be an enhancement to v1.0

Recommended approach: ITERATION MODE
- Preserves 80-90% of existing functionality
- Extends rather than replaces documentation
- Implements only what changed
- Ensures backward compatibility

Should I create an iteration plan? [Y/n]
```

**User can override but explain consequences:**
```
⚠️ Standard mode will redesign from scratch
- May break existing features
- Will take significantly longer
- Could disrupt user workflows

Are you sure you want standard mode? [y/N]
```

### Planning Verification Checklist

Before proceeding with ANY implementation, verify:

- [ ] TodoWrite plan created with specific workflow steps?
- [ ] Plan shown to user for approval?
- [ ] Each step maps to a workflow command or skill?
- [ ] State tracking configured in CLAUDE.md?
- [ ] Tests identified for validation?
- [ ] No direct code writing without workflow commands?

**If any item unchecked → STOP and create proper plan first!**

## CRITICAL: Real Validation Required

**YOU HAVE THE BASH TOOL. USE IT.**

This workflow ONLY works if you:
1. **Run actual tests** - Use Bash tool to execute `npm test`
2. **Start actual servers** - Use Bash tool to run `npm run dev`
3. **Check actual results** - Show real output, not assumptions
4. **Fail when broken** - If tests fail, say so

**NEVER** say:
- "Tests would pass"
- "Should work"
- "Implementation successful"

**ALWAYS** say:
- "Running tests now..." [then actually run them]
- "Test results: [actual output]"
- "Tests failed with: [actual error]"

## Overview

This skill provides orchestration logic for greenfield and brownfield development workflows. Claude automatically loads this skill when managing project phases.

## L1 Planning Flow (Greenfield)

```
Intent → UX → Architecture → Planning → L2
```

### Phase 1: Intent

**When:** Starting new project or capturing requirements

**Actions:**
1. Load skill: `intent-guardian`
2. Create `/docs/intent/product-intent.md`
3. Capture promises with criticality levels (CORE/IMPORTANT/NICE_TO_HAVE)
4. Define acceptance criteria for each promise
5. Update CLAUDE.md state: `l1.intent.status = complete`

**Continue to:** UX Design

### Phase 2: UX Design

**When:** After intent complete

**Actions:**
1. Load skill: `ux-design`
2. Create `/docs/ux/user-journeys.md`
3. Apply design principles (Fitts's Law, Hick's Law, etc.)
4. Define screen specifications
5. Update CLAUDE.md state: `l1.ux.status = complete`

**Continue to:** Architecture

### Phase 3: Architecture

**When:** After UX complete

**Actions:**
1. Load skill: `architecture`
2. Create `/docs/architecture/system-design.md`
3. Map promises to modules
4. Define tech stack and patterns
5. Update CLAUDE.md state: `l1.architecture.status = complete`

**Continue to:** Planning

### Phase 4: Planning

**When:** After architecture complete

**Actions:**
1. Load skill: `planning`
2. Create `/docs/plans/implementation-order.md`
3. Create feature plans in `/docs/plans/features/`
4. Define build order and dependencies
5. Update CLAUDE.md state: `l1.planning.status = complete`

**Continue to:** L2 Building

---

## L2 Building Flow (Per Feature)

```
Backend → (review) → Frontend → (review) → Tests → Validate → Complete
```

### Step 1: Backend

**Actions:**
1. Load skill: `backend`
2. Implement APIs, database, services
3. **Automatic:** Code review reminder via hook
4. **CRITICAL:** Run ACTUAL backend tests using Bash tool:
   ```bash
   npm test -- backend/
   # Show REAL output, not hypothetical
   ```
5. Only update state if tests ACTUALLY pass: `l2.features[name].backend = complete`

**Continue to:** Frontend

### Step 2: Frontend

**Actions:**
1. Load skill: `frontend`
2. Implement UI components (apply design principles from ux-design skill)
3. **Automatic:** Code review reminder via hook
4. Run frontend tests
5. Update state: `l2.features[name].frontend = complete`

**Continue to:** Testing

### Step 3: Testing

**Actions:**
1. Load skill: `testing`
2. Write comprehensive test coverage
3. Run full test suite
4. **Automatic:** Quality gate reminder via hook
5. Update state: `l2.features[name].tests = complete`

**Continue to:** Validation

### Step 4: Validation

**Actions:**
1. Load skill: `validation`
2. Validate promises are KEPT (not just tests passing)
3. Check acceptance criteria
4. If PARTIAL/FAILED: Create remediation tasks
5. If VALIDATED: Mark feature complete

**Continue to:** Next feature or project complete

---

## Iteration Flow (Evolving Systems)

**NEW! For v2.0+ enhancements to existing systems**

### When to Use Iteration Flow

**Triggered when:**
- User says "enhance with [X]", "add [major feature]", "redesign [area]"
- Significant evolution beyond simple bug fixes
- Need to maintain backward compatibility
- Want to preserve existing functionality

### Iteration Workflow Steps

```
Load State → Analyze Impact → Evolve Docs → Delta Analysis → Incremental Implementation
```

#### Step 1: Load Current State

```bash
# Load existing documentation versions
cat docs/intent/product-intent.md        # v1.0 promises
cat docs/ux/user-journeys.md            # v1.0 journeys
cat docs/architecture/system-design.md   # v1.0 architecture
grep "features:" CLAUDE.md              # Completed features
```

#### Step 2: Iteration Analysis

**Analyze enhancement compatibility:**
1. Will it break existing promises?
2. Does it conflict with current UX?
3. Can architecture support it?
4. What's the integration effort?

**Output:** Compatibility report with risk assessment

#### Step 3: Evolutionary Design

**Create v2.0 documents that EXTEND v1.0:**

```markdown
# Intent v2.0
## Existing Promises (v1.0)
[Keep all existing promises]

## New Promises (v2.0)
[Add new promises]

## Evolution Notes
- What changed and why
- Backward compatibility notes
```

Same pattern for UX v2.0 and Architecture v2.0

#### Step 4: Delta Analysis

**Identify precise changes:**
```yaml
delta_analysis:
  new_promises: [P8, P9]
  modified_journeys: [checkout, profile]
  new_components: [ai_service, suggestion_engine]
  deprecated: []
  preserved: 85%
  breaking_changes: none
```

#### Step 5: Gap-Based Implementation

**Create iteration gaps (GAP-I-XXX):**
```bash
/gap --iteration "v1.0 to v2.0"
# Creates GAP-I-001, GAP-I-002, etc.
```

**Implement incrementally:**
```bash
/improve GAP-I-001  # Highest priority first
/verify GAP-I-001   # Verify no regression
```

#### Step 6: Validation

**Ensure both old AND new work:**
1. All v1.0 tests still pass
2. New v2.0 features validated
3. No performance regression
4. User journeys intact

### State Tracking for Iterations

```yaml
workflow:
  mode: iteration
  version: "1.0 → 2.0"

iteration:
  base_version: "1.0"
  target_version: "2.0"
  compatibility: maintained
  preserved_percentage: 85
  new_promises: [P8, P9]
  iteration_gaps: [GAP-I-001, GAP-I-002]
  status: in_progress
```

## Brownfield Flow (Existing Code)

### First Session

```
Analyze → Infer State → Ask User → Continue
```

**Actions:**
1. Load skill: `brownfield`
2. Scan project structure and code
3. Infer: tech stack, features, promises, test coverage
4. Create [INFERRED] documentation
5. Ask user: What would you like to do?
   - Add feature → change-analysis skill → L2 flow
   - Improve code → gap-analysis skill → Fix gaps
   - Fix bug → debugging skill → Fix + test

---

## Change Request Handling

**Triggered when:** User says "add [feature]", "change [thing]", "also need"

**Actions:**
1. Load skill: `change-analysis`
2. Analyze impact on existing:
   - Intent (new promises?)
   - UX (new journeys?)
   - Architecture (new modules?)
   - Plans (new tasks?)
3. Estimate effort and complexity
4. Present analysis to user
5. On confirmation: Update docs and continue to L2

---

## Issue Response

### Backend/General Issues

**Triggered when:** "error", "crash", "bug", "broken", "doesn't work"

**Actions:**
1. Invoke **debugger** subagent (isolated context)
2. Wait for diagnosis and fix
3. **Automatic:** Code review reminder via hook
4. Verify fix with tests

### UI Issues

**Triggered when:** "page doesn't work", "button broken", "UI issue", "layout wrong"

**Actions:**
1. Invoke **ui-debugger** subagent (isolated context + browser access)
2. Wait for diagnosis and fix
3. **Automatic:** Code review reminder via hook
4. Verify fix with tests

---

## Quality Gates (Automatic via Hooks)

Quality reminders are injected automatically by hooks:

### After Code Changes

PostToolUse hook detects Write/Edit and reminds to run code-reviewer subagent

### Before Marking Complete

Stop hook reminds to check:
- Tests passing?
- Code reviewed?
- State updated?

---

## State Management

### CRITICAL: State Must Be Persisted

**Every workflow action MUST update state in CLAUDE.md immediately:**

1. **Read current state first:**
   ```bash
   grep -A 20 "workflow:" CLAUDE.md
   ```

2. **Update after EVERY action:**
   - Command executed → Update state
   - Skill loaded → Update state
   - Test run → Update state with results
   - Feature completed → Update state

3. **State includes execution details:**
   ```yaml
   workflow:
     phase: L1|L2
     status: in_progress|paused|complete
     last_command: "/gap"
     last_command_output: "Created 5 gaps"
     pending_steps:
       - "/improve --severity=critical"
       - "/verify"
   ```

Always update CLAUDE.md state after significant actions:

```yaml
workflow:
  phase: L1|L2
  status: in_progress|paused|complete

l1:
  intent: {status: pending|in_progress|complete}
  ux: {status: pending|in_progress|complete}
  architecture: {status: pending|in_progress|complete}
  planning: {status: pending|in_progress|complete}

l2:
  current_feature: string
  features:
    feature_name:
      backend: pending|in_progress|complete
      frontend: pending|in_progress|complete
      tests: pending|in_progress|complete
      validation: pending|in_progress|complete
```

---

## Available Skills Reference

Load these skills as needed:

| Skill | Use For |
|-------|---------|
| `intent-guardian` | Capturing user promises and requirements |
| `ux-design` | Designing user experience and applying design principles |
| `architecture` | System design and module architecture |
| `planning` | Creating implementation plans and build order |
| `backend` | Implementing APIs, database, services |
| `frontend` | Implementing UI components with design principles |
| `testing` | Writing comprehensive test coverage |
| `validation` | Validating promises are kept (acceptance testing) |
| `brownfield` | Analyzing existing codebases |
| `change-analysis` | Assessing impact of change requests |
| `gap-analysis` | Finding issues in existing code |
| `debugging` | General debugging strategies |
| `code-quality` | Code review criteria and standards |
| `project-ops` | Project setup, sync, docs, verification |

---

## Available Subagents Reference

Invoke these for isolated tasks:

| Subagent | Use For |
|----------|---------|
| `code-reviewer` | Read-only code review (isolated context) |
| `debugger` | Isolated debugging sessions |
| `ui-debugger` | UI debugging with browser automation |
