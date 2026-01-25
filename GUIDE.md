# Claude Workflow Agents - Complete Guide

> **Quick Start:** Just talk to Claude naturally. This guide explains how the system works internally.

## Table of Contents

1. [Overview](#overview)
2. [The Two-Level Workflow](#the-two-level-workflow)
3. [Brownfield (Existing Code)](#brownfield-existing-code)
4. [The 11 Agents](#the-11-agents)
5. [Available Commands](#available-commands)
6. [Development Patterns](#development-patterns)
7. [Parallel Development (Advanced)](#parallel-development-advanced)
8. [Documentation Structure](#documentation-structure)
9. [Troubleshooting](#troubleshooting)

---

## Overview

Claude Workflow Agents is a conversation-driven multi-agent system for Claude Code. You don't need to memorize commands or agent names - just describe what you want, and Claude automatically orchestrates specialized agents to:

1. **Analyze** - Define product intent, user experience, and system architecture
2. **Plan** - Create feature-based implementation plans
3. **Implement** - Build features one by one with backend, frontend, and tests
4. **Verify** - Ensure everything works correctly

### Default Mode: Sequential Development

By default, Claude implements features **one at a time** in your main project:

```
Feature 1: user-authentication
  → Backend (APIs, database, services)
  → Frontend (pages, components, state)
  → Tests (unit, integration, E2E)
  → ✓ Complete

Feature 2: profile-management
  → Backend
  → Frontend
  → Tests
  → ✓ Complete

... continues until all features done
```

### Advanced Mode: Parallel Development (Opt-In)

For teams with **multiple developers**, you can use git worktrees to work on features simultaneously. See [Parallel Development](#parallel-development-advanced) section.

---

## The Two-Level Workflow

### Level 1: App-Level Workflow (Runs Once at Start)

When you start a new project, Claude runs these agents to understand the big picture:

```
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Intent     │ → │      UX      │ → │    System    │ → │   Planner    │
│   Guardian   │   │  Architect   │   │  Architect   │   │              │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

**Output Documents:**
- `/docs/intent/product-intent.md` - What we promise users
- `/docs/ux/user-journeys.md` - How users interact with the app
- `/docs/architecture/agent-design.md` - System architecture
- `/docs/plans/overview/` - Full system specifications (backend, frontend, tests)
- `/docs/plans/features/` - Individual feature plans
- `/docs/plans/implementation-order.md` - Build sequence with dependency batches

**Triggers:**
- "Build me a [app idea]"
- "I want to create a [description]"
- Starting a new project

### Level 2: Feature-Level Workflow (Runs for Each Feature)

For each feature, Claude runs these agents in sequence:

```
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Backend    │ → │   Frontend   │ → │     Test     │ → │    Verify    │
│   Engineer   │   │   Engineer   │   │   Engineer   │   │              │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

**Flow:**
1. Read feature plan from `/docs/plans/features/[name].md`
2. Implement backend (APIs, database, services)
3. Implement frontend (pages, components, state)
4. Write tests (unit, integration, E2E)
5. Verify feature works
6. Mark complete, move to next feature

**Triggers:**
- "Implement the features"
- "Continue"
- "Build [specific feature]"

### Why Two Levels?

- **Level 1** ensures every feature aligns with the overall vision
- **Level 2** ensures every feature is complete before moving on
- Changes at Level 1 automatically trigger replanning at Level 2
- Clear separation between "what to build" and "how to build it"

---

## Brownfield (Existing Code)

For existing codebases, Claude uses **AUDIT mode** to understand what exists before suggesting improvements.

### The Brownfield Workflow

```
"Analyze this codebase"
        │
        ▼
    AUDIT (infer intent, UX, architecture)
        │
        ▼
    REVIEW (confirm understanding)
        │
        ▼
    GAP ANALYSIS (find issues)
        │
        ▼
    IMPROVE (fix by priority)
```

### Trigger Phrases

Claude enters brownfield mode when you say:
- "Analyze this codebase"
- "Improve this project"
- "What's wrong with this code"
- "Audit this"
- "Fix the technical debt"

### Inferred Documents

In brownfield mode, Claude creates docs marked `[INFERRED]`:
- `/docs/intent/product-intent.md [INFERRED]`
- `/docs/ux/user-journeys.md [INFERRED]`
- `/docs/architecture/agent-design.md [INFERRED]`

These are educated guesses based on your code. **Review and correct them** before proceeding.

### Example Session

```
You:    "Analyze this codebase"

Claude: Analyzing...

        This appears to be an e-commerce app:
        - User auth with roles
        - Product catalog
        - Shopping cart
        - Checkout with payments

        Found 3 incomplete journeys and
        several security concerns.

        Is this understanding correct?

You:    "Yes, but checkout is the priority"

Claude: Running gap analysis focused on checkout...

        Checkout issues:
        🔴 No payment validation
        🟠 Race condition in inventory
        🟡 No order confirmation email

        Fix these?

You:    "Yes"

Claude: [Fixes each issue, adds tests]
```

### Gap Prioritization

- **Critical** 🔴 - Security, data loss (Phase 0, fix now)
- **High** 🟠 - Broken features, major UX issues (Phase 1)
- **Medium** 🟡 - Tech debt, minor improvements (Phase 2)
- **Low** 🟢 - Polish, nice-to-have (Phase 3/backlog)

### Tips for Brownfield

- Let Claude audit first before asking for fixes
- Review `[INFERRED]` docs - Claude might misunderstand
- Start with security issues (Phase 0)
- Fix one thing at a time, verify, then continue
- Use natural language: "What's the status?" to track progress

---

## The 11 Agents

### Level 1 Agents (App-Level)

#### intent-guardian
**What:** Defines product intent and behavioral contracts
**Creates:** `/docs/intent/product-intent.md`
**Triggers:** New project, "what should it do", "guarantee", "promise"
**Example:** "What promises should we make to users?"

#### ux-architect
**What:** Designs user journeys and experience
**Creates:** `/docs/ux/user-journeys.md`
**Triggers:** New project, "user flow", "UX", "journey", "how will users"
**Example:** "How will users accomplish their goals?"

#### agentic-architect
**What:** Designs multi-agent system architecture
**Creates:** `/docs/architecture/agent-design.md`
**Triggers:** New project, "architecture", "system design", "how should this work"
**Example:** "What should be agents vs traditional code?"

#### implementation-planner
**What:** Creates technical implementation plans
**Creates:** `/docs/plans/overview/`, `/docs/plans/features/`, `/docs/plans/implementation-order.md`
**Triggers:** After L1 analysis, "plan", "how to build", "ready to build"
**Example:** "Create the implementation plan"

#### change-analyzer
**What:** Analyzes impact of requirement changes
**Creates:** `/docs/changes/change-*.md`
**Triggers:** "Add", "change", "also need", "what if"
**Example:** "Actually, we also need user roles"

#### gap-analyzer
**What:** Analyzes gaps in existing codebases
**Creates:** `/docs/gaps/gap-analysis.md`, `/docs/migration/migration-plan.md`
**Triggers:** Existing codebase, "improve", "technical debt", "analyze this code"
**Example:** "This codebase has technical debt. Help me improve it."

### Level 2 Agents (Feature-Level)

#### backend-engineer
**What:** Implements backend code (APIs, database, services)
**Triggers:** Backend tasks, "API", "endpoint", "database", "service"
**Example:** "Implement the backend for user authentication"

#### frontend-engineer
**What:** Implements frontend code (pages, components, state, API integration)
**Triggers:** Frontend tasks, "UI", "page", "component", "frontend"
**Example:** "Build the signup page"

#### test-engineer
**What:** Writes tests and verifies system correctness
**Triggers:** "Test", "verify", after implementation
**Example:** "Write tests for the auth feature"

#### code-reviewer
**What:** Reviews code for security, bugs, performance, maintainability
**Triggers:** "Review", "check code", before milestone
**Example:** "Review the auth code before deploy"

#### debugger
**What:** Debugs errors and fixes issues with minimal changes
**Triggers:** "Broken", "error", "bug", "doesn't work"
**Example:** "The login endpoint is returning 500 errors"

---

## Available Commands

### Help

```bash
/agent-wf-help              # Quick overview
/agent-wf-help workflow     # Two-level workflow
/agent-wf-help agents       # All 11 agents
/agent-wf-help commands     # Available commands
/agent-wf-help patterns     # Development patterns
/agent-wf-help parallel     # Parallel development
```

### Main Project Commands

```bash
/analyze <idea>             # Run all analysis agents (intent, UX, architecture)
/plan <tech stack>          # Generate implementation plans
/implement phase N          # Build phase by phase
/verify phase N             # Verify phase correctness
```

### Existing Codebase Commands

```bash
/audit                      # Understand existing codebase
/gap                        # Find gaps and create migration plan
/improve phase N            # Fix gaps incrementally
```

### Change Management Commands

```bash
/change <description>       # Analyze impact of requirement changes
/update                     # Apply changes to artifacts
/replan                     # Regenerate plans after changes
```

### Quality Commands

```bash
/review [target]            # Code review (file, dir, or "staged")
/debug                      # Launch debugger
```

### Architecture Commands

```bash
/aa <idea>                  # Design agentic architecture
/aa-audit                   # Audit existing agent system
/ux <idea>                  # Design user experience
/ux-audit                   # Audit existing UX
/intent <idea>              # Define product intent
/intent-audit               # Audit implementation against intent
```

### Parallel Development (Advanced)

```bash
/parallel <feature>         # Create git worktree for feature
                            # (Only for multi-developer teams)
```

### Tips

- **Commands are optional** - Just talking naturally works fine
- "Continue" works without commands
- "What's the status" works naturally
- "Review the auth code" works naturally
- Claude understands natural language

---

## Development Patterns

### Pattern 1: New Project (Greenfield)

```
You:    "Build me a task manager with AI prioritization"

Claude: [Analyzes] Creating intent, UX, architecture...
        [Plans] Identified features: auth, tasks, AI priority...
        [Builds] Starting with auth feature...

You:    "Continue"

Claude: [Builds] Auth complete ✓. Starting tasks feature...

(repeat until done)
```

### Pattern 2: Add Features (Iteration)

```
You:    "Add comments on posts"

Claude: [Analyzes impact]
        This adds:
        - New journey: Add comment
        - Backend: 2 endpoints
        - Frontend: Comment component

        Updating plans and continuing...
```

### Pattern 3: Existing Code (Brownfield)

```
You:    "Analyze this codebase and improve it"

Claude: [Audits] Understanding existing code...
        [Gaps] Found 5 improvements:
        1. Auth missing rate limiting (security)
        2. N+1 queries in dashboard (perf)
        ...
        Start fixing?
```

### Pattern 4: Bug Fix

```
You:    "The checkout shows wrong totals"

Claude: [Debugs]
        Found: Tax calculation wrong
        Fixed: cart/service.py:45
        Added: Regression test

        Continuing...
```

### Pattern 5: Code Review

```
You:    "Review auth before deploy"

Claude: [Reviews]

        Summary: APPROVED with suggestions

        🟠 High: Reset token doesn't expire
        🟡 Medium: Missing rate limit
        🟢 Suggestion: Extract validation

        Want me to fix high-priority?
```

### Pattern 6: Resume Work

```
You:    "Where were we?"

Claude: Project: Recipe App

        ✓ auth - complete
        🔄 recipes - in progress
        ○ search - not started

        Continue with recipes?
```

### Pattern 7: Focused Work

```
You:    "Just build the API, I'll do frontend"

Claude: [Builds only backend for each feature]

        Auth API complete:
        - POST /api/auth/signup
        - POST /api/auth/login
        - GET /api/auth/me

        Tests in /tests/auth/
```

---

## Parallel Development (Advanced)

> **Warning:** This section is for teams with **multiple developers**. If you're a single developer, stick with sequential mode (default).

### When to Use Parallel Mode

✓ **Use parallel if:**
- Multiple developers on your team
- Features are independent
- Want faster development
- Comfortable with git worktrees

✗ **Don't use parallel if:**
- Single developer
- Tightly coupled features
- Still learning the system

### How It Works

1. Claude creates feature plans with dependencies
2. `/parallel <feature>` creates isolated folder (git worktree): `../myapp-auth/`
3. Each folder has scoped CLAUDE.md (Claude there ONLY works on that feature)
4. You open terminal in that folder
5. When done, merge back to main

### Step by Step

```bash
# In main project
You: /parallel user-authentication

Claude: Created worktree: ../user-authentication/
        cd ../user-authentication

# New terminal
$ cd ../user-authentication
$ claude  # or your Claude Code command

You: "Implement this feature"

Claude: [Reads FEATURE.md]
        [Implements backend → frontend → tests]
        ✓ Complete. Ready to merge.

# Back in main project
$ cd ../main-project
$ git worktree remove ../user-authentication
$ git merge feature/user-authentication
```

### Dependency Batches

From `implementation-order.md`:

```
Batch 0: auth               (foundation, sequential)
    ↓
Batch 1: recipes, profiles  (independent, parallel OK)
    ↓
Batch 2: search             (depends on Batch 1)
```

- **Batch 0** must complete first (foundation features like auth)
- **Batch 1+** features can be developed in parallel
- Each batch depends on previous batches

### Multiple Parallel Features

```bash
# Developer 1
/parallel profile-management
cd ../profile-management
# Works on profile feature

# Developer 2 (same time)
/parallel notification-system
cd ../notification-system
# Works on notifications feature

# Both work independently
# Both merge when ready
# No conflicts (different files)
```

---

## Documentation Structure

All agents create and use `/docs` as the source of truth:

```
/docs
├── intent/
│   └── product-intent.md          # What we promise users
│
├── ux/
│   └── user-journeys.md           # How users accomplish goals
│
├── architecture/
│   ├── system-design.md           # System architecture
│   └── agent-topology.md          # Agent design (if using agents)
│
├── plans/
│   ├── overview/                  # Full system reference
│   │   ├── backend-plan.md        # All endpoints, DB, services
│   │   ├── frontend-plan.md       # All pages, components
│   │   └── test-plan.md           # Test strategy
│   │
│   ├── features/                  # Feature-specific (execution)
│   │   ├── user-authentication.md # Vertical slice with all specs
│   │   ├── profile-management.md
│   │   └── ...
│   │
│   └── implementation-order.md    # Parallel batches and dependencies
│
├── verification/
│   └── phase-N-report.md          # Verification results
│
├── changes/
│   └── change-[timestamp].md      # Change impact analysis
│
└── migration/
    └── migration-plan.md          # Brownfield improvement plan
```

### Key Documents

#### `/docs/intent/product-intent.md`
- What promises we make to users
- What the app MUST do and MUST NOT do
- Success criteria and invariants

#### `/docs/ux/user-journeys.md`
- How users accomplish their goals
- Screen flows and interactions
- Error states and edge cases

#### `/docs/architecture/agent-design.md`
- What should be agents vs traditional code
- System components and responsibilities
- Failure modes and recovery

#### `/docs/plans/overview/backend-plan.md`
- Complete database schema
- All API endpoints with specs
- All services and their responsibilities

#### `/docs/plans/overview/frontend-plan.md`
- All pages and routes
- Complete component inventory
- State management overview

#### `/docs/plans/features/[feature-name].md`
- Scope (what's included in this feature)
- Backend work (endpoints, DB, services)
- Frontend work (pages, components, state)
- Tests (what to verify)
- Exact file paths to create/modify
- Acceptance criteria

#### `/docs/plans/implementation-order.md`
- Dependency batches (Batch 0, 1, 2, ...)
- Which features can be parallel
- Critical path and time estimates

---

## Troubleshooting

### "Claude is suggesting parallel mode but I'm a single developer"

This shouldn't happen. Sequential mode is default. If it does:
1. Say: "I'm a single developer, use sequential mode"
2. Claude will implement features one by one

### "How do I know which feature is being worked on?"

Claude reports progress after each feature:
```
✓ user-authentication complete
Starting profile-management...
```

### "Can I skip a feature and do another one first?"

Yes, just say:
```
You: "Skip to the search feature"

Claude: [Checks dependencies]
        Search depends on: auth, recipes
        Both are complete. Starting search...
```

### "I want to change a feature after it's built"

Just describe the change:
```
You: "Add password reset to auth"

Claude: [Analyzes impact]
        This affects:
        - Backend: 1 new endpoint
        - Frontend: Reset password page
        - Tests: Reset flow test

        Updating plans and implementing...
```

### "How do I review what's been built?"

```
You: "What's the status?"

Claude: Project: Recipe App

        ✓ user-authentication - complete
        ✓ profile-management - complete
        🔄 recipe-search - in progress (backend done, frontend next)
        ○ recipe-sharing - not started

        Continue with recipe-search?
```

### "Tests are failing"

Claude automatically runs tests after each feature. If they fail:
```
Claude: Tests failing for profile-management:
        - ProfileService.update returns 500

        [Debugger] Found issue in validation logic.
        Fixed: backend/src/profile/service.ts:45

        Re-running tests... ✓ All passing
```

### "I want to work on multiple features at once (parallel mode)"

Only do this if you have multiple developers:
```
You: "I have 3 developers. Can we work in parallel?"

Claude: Yes! After planning, run:
        /parallel profile-management    (Developer 1)
        /parallel notification-system   (Developer 2)
        /parallel settings-page         (Developer 3)

        Each gets isolated workspace with scoped CLAUDE.md
```

### "How do I know which agents are running?"

Claude tells you:
```
Claude: [Analyzing with intent-guardian and ux-architect]
        ...
        [Planning with implementation-planner]
        ...
        [Implementing backend with backend-engineer]
```

You don't need to know agent names - this is just for transparency.

---

## Getting Help

```bash
/agent-wf-help              # Quick overview
/agent-wf-help workflow     # How the two-level workflow works
/agent-wf-help agents       # All 11 specialized agents
/agent-wf-help commands     # Available commands
/agent-wf-help patterns     # Development patterns & examples
/agent-wf-help parallel     # Parallel development guide
```

Or just ask Claude:
- "How does this work?"
- "What's next?"
- "What should I do?"

**Remember:** Just talk naturally. Claude handles the rest.
