---
name: agent-wf-help
description: Show help about the agent workflow system - workflow, agents, commands, and development patterns
argument-hint: "[topic] - workflow | agents | commands | patterns | parallel"
---

# Claude Workflow Agents - Help System

Display help based on the topic requested.

**Usage:**
```bash
/agent-wf-help              # Quick overview
/agent-wf-help workflow     # Two-level workflow
/agent-wf-help agents       # All 11 agents
/agent-wf-help commands     # Available commands
/agent-wf-help patterns     # Development patterns
/agent-wf-help parallel     # Parallel development
```

---

## Implementation

Read the topic from `$1` and display appropriate help:

### If empty or no argument:

```
╔══════════════════════════════════════════════════════════════════╗
║                    CLAUDE WORKFLOW AGENTS                        ║
║                         Quick Start                              ║
╚══════════════════════════════════════════════════════════════════╝

Just talk naturally. Claude handles the rest.

┌─────────────────────────────────────────────────────────────────┐
│ START A PROJECT                                                 │
│                                                                 │
│   "Build me a recipe app where I can save and search recipes"   │
│                                                                 │
│   Claude will:                                                  │
│   1. Define what we're building (intent)                        │
│   2. Design user experience (journeys)                          │
│   3. Design the system (architecture)                           │
│   4. Create implementation plans                                │
│   5. Build features one by one                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ COMMON ACTIONS                                                  │
│                                                                 │
│   "Continue" / "Next"      → Keep building                      │
│   "Add [feature]"          → Add new capability                 │
│   "It's broken" / "Error"  → Debug and fix                      │
│   "Review the code"        → Quality check                      │
│   "Status?"                → See progress                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ MORE HELP                                                       │
│                                                                 │
│   /agent-wf-help workflow  - How the two-level workflow works   │
│   /agent-wf-help agents    - All 11 specialized agents          │
│   /agent-wf-help commands  - Available commands                 │
│   /agent-wf-help patterns  - Development patterns & examples    │
│   /agent-wf-help parallel  - Parallel development guide         │
└─────────────────────────────────────────────────────────────────┘
```

### If topic = "workflow":

```
╔══════════════════════════════════════════════════════════════════╗
║                      THE TWO-LEVEL WORKFLOW                      ║
╚══════════════════════════════════════════════════════════════════╝

LEVEL 1: APP WORKFLOW (runs once at start)
──────────────────────────────────────────

  "Build me an app..."
        │
        ▼
  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
  │  Intent  │ → │    UX    │ → │  System  │ → │  Planner │
  │ Guardian │   │ Architect│   │ Architect│   │          │
  └──────────┘   └──────────┘   └──────────┘   └──────────┘
        │
        ▼
  Creates: Intent doc, User journeys, Architecture, Feature plans


LEVEL 2: FEATURE WORKFLOW (runs for each feature)
─────────────────────────────────────────────────

  For each feature in sequence:

  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
  │ Backend  │ → │ Frontend │ → │   Test   │ → │  Verify  │
  │ Engineer │   │ Engineer │   │ Engineer │   │          │
  └──────────┘   └──────────┘   └──────────┘   └──────────┘
        │
        ▼
  Feature complete ✓ → Move to next feature


WHY TWO LEVELS?
───────────────

  Level 1 = "What are we building?" (big picture)
  Level 2 = "How do we build this piece?" (execution)

  • Every feature aligns with the overall vision
  • Every feature is verified before moving on
  • Changes trigger re-analysis at the right level


DOCUMENTS CREATED
─────────────────

  /docs/intent/product-intent.md      - What we promise users
  /docs/ux/user-journeys.md           - How users interact
  /docs/architecture/agent-design.md  - System design
  /docs/plans/overview/               - Full system specs
  /docs/plans/features/               - Per-feature plans
  /docs/plans/implementation-order.md - Build sequence
```

### If topic = "agents":

