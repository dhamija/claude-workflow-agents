# Workflow Documentation

## Conversation-Driven Orchestration

**You don't need to know this workflow.** Just talk to Claude naturally, and it will orchestrate the right agents automatically.

This document explains how the system works internally.

---

## How Claude Selects Agents

When you talk to Claude, it:
1. Analyzes your message for **trigger words** and **context**
2. Selects appropriate agent(s) based on intent
3. Launches agents in parallel when possible
4. Presents synthesized results

### Trigger Word Mapping

| Your Intent | Trigger Words | Claude Launches |
|-------------|---------------|-----------------|
| Start new project | "build", "create", "make" | intent-guardian + ux-architect + agentic-architect (parallel) |
| Design UX | "user flow", "screens", "journey" | ux-architect |
| Design system | "architecture", "how will it work" | agentic-architect |
| Create plans | "plan", "ready to build" | implementation-planner (after L1 complete) |
| Implement backend | "backend", "API", "database" | backend-engineer |
| Implement frontend | "frontend", "UI", "component" | frontend-engineer |
| Write tests | "test", "verify", "check" | test-engineer |
| Review code | "review", "is this good", "security" | code-reviewer |
| Fix bugs | "broken", "error", "bug", "fix" | debugger |
| Add features | "also need", "add feature", "change" | change-analyzer |
| Improve existing | "technical debt", "improve" | gap-analyzer |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         APP IDEA                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┴────────────────────┐
         │                                         │
   ┌─────▼─────┐                             ┌─────▼─────┐
   │ GREENFIELD│                             │ BROWNFIELD│
   └─────┬─────┘                             └─────┬─────┘
         │                                         │
┌────────▼────────┐                       ┌────────▼────────┐
│ L1: /analyze    │                       │ L1: /audit      │
│ (parallel)      │                       │ (parallel)      │
│                 │                       │                 │
│ • intent-guardian│                      │ • intent-audit  │
│ • ux-architect  │                       │ • ux-audit      │
│ • agentic-arch  │                       │ • aa-audit      │
└────────┬────────┘                       └────────┬────────┘
         │                                         │
         ▼                                         ▼
┌────────────────┐                        ┌────────────────┐
│ L2: /plan      │                        │ L2: /gap       │
│                │                        │                │
│ • impl-planner │                        │ • gap-analyzer │
└────────┬───────┘                        └────────┬───────┘
         │                                         │
         ▼                                         ▼
┌────────────────┐                        ┌────────────────┐
│ L3: /implement │                        │ L3: /improve   │
│                │                        │                │
│ • backend-eng  │                        │ • backend-eng  │
│ • frontend-eng │                        │ • frontend-eng │
│ • test-engineer│                        │ • test-engineer│
└────────┬───────┘                        └────────┬───────┘
         │                                         │
         └──────────────────┬──────────────────────┘
                            │
                     ┌──────▼──────┐
                     │ /verify     │
                     │             │
                     │ test-engineer│
                     └─────────────┘
