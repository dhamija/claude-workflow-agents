---
name: agent-wf-help
description: Show help about the agent workflow system - workflow, agents, commands, and development patterns
argument-hint: "[topic] - workflow | agents | commands | patterns | parallel | brownfield"
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
/agent-wf-help brownfield   # Improving existing code
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
│   /agent-wf-help workflow    - How the two-level workflow works │
│   /agent-wf-help agents      - All 11 specialized agents        │
│   /agent-wf-help commands    - Available commands               │
│   /agent-wf-help patterns    - Development patterns & examples  │
│   /agent-wf-help parallel    - Parallel development guide       │
│   /agent-wf-help brownfield  - Improving existing code          │
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

  Claude: [Audits existing code]

          Analyzing codebase...

          Inferred intent:
          - This appears to be a task management app
          - Users can create, assign, and track tasks

          Inferred journeys:
          - Create task, Assign task, Complete task
          - Some journeys seem incomplete

          Is this understanding correct?

  You:    "Yes, but it's also for team collaboration"

  Claude: [Updates inferred docs]
          [Runs gap analysis]

          Found 12 gaps:
          - 2 Critical (security)
          - 4 High (broken features)
          - 6 Medium (tech debt)

          Start with critical fixes?

  You:    "Yes"

  Claude: [Fixes GAP-001: SQL injection in search]
          [Fixes GAP-002: Missing auth on admin routes]

          Critical gaps fixed ✓
          Continue with high priority?


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


PATTERN 8: BROWNFIELD WITH REVIEW
─────────────────────────────────

  You:    "What's wrong with this code?"

  Claude: [Quick audit]

          Issues found:

          🔴 Critical:
             - No rate limiting on auth endpoints

          🟠 High:
             - N+1 queries in dashboard
             - Missing error handling in checkout

          🟡 Medium:
             - Duplicated validation logic
             - No tests for payment flow

          Want a full analysis with migration plan?

  You:    "Yes, full analysis"

  Claude: [Runs complete audit]
          [Creates gap-analysis.md]
          [Creates migration-plan.md]

          Full analysis complete. See /docs/gaps/

          Recommended approach:
          Phase 0: Fix rate limiting (security)
          Phase 1: Fix N+1 queries, error handling
          Phase 2: Refactor validation, add tests


PATTERN 9: INCREMENTAL BROWNFIELD
─────────────────────────────────

  You:    "Just fix the security issues for now"

  Claude: [Identifies security gaps only]

          Security issues:
          1. GAP-001: No rate limiting
          2. GAP-002: SQL injection in search
          3. GAP-003: Weak password requirements

          Fixing...

  Claude: [Fixes each with tests]

          ✓ GAP-001: Added rate limiting middleware
          ✓ GAP-002: Parameterized all queries
          ✓ GAP-003: Added password strength validation

          All security issues fixed.
          Run /status to see remaining gaps.
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

### If topic = "brownfield":

```
╔══════════════════════════════════════════════════════════════════╗
║                   BROWNFIELD DEVELOPMENT                         ║
║                  (Improving Existing Code)                       ║
╚══════════════════════════════════════════════════════════════════╝

For existing codebases, Claude uses AUDIT mode to understand
what exists before suggesting improvements.


THE PROCESS
───────────

  "Analyze this codebase"
          │
          ▼
  ┌─────────────────────────────────────────┐
  │  1. AUDIT PHASE                         │
  │     Claude reads your code and infers:  │
  │     • Intent (what it's supposed to do) │
  │     • UX (how users interact)           │
  │     • Architecture (how it's built)     │
  │                                         │
  │     All marked [INFERRED]               │
  └─────────────────────────────────────────┘
          │
          ▼
  ┌─────────────────────────────────────────┐
  │  2. REVIEW                              │
  │     Claude asks you to confirm:         │
  │     "Is this understanding correct?"    │
  │                                         │
  │     You can correct any misunderstandings│
  └─────────────────────────────────────────┘
          │
          ▼
  ┌─────────────────────────────────────────┐
  │  3. GAP ANALYSIS                        │
  │     Claude compares current vs ideal:   │
  │     • What's broken?                    │
  │     • What's missing?                   │
  │     • What's risky?                     │
  │                                         │
  │     Creates prioritized migration plan  │
  └─────────────────────────────────────────┘
          │
          ▼
  ┌─────────────────────────────────────────┐
  │  4. IMPROVE                             │
  │     Fix gaps in priority order:         │
  │     • Phase 0: Critical (security)      │
  │     • Phase 1: High (broken features)   │
  │     • Phase 2: Medium (tech debt)       │
  │     • Phase 3: Low (polish)             │
  └─────────────────────────────────────────┘


TRIGGER PHRASES
───────────────

  Claude enters brownfield mode when you say:

  • "Analyze this codebase"
  • "Improve this project"
  • "What's wrong with this code"
  • "Audit this"
  • "Fix the technical debt"
  • "Review existing code"


INFERRED DOCS
─────────────

  In brownfield mode, docs are marked [INFERRED]:

  /docs/intent/product-intent.md [INFERRED]
  /docs/ux/user-journeys.md [INFERRED]
  /docs/architecture/agent-design.md [INFERRED]

  This means Claude guessed based on code.
  Review and correct before proceeding.


EXAMPLE SESSION
───────────────

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

  Claude: [Fixes each, adds tests]


TIPS
────

  • Let Claude audit first before asking for fixes
  • Review [INFERRED] docs - Claude might misunderstand
  • Start with security (Phase 0)
  • Fix one thing at a time, verify, then continue
  • Use /status to track remaining gaps
```

