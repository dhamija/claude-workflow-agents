---
name: sync
description: Sync project documentation, update CLAUDE.md state, and verify test coverage
argument-hint: "[quick | full | report]"
---

# Sync Project State

Sync project state using the project-maintainer agent.

---

## Usage

```
/sync           # Full sync (default)
/sync quick     # Quick sync - just CLAUDE.md
/sync report    # Show status without changes
```

---

## Actions

### (default) or "full"

Full project sync:
1. Update CLAUDE.md with current state
2. Sync all /docs/* with code reality
3. Verify test coverage
4. Generate comprehensive report

**When to use:**
- After completing features
- Before ending a session
- When documentation feels stale
- Periodically during long development

**Output:**
- Updated CLAUDE.md (Current State section)
- Updated /docs/intent/ with promise statuses
- Updated /docs/ux/ with journey statuses
- Updated /docs/plans/ with feature progress
- Comprehensive sync report

---

### "quick"

Quick sync - just essentials:
1. Update CLAUDE.md current state section
2. Log recent changes
3. Brief status report

**When to use:**
- Quick progress checkpoint
- Want to save current task
- Need brief status update

**Output:**
- Updated CLAUDE.md Current State
- Brief progress report

---

### "report"

Show sync status without making changes:
1. Compare code vs docs
2. Identify gaps
3. Show what would be updated

**When to use:**
- Want to see status before syncing
- Check what's out of date
- Understand current state

**Output:**
- Comparison report
- List of what would be updated
- No files modified

---

## Examples

### Full Sync

```
User: /sync

project-maintainer:
  Running full project sync...

  ✓ CLAUDE.md updated
    - Feature progress table refreshed
    - Current task updated
    - Session continuity notes added

  ✓ Documentation synced
    - product-intent.md: 6/8 promises KEPT
    - user-journeys.md: 4/6 IMPLEMENTED
    - implementation-order.md: Updated statuses

  ✓ Test coverage verified
    - Completed features: 100% covered
    - Current feature: Backend tested, frontend pending

  ╔══════════════════════════════════════════════════╗
  ║            PROJECT SYNC COMPLETE                 ║
  ╚══════════════════════════════════════════════════╝

  Progress: 5/8 features complete
  Current: search frontend (SearchBar component)
  Next: Continue SearchBar, then ResultsList

  Ready for next session.
```

---

### Quick Sync

```
User: /sync quick

project-maintainer:
  Quick sync ✓

  Progress: 5/8 features
  Current: search frontend
  Next: ResultsList component

  CLAUDE.md Current State updated.
```

---

### Sync Report

```
User: /sync report

project-maintainer:
  Sync Status (no changes made):

  Would update:
  - CLAUDE.md: 3 features status changed
  - product-intent.md: 2 promises now KEPT
  - implementation-order.md: New progress
  - features/search.md: 4 tasks completed

  Test gaps found:
  - search: Missing E2E tests
  - auth: Missing rate limit test

  To apply these updates: /sync
```

---

## Integration with Workflow

### Automatic Triggers

The project-maintainer agent runs automatically:

- **After feature completion** - When test-engineer verifies a feature
- **Before session end** - When user says "before I go" or "end session"
- **Periodic** - Every 3-4 features during long sessions

### Manual Triggers

You can also trigger manually:
- `/sync` - Full sync
- `/sync quick` - Quick update
- "Update the docs" - Full sync
- "Save my progress" - Quick sync
- "What did we do" - Session summary

---

## What Gets Synced

### CLAUDE.md

**Current State section:**
- Project status (Planning/Building/Testing/Complete)
- Feature progress table
- Current focus (feature, task, blockers)
- Recent activity log
- Session continuity notes
- Test coverage summary
- Open questions

### Documentation (/docs/)

**Intent (/docs/intent/product-intent.md):**
- Promise statuses: `[KEPT]`, `[AT RISK]`, `[BROKEN]`
- Updated boundaries
- New promises discovered

**UX (/docs/ux/user-journeys.md):**
- Journey statuses: `[IMPLEMENTED]`, `[PARTIAL]`, `[NOT STARTED]`
- Edge cases discovered
- UX changes made

**Architecture (/docs/architecture/):**
- Component changes
- Architectural deviations
- New components added

**Plans (/docs/plans/):**
- Feature statuses
- Task completion
- Implementation notes

### Test Coverage

**Identifies gaps:**
- Features without tests
- Journeys without E2E tests
- Promises without verification
- API endpoints without coverage

---

## Session Continuity

Before ending a session:

```
User: "Before I go, save the state"

project-maintainer:
  Session state saved ✓

  ╔══════════════════════════════════════════════════╗
  ║           SESSION SUMMARY                        ║
  ╚══════════════════════════════════════════════════╝

  ACCOMPLISHED THIS SESSION
  ─────────────────────────
  ✓ Completed auth feature
  ✓ Completed recipes feature
  ✓ Started search (backend done)

  STATE SAVED
  ───────────
  CLAUDE.md updated with:
  - Current task: search frontend (SearchBar)
  - Important context: Using debounced search
  - Next steps: SearchBar → ResultsList → FilterPanel

  NEXT SESSION
  ────────────
  Just say "continue" and I'll know:
  - Exactly where you left off
  - What's already done
  - What to do next
  - Decisions made this session
```

Next session:

```
User: "Continue"

Claude: Continuing from where we left off...

  From last session:
  - Completed: auth, recipes
  - In progress: search (backend done)
  - Current task: SearchBar component

  Let me build the SearchBar component with debounced search.
  [Continues seamlessly]
```

---

## Tips

1. **Before ending session** - Always run `/sync` or say "save state"
2. **After each feature** - Automatic, but you can manually verify with `/sync report`
3. **Check status** - Use `/sync report` to see current state without changes
4. **Quick updates** - Use `/sync quick` for fast checkpoints

---

## See Also

- `project-maintainer` agent documentation
- `/agent-wf-help sync` - Sync help topic
- CLAUDE.md template - Current State section format
