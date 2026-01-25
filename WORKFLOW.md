# Workflow Documentation

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

## Workflow Variants

### Minimal Workflow (Proof of Concept)
```bash
/analyze simple todo app
/plan python flask react
/implement phase 1
```

### Standard Workflow (Production App)
```bash
/analyze comprehensive app description
/plan detailed tech stack
/implement phase 1
/verify phase 1
/implement phase 2
/verify phase 2
# ... continue for all phases
/verify final
```

### Audit-Only Workflow (Understanding Existing Code)
```bash
/audit
# Review output, no further action
```

### Focused Improvement (Single Gap)
```bash
/audit security practices
/gap security
/improve GAP-SEC-001
/verify security
```

### Agentic Migration (Add AI Capabilities)
```bash
/aa-audit
# Review suggestions
/implement content-classifier agent
/verify content-classifier
```

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