```
╔══════════════════════════════════════════════════════════════════╗
║                       THE 11 AGENTS                              ║
╚══════════════════════════════════════════════════════════════════╝

Claude automatically selects agents. You don't call them directly.


LEVEL 1 AGENTS (App-level)
──────────────────────────

  ┌─────────────────────────────────────────────────────────────┐
  │ INTENT-GUARDIAN                                             │
  │ "What are we promising users?"                              │
  │ Creates: /docs/intent/product-intent.md                     │
  │ Triggers: New project, "what should it do", "guarantee"     │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ UX-ARCHITECT                                                │
  │ "How will users interact?"                                  │
  │ Creates: /docs/ux/user-journeys.md                          │
  │ Triggers: New project, "user flow", "UX", "journey"         │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ AGENTIC-ARCHITECT                                           │
  │ "How should the system work?"                               │
  │ Creates: /docs/architecture/agent-design.md                 │
  │ Triggers: New project, "architecture", "system design"      │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ IMPLEMENTATION-PLANNER                                      │
  │ "What's the build plan?"                                    │
  │ Creates: /docs/plans/overview/*, /docs/plans/features/*     │
  │ Triggers: After L1 analysis, "plan", "how to build"         │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ CHANGE-ANALYZER                                             │
  │ "What's the impact of this change?"                         │
  │ Creates: /docs/changes/change-*.md                          │
  │ Triggers: "Add", "change", "also need", "what if"           │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ GAP-ANALYZER                                                │
  │ "What's wrong with existing code?"                          │
  │ Creates: /docs/gaps/gap-analysis.md, migration-plan.md      │
  │ Triggers: Existing codebase, "improve", "technical debt"    │
  └─────────────────────────────────────────────────────────────┘


LEVEL 2 AGENTS (Feature-level)
──────────────────────────────

  ┌─────────────────────────────────────────────────────────────┐
  │ BACKEND-ENGINEER                                            │
  │ Implements: APIs, database, services, business logic        │
  │ Triggers: Backend tasks, "API", "endpoint", "database"      │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ FRONTEND-ENGINEER                                           │
  │ Implements: Pages, components, state, API integration       │
  │ Triggers: Frontend tasks, "UI", "page", "component"         │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ TEST-ENGINEER                                               │
  │ Implements: Unit, integration, E2E tests + verification     │
  │ Triggers: "Test", "verify", after implementation            │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ CODE-REVIEWER                                               │
  │ Reviews: Security, bugs, performance, maintainability       │
  │ Triggers: "Review", "check code", before milestone          │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ DEBUGGER                                                    │
  │ Does: Root cause analysis, minimal fix, regression test     │
  │ Triggers: "Broken", "error", "bug", "doesn't work"          │
  └─────────────────────────────────────────────────────────────┘
```

### If topic = "commands":

```
╔══════════════════════════════════════════════════════════════════╗
║                      AVAILABLE COMMANDS                          ║
╚══════════════════════════════════════════════════════════════════╝

Most of the time, just talk naturally. Commands are optional.


HELP
────
  /agent-wf-help [topic]     This help system
                             Topics: workflow, agents, commands,
                                     patterns, parallel


MAIN COMMANDS
─────────────
  /analyze                   Run all analysis agents
  /plan                      Generate implementation plans
  /audit                     Audit existing codebase
  /gap                       Find gaps and create migration plan
  /change <description>      Analyze change impact
  /debug                     Launch debugger
  /review [target]           Code review (file, dir, or "staged")


PARALLEL DEVELOPMENT (Advanced, Opt-In)
───────────────────────────────────────
  /parallel <feature>        Create worktree for a feature
                             Only for multi-developer teams


TIPS
────
  • Commands are shortcuts, not requirements
  • "Continue" works without commands
  • "What's the status" works naturally
  • "Review the auth code" works naturally
  • Claude understands natural language
```

### If topic = "patterns":