### If topic = "examples":

```
PRACTICAL EXAMPLES
══════════════════

See EXAMPLES.md for 7 complete real-world scenarios.

Quick summaries:


📝 EXAMPLE 1: SIMPLE TODO APP (Greenfield)
─────────────────────────────────────────

  You:    "Build me a simple todo app"

  Claude: [Analyzes → Plans → Builds 3 features]
          ✅ user-authentication
          ✅ task-management
          ✅ task-filtering

  Time: ~10 minutes
  Learn: Basic greenfield workflow


🏢 EXAMPLE 2: E-COMMERCE PLATFORM (Greenfield + Parallel)
──────────────────────────────────────────────────────────

  You:    "Build me an e-commerce platform"
          "We have 3 developers"

  Claude: [Plans 11 features in 4 batches]
          [Sets up git worktrees for parallel dev]
          [3 developers work simultaneously]

  Time: ~15 hours with 3 devs (vs 40 hours solo)
  Learn: Parallel development for teams


🔧 EXAMPLE 3: IMPROVING EXISTING CODE (Brownfield)
───────────────────────────────────────────────────

  You:    "Analyze this codebase"

  Claude: [Infers intent/UX/architecture]
          [Finds 12 gaps: 2 critical, 4 high, 6 medium]
          [Fixes critical + high priority issues]

  Time: ~8 hours
  Learn: Brownfield audit and gap fixing


➕ EXAMPLE 4: ADDING FEATURES (Change Management)
──────────────────────────────────────────────────

  You:    "Add meal planning to my recipe app"

  Claude: [Analyzes impact]
          [Updates docs and plans]
          [Implements new feature]
          ✅ No regressions

  Time: ~6 hours
  Learn: Change management workflow


🎯 EXAMPLE 5: BACKEND ONLY (Focused Work)
──────────────────────────────────────────

  You:    "Build backend API for movie app"
          "I'll handle frontend myself"

  Claude: [Builds API only]
          [Creates API documentation]
          [Tests backend thoroughly]

  Time: ~4 hours
  Learn: Focused backend development


🐛 EXAMPLE 6: DEBUGGING PRODUCTION ISSUE
─────────────────────────────────────────

  You:    "Users report 'Failed to load profile' errors"

  Claude: [Finds root cause in 1 minute]
          [Fixes + adds regression test]
          [Deploys to production]

  Time: ~30 minutes (from report to fix)
  Learn: Systematic debugging


✅ EXAMPLE 7: PRE-DEPLOYMENT REVIEW
────────────────────────────────────

  You:    "Review code before production deploy"

  Claude: [Finds 2 critical security issues]
          [Finds 5 high-priority issues]
          [Finds 3 bugs]
          [Fixes everything]
          ✅ Ready for production

  Time: ~4 hours (review + fixes)
  Learn: Security and quality review


KEY TAKEAWAYS
─────────────

  Pattern 1: Just talk - no commands needed
  Pattern 2: Greenfield = Analyze → Plan → Build
  Pattern 3: Brownfield = Audit → Gap → Improve
  Pattern 4: Changes = Analyze Impact → Update
  Pattern 5: Verification at every step
  Pattern 6: Parallel for teams, sequential for solo
  Pattern 7: Focused work is supported
  Pattern 8: Debugging is systematic
  Pattern 9: Reviews before deploy


FULL DETAILS
────────────

  See EXAMPLES.md in project root for complete
  conversation transcripts and detailed explanations.
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
  /agent-wf-help brownfield   - Improving existing code
  /agent-wf-help examples     - Practical examples

Or just ask me what you want to know!
```