```

## Level 1: Analysis

### Greenfield: /analyze

Runs three agents **IN PARALLEL**:

1. **intent-guardian** → `/docs/intent/product-intent.md`
   - Defines what the product promises
   - Documents invariants that must hold
   - Sets success criteria

2. **ux-architect** → `/docs/ux/user-journeys.md`
   - Designs user personas
   - Maps user journeys
   - Defines screens and interactions

3. **agentic-architect** → `/docs/architecture/agent-design.md`
   - Designs system architecture
   - Separates agent vs traditional code
   - Documents failure modes

### Brownfield: /audit

Runs three audits **IN PARALLEL**:

- **intent-audit** → Infers intent if missing, audits compliance
- **ux-audit** → Maps current journeys, identifies issues
- **aa-audit** → Maps current architecture, finds agentic opportunities

## Level 2: Planning

### Greenfield: /plan

**implementation-planner** reads all L1 outputs and produces:

- `/docs/plans/backend-plan.md` - APIs, DB, services
- `/docs/plans/frontend-plan.md` - Components, pages, state
- `/docs/plans/test-plan.md` - Test strategy
- `/docs/plans/implementation-order.md` - Phased execution

### Brownfield: /gap

**gap-analyzer** reads all audit outputs and produces:

- `/docs/gaps/gap-analysis.md` - All gaps categorized
- `/docs/gaps/migration-plan.md` - Phased improvements

## Level 3: Implementation

### Greenfield: /implement

Executes phases from `implementation-order.md`:

- **backend-engineer** for API, DB, services
- **frontend-engineer** for UI components
- **test-engineer** for tests AND verification

### Brownfield: /improve

Executes phases from `migration-plan.md`:

- Same engineers, but fixing gaps
- Each fix includes tests
- Regression checks after each fix

## Verification: /verify

**test-engineer** verifies after each phase:

- Smoke tests pass
- No regressions
- Journeys work (E2E)
- Promises kept (intent compliance)

## Output Structure

After running workflows, your project will have:

```
your-project/
├── docs/
│   ├── intent/
│   │   ├── product-intent.md
│   │   └── intent-audit.md
│   ├── ux/
│   │   ├── user-journeys.md
│   │   └── ux-audit.md
│   ├── architecture/
│   │   ├── agent-design.md
│   │   └── agentic-audit.md
│   ├── plans/              # Greenfield
│   │   ├── backend-plan.md
│   │   ├── frontend-plan.md
│   │   ├── test-plan.md
│   │   └── implementation-order.md
│   ├── gaps/               # Brownfield
│   │   ├── gap-analysis.md
│   │   └── migration-plan.md
│   └── verification/
│       ├── phase-1-report.md
│       ├── phase-2-report.md
│       └── ...
```

## Workflow Principles

### 1. Analysis Before Action
Always understand the problem space (intent, UX, architecture) before generating plans or writing code.

### 2. Plans Before Code
Generate detailed implementation plans before writing code. Plans are cheap to change; code is expensive.

### 3. Verification at Every Phase
Verify correctness after each implementation phase. Catch issues early when they're easier to fix.

### 4. Parallel Analysis
Run analysis agents in parallel to save time. They work independently and produce different outputs.

### 5. Sequential Planning
Planning must be sequential because the planner needs ALL analysis outputs to create coherent plans.

### 6. Phased Implementation
Implement in phases (foundation → features → polish) rather than all at once. Verify after each phase.

### 7. Documentation as Source of Truth
All analysis, plans, and gaps are documented in `/docs/`. Code implements the docs; docs don't follow the code.

---

## Conversation Examples

### Example 1: Greenfield Project

```
You: I want to build a food delivery app

Claude: I'll help design this. Let me define product intent and UX...
        [Launches intent-guardian + ux-architect in parallel]

        Intent and UX complete. Designing architecture...
        [Launches agentic-architect]

        Ready to create implementation plans?

You: Yes, use FastAPI, React, PostgreSQL

Claude: [Launches implementation-planner]

        Plans ready. Starting Phase 1: Database + Auth
        [Launches backend-engineer + frontend-engineer in parallel]
```

**What happened:**
- Claude detected "build" trigger → ran analysis agents
- Completed L1 → automatically suggested L2 (planning)
- User confirmed tech stack → ran planner
- Planner output showed Phase 1 → started implementation

**Equivalent command workflow:**
```bash
/analyze food delivery app
/plan fastapi react postgres
/implement phase 1
```

### Example 2: Brownfield Improvement

```
You: This codebase has technical debt. Help me improve it.

Claude: I'll analyze current state and create migration plan...
        [Launches gap-analyzer]

        Found gaps in 3 areas:
        1. No error handling (High)
        2. Inconsistent state (Medium)
        3. Missing tests (High)

        Created 3-phase plan. Start with Phase 1: Error handling?

You: Yes

Claude: [Launches backend-engineer for error handling improvements]
```

**What happened:**
- Claude detected "technical debt", "improve" → launched gap-analyzer
- Gap-analyzer audited codebase → created migration plan
- User approved Phase 1 → implementation started

**Equivalent command workflow:**
```bash
/audit
/gap
/improve phase 1
```

### Example 3: Mid-Project Change

```
You: Actually, we also need user roles - admin, editor, viewer

Claude: Let me analyze the impact...
        [Launches change-analyzer]

        This affects:
        - Database (users table needs role field)
        - Auth system (permissions)
        - 3 APIs (authorization checks)
        - 2 pages (role-based UI)

        Medium-sized change. Should I update plans and implement?

You: Yes