```
╔══════════════════════════════════════════════════════════════════╗
║                    DEVELOPMENT PATTERNS                          ║
╚══════════════════════════════════════════════════════════════════╝


PATTERN 1: NEW PROJECT (Greenfield)
───────────────────────────────────

  You:    "Build me a task manager with AI prioritization"

  Claude: [Analyzes] Creating intent, UX, architecture...
          [Plans] Identified features: auth, tasks, AI priority...
          [Builds] Starting with auth feature...

  You:    "Continue"

  Claude: [Builds] Auth complete ✓. Starting tasks feature...

  (repeat until done)


PATTERN 2: ADD FEATURES (Iteration)
───────────────────────────────────

  You:    "Add comments on posts"

  Claude: [Analyzes impact]
          This adds:
          - New journey: Add comment
          - Backend: 2 endpoints
          - Frontend: Comment component

          Updating plans and continuing...


PATTERN 3: EXISTING CODE (Brownfield)
─────────────────────────────────────

  You:    "Analyze this codebase and improve it"

  Claude: [Audits] Understanding existing code...
          [Gaps] Found 5 improvements:
          1. Auth missing rate limiting (security)
          2. N+1 queries in dashboard (perf)
          ...
          Start fixing?


PATTERN 4: BUG FIX
──────────────────

  You:    "The checkout shows wrong totals"

  Claude: [Debugs]
          Found: Tax calculation wrong
          Fixed: cart/service.py:45
          Added: Regression test

          Continuing...


PATTERN 5: CODE REVIEW
──────────────────────

  You:    "Review auth before deploy"

  Claude: [Reviews]

          Summary: APPROVED with suggestions

          🟠 High: Reset token doesn't expire
          🟡 Medium: Missing rate limit
          🟢 Suggestion: Extract validation

          Want me to fix high-priority?


PATTERN 6: RESUME WORK
──────────────────────

  You:    "Where were we?"

  Claude: Project: Recipe App

          ✓ auth - complete
          🔄 recipes - in progress
          ○ search - not started

          Continue with recipes?


PATTERN 7: FOCUSED WORK
───────────────────────

  You:    "Just build the API, I'll do frontend"

  Claude: [Builds only backend for each feature]

          Auth API complete:
          - POST /api/auth/signup
          - POST /api/auth/login
          - GET /api/auth/me

          Tests in /tests/auth/
```

### If topic = "parallel":

```
╔══════════════════════════════════════════════════════════════════╗
║                   PARALLEL DEVELOPMENT                           ║
╚══════════════════════════════════════════════════════════════════╝

Build multiple features simultaneously in separate terminals.
This is OPT-IN. Default is sequential (single terminal).


WHEN TO USE
───────────
  ✓ Multiple developers on team
  ✓ Independent features
  ✓ Want faster development
  ✓ Comfortable with git worktrees

  ✗ Single developer
  ✗ Tightly coupled features
  ✗ Still learning the system


HOW IT WORKS
────────────

  1. Claude creates feature plans with dependencies

  2. /parallel <feature> creates isolated folder:
     ../myapp-auth/

  3. Each folder has scoped CLAUDE.md
     Claude there ONLY works on that feature

  4. You open terminal in that folder

  5. When done, merge back to main


STEP BY STEP
────────────

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


DEPENDENCY BATCHES
──────────────────

  From implementation-order.md:

  Batch 0: auth               (foundation, sequential)
      ↓
  Batch 1: recipes, profiles  (independent, parallel OK)
      ↓
  Batch 2: search             (depends on Batch 1)


COMMANDS
────────
  /parallel <feature>        Create worktree for feature
```

### If topic not recognized:

```
I don't have specific help for "<topic>".

Available topics:
  /agent-wf-help              - Quick overview
  /agent-wf-help workflow     - How the two-level workflow works
  /agent-wf-help agents       - All 11 specialized agents
  /agent-wf-help commands     - Available commands
  /agent-wf-help patterns     - Development patterns & examples
  /agent-wf-help parallel     - Parallel development guide

Or just ask me what you want to know!
```
