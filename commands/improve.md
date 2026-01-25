---
description: Incrementally improve codebase based on migration plan (brownfield L3)
argument-hint: <"phase N" or specific gap ID>
---

## Prerequisites

Check migration plan exists:
- /docs/gaps/migration-plan.md

If missing: "Run /gap first"

## Parse Target

Target: $ARGUMENTS

### If "phase N":
1. Read /docs/gaps/migration-plan.md
2. Find Phase N items
3. Execute each improvement

### If specific gap (e.g., "GAP-007"):
1. Find that gap in gap-analysis.md
2. Execute just that fix

### If empty:
1. Find first incomplete phase
2. Execute it

## Execution

For each gap:

1. Read the gap details from gap-analysis.md
2. Determine the type:
   - Intent/Promise fix → backend-engineer or frontend-engineer
   - UX fix → frontend-engineer
   - Architecture fix → backend-engineer (may involve agentic-architect for design)
   - Test fix → test-engineer
3. Implement the fix
4. Write/update tests to verify the fix
5. Commit: `fix([scope]): [GAP-XXX] [description]`

## After Each Gap

Verify the fix:
- Does it address the gap?
- Did it break anything else? (run tests)
- Is the promise/journey now working?

## After Phase Complete

Use test-engineer to verify:
1. All tests pass
2. No regressions
3. Gaps in this phase are resolved

Save to /docs/verification/improvement-phase-N-report.md

### If FAIL:
````
⛔ Phase N improvements FAILED

Issues:
- [list]

Fix before proceeding.
````

### If PASS:
````
✅ Phase N improvements complete

Fixed:
- [list gaps fixed]

Remaining:
- Phase N+1: X gaps
- Phase N+2: Y gaps
- Backlog: Z gaps

Run `/improve phase N+1` to continue.
````
