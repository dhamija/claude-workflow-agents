# Manual Test Checklist

Automated tests cover structure and content. These manual tests verify actual functionality with Claude Code.

## Prerequisites

- [ ] Claude Code installed and authenticated
- [ ] Repository cloned
- [ ] `./install.sh --user` completed successfully

---

## Test 1: New Project (Greenfield)

### Setup
```bash
mkdir /tmp/test-greenfield && cd /tmp/test-greenfield
claude
```

### Steps

1. [ ] Say: "Build me a simple todo app"
2. [ ] Verify Claude creates /docs/intent/product-intent.md
3. [ ] Verify Claude creates /docs/ux/user-journeys.md
4. [ ] Verify Claude creates /docs/architecture/agent-design.md
5. [ ] Verify Claude creates /docs/plans/
6. [ ] Verify Claude starts building first feature
7. [ ] Say: "Continue"
8. [ ] Verify Claude continues with next task/feature
9. [ ] Say: "Status?"
10. [ ] Verify Claude reports progress correctly

### Expected Results
- [ ] All L1 docs created
- [ ] Feature plans created
- [ ] Implementation starts automatically
- [ ] Progress tracking works

---

## Test 2: Add Feature (Change Management)

### Continuing from Test 1

1. [ ] Say: "Add user categories for todos"
2. [ ] Verify Claude analyzes impact
3. [ ] Verify Claude updates plans
4. [ ] Verify Claude continues building

### Expected Results
- [ ] Change impact analyzed
- [ ] Plans updated
- [ ] Building continues smoothly

---

## Test 3: Brownfield Project

### Setup
```bash
# Use an existing codebase
cd /path/to/existing/project
claude
```

### Steps

1. [ ] Say: "Analyze this codebase"
2. [ ] Verify Claude reads existing files
3. [ ] Verify Claude creates INFERRED docs
4. [ ] Verify Claude asks for confirmation
5. [ ] Say: "Yes, that's correct"
6. [ ] Verify Claude runs gap analysis
7. [ ] Verify Claude creates migration plan
8. [ ] Say: "Fix the critical issues"
9. [ ] Verify Claude fixes issues with tests

### Expected Results
- [ ] INFERRED docs created
- [ ] User asked to confirm understanding
- [ ] Gap analysis runs
- [ ] Migration plan created
- [ ] Fixes include tests

---

## Test 4: Commands

### /agent-wf-help
1. [ ] Say: "/agent-wf-help"
2. [ ] Verify overview shown
3. [ ] Say: "/agent-wf-help workflow"
4. [ ] Verify workflow explanation shown
5. [ ] Say: "/agent-wf-help agents"
6. [ ] Verify all 11 agents listed
7. [ ] Say: "/agent-wf-help examples"
8. [ ] Verify examples shown
9. [ ] Say: "/agent-wf-help brownfield"
10. [ ] Verify brownfield guide shown

### /review
1. [ ] Create some code
2. [ ] Say: "/review"
3. [ ] Verify code review output with severity levels

---

## Test 5: Debugging

### Setup
Create a file with an obvious bug.

### Steps
1. [ ] Say: "The [function] is broken, it [describes wrong behavior]"
2. [ ] Verify Claude investigates
3. [ ] Verify Claude identifies root cause
4. [ ] Verify Claude fixes the issue
5. [ ] Verify Claude adds regression test

### Expected Results
- [ ] Root cause found
- [ ] Minimal fix applied
- [ ] Test added

---

## Test 6: Code Review

### Steps
1. [ ] Say: "Review the code before we release"
2. [ ] Verify Claude reviews code
3. [ ] Verify findings grouped by severity
4. [ ] Verify security issues flagged

### Expected Results
- [ ] Critical/High/Medium/Low format
- [ ] Security issues highlighted
- [ ] Actionable feedback

---

## Test 7: Natural Language Understanding

Test that Claude understands various phrasings:

| You Say | Expected Behavior | Works? |
|---------|-------------------|--------|
| "Build me a..." | Start new project | [ ] |
| "Create a..." | Start new project | [ ] |
| "Continue" | Continue building | [ ] |
| "What's the status?" | Show progress | [ ] |
| "Add [feature]" | Change analysis | [ ] |
| "It's broken" | Debug mode | [ ] |
| "Review the code" | Code review | [ ] |
| "Analyze this codebase" | Brownfield audit | [ ] |

---

## Test Results Summary

| Test | Status | Notes |
|------|--------|-------|
| Test 1: Greenfield | | |
| Test 2: Change Management | | |
| Test 3: Brownfield | | |
| Test 4: Commands | | |
| Test 5: Debugging | | |
| Test 6: Code Review | | |
| Test 7: Natural Language | | |

**Tested By:** ________________
**Date:** ________________
**Claude Code Version:** ________________
**Issues Found:** ________________