Claude: Updating intent, UX, architecture...
        Regenerating plans...
        [Launches implementation-planner]

        Implementing role-based auth...
        [Launches backend-engineer]
```

**What happened:**
- Claude detected "actually", "also need" → launched change-analyzer
- Change-analyzer assessed impact → presented to user
- User approved → updated L1 artifacts → regenerated plans → implemented

**Equivalent command workflow:**
```bash
/change add user roles admin editor viewer
/update
# /replan automatically triggered
/implement phase 2
```

### Example 4: Debugging

```
You: The login endpoint is returning 500 errors

Claude: I'll investigate...
        [Launches debugger]

        Found it. Root cause: Password comparison bug (= vs ===)

        Fixed in src/auth/login.ts:45
        Added regression test
        All tests passing
```

**What happened:**
- Claude detected "error" → immediately launched debugger
- Debugger handled full cycle: diagnose → fix → test → verify

**Equivalent command workflow:**
```bash
/debug login endpoint 500 error
```

---

## Power User: Command Reference

While conversation mode is recommended, power users can use explicit commands:

### Greenfield Commands
```bash
/analyze <app idea>          # Run L1 analysis (parallel)
/plan <optional tech stack>  # Run L2 planning (sequential)
/implement phase N           # Run L3 implementation for phase N
/verify phase N              # Verify phase N correctness
```

### Brownfield Commands
```bash
/audit <optional focus>      # Audit existing codebase
/gap <optional focus>        # Analyze gaps and create migration plan
/improve phase N             # Execute migration phase N
```

### Change Management Commands
```bash
/change <description>        # Analyze change impact
/update                      # Apply changes to L1 artifacts
/replan                      # Regenerate L2 plans (auto-triggered by /update)
```

### Quality Commands
```bash
/review <file/directory>     # Code review
/debug <description>         # Debug issue
```

### Individual Agent Commands (Advanced)
```bash
/intent <app idea>           # Just run intent-guardian
/ux <app idea>               # Just run ux-architect
/aa <app idea>               # Just run agentic-architect
/intent-audit                # Just audit intent compliance
/ux-audit                    # Just audit UX
/aa-audit                    # Just audit architecture
```

---

## CLAUDE.md Orchestrator

When you install with `--project`, a `CLAUDE.md` file is created in your project root. This file:

1. **Instructs Claude** to automatically select agents based on conversation
2. **Documents available agents** with their trigger words
3. **Provides workflow patterns** for greenfield, brownfield, changes, debugging
4. **Contains project-specific config** (tech stack, conventions, customizations)

### Customizing CLAUDE.md

Edit `CLAUDE.md` to customize agent behavior for your project:

```markdown
### Tech Stack
TypeScript, React, Node.js, PostgreSQL, Prisma

### Code Conventions
- Use functional components
- Prisma for database access
- Zod for validation
- TailwindCSS for styling

### Agent Customizations
- Always use Claude Sonnet for complex agents
- Prefer Ollama for simple tasks to save costs
- Never use GPT-4 (project policy)
```

Claude reads this configuration and follows it when orchestrating agents.

### Change Management (Mid-Flight Requirement Changes)
```bash
# Initial workflow
/analyze task app
/plan fastapi react
/implement phase 1
/implement phase 2   # IN PROGRESS

# User realizes they need teams
/change add team workspaces where users can create teams and share tasks
# Review impact analysis in /docs/changes/
/update
# Artifacts updated, plans regenerated
/implement phase 2   # Continue with updated plans (now includes teams)
/verify final
```

## Change Management Workflow

One of the biggest challenges in software development is handling requirement changes after planning or mid-implementation. The change management workflow solves this.

### The Problem

```
Initial:  /analyze → /plan → /implement phase 1 → /implement phase 2

User: "Actually, we also need user roles and permissions"

Now what? Which docs are stale? What needs updating?
```

### The Solution

```
                    ┌─────────────────┐
                    │  CHANGE REQUEST │
                    │  (user input)   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  /change        │
                    │  (impact analysis)│
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ Intent   │  │ UX       │  │ System   │
        │ affected?│  │ affected?│  │ affected?│
        └────┬─────┘  └────┬─────┘  └────┬─────┘
             │              │              │
             └──────────────┼──────────────┘
                            │
                            ▼
                    ┌─────────────────┐
                    │  /update        │
                    │  (apply changes)│
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  /replan        │
                    │  (update plans) │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  Updated plans  │
                    │  + migration    │
                    └─────────────────┘
