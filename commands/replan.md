---
description: Regenerate implementation plans after L1 artifact changes
argument-hint: <optional: specific plan to regenerate or "all">
---

Regenerate implementation plans based on updated L1 artifacts.

Target: $ARGUMENTS (default: all affected plans)

## Prerequisites

L1 artifacts must exist:
- /docs/intent/product-intent.md
- /docs/ux/user-journeys.md
- /docs/architecture/agent-design.md (or system-design.md)

Existing plans should exist (from previous /plan):
- /docs/plans/backend-plan.md
- /docs/plans/frontend-plan.md
- /docs/plans/test-plan.md
- /docs/plans/implementation-order.md

## Process

### Step 1: Detect Changes

Compare current L1 artifacts against existing plans:

Use **implementation-planner** to analyze:
- What's in L1 that's missing from plans? (new requirements)
- What's in plans that's removed from L1? (removed features)
- What's changed in L1 that affects plans? (modifications)

### Step 2: Assess Implementation Progress

Read `/docs/plans/implementation-order.md`:
- Which phases are marked ✅ COMPLETE?
- Which phases are marked 🔄 IN PROGRESS?
- Which phases are pending?

Check git commits or verification reports for actual completion status.

### Step 3: Preserve vs Regenerate Decision

**Preserve (don't change):**
- Completed phases that aren't affected by L1 changes
- In-progress work that doesn't conflict with changes
- Implementation details that remain valid

**Regenerate (update):**
- Affected completed work (mark as needing migration)
- In-progress work that conflicts with changes
- Future phases (not started)
- New work from L1 updates

### Step 4: Regenerate Plans

Use **implementation-planner** subagent to update plans:

#### If specific plan requested ($ARGUMENTS = "backend" / "frontend" / "test"):
- Regenerate just that plan
- Keep other plans intact
- Update implementation-order to reflect changes

#### If "all" or empty ($ARGUMENTS):
- Regenerate all affected plans
- Preserve unaffected sections within plans
- Update all cross-references

For each plan:
1. Read current plan
2. Read updated L1 artifacts
3. Identify what changed
4. Generate updated sections
5. Merge with preserved sections
6. Mark updated sections with: `<!-- UPDATED: [date] - [change reason] -->`

### Step 5: Update Implementation Order

Adjust phases in `/docs/plans/implementation-order.md`:

```markdown
## Phase 1: Foundation ✅ COMPLETE
- [x] Database schema
- [x] Auth endpoints
- [x] User model
<!-- No changes - complete and unaffected -->

## Phase 2: Core Features 🔄 IN PROGRESS (MODIFIED)
- [x] User dashboard (COMPLETE)
- [x] Task CRUD (COMPLETE)
- [ ] Team management (ADDED - from change)        ← NEW
- [ ] Role-based permissions (ADDED - from change) ← NEW

## Phase 3: Advanced Features (REORDERED)
<!-- Adjusted due to new dependencies from Phase 2 changes -->
- [ ] Notifications
- [ ] Activity feed
- [ ] Team analytics (ADDED - from change)        ← NEW

## Phase 4: Polish (UNCHANGED)
- [ ] Error boundaries
- [ ] Loading states
- [ ] Performance optimization
```

Mark changes:
- ✅ COMPLETE - Done, verified, no changes
- 🔄 IN PROGRESS (MODIFIED) - Partially done, needs additions
- ⚠️ NEEDS MIGRATION - Complete but affected, requires rework
- 🆕 NEW - Added from L1 changes
- (REORDERED) - Sequence changed
- (UNCHANGED) - Not affected

### Step 6: Handle Rework

If completed work is affected:

Create migration tasks in implementation-order.md:

```markdown
## Migration Tasks (Rework for completed phases)

### MIG-001: Update user dashboard for teams
**Affected phase:** Phase 2 (complete)
**Changes needed:** Add team switcher, filter by team
**Effort:** M
**Dependencies:** Phase 2 team backend complete

### MIG-002: Modify auth to check roles
**Affected phase:** Phase 1 (complete)
**Changes needed:** Add role checks to auth middleware
**Effort:** S
**Dependencies:** Phase 2 role model complete
```

Add migrations to current or next phase in implementation order.

### Step 7: Validate Plan Consistency

After regeneration, verify:
- [ ] All journeys from UX have implementation in frontend plan
- [ ] All promises from intent have implementation in backend plan
- [ ] All new entities have tests in test plan
- [ ] Phases have clear dependencies
- [ ] Completed work preserved where possible
- [ ] Migration path defined for affected completed work

### Step 8: Create Replan Summary

Save to `/docs/changes/replan-[timestamp].md`:

```markdown
# Replan Summary

## Trigger
[What caused replan: /update, manual, etc.]

## L1 Changes Detected
- Intent: [changes]
- UX: [changes]
- Architecture: [changes]

## Plans Updated

### Backend Plan
- Added: [list new endpoints, entities, services]
- Modified: [list changed items]
- Removed: [list removed items]

### Frontend Plan
- Added: [list new pages, components]
- Modified: [list changed items]
- Removed: [list removed items]

### Test Plan
- Added: [list new tests]
- Modified: [list changed tests]

### Implementation Order
- Phase 1: No changes (complete, unaffected)
- Phase 2: MODIFIED - added 2 tasks, still in progress
- Phase 3: REORDERED - adjusted sequence
- Phase 4: ADDED - new phase for migrations

## Migration Tasks Created
- MIG-001: [description]
- MIG-002: [description]

## Effort Impact
- Additional work: [estimate]
- Rework effort: [estimate]
- Phase count: [before] → [after]

## Next Steps
Continue implementation: `/implement phase N`
Or handle migrations: `/improve MIG-001`
```

## Output

Report to user:

```
✅ Replan Complete

Plans regenerated based on updated L1 artifacts.

Changes detected:
- Intent: Added 1 promise
- UX: Added 2 journeys, modified 1
- Architecture: Added Team entity, 5 endpoints

Plans updated:
- backend-plan.md
  • Added: Team endpoints, role checks
  • Modified: User schema (add teamId)

- frontend-plan.md
  • Added: TeamManagement page, TeamSwitcher component
  • Modified: Dashboard (team filtering)

- test-plan.md
  • Added: E2E for team journeys
  • Added: Integration for role checks

- implementation-order.md
  • Phase 2 (in progress): Extended with 2 tasks
  • Phase 3: Reordered
  • Migration tasks: 2 created

Completed work affected:
⚠️ Phase 1 auth needs role check updates (MIG-002)
⚠️ Phase 2 dashboard needs team features (MIG-001)

Ready to continue:
  /implement phase 2  (finish current phase)
  Then: /improve MIG-001 (migrations)
```

## Use Cases

### After /update
Automatically called by /update after L1 artifacts updated.

### Manual replan
```bash
/replan              # Regenerate all plans
/replan backend      # Just backend plan
/replan frontend     # Just frontend plan
```

### After manual doc edits
If you manually edit intent/UX/architecture docs:
```bash
/replan
```

## Rules

1. **Preserve completed work** - Don't regenerate what's already built unless affected
2. **Mark changes clearly** - Use comments and status markers
3. **Create migration tasks** - Don't ignore rework needs
4. **Validate consistency** - Ensure plans match L1 artifacts
5. **Be specific** - Show exactly what changed and why
6. **Estimate honestly** - Don't hide effort impact
