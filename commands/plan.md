---
description: Generate implementation plans from analysis outputs
argument-hint: <optional tech stack override>
---

## Prerequisites Check

Verify these files exist:
- /docs/intent/product-intent.md
- /docs/ux/user-journeys.md
- /docs/architecture/agent-design.md

If ANY missing, tell user which analysis to run first.

## Generate Plans

Use the implementation-planner subagent to:

1. Read all three analysis documents
2. Synthesize into coherent technical vision
3. Produce detailed implementation plans:
   - /docs/plans/backend-plan.md
   - /docs/plans/frontend-plan.md
   - /docs/plans/test-plan.md
   - /docs/plans/implementation-order.md

Tech stack (if specified): $ARGUMENTS

## Output

Summary of what's planned:
- Backend: X endpoints, Y services, Z agents
- Frontend: X pages, Y components
- Tests: X unit, Y integration, Z e2e
- Estimated phases: N

Tell user: "Plans complete. Run /implement to start building."
