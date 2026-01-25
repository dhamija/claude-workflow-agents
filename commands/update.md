---
description: Apply changes to artifacts after impact analysis
argument-hint: <path to change analysis or "latest">
---

Apply the changes from impact analysis:

$ARGUMENTS (default: latest change analysis in /docs/changes/)

## Prerequisites

Must have a change impact analysis. Run `/change` first if none exists.

Check for:
- /docs/changes/change-*.md files

If $ARGUMENTS is "latest" or empty:
- Use Glob to find most recent change analysis
- Read that file

If $ARGUMENTS is a path:
- Read that specific change analysis file

## Process

### Step 1: Load Change Analysis

Read the change impact analysis document to understand:
- What artifacts need updating
- What specific changes to make
- What conflicts exist (resolve before proceeding)
- What order to apply updates

### Step 2: Update L1 Artifacts (in dependency order)

Update artifacts in this order to maintain consistency:

#### 1. Update Intent (if affected)

Use **intent-guardian** subagent to update `/docs/intent/product-intent.md`:
- Read current intent doc
- Apply changes from impact analysis
- Preserve existing promises unless explicitly changing them
- Add new promises, modify existing ones
- Update invariants, boundaries, success criteria
- Mark updated sections with comment: `<!-- UPDATED: [date] - [reason] -->`

#### 2. Update UX (if affected)

Use **ux-architect** subagent to update `/docs/ux/user-journeys.md`:
- Read current journeys doc
- Add new journeys as specified
- Modify existing journeys
- Keep unaffected journeys intact
- Ensure new journeys align with updated intent
- Mark updated sections with comment: `<!-- UPDATED: [date] - [reason] -->`

#### 3. Update Architecture (if affected)

Use **agentic-architect** subagent to update `/docs/architecture/agent-design.md`:
- Read current design doc
- Add new entities, endpoints, agents as specified
- Modify existing components
- Preserve unaffected architecture
- Ensure design supports updated journeys
- Mark updated sections with comment: `<!-- UPDATED: [date] - [reason] -->`

### Step 3: Validate Consistency

After L1 updates, verify:
- [ ] UX journeys align with intent promises
- [ ] Architecture supports all journeys (new and existing)
- [ ] No contradictions introduced
- [ ] All cross-references still valid

If validation fails:
- Report issues
- Don't proceed to /replan
- User must resolve conflicts

### Step 4: Trigger Replan

After L1 artifacts successfully updated and validated:

Automatically run `/replan` to regenerate implementation plans based on updated L1 docs.

This will:
- Update backend-plan.md
- Update frontend-plan.md
- Update test-plan.md
- Update implementation-order.md
- Preserve completed work where possible
- Mark modified/added work

### Step 5: Create Update Log

Save summary to `/docs/changes/update-[timestamp].md`:

```markdown
# Update Applied: [change description]

## Source
Change analysis: [path to change-*.md]

## Artifacts Updated

### Intent
- Added promise: [promise]
- Modified: [what changed]

### UX
- Added journey: [journey name]
- Modified journey: [journey name] - [changes]

### Architecture
- Added entity: [entity]
- Modified: [what changed]

## Validation
- [x] UX aligns with intent
- [x] Architecture supports UX
- [x] No contradictions

## Plans Regenerated
- backend-plan.md ✓
- frontend-plan.md ✓
- test-plan.md ✓
- implementation-order.md ✓

## Next Steps
Continue implementation: `/implement phase N`

## Rework Summary
[If any completed work affected, describe migration needed]
```

## Output

Report to user:

```
✅ Update Complete

Artifacts updated:
- product-intent.md (added 1 promise, modified success criteria)
- user-journeys.md (added 2 journeys)
- agent-design.md (added Team entity, 3 endpoints)

Plans regenerated:
- backend-plan.md (added 5 endpoints, modified schema)
- frontend-plan.md (added 2 pages, 3 components)
- test-plan.md (added journey tests)
- implementation-order.md (extended phase 2, adjusted phase 3)

Validation: PASS

Completed work affected:
- Phase 2 (in progress): Extended with new backend work
- Rework needed: Modify user dashboard to show teams

Ready to continue:
  /implement phase 2
```

## Error Handling

If any step fails:
- Stop immediately
- Report which step failed
- Show error details
- Don't modify remaining artifacts
- Don't trigger /replan

User must fix issues and re-run /update.

## Rules

1. **Update in order** - Intent → UX → Architecture
2. **Preserve existing** - Only change what's specified in impact analysis
3. **Mark updates** - Comment showing when/why changed
4. **Validate before replanning** - Catch issues early
5. **Log everything** - Create detailed update log
6. **Fail safe** - If error, stop and report (don't corrupt docs)
