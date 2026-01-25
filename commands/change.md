---
description: Analyze impact of a requirement change across all project artifacts
argument-hint: <description of the change>
---

Use change-analyzer subagent to assess impact of:

$ARGUMENTS

## Prerequisites

Should have existing artifacts from analysis/planning:
- /docs/intent/product-intent.md
- /docs/ux/user-journeys.md
- /docs/architecture/agent-design.md (or system-design.md)
- /docs/plans/*.md (if greenfield)
- /docs/gaps/migration-plan.md (if brownfield)

If running very early (before /analyze), will analyze against minimal baseline.

## Process

### Step 1: Load Current State

Use Glob to find all existing docs:
- Glob("docs/**/*.md")
- Read each relevant file

### Step 2: Analyze Impact

change-analyzer evaluates:
1. **Change type:** Addition / Modification / Removal / Pivot
2. **Scope:** Minor / Medium / Major / Pivot
3. **Impact per artifact:**
   - Intent (promises, invariants, boundaries)
   - UX (journeys, personas, screens)
   - Architecture (entities, APIs, agents)
   - Plans (backend, frontend, tests, phases)
4. **Dependency ripple:** What else changes as consequence
5. **Conflicts:** Any contradictions with existing decisions
6. **Completed work:** What's already built and affected

### Step 3: Assess Rework

Check implementation-order.md (if exists):
- What phases are complete?
- What's in progress?
- Does change affect completed work?
- Can we extend or must we modify?

### Step 4: Produce Impact Report

Create detailed analysis showing:
- Impact summary table (artifact → impact level → action)
- Detailed changes per artifact
- Conflicts detected
- Rework assessment
- Recommended update sequence
- Effort estimate

## Output

Create /docs/changes/ directory if not exists.

Save report to `/docs/changes/change-[timestamp].md`

Format includes:
```
# Change Impact Analysis

## Change Request
[What user wants]

## Impact Summary
[Table of affected artifacts]

## Detailed Impact
[Specific changes per artifact]

## Conflicts Detected
[Any issues]

## Implementation Already Done
[Rework assessment]

## Recommended Update Sequence
[Step-by-step update process]

## Estimated Effort Impact
[Timeline and scope changes]
```

## Next Steps

Review the impact analysis, then:

**If changes accepted:**
```bash
/update
```
This will apply changes to artifacts and trigger `/replan`.

**If too much rework:**
Consider alternative approaches or defer the change.

**If conflicts detected:**
Resolve conflicts before proceeding.

## Example

```bash
# User realizes they need roles
/change add user roles and permissions - admins, editors, and viewers with different access levels

# Output shows:
# - Intent: Add promise about access control
# - UX: Add role management journey
# - Architecture: Add Role entity, permission checks
# - Backend: Add role endpoints, modify auth
# - Frontend: Add role management page
# - Phase impact: Extends current phase
```
