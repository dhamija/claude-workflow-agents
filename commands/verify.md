---
description: Verify system correctness after implementation phase
argument-hint: <phase N or "final">
---

Use test-engineer subagent in VERIFICATION MODE for phase: $ARGUMENTS

Verify:
1. Smoke tests pass
2. All tests pass (no regressions)
3. Journeys work (E2E tests exist and pass)
4. Promises kept (verification tests exist and pass)
5. Invariants protected

If critical tests missing, write them first, then verify.

Save report to /docs/verification/phase-N-report.md

FAIL → List blockers, do not proceed
PASS → Confirm ready for next phase