```

### Change Workflow Steps

1. **Analyze Impact** - `/change <description>`
   - change-analyzer examines all artifacts
   - Identifies what needs updating
   - Detects conflicts
   - Assesses rework needed
   - Produces impact analysis report

2. **Review Impact**
   - Read `/docs/changes/change-[timestamp].md`
   - Understand scope of changes
   - Decide if acceptable

3. **Apply Changes** - `/update`
   - Updates intent, UX, architecture documents
   - Preserves existing work
   - Validates consistency
   - Automatically triggers `/replan`

4. **Continue Implementation**
   - Plans now reflect changes
   - Phases adjusted
   - Migration tasks created if needed
   - `/implement` continues with updated plans

### What Gets Updated

The change workflow intelligently updates:

**L1 Artifacts (Analysis):**
- product-intent.md - New/modified promises, invariants
- user-journeys.md - New/modified journeys
- agent-design.md - New/modified components

**L2 Artifacts (Plans):**
- backend-plan.md - New endpoints, modified schema
- frontend-plan.md - New pages, modified components
- test-plan.md - New tests for new journeys
- implementation-order.md - Adjusted phases, migration tasks

**Preservation:**
- Completed phases stay marked complete
- In-progress work extended (not rewritten)
- Unaffected sections unchanged
- Migration tasks created for rework

### Example: Adding Roles Mid-Flight

```bash
# Initial state
/analyze task management app
/plan
/implement phase 1  # ✅ Complete - Auth, CRUD
/implement phase 2  # 🔄 In progress - Dashboard, Reports

# Change request
/change add user roles (admin, editor, viewer) with different permissions

# Impact analysis shows:
# - Intent: Add promise about access control
# - UX: Add role management journey
# - Architecture: Add Role entity, permission middleware
# - Backend: Add role endpoints, modify auth
# - Frontend: Add role management page
# - Phase 1 (complete): Needs auth modification (migration)
# - Phase 2 (in progress): Extended with role features

# Accept changes
/update

# Result:
# - All artifacts updated
# - Plans regenerated
# - Phase 2 extended with:
#   - Backend: Role endpoints, permission checks
#   - Frontend: Role management UI
# - Migration task created:
#   - MIG-001: Update auth middleware for role checks

# Continue
/implement phase 2     # Now includes role features
/improve MIG-001       # Apply migration to phase 1 auth
/verify final
```

### Change Impact Levels

Changes are categorized by scope:

- **Minor** - Single component, no architectural impact
  - Example: Add new field to existing form
  - Impact: Low, quick to implement

- **Medium** - Multiple components, new journeys
  - Example: Add export feature
  - Impact: Moderate, adds work to current phase

- **Major** - Core architecture, multiple journeys
  - Example: Add multi-tenancy
  - Impact: High, may add phases

- **Pivot** - Fundamental change to direction
  - Example: Change from B2C to B2B
  - Impact: Critical, may require re-analysis

## Integration with Git Workflows

### Feature Branch Development
```bash
git checkout -b feature/new-capability
/analyze new capability
/plan
/implement phase 1
git commit -m "Phase 1: Foundation"
/implement phase 2
git commit -m "Phase 2: Core features"
/verify final
git push origin feature/new-capability
```

### Parallel Worktrees
```bash
# Main worktree
/analyze app

# Create worktrees for parallel implementation
git worktree add ../app-api feature/api
git worktree add ../app-web feature/web

# Terminal 1 (api)
cd ../app-api
/implement backend auth

# Terminal 2 (web)
cd ../app-web
/implement frontend auth
```

## Best Practices

### 1. Review Analysis Before Planning
Don't blindly run `/analyze` → `/plan` → `/implement`. Review the analysis outputs and adjust if needed.

### 2. Keep Plans Up to Date
If implementation reveals gaps in the plan, update the plan documents. Don't let code and docs diverge.

### 3. Use Verification Aggressively
Run `/verify` after each phase, not just at the end. Early detection saves debugging time.

### 4. Commit Docs and Code Together
When you implement a phase, commit both the code changes and any doc updates in the same commit.

### 5. Use Intent Audits to Catch Drift
Periodically run `/intent-audit` to ensure implementation still matches original product vision.
