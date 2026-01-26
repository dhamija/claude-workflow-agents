---
description: Implement from plans using engineering agents
argument-hint: <"phase N" or specific component>
---

## Prerequisites

Check plans exist:
- /docs/plans/backend-plan.md
- /docs/plans/frontend-plan.md
- /docs/plans/test-plan.md
- /docs/plans/implementation-order.md

If missing: "Run /plan first"

## Parse Target

Target: $ARGUMENTS

### If "phase N":
1. Read /docs/plans/implementation-order.md
2. Find Phase N items
3. Execute each item with appropriate engineer

### If specific component (e.g., "auth endpoints"):
1. Find relevant section in appropriate plan
2. Execute with appropriate engineer

### If empty:
1. Read /docs/plans/implementation-order.md
2. Find first incomplete phase
3. Execute it

## Execution

For each item, delegate to appropriate subagent:

| Item Type | Subagent | Plan File |
|-----------|----------|-----------|
| Database, API, Service, Agent | backend-engineer | backend-plan.md |
| Component, Page, State | frontend-engineer | frontend-plan.md |
| Unit, Integration, E2E test | test-engineer | test-plan.md |

## After Each Item

1. Verify tests pass
2. Check against intent (any promises at risk?)
3. Mark complete in implementation-order.md
4. Commit: `feat([scope]): [description]`

## After Phase Complete

Use test-engineer subagent in verification mode:
1. Run all tests
2. Check for regressions
3. Validate journeys
4. Verify intent compliance
5. Write missing critical tests if needed

Save report to /docs/verification/phase-N-report.md

FAIL → Fix before proceeding
PASS → Ready for next phase

Report:
```
## Phase N Complete

### Implemented
- [list items]

### Tests
- X passing, Y total

### Intent Check
- Promises verified: [list]
- Invariants protected: [list]

### Next
Run `/implement phase N+1` or specific component
```
