# Workflow Deep Dive

> **v2.1 Architecture:** Workflow orchestration now happens via the **workflow skill** loaded on-demand by Claude. Skills + Hooks + Subagents architecture for 90% context reduction.

> **Note:** You don't need to know this to use the system. Just talk naturally to Claude. This document explains the internal mechanics for those who want to understand how it works.

---

## Table of Contents

1. [Core Concept: Two-Level Workflow](#core-concept-two-level-workflow)
2. [Level 1: App Workflow](#level-1-app-workflow)
3. [Level 2: Feature Workflow](#level-2-feature-workflow)
4. [Brownfield Workflow](#brownfield-workflow)
5. [Change Management Workflow](#change-management-workflow)
6. [Sequential vs Parallel](#sequential-vs-parallel)
7. [Verification Strategy](#verification-strategy)
8. [Document Relationships](#document-relationships)
9. [How Claude Selects Agents](#how-claude-selects-agents)
10. [Best Practices](#best-practices)

---

## Core Concept: Two-Level Workflow

The system uses a **two-level workflow** to separate "what to build" from "how to build it":

```
Level 1: APP ANALYSIS (Runs once at project start)
┌─────────────┬─────────────┬─────────────┬─────────────┐
│   Intent    │     UX      │   System    │   Plans     │
│  Guardian   │  Architect  │  Architect  │   Planner   │
└─────────────┴─────────────┴─────────────┴─────────────┘
    │               │               │               │
    ▼               ▼               ▼               ▼
What promises?  How do users  What architecture? What to build?
What must/     accomplish      What should be     How to sequence?
must not?      goals?          agents vs code?

Level 2: FEATURE IMPLEMENTATION (Runs for each feature)
┌─────────────┬─────────────┬─────────────┬─────────────┐
│   Backend   │  Frontend   │    Tests    │   Verify    │
│  Engineer   │  Engineer   │  Engineer   │             │
└─────────────┴─────────────┴─────────────┴─────────────┘
    │               │               │               │
    ▼               ▼               ▼               ▼
APIs, database  Pages, comps,  Unit, int, E2E  Everything
services       state, styling  promise tests   works?
```

### Why Two Levels?

**Level 1 (App)** ensures:
- All features align with product vision
- User experience is consistent across features
- Architecture decisions are intentional
- Features are planned in correct sequence

**Level 2 (Feature)** ensures:
- Each feature is completely built before moving on
- Backend, frontend, and tests are all included
- Features are verified independently
- Progress is clear and measurable

**Benefits:**
- Changes to product vision (Level 1) automatically update all feature plans (Level 2)
- Features can be built sequentially (default) or in parallel (teams)
- Clear separation of concerns between planning and implementation
- Easy to verify correctness at both levels

---

## Level 1: App Workflow

Level 1 runs **once** when starting a new project or analyzing an existing one. It creates the foundation for all feature work.

### Phase 1: Intent Definition

**Agent:** intent-guardian
**Input:** App idea or existing codebase
**Output:** `/docs/intent/product-intent.md`

**What it does:**
1. Identifies the problem being solved
2. Defines who the users are
3. Documents **promises** - what the app MUST do
4. Documents **anti-promises** - what the app MUST NOT do
5. Defines **invariants** - conditions that must always hold
6. Sets **success criteria** - how to measure if it's working

**Example output:**
```markdown
## Promises
- PRM-001: Tasks are never lost (even if server crashes)
- PRM-002: Users can access their tasks offline
- PRM-003: Tasks sync automatically when online

## Anti-Promises
- ANTI-001: We will NEVER share user data with third parties
- ANTI-002: We will NEVER lock features behind paywalls after signup

## Invariants
- INV-001: Task.userId must always match auth.userId (no leaking)
- INV-002: Deleted tasks must be in trash for 30 days before purging
```

**Why this matters:**
- Promises become test cases (promise verification tests)
- Anti-promises prevent scope creep and mission drift
- Invariants are enforced in code and tested continuously

---

### Phase 2: UX Design

**Agent:** ux-architect
**Input:** Product intent
**Output:** `/docs/ux/user-journeys.md`

**What it does:**
1. Defines user personas (who will use this)
2. Maps user journeys (how users accomplish goals)
3. Designs screen flows and interactions
4. Documents edge cases and error states
5. Identifies UX requirements (loading states, feedback, etc.)

**Example output:**
```markdown
## Journey: Create and Complete Task

**User:** Sarah (busy professional, uses app daily)
**Goal:** Add new task and mark it done
**Frequency:** 10-20 times per day

### Happy Path
1. User opens app → Shows task list (with loading indicator if syncing)
2. User taps "+" button → Opens new task form
3. User enters title, optional due date → "Add" button enabled
4. User taps "Add" → Task appears in list, form closes, success feedback
5. Later: User taps task checkbox → Task marked done, moves to "Completed"

### Edge Cases
- No network → Task saved locally, syncs later (show sync status)
- Form validation fails → Inline error messages, field highlighting
- Duplicate task title → Confirm "Add anyway?" or auto-append timestamp

### UX Requirements
- Loading states: Skeleton screens while fetching
- Error states: Friendly messages with recovery actions
- Success feedback: Subtle animation + toast notification
```

**Why this matters:**
- Journeys become test cases (E2E tests)
- Edge cases prevent bugs from reaching production
- UX requirements ensure polished, professional app

---

### Phase 3: Architecture Design

**Agent:** agentic-architect
**Input:** Product intent + UX design
**Output:** `/docs/architecture/agent-design.md`

**What it does:**
1. Analyzes problem for agentic opportunities
2. Decides what should be AI agents vs traditional code
3. Designs system components and their responsibilities
4. Documents failure modes and recovery strategies
5. Plans for observability and debugging

**Example output:**
```markdown
## System Components

### Traditional Code
**Task CRUD Service**
- Why traditional: Simple database operations, no intelligence needed
- Responsibilities: Create, read, update, delete tasks
- Technology: RESTful API with PostgreSQL

**Authentication Service**
- Why traditional: Well-established patterns, security-critical
- Responsibilities: Login, signup, session management
- Technology: JWT tokens with refresh mechanism

### AI Agents
**Smart Prioritization Agent**
- Why agent: Requires understanding user context, deadlines, importance
- Input: User's task list + calendar + completion history
- Output: Ranked priority order with explanations
- Technology: Claude API with custom prompt

**Natural Language Task Parser**
- Why agent: Converts freeform text to structured task data
- Input: "Buy milk tomorrow at 3pm"
- Output: {title: "Buy milk", dueDate: "2024-01-25T15:00:00Z"}
- Technology: Claude API with structured output

## Failure Modes
| Scenario | Recovery Strategy |
|----------|-------------------|
| Claude API down | Fall back to manual priority, simple date parsing |
| Slow API response | Show loading state, cache previous results |
| Parse fails | Accept raw input, offer edit UI |
```

**Why this matters:**
- Prevents over-engineering (not everything needs AI)
- Identifies where AI adds genuine value
- Plans for failure so app never breaks completely
- Guides implementation decisions

---

### Phase 4: Implementation Planning

**Agent:** implementation-planner
**Input:** Intent + UX + Architecture
**Output:**
- `/docs/plans/overview/backend-plan.md`
- `/docs/plans/overview/frontend-plan.md`
- `/docs/plans/overview/test-plan.md`
- `/docs/plans/features/*.md` (one per feature)
- `/docs/plans/implementation-order.md`

**What it does:**
1. **Analyzes all Level 1 outputs** to understand complete system
2. **Breaks work into vertical slices** (features with backend + frontend + tests)
3. **Creates detailed feature plans** with exact file paths and specifications
4. **Sequences features by dependencies** (Batch 0, 1, 2, ...)
5. **Estimates effort** and identifies risks

**Overview Documents (Reference):**

`backend-plan.md` - Complete system reference:
```markdown
## Database Schema
(All tables, all fields, all relationships)

## All API Endpoints
(Every endpoint across all features)

## All Services
(Business logic layer components)
```

`frontend-plan.md` - Complete UI reference:
```markdown
## All Pages
(Every route in the app)

## All Components
(Shared and feature-specific)

## State Management
(What state, where it lives, how it flows)
```

**Feature Documents (Execution):**

Each feature gets its own plan in `/docs/plans/features/[name].md`:

```markdown
# Feature: Task Management

## Scope
This feature includes creating, viewing, editing, and deleting tasks.
Does NOT include: prioritization (separate feature), sharing (separate feature)

## Backend Work
### Files to Create/Modify
- `src/tasks/task.model.ts` - Prisma model
- `src/tasks/task.service.ts` - Business logic
- `src/tasks/task.controller.ts` - API endpoints

### Endpoints
- POST /api/tasks - Create task
- GET /api/tasks - List user's tasks (with pagination, filtering)
- GET /api/tasks/:id - Get task details
- PATCH /api/tasks/:id - Update task
- DELETE /api/tasks/:id - Delete task (soft delete to trash)

### Database
```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  title VARCHAR(200) NOT NULL,
  ...
)
```

## Frontend Work
### Files to Create/Modify
- `src/pages/TaskListPage.tsx` - Main task list view
- `src/components/TaskForm.tsx` - Create/edit form
- `src/components/TaskItem.tsx` - Single task display
- `src/hooks/useTasks.ts` - React Query hook

### Pages
- /tasks - Task list (route: /tasks)
- /tasks/new - Create task (modal or inline form)
- /tasks/:id/edit - Edit task (modal or inline form)

### State
- Task list cached in React Query
- Optimistic updates on create/edit/delete
- Real-time sync via polling (every 30s when tab active)

## Tests
### Unit Tests
- TaskService.create validates title length
- TaskService.delete moves to trash (not hard delete)

### Integration Tests
- POST /api/tasks creates task in database
- GET /api/tasks returns only current user's tasks (security)

### E2E Tests
- Complete journey: Create task → Edit → Mark done → Delete

## Acceptance Criteria
- [ ] User can create task with title (required) and optional due date
- [ ] User sees only their own tasks (never other users')
- [ ] Deleted tasks go to trash (recoverable for 30 days)
- [ ] All tests pass
- [ ] No console errors
```

**Implementation Order:**

`implementation-order.md` shows how features are sequenced:

```markdown
## Batch 0: Foundation (SEQUENTIAL - must complete first)
- user-authentication (nothing else can start until this is done)
- database-setup

## Batch 1: Core Features (CAN BE PARALLEL)
- task-management (independent)
- user-profile (independent)

## Batch 2: Advanced Features (CAN BE PARALLEL, after Batch 1)
- task-prioritization (depends on: task-management)
- task-sharing (depends on: task-management, user-profile)

## Batch 3: Polish (After Batch 2)
- offline-sync
- notifications
```

**Why this matters:**
- Overview docs are reference (what exists in full system)
- Feature docs are execution (exactly what to build now)
- Dependencies ensure correct build order
- Batching enables parallel development for teams

---

## Level 2: Feature Workflow

Level 2 runs **for each feature** in the implementation order. Each feature is a complete vertical slice.

### Feature Implementation Cycle

For each feature in `implementation-order.md`:

```
1. READ feature plan
   └─> /docs/plans/features/[feature-name].md

2. IMPLEMENT BACKEND
   └─> backend-engineer creates APIs, database, services

3. IMPLEMENT FRONTEND
   └─> frontend-engineer creates pages, components, state

4. WRITE TESTS
   └─> test-engineer writes unit, integration, E2E tests

5. VERIFY
   └─> test-engineer runs tests, checks journeys, verifies promises

6. SYNC STATE
   └─> project-ops updates CLAUDE.md, docs, test coverage

7. MARK COMPLETE
   └─> Move to next feature
```

---

### Phase 1: Backend Implementation

**Agent:** backend-engineer
**Input:** Feature plan (backend section)
**Output:** Working backend code

**What it does:**
1. Reads feature plan's backend specification
2. Creates/modifies files listed in plan
3. Implements all endpoints with proper error handling
4. Adds database migrations if needed
5. Implements business logic in services layer
6. Adds logging and observability
7. Runs linter and type checker

**Example work for "task-management" feature:**

Creates `src/tasks/task.service.ts`:
```typescript
export class TaskService {
  async create(userId: string, data: CreateTaskDto): Promise<Task> {
    // Validate title length (promise enforcement)
    if (data.title.length > 200) {
      throw new ValidationError('Title too long')
    }

    // Create task in database
    const task = await this.db.task.create({
      data: {
        userId,
        title: data.title,
        dueDate: data.dueDate,
        status: 'active'
      }
    })

    // Log for observability
    logger.info('Task created', { taskId: task.id, userId })

    return task
  }

  async delete(userId: string, taskId: string): Promise<void> {
    // Soft delete (promise: tasks recoverable for 30 days)
    await this.db.task.update({
      where: { id: taskId, userId }, // Enforce invariant: user owns task
      data: {
        status: 'deleted',
        deletedAt: new Date()
      }
    })
  }
}
```

**Quality checks:**
- All endpoints have error handling
- Database queries enforce invariants (user ownership)
- Promises are implemented correctly
- Code follows project conventions
- No hard-coded values (use config)

---

### Phase 2: Frontend Implementation

**Agent:** frontend-engineer
**Input:** Feature plan (frontend section)
**Output:** Working UI code

**What it does:**
1. Reads feature plan's frontend specification
2. Creates/modifies files listed in plan
3. Implements all pages and components
4. Adds state management (React Query, Zustand, etc.)
5. Implements error states and loading states
6. Makes UI responsive and accessible
7. Runs linter and type checker

**Example work for "task-management" feature:**

Creates `src/pages/TaskListPage.tsx`:
```typescript
export function TaskListPage() {
  const { data: tasks, isLoading, error } = useTasks()

  // Loading state (UX requirement)
  if (isLoading) {
    return <TaskListSkeleton />
  }

  // Error state (UX requirement)
  if (error) {
    return (
      <ErrorState
        message="Couldn't load tasks"
        action={<Button onClick={() => refetch()}>Try Again</Button>}
      />
    )
  }

  // Empty state (UX requirement)
  if (tasks.length === 0) {
    return <EmptyState message="No tasks yet" action="Create your first task" />
  }

  // Happy path
  return (
    <div className="task-list">
      {tasks.map(task => (
        <TaskItem key={task.id} task={task} />
      ))}
    </div>
  )
}
```

**Quality checks:**
- All journeys implemented per UX doc
- Loading, error, and empty states present
- Responsive design (mobile, tablet, desktop)
- Accessible (keyboard nav, screen readers)
- No hardcoded strings (use i18n if needed)

---

### Phase 3: Testing

**Agent:** test-engineer
**Input:** Feature plan (tests section)
**Output:** Complete test suite

**What it does:**
1. Reads feature plan's test specification
2. Writes unit tests for business logic
3. Writes integration tests for API endpoints
4. Writes E2E tests for user journeys
5. Writes promise verification tests
6. Runs all tests and fixes failures
7. Measures code coverage

**Example tests for "task-management" feature:**

```typescript
// Unit test - Business logic
describe('TaskService', () => {
  it('should enforce title length limit (PRM-003)', async () => {
    const longTitle = 'x'.repeat(201)
    await expect(
      taskService.create(userId, { title: longTitle })
    ).rejects.toThrow('Title too long')
  })

  it('should soft delete tasks (PRM-001: tasks never lost)', async () => {
    await taskService.delete(userId, taskId)
    const task = await db.task.findUnique({ where: { id: taskId } })
    expect(task.status).toBe('deleted')
    expect(task.deletedAt).toBeTruthy()
    // Task still exists in database (not hard deleted)
  })
})

// Integration test - API endpoint
describe('POST /api/tasks', () => {
  it('should create task for authenticated user', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .set('Authorization', `Bearer ${validToken}`)
      .send({ title: 'Buy milk' })

    expect(response.status).toBe(201)
    expect(response.body.title).toBe('Buy milk')
  })

  it('should enforce user ownership (INV-001)', async () => {
    // Cannot create task for another user
    const response = await request(app)
      .post('/api/tasks')
      .set('Authorization', `Bearer ${user1Token}`)
      .send({ title: 'Task', userId: user2Id }) // Try to assign to user2

    expect(response.status).toBe(403) // Forbidden
  })
})

// E2E test - User journey
describe('Task Management Journey', () => {
  it('should allow creating, editing, and deleting tasks', async () => {
    // Journey from UX doc
    await page.goto('/tasks')
    await page.click('[data-testid="add-task-button"]')
    await page.fill('[data-testid="task-title"]', 'Buy milk')
    await page.click('[data-testid="save-button"]')

    // Task appears in list
    await expect(page.locator('text=Buy milk')).toBeVisible()

    // Edit task
    await page.click('[data-testid="edit-task"]')
    await page.fill('[data-testid="task-title"]', 'Buy oat milk')
    await page.click('[data-testid="save-button"]')
    await expect(page.locator('text=Buy oat milk')).toBeVisible()

    // Delete task
    await page.click('[data-testid="delete-task"]')
    await expect(page.locator('text=Buy oat milk')).not.toBeVisible()
  })
})
```

**Coverage targets:**
- Unit tests: 80%+ coverage of business logic
- Integration tests: All API endpoints covered
- E2E tests: All primary journeys covered
- Promise tests: Every promise has verification test

---

### Phase 4: Verification

**Agent:** test-engineer (verification mode)
**Input:** Completed feature
**Output:** Verification report

**What it does:**
1. Runs all tests (unit, integration, E2E)
2. Checks test coverage meets targets
3. Manually tests primary journeys
4. Verifies promises are kept
5. Checks for console errors
6. Runs performance checks
7. Creates verification report

**Example verification report:**

```markdown
# Verification Report: task-management

## Test Results
✅ Unit tests: 24/24 passed (coverage: 87%)
✅ Integration tests: 12/12 passed
✅ E2E tests: 5/5 passed

## Promise Verification
✅ PRM-001: Tasks never lost (tested with soft delete)
✅ PRM-002: Offline access (local storage fallback works)
✅ PRM-003: Auto-sync (polling every 30s when online)

## Manual Journey Tests
✅ Create task journey - smooth, no errors
✅ Edit task journey - inline editing works
✅ Delete task journey - goes to trash, recoverable

## Issues Found
⚠️ Warning: Task list pagination not implemented yet (not in this feature scope)

## Performance
✅ Task list loads in <200ms (target: <500ms)
✅ Task creation responds in <100ms

## Conclusion
✅ FEATURE COMPLETE - Ready for next feature
```

If verification fails, debugger is called to fix issues before moving on.

**After successful verification**, project-ops automatically syncs project state:
- Updates CLAUDE.md Current State section with completed feature
- Syncs /docs/* status markers ([KEPT], [IMPLEMENTED])
- Records test coverage
- Prepares for next feature

This ensures session continuity - next session can resume with "continue".

---

## Brownfield Workflow

For existing codebases, the workflow is different: **Audit → Review → Gap Analysis → Improve**.

### Phase 1: Audit (Infer from Code)

Instead of creating intent/UX/architecture from scratch, agents **infer** from existing code:

**intent-guardian (AUDIT mode):**
- Reads README, routes, validations, error handling
- Infers what promises the code is trying to keep
- Documents as `[INFERRED]` for user review
- Asks questions about uncertain assumptions

**ux-architect (AUDIT mode):**
- Maps routes to discover pages
- Traces flows through components
- Identifies journeys from UI structure
- Documents as `[INFERRED]`

**agentic-architect (AUDIT mode):**
- Analyzes code structure
- Identifies where AI could help
- Documents current architecture
- Suggests agentic opportunities

**Output example:**

```markdown
# Product Intent [INFERRED]

> ⚠️ **Inferred from existing code** - Please review and correct

## Confidence: MEDIUM

## Inferred Promises
| ID | Promise | Evidence | Confidence |
|----|---------|----------|------------|
| PRM-001 | Users can't see other users' data | `userId` filter in all queries (backend/src/tasks/service.ts:23) | HIGH |
| PRM-002 | Tasks auto-save every 30s | `setInterval` in TaskForm.tsx:45 | HIGH |
| PRM-003 | App works offline | LocalStorage fallback exists, but no sync? | LOW ❓ |

## Questions for User
1. Is offline support a goal? Code suggests it but implementation incomplete.
2. Should deleted tasks be recoverable? Currently hard-deleted (trash not implemented).
3. Is real-time collaboration planned? No WebSocket code found.
```

---

### Phase 2: Review Inferred Docs

**User reviews** `[INFERRED]` documents and corrects:

```
You: Review looks good but:
     - Offline is NOT a goal, remove that
     - Deleted tasks SHOULD be recoverable (that's a bug)
     - Real-time collab is future phase, not now

Claude: Updated intent document:
        - Removed offline promise
        - Added trash/recovery promise (marked as GAP)
        - Noted real-time as future consideration

        Ready to run gap analysis?
```

---

### Phase 3: Gap Analysis

**gap-analyzer** compares current code against reviewed docs:

```markdown
# Gap Analysis Report

## Critical (Fix Now)
### GAP-001: Deleted Tasks Are Hard-Deleted
- **Current:** DELETE query removes row permanently
- **Expected:** Soft delete to trash, 30-day recovery
- **Risk:** Users lose data accidentally, can't recover
- **Fix:** Add `deletedAt` field, change DELETE to UPDATE
- **Effort:** Small (2 hours)

## High (Phase 1)
### GAP-002: No Rate Limiting on Auth
- **Current:** Login endpoint allows unlimited attempts
- **Expected:** Rate limit to prevent brute force
- **Risk:** Account takeover via brute force
- **Fix:** Add express-rate-limit middleware
- **Effort:** Small (1 hour)

### GAP-003: N+1 Query in Dashboard
- **Current:** Fetches user, then tasks in loop (100+ queries)
- **Expected:** Single join query
- **Risk:** Dashboard slow for users with many tasks
- **Fix:** Use JOIN or eager loading
- **Effort:** Medium (3 hours)

## Medium (Phase 2)
... (6 more gaps)

## Low (Phase 3/Backlog)
... (4 more gaps)
```

---

### Phase 4: Improve (Fix Gaps)

User chooses which phase to implement:

```
You: Fix the critical issues first

Claude: Starting Phase 0: Critical Fixes

        [Fixing GAP-001: Soft delete]
        - Added deletedAt field to schema
        - Updated delete endpoint to soft delete
        - Added trash view UI
        - Added tests for recovery
        ✅ Complete

        Phase 0 complete. Move to Phase 1 (High priority)?

You: Yes

Claude: [Fixes GAP-002 and GAP-003]
```

Each gap fix follows Level 2 feature workflow (backend → frontend → tests → verify).

---

## Change Management Workflow

When requirements change mid-project, the change management workflow handles updates intelligently.

### The Problem

```
Initial plan:
  ✅ Phase 1: Auth + Tasks (completed)
  🔄 Phase 2: Dashboard (in progress)
  ⏳ Phase 3: Reports (not started)

User: "Actually, we need user roles - admin, editor, viewer"

Problem: This affects EVERYTHING. What needs updating?
```

### The Solution: /change workflow

```
Step 1: ANALYZE IMPACT
  └─> change-analyzer examines all artifacts
  └─> Identifies what's affected
  └─> Assesses rework needed

Step 2: REVIEW IMPACT
  └─> Read /docs/changes/change-[timestamp].md
  └─> Decide if acceptable

Step 3: APPLY CHANGES
  └─> /update modifies artifacts
  └─> Automatically triggers /replan

Step 4: CONTINUE
  └─> /implement uses updated plans
```

**Example change analysis:**

```markdown
# Change Impact Analysis: Add User Roles

## Summary
**Scope:** Major change affecting core auth and multiple features
**Effort:** ~8 hours additional work
**Risk:** Medium (requires migration of existing users)

## Affected Artifacts

### Intent (product-intent.md)
- Add promise: "Users have role-appropriate access"
- Add invariant: "Role checks on every protected endpoint"

### UX (user-journeys.md)
- New journey: "Admin manages user roles"
- Modified journey: "User signup" (now includes role selection)

### Architecture (agent-design.md)
- New component: Role authorization middleware
- Modified: User service (role assignment)

## Affected Features

### ✅ Phase 1 (Completed) - NEEDS MIGRATION
- **Auth feature:** Add role field to user table
  - Migration: MIG-001 (add column, default to 'viewer')
  - Effort: 1 hour

### 🔄 Phase 2 (In Progress) - EXTEND
- **Dashboard feature:** Add role-based filtering
  - Admin sees all data
  - Editor sees team data
  - Viewer sees own data only
  - Effort: +3 hours

### ⏳ Phase 3 (Not Started) - EXTEND
- **Reports feature:** Role-based report access
  - Already planned with [TBD] - now specified
  - Effort: +2 hours

## New Work Required
- **Role management UI:** Admin can assign/change roles
  - New feature plan created
  - Effort: 2 hours

## Total Impact
- Migration work: 1 hour
- Extended work: 5 hours
- New work: 2 hours
- **Total: 8 hours**

## Recommendation
Accept change. Impact is manageable, adds important capability.
```

### Update Process

When user accepts changes:

```bash
/update
```

**What happens:**
1. ✅ Intent updated with role promises
2. ✅ UX updated with role management journey
3. ✅ Architecture updated with auth middleware
4. ✅ Backend plan regenerated (new endpoints)
5. ✅ Frontend plan regenerated (new pages)
6. ✅ Test plan regenerated (role permission tests)
7. ✅ Implementation order updated:
   ```
   Phase 1: ✅ Complete → MIG-001: Add roles to users
   Phase 2: 🔄 In Progress → Extended with role features
   Phase 3: ⏳ Not Started → Now includes role-based access
   Phase 4: 🆕 NEW → Role management UI
   ```

**Preservation:**
- Completed work stays marked complete
- In-progress work is extended (not rewritten)
- New migration tasks for touching completed features
- Unaffected sections unchanged

### Continuing After Changes

```
You: Continue

Claude: Resuming Phase 2: Dashboard (now with role features)
        [Implements role-based filtering]
        ...
        Phase 2 complete.

        Should I apply MIG-001 to add roles to Phase 1?

You: Yes

Claude: [Updates user table, adds role field, migrates existing users]
        MIG-001 complete.

        Continue to Phase 3?
```

---

## Sequential vs Parallel

### Sequential Mode (Default)

**Who it's for:** Solo developers, learning, small projects

**How it works:**
```
Main project directory:
  Feature 1 → Complete
  Feature 2 → Complete
  Feature 3 → In Progress
  Feature 4 → Not Started
```

All work happens in your main project. One feature at a time. Simple, straightforward.

**Advantages:**
- Simple mental model
- No git worktree complexity
- Easy to track progress
- Perfect for solo developers

**Disadvantages:**
- Only one feature at a time
- Can't parallelize work across team

---

### Parallel Mode (Opt-In, Teams Only)

**Who it's for:** Teams with multiple developers, large projects

**How it works:**
```
Main project:
  Batch 0 → Complete (sequential, foundation)

Parallel worktrees:
  ../myapp-feature1/  (Developer 1 works here)
  ../myapp-feature2/  (Developer 2 works here)
  ../myapp-feature3/  (Developer 3 works here)
```

Each feature gets isolated git worktree. Developers work independently. Merge when ready.

**Setup:**
```bash
# Main project
/analyze my app
/plan

# Review implementation-order.md
# Batch 1 shows 3 independent features

# Create worktrees
/parallel feature1  # Creates ../myapp-feature1/
/parallel feature2  # Creates ../myapp-feature2/
/parallel feature3  # Creates ../myapp-feature3/

# Each developer
cd ../myapp-feature1
claude  # Start claude in this worktree
> Implement this feature
```

**Scoped CLAUDE.md:**

Each worktree gets simplified CLAUDE.md:
```markdown
# Feature: feature1

Your job: Implement this feature per FEATURE.md

Available agents:
- backend-engineer
- frontend-engineer
- test-engineer

NOT available (already done in main):
- intent-guardian
- ux-architect
- implementation-planner
```

This prevents re-analyzing or re-planning in feature context.

**Merging:**
```bash
# After feature complete
cd ../myapp-feature1
git push origin feature/feature1

# Create PR, review, merge to main

# Clean up
cd ../main-project
git worktree remove ../myapp-feature1
git pull origin main
```

**Advantages:**
- 3 features in parallel = 3x faster
- No merge conflicts (different files)
- Independent testing and review
- Scales to large teams

**Disadvantages:**
- Git worktree complexity
- Need multiple developers
- Requires understanding dependencies

---

## Verification Strategy

Verification happens at **two levels**: per-feature and per-phase.

### Feature-Level Verification

After each feature (Level 2):

```markdown
✅ All tests pass (unit, integration, E2E)
✅ All promises verified for this feature
✅ All journeys work for this feature
✅ No console errors
✅ Code coverage meets targets
```

If verification fails → debugger fixes → re-verify → proceed.

### Phase-Level Verification

After each batch/phase:

```markdown
✅ All features in phase complete
✅ Integration between features works
✅ No regressions in previous features
✅ System-wide journeys work end-to-end
✅ All promises still kept
✅ Performance acceptable
```

**Example:**
```
Batch 1: auth, tasks, profile

Feature verification:
  ✅ auth - verified
  ✅ tasks - verified
  ✅ profile - verified

Phase verification:
  ✅ Auth works with tasks (user can only see their tasks)
  ✅ Auth works with profile (user can edit own profile)
  ✅ Profile shows task stats (integration working)
  ✅ All Phase 1 journeys complete
  ✅ No regressions from Batch 0
```

### Final Verification

Before shipping:

```markdown
✅ All features complete
✅ All tests passing
✅ All promises kept
✅ All journeys smooth
✅ No critical performance issues
✅ No security vulnerabilities
✅ Accessibility requirements met
✅ Browser compatibility verified
```

---

## Document Relationships

Understanding how documents relate helps clarify the workflow:

```
LEVEL 1 ARTIFACTS (Created once, updated on changes)
┌─────────────────────────────────────────────────────┐
│ product-intent.md                                    │
│   ↓ (informs)                                       │
│ user-journeys.md                                    │
│   ↓ (informs)                                       │
│ agent-design.md                                     │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│ implementation-planner (reads all L1)               │
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│backend-plan │ │frontend-plan│ │  test-plan  │ (OVERVIEW)
│(reference)  │ │(reference)  │ │(reference)  │
└─────────────┘ └─────────────┘ └─────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│ features/*.md (EXECUTION)                           │
│   - auth.md                                         │
│   - tasks.md                                        │
│   - profile.md                                      │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│ implementation-order.md (SEQUENCE)                  │
│   - Batch 0: auth                                   │
│   - Batch 1: tasks, profile (parallel OK)           │
└─────────────────────────────────────────────────────┘

LEVEL 2 ARTIFACTS (Per feature)
┌─────────────────────────────────────────────────────┐
│ For each feature:                                   │
│   Read features/[name].md                           │
│   → backend-engineer implements                     │
│   → frontend-engineer implements                    │
│   → test-engineer tests                             │
│   → Verification report created                     │
└─────────────────────────────────────────────────────┘
```

**Key relationships:**

1. **Intent informs UX:** Can't design user journeys without knowing promises
2. **UX informs Architecture:** Can't design system without knowing user needs
3. **All L1 informs Planning:** Planner needs complete picture
4. **Overview plans are reference:** Backend-plan shows ALL endpoints across ALL features
5. **Feature plans are execution:** Auth.md shows ONLY auth endpoints
6. **Implementation order sequences features:** Based on dependencies

---

## How Claude Selects Agents

When you talk to Claude, it analyzes your message to select agents:

### Trigger Word Detection

| Trigger | Launches |
|---------|----------|
| "build", "create", "make" | intent-guardian + ux-architect + agentic-architect |
| "analyze", "audit", "improve" | gap-analyzer (brownfield) |
| "add", "also need", "change" | change-analyzer |
| "broken", "error", "bug" | debugger |
| "review", "check code" | code-reviewer |
| "test", "verify" | test-engineer |
| "plan", "ready to build" | implementation-planner |

### Context Detection

Claude also uses context:

```
Context: No existing docs
Trigger: "build task app"
→ Greenfield mode
→ Launch: intent-guardian + ux-architect + agentic-architect

Context: Existing codebase, no docs
Trigger: "improve this"
→ Brownfield mode
→ Launch: audit agents (infer intent/UX/architecture)

Context: Plans exist, no implementation
Trigger: "continue"
→ Implementation mode
→ Launch: backend-engineer + frontend-engineer (for next feature)

Context: Feature in progress
Trigger: "continue"
→ Resume implementation
→ Launch: (resume where left off)
```

### Parallel Agent Execution

When multiple agents can run independently:

```
"Build a recipe app"
→ Launch in PARALLEL:
   - intent-guardian (defines promises)
   - ux-architect (designs journeys)
   - agentic-architect (designs system)

All 3 run simultaneously, results synthesized.
```

When agents depend on each other:

```
After L1 complete:
→ Launch SEQUENTIAL:
   1. implementation-planner (needs ALL L1 outputs)
   2. Wait for plans
   3. Then launch backend-engineer + frontend-engineer
```

---

## Best Practices

### 1. Review Analysis Before Proceeding

Don't blindly run through the workflow. Review each level:

```
✅ Good:
  /analyze
  [Review intent, UX, architecture - make corrections]
  /plan
  [Review plans - ensure they're right]
  /implement

❌ Bad:
  /analyze && /plan && /implement
  [Fire and forget - no review]
```

### 2. Keep Docs and Code in Sync

When implementation reveals issues with plans:

```
✅ Good:
  [Implementing auth, discover plan missed password reset]
  /change add password reset to auth
  /update
  [Plans updated, continue with correct scope]

❌ Bad:
  [Implementing auth, notice plan missing password reset]
  [Just add it without updating docs]
  [Now code and docs diverged]
```

### 3. Verify After Each Feature

Don't wait until the end:

```
✅ Good:
  Feature 1 → Implement → Verify → ✅
  Feature 2 → Implement → Verify → ✅
  Feature 3 → Implement → Verify → ✅

❌ Bad:
  Feature 1 → Implement
  Feature 2 → Implement
  Feature 3 → Implement
  [Try to verify everything at once]
  [Find bug in Feature 1, have to debug through everything]
```

### 4. Commit Docs + Code Together

```
✅ Good:
  git add src/auth/* docs/plans/features/auth.md
  git commit -m "Implement auth feature per plan"

❌ Bad:
  git add src/auth/*
  git commit -m "Add auth"
  [Docs not committed, unclear what was planned]
```

### 5. Use Audits to Prevent Drift

Periodically check alignment:

```
Every few weeks:
  /intent-audit
  [Compare implementation vs promises]
  [Fix any drift found]
```

### 6. Start Sequential, Graduate to Parallel

Don't start with parallel mode:

```
✅ Good progression:
  1. Build first project sequentially (learn the system)
  2. Build second project sequentially (get comfortable)
  3. Try parallel mode on third project (with team)

❌ Bad:
  1. First project, immediately use parallel mode
  [Confused by worktrees, scoped CLAUDE.md, merge process]
```

### 7. Trust the Process

The two-level workflow exists for a reason:

```
✅ Good:
  Let Claude do L1 analysis completely
  Then move to L2 implementation
  [Clear separation, easy to verify]

❌ Bad:
  "Skip the analysis, just start coding"
  [End up with misaligned features]
  [Have to refactor everything later]
```

---

## Summary

**Two-Level Workflow:**
- Level 1: Define what to build (intent, UX, architecture, plans)
- Level 2: Build it (backend, frontend, tests, verify)

**Greenfield:** Analyze → Plan → Implement → Verify

**Brownfield:** Audit → Review → Gap Analysis → Improve

**Changes:** Analyze Impact → Update Artifacts → Replan → Continue

**Sequential:** Default, one feature at a time, simple

**Parallel:** Opt-in, multiple features simultaneously, teams only

**Verification:** Per-feature and per-phase, catch issues early

**Documentation:** Source of truth, code implements docs

Just talk to Claude naturally - it orchestrates this workflow automatically.
