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
