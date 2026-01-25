<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/agent-wf-help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
name: agent-wf-help
description: Show help about the agent workflow system - workflow, agents, commands, and development patterns
argument-hint: "[topic] - workflow | agents | commands | patterns | parallel | brownfield | cicd | sync | docs"
---

# Claude Workflow Agents - Help System

Display help based on the topic requested.

**Usage:**
```bash
/agent-wf-help              # Quick overview
/agent-wf-help workflow     # Two-level workflow
/agent-wf-help agents       # All 14 agents
/agent-wf-help commands     # Available commands
/agent-wf-help patterns     # Development patterns
/agent-wf-help parallel     # Parallel development
/agent-wf-help brownfield   # Improving existing code
/agent-wf-help cicd         # CI/CD validation setup
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
│   /agent-wf-help agents      - All 15 specialized agents        │
│   /agent-wf-help docs        - Documentation management         │
│   /agent-wf-help commands    - Available commands               │
│   /agent-wf-help design      - Design system & visual styling   │
│   /agent-wf-help llm         - LLM integration & AI components  │
│   /agent-wf-help mcp         - MCP servers for enhanced dev     │
│   /agent-wf-help patterns    - Development patterns & examples  │
│   /agent-wf-help parallel    - Parallel development guide       │
│   /agent-wf-help brownfield  - Improving existing code          │
│   /agent-wf-help cicd        - CI/CD validation setup           │
│   /agent-wf-help enforce     - Documentation enforcement        │
│   /agent-wf-help sync        - Project state & maintenance      │
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
║                       THE 15 AGENTS                              ║
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
  │ Creates: /docs/architecture/README.md, agent-design.md      │
  │ Triggers: New project, "architecture", "system design"      │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ IMPLEMENTATION-PLANNER                                      │
  │ "What's the build plan?"                                    │
  │ Creates: /docs/plans/overview/*, /docs/plans/features/*     │
  │ Triggers: After L1 analysis, "plan", "how to build"         │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ DOCUMENTATION-ENGINEER                                      │
  │ "Create and maintain comprehensive docs"                    │
  │ Creates: USAGE.md, README.md, /docs/api/, /docs/guides/     │
  │ Triggers: After L1 planning (auto), "document", "usage"     │
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

  ┌─────────────────────────────────────────────────────────────┐
  │ CI-CD-ENGINEER                                              │
  │ Sets up: Automated validation, rules, GitHub Actions        │
  │ Triggers: "Set up CI/CD", "validate", after L1 planning     │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ PROJECT-MAINTAINER                                          │
  │ Maintains: Project docs, state, and test coverage           │
  │ Triggers: After features, "/sync", "save state"             │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ PROJECT-ENFORCER                                            │
  │ Sets up: Git hooks, CI, enforcement for doc sync            │
  │ Triggers: After L1, "/enforce setup", "protect docs"        │
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
                                     patterns, parallel, enforce, sync


MAIN COMMANDS
─────────────
  /analyze                   Run all analysis agents
  /plan                      Generate implementation plans
  /audit                     Audit existing codebase
  /gap                       Find gaps and create migration plan
  /change <description>      Analyze change impact
  /debug                     Launch debugger
  /review [target]           Code review (file, dir, or "staged")
  /docs [mode]               Manage documentation
                             Modes: verify, update, generate, status
  /sync [mode]               Update project state & docs
                             Modes: full (default), quick, report
  /enforce [action]          Manage documentation enforcement
                             Actions: setup, status, verify, disable


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

### If topic = "cicd" or "ci" or "cd" or "validation":

```
╔══════════════════════════════════════════════════════════════════╗
║                    CI/CD VALIDATION                              ║
║              (Automated Promise Protection)                      ║
╚══════════════════════════════════════════════════════════════════╝

CI/CD validation automatically checks if your code honors the promises
made in /docs/intent/, /docs/ux/, and /docs/architecture/.


WHEN TO SET IT UP
─────────────────

  ✅ After L1 planning (intent, UX, architecture docs exist)
  ✅ Before production deployment
  ✅ When working with a team
  ✅ User asks: "set up CI/CD", "validate", "protect the intent"

  ❌ During active development (unless docs changed)
  ❌ Small prototypes/learning projects


WHAT IT DOES
────────────

  1. Reads /docs/intent/, /docs/ux/, /docs/architecture/
  2. Generates validation rules from your promises
  3. Runs validators on every commit/PR
  4. Reports violations with references to broken promises
  5. Auto-updates rules when docs change


WHAT IT CREATES
───────────────

  /ci/
  ├── validate.sh              # Master validation script
  ├── rules.json               # Generated from /docs (auto-updated)
  ├── validators/
  │   ├── intent-validator.sh  # Checks promises and invariants
  │   ├── ux-validator.sh      # Checks journeys have tests
  │   ├── arch-validator.sh    # Checks boundaries and patterns
  │   └── test-validator.sh    # Checks test coverage
  └── reports/
      └── latest.md            # Last validation report

  .git/hooks/
  ├── pre-commit               # Quick checks before commit
  └── pre-push                 # Full validation before push

  .github/workflows/
  └── validate.yml             # GitHub Actions workflow


HOW TO USE IT
─────────────

  After L1 planning, just ask:

    "Set up CI/CD validation"

  Claude will:
  1. Read your intent, UX, and architecture docs
  2. Generate validation rules
  3. Create validators and git hooks
  4. Set up GitHub Actions workflow
  5. Test the setup

  Then every commit/PR will automatically check:
  • Are all promises from intent being kept?
  • Do all user journeys have tests?
  • Are architectural boundaries intact?
  • Is test coverage adequate?


VALIDATION REPORT
─────────────────

  Every run creates a report like this:

  ════════════════════════════════════════
  🔍 VALIDATION REPORT
  ════════════════════════════════════════

  ✅ Intent Validation: PASS (8/8 promises honored)
  ✅ UX Validation: PASS (3/3 journeys have tests)
  ✅ Architecture Validation: PASS (7/7 boundaries intact)

  ════════════════════════════════════════
  VERDICT: ALL CLEAR ✅
  ════════════════════════════════════════


BLOCKING MERGES
───────────────

  If CRITICAL promises are broken, CI/CD blocks the merge:

  ❌ CRITICAL VIOLATION DETECTED

  Promise: "User data never leaves device"
  Source: /docs/intent/product-intent.md:12

  Violation:
    File: frontend/src/api/sync.ts:45
    Code: fetch('https://api.example.com/sync', { body: userData })

  This breaks a CRITICAL promise. Deployment blocked.


AUTO-UPDATE
───────────

  When you update /docs/intent/, /docs/ux/, or /docs/architecture/,
  CI/CD automatically regenerates validation rules to stay in sync.


EXAMPLE
───────

  User: Set up CI/CD to protect our intent

  Claude: Reading your documentation...

          Extracted promises:
          - Privacy: User data never leaves device (CRITICAL)
          - Performance: All operations < 200ms (HIGH)
          - No ads ever (CRITICAL)

          Extracted journeys:
          - User Login (4 steps)
          - Create Todo (3 steps)

          Creating validation infrastructure...
          ✅ /ci/rules.json (15 rules generated)
          ✅ /ci/validators/*
          ✅ Git hooks
          ✅ GitHub Actions workflow

          Testing...
          ✅ All checks pass

          CI/CD is now protecting your project intent.
          Every commit will be validated automatically.


OPT-IN, NOT MANDATORY
─────────────────────

  CI/CD validation is OPTIONAL. Claude may offer to set it up
  after L1 planning, but you can:

  • Say "yes" - Set it up now
  • Say "no" - Skip it
  • Say "later" - Ask for it anytime

  It's valuable for production projects but not required for
  prototypes or learning.


MORE INFO
─────────

  The ci-cd-engineer agent handles all setup automatically.
  You just ask for it - Claude does the rest.
```

### If topic = "enforce" or "enforcement" or "hooks" or "protect docs":

```
╔══════════════════════════════════════════════════════════════════╗
║                      DOCUMENTATION ENFORCEMENT                   ║
║                  (Keep Docs In Sync Automatically)               ║
╚══════════════════════════════════════════════════════════════════╝

Automatic enforcement keeps your documentation in sync with code.
OPTIONAL - enable after L1 planning for production projects.


WHAT IT DOES
────────────

  Git pre-commit hook:
    • Runs before every commit
    • Checks docs are in sync
    • Blocks commit if issues found

  CI workflow:
    • Runs on every PR
    • Verifies promises, state, tests
    • Fails PR if out of sync


WHAT'S CHECKED
──────────────

  ✓ CLAUDE.md has current state
  ✓ No BROKEN promises without reason
  ✓ Tests exist for features
  ✓ Code changes → docs updated


COMMANDS
────────

  /enforce setup     Set up enforcement
  /enforce status    Check if active
  /enforce verify    Run verification manually
  /enforce disable   Remove enforcement


SETUP
─────

  After L1 planning, run:

    /enforce setup

  This creates:
    • /scripts/verify-project.sh
    • /scripts/hooks/pre-commit
    • /.github/workflows/verify.yml


WHAT HAPPENS
────────────

  On commit:
    1. Hook runs verification
    2. If issues → COMMIT BLOCKED
    3. Fix issues, commit again

  On PR:
    1. CI runs verification
    2. If issues → PR FAILS
    3. Must fix before merge


WHEN TO ENABLE
──────────────

  ✅ After L1 planning completes (Claude will suggest)
  ✅ Before adding team members
  ✅ Before production deployment
  ✅ When documentation accuracy is critical

  ❌ Small prototypes
  ❌ Learning projects
  ❌ Solo throwaway code


EMERGENCY BYPASS
────────────────

  git commit --no-verify

  Use sparingly! CI will still check on PR.


DIFFERENCE FROM CI/CD
─────────────────────

  /enforce    → Ensures DOCS stay in sync
              → Blocks stale documentation
              → Checks promise statuses

  CI/CD       → Ensures CODE honors promises
              → Validates implementation
              → Runs custom validators


EXAMPLE
───────

  User: /enforce setup

  Claude: Setting up enforcement...

          ✓ Created verification script
          ✓ Installed git hook
          ✓ Created CI workflow

          Enforcement active! Every commit will be verified.

  [Later, user tries to commit code without updating docs]

  $ git commit -m "Add search feature"

  ═══════════════════════════════════════════════════════
                   PRE-COMMIT VERIFICATION
  ═══════════════════════════════════════════════════════

  [1/5] Checking Intent Compliance...
    ✓ 5/6 promises kept

  [2/5] Checking UX Journeys...
    ✓ 4 journeys implemented

  [3/5] Checking CLAUDE.md State...
    ⚠ Feature "search" shows "In Progress" but looks complete

  [+] Checking staged changes...
    ⚠ Code changed but documentation not updated

  ═══════════════════════════════════════════════════════
                         VERDICT
  ═══════════════════════════════════════════════════════

  ⚠ COMMIT ALLOWED WITH 2 WARNINGS

     Consider updating CLAUDE.md feature status.


OPT-IN, NOT MANDATORY
─────────────────────

  Enforcement is OPTIONAL. Claude may suggest it after L1
  planning, but you can:

  • Say "yes" - Set it up now
  • Say "no" - Skip it
  • Say "later" - Enable anytime with /enforce setup


MORE INFO
─────────

  The project-enforcer agent handles all setup automatically.
  You just ask for it - Claude does the rest.
```

### If topic = "sync" or "maintenance" or "state":

```
╔══════════════════════════════════════════════════════════════════╗
║                    PROJECT MAINTENANCE                           ║
║              (Keep Docs & State In Sync)                         ║
╚══════════════════════════════════════════════════════════════════╝

Keep your project documentation and state in sync automatically.


WHAT IS PROJECT SYNC?
─────────────────────

  As you build, your project evolves:
  • Features get completed
  • Tests get written
  • Decisions get made
  • Context accumulates

  The project-maintainer agent keeps everything in sync so:
  • Your next session knows where to continue
  • Documentation reflects reality
  • Tests are tracked
  • Nothing gets lost


WHAT GETS MAINTAINED?
──────────────────────

  1. CLAUDE.md "Current State" Section
     • Feature progress table
     • Current task and next steps
     • Important context from this session
     • Test coverage summary
     • Open questions

  2. Documentation (/docs/*)
     • Intent: Promise statuses ([KEPT], [AT RISK], [BROKEN])
     • UX: Journey statuses ([IMPLEMENTED], [PARTIAL])
     • Plans: Feature completion statuses

  3. Test Coverage Verification
     • Every completed feature has tests
     • Every journey has E2E tests
     • Identify gaps


WHEN DOES IT RUN?
─────────────────

  AUTOMATICALLY:
  • After feature completion (test-engineer triggers it)
  • After L1 planning (implementation-planner triggers it)
  • Periodically during long sessions (every 3-4 features)

  MANUALLY:
  • /sync              - Full sync
  • /sync quick        - Quick CLAUDE.md update only
  • /sync report       - Show status without changes
  • "Save state"       - Before ending session
  • "Update the docs"  - Full sync


THE SYNC COMMAND
────────────────

  /sync                # Full sync (default)
  /sync quick          # Quick CLAUDE.md update
  /sync report         # Status check, no changes

  Full Sync Does:
  1. Update CLAUDE.md Current State section
  2. Sync all /docs/* with code reality
  3. Verify test coverage
  4. Generate comprehensive report

  Quick Sync Does:
  1. Update CLAUDE.md Current State
  2. Log recent changes
  3. Brief status report

  Report Mode Does:
  1. Compare code vs docs
  2. Identify what's out of sync
  3. Show what would be updated (no changes)


SESSION CONTINUITY
──────────────────

  Before ending a session:

    You: "Save state before I go"

    Claude: [Runs full sync]
            ✓ CLAUDE.md updated with:
              - Current task: search frontend (SearchBar)
              - Important context: Using debounced search
              - Next steps: SearchBar → ResultsList → FilterPanel

            Session state saved ✓

  Next session:

    You: "Continue"

    Claude: Continuing from where we left off...
            From last session:
            - Current task: SearchBar component
            - Using debounced search
            [Continues seamlessly]


WHAT YOU SEE
────────────

  Full Sync Output:

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


TIPS
────

  • Before ending session - Always run /sync or say "save state"
  • After each feature - Automatic, but verify with /sync report
  • Check status - Use /sync report to see current state
  • Quick updates - Use /sync quick for fast checkpoints


WHY IT MATTERS
──────────────

  Without sync:
  • "Where were we?" - Can't remember
  • Docs go stale - Don't reflect reality
  • Context is lost - Decisions forgotten
  • Session handoff is rough

  With sync:
  • "Continue" - Instant resumption
  • Docs always accurate - Source of truth
  • Context preserved - Decisions recorded
  • Seamless sessions - No cognitive overhead


MORE INFO
─────────

  The project-maintainer agent handles all syncing automatically.
  See: /sync command documentation
```

### If topic = "docs":

```
╔══════════════════════════════════════════════════════════════════╗
║                  DOCUMENTATION MANAGEMENT                        ║
╚══════════════════════════════════════════════════════════════════╝

Keep comprehensive, up-to-date documentation automatically.


WHAT IT CREATES
───────────────

  After L1 Planning (Auto):
  • USAGE.md - Complete end-user guide
  • README.md - Project overview and quick start
  • /docs/api/README.md - API documentation
  • /docs/architecture/README.md - Comprehensive architecture
  • /docs/guides/developer-guide.md - Development setup
  • /docs/guides/deployment-guide.md - Deployment instructions


DOCUMENTATION WORKFLOW
──────────────────────

  Phase 1: After L1 Planning (Automatic)

    After intent-guardian, ux-architect, agentic-architect complete:
    → documentation-engineer automatically launches
    → Creates initial documentation structure
    → Populates with info from intent/UX/architecture
    → Creates skeleton for planned features

  Phase 2: During L2 Building (Manual Updates)

    As features are built:
    → Run "/docs update" to add feature documentation
    → Documentation stays in sync with implementation

  Phase 3: Before Release (Verification)

    Before shipping:
    → Run "/docs verify" to check completeness
    → All features documented?
    → All endpoints in API docs?
    → Examples working?


COMMANDS
────────

  /docs                      Check documentation completeness
  /docs verify               Same as above (explicit)
  /docs update               Update docs from current code
  /docs generate             Generate all documentation
  /docs status               Quick documentation status


TYPICAL USAGE
─────────────

  # After planning phase:
  You: "I'm ready to start building"

  Claude: Planning complete. Creating documentation structure...
          [documentation-engineer creates initial docs]

          ✓ README.md created
          ✓ USAGE.md skeleton created
          ✓ API docs structure created
          ✓ Developer & deployment guides created


  # After building search feature:
  You: "/docs update"

  Claude: Documentation updated ✓

          USAGE.md
            + Added "Search" feature documentation
            + Added 3 usage examples

          docs/api/README.md
            + Added GET /api/search endpoint
            + Added request/response examples


  # Before release:
  You: "/docs verify"

  Claude: Documentation Verification

          USAGE.md: 95% complete
            ⚠ Missing: 1 FAQ entry

          API Docs: 100% complete
            ✓ All endpoints documented

          Guides: 90% complete
            ⚠ Deployment guide: Missing monitoring setup

          Run "/docs update" to complete missing sections


WHAT GETS DOCUMENTED
────────────────────

  USAGE.md:
  • Overview and key features
  • Installation and quick start
  • Every feature with examples
  • User journeys step-by-step
  • Configuration options
  • Troubleshooting and FAQ

  README.md:
  • Project overview (1-2 paragraphs)
  • Quick start (5 minutes)
  • Tech stack
  • Links to full documentation

  /docs/api/README.md:
  • All API endpoints
  • Request/response schemas
  • Error codes
  • Authentication
  • Examples for each endpoint

  /docs/architecture/README.md:
  • System architecture with diagrams
  • Component catalog
  • Data architecture (ERD)
  • API design
  • Security architecture
  • Design decisions (ADRs)

  /docs/guides/:
  • Developer setup and workflow
  • Testing strategy
  • Deployment options
  • Environment configuration


INTEGRATION WITH /sync
──────────────────────

  The project-maintainer agent checks documentation completeness:

  When you run "/sync":
  → Verifies docs exist for implemented features
  → Reports documentation gaps
  → Suggests running "/docs verify" if needed

  Example sync output:

    USER DOCUMENTATION COMPLETENESS
    ────────────────────────────────
      ✓ USAGE.md - 80% complete
      ⚠ docs/api/README.md - Missing 2 endpoints
      ✓ docs/guides/ - Complete

      💡 Suggestion: Run /docs verify for detailed report


WHY IT MATTERS
──────────────

  Without comprehensive docs:
  • Users don't know how to use your app
  • New developers struggle to contribute
  • Deployment process is unclear
  • API is hard to integrate

  With comprehensive docs:
  • Users onboard quickly
  • Developers contribute easily
  • Deployment is straightforward
  • API integration is smooth


TIPS
────

  • Let docs auto-generate after L1 - Saves time
  • Update docs after each feature - Stays current
  • Verify before release - Ensures completeness
  • Test all examples - Make sure they work


MORE INFO
─────────

  The documentation-engineer agent handles all documentation.
  Templates are based on best practices for user-facing docs.
  All documentation is comprehensive and example-driven.
```

### If topic not recognized:

```
I don't have specific help for "<topic>".

Available topics:
  /agent-wf-help              - Quick overview
  /agent-wf-help workflow     - How the two-level workflow works
  /agent-wf-help agents       - All 14 specialized agents
  /agent-wf-help commands     - Available commands
  /agent-wf-help patterns     - Development patterns & examples
  /agent-wf-help parallel     - Parallel development guide
  /agent-wf-help brownfield   - Improving existing code
  /agent-wf-help cicd         - CI/CD validation setup
  /agent-wf-help sync         - Project state & maintenance
  /agent-wf-help docs         - Documentation management
  /agent-wf-help design       - Design system & visual styling
  /agent-wf-help examples     - Practical examples

Or just ask me what you want to know!
```

### If topic = "design":

```
╔══════════════════════════════════════════════════════════════════╗
║               DESIGN SYSTEM & VISUAL CONSISTENCY                 ║
╚══════════════════════════════════════════════════════════════════╝

Ensure visual consistency across your entire UI with design systems.


WHAT IS A DESIGN SYSTEM?
────────────────────────

  A complete visual specification that defines:
  • Colors (primary, secondary, neutral, semantic)
  • Typography (fonts, sizes, weights)
  • Spacing & layout (margins, padding, grid)
  • Components (buttons, inputs, cards, modals)
  • Motion & animation (transitions, timing)
  • Accessibility (contrast, focus states, ARIA)
  • Implementation (Tailwind config, CSS variables)

  It's the single source of truth for ALL visual design decisions.
  Frontend engineer MUST follow it - no arbitrary colors or styling.


THE DESIGN WORKFLOW
───────────────────

  Step 1: Define Design System (during UX phase)

    UX architect asks about design preferences:
    • "Do you have existing brand guidelines?"
    • "What style do you prefer?" (shows presets)
    • "Any reference sites you like?"

    Creates: /docs/ux/design-system.md

  Step 2: Bootstrap Component Library (before building)

    Frontend engineer:
    • Reads design system
    • Sets up Tailwind config OR CSS variables
    • Creates base components (Button, Input, Card, etc.)
    • All components use design system values ONLY

  Step 3: Build Features (following design system)

    Every component/page:
    • Uses colors from design system
    • Uses typography from design system
    • Uses spacing from design system
    • Never arbitrary styling decisions


USING THE /design COMMAND
──────────────────────────

  View current design system:
    /design show

  Apply a preset (quick start):
    /design preset modern-clean     - Professional SaaS style
    /design preset minimal          - Ultra-clean, content-focused
    /design preset playful          - Vibrant, fun, energetic
    /design preset corporate        - Enterprise, formal
    /design preset glassmorphism    - Modern glass effects

  Match a reference site:
    /design reference https://linear.app
    /design reference https://notion.so

  Update design system:
    /design update


AVAILABLE PRESETS
─────────────────

  ┌────────────────┬─────────────────────────────────────────────┐
  │ modern-clean   │ Blue primary, clean, professional           │
  │                │ Best for: SaaS, business apps, dashboards   │
  ├────────────────┼─────────────────────────────────────────────┤
  │ minimal        │ Black/white, typography-focused             │
  │                │ Best for: Blogs, docs, reading apps         │
  ├────────────────┼─────────────────────────────────────────────┤
  │ playful        │ Purple/pink gradients, vibrant, animated    │
  │                │ Best for: Consumer apps, gaming, creative   │
  ├────────────────┼─────────────────────────────────────────────┤
  │ corporate      │ Dark blue, formal, enterprise-grade         │
  │                │ Best for: B2B, financial, legal tech        │
  ├────────────────┼─────────────────────────────────────────────┤
  │ glassmorphism  │ Frosted glass, transparency, depth          │
  │                │ Best for: Modern apps, portfolios, premium  │
  └────────────────┴─────────────────────────────────────────────┘


DESIGN SYSTEM STRUCTURE
────────────────────────

  /docs/ux/design-system.md contains:

  1. Color Palette
     - Primary (default, light, dark variants)
     - Secondary & accent colors
     - Neutral scale (grays)
     - Semantic (success, warning, error, info)
     - Dark mode support

  2. Typography
     - Font families (heading, body, monospace)
     - Font sizes (xs through 5xl)
     - Font weights (regular through bold)
     - Line heights & text styles

  3. Spacing & Layout
     - Spacing scale (0-16 in rem)
     - Max widths, grid system
     - Border radius scale
     - Shadow definitions

  4. Components
     - Buttons (primary, secondary, variants)
     - Inputs, forms, validation states
     - Cards, modals, navigation
     - Badges, alerts, tables
     - All with complete CSS/Tailwind specs

  5. Motion & Animation
     - Transition durations
     - Easing functions
     - Hover/focus/active states
     - Keyframe animations

  6. Accessibility
     - WCAG color contrast ratios
     - Focus state specifications
     - ARIA patterns
     - Keyboard navigation

  7. Implementation
     - Tailwind configuration code
     - CSS variables definitions
     - Component library bootstrap guide


FRONTEND ENGINEER RULES
────────────────────────

  ✓ ALWAYS read /docs/ux/design-system.md FIRST
  ✓ Use ONLY colors from design system
  ✓ Use ONLY fonts from design system
  ✓ Use ONLY spacing from design system
  ✓ Follow component specs exactly

  ✗ NEVER use arbitrary hex codes (#3b82f6)
  ✗ NEVER use custom fonts not specified
  ✗ NEVER use arbitrary spacing (padding: 17px)
  ✗ NEVER create component styles without design system spec

  If using Tailwind:
  → Configure from design system Tailwind config section
  → Use only configured values, never arbitrary

  If using vanilla CSS:
  → Copy CSS variables from design system
  → Reference variables in all components


EXAMPLE: APPLYING A PRESET
───────────────────────────

  Starting a new SaaS app:

    You: "Build me a project management app"

    Claude (via ux-architect):
      "What design style do you prefer?
       1. modern-clean (professional SaaS)
       2. minimal (content-focused)
       3. playful (vibrant, fun)
       4. corporate (enterprise)
       5. glassmorphism (modern, premium)
       6. Reference another site
       7. Custom specifications"

    You: "1"

    Claude:
      ✓ Applied modern-clean preset
      ✓ Created /docs/ux/design-system.md
        Primary: #2563eb (Blue)
        Typography: Inter font
        Style: Clean, professional, trustworthy

    Later, frontend-engineer:
      1. Reads /docs/ux/design-system.md
      2. Sets up Tailwind config with design system colors
      3. Creates Button component using design system specs
      4. All UI automatically consistent


EXAMPLE: UPDATING DESIGN
─────────────────────────

  Changing brand color:

    You: "/design update"

    Claude: "What would you like to update?"
            1. Colors
            2. Typography
            ...

    You: "1"

    Claude: "Current primary: #2563eb
             New primary color:"

    You: "#7c3aed"

    Claude: ✓ Updated primary to #7c3aed (purple)
            ✓ Updated primary-light to #a78bfa
            ✓ Updated primary-dark to #5b21b6
            ✓ Updated Tailwind config
            ✓ Updated CSS variables

            ⚠ This affects existing components.
              Rebuild component library to apply changes.


WHY DESIGN SYSTEMS MATTER
──────────────────────────

  Without design system:
  ✗ Frontend engineer makes arbitrary color choices
  ✗ Buttons look different across pages
  ✗ Inconsistent spacing everywhere
  ✗ Hard to change colors/fonts later
  ✗ Accessibility not guaranteed

  With design system:
  ✓ All visual decisions documented upfront
  ✓ Frontend follows spec strictly
  ✓ Consistent UI across entire app
  ✓ Easy to update (change once, applies everywhere)
  ✓ Accessibility built-in (WCAG compliance)


FILES CREATED
─────────────

  /docs/ux/design-system.md        - Complete visual specification
  tailwind.config.js               - Tailwind configuration
  styles/variables.css             - CSS variables (if not using Tailwind)


COMMON WORKFLOWS
────────────────

  Quick start with preset:
    /design preset modern-clean

  Match competitor's style:
    /design reference https://linear.app

  Custom brand colors:
    /design update
    → Colors → Primary → #your-hex

  View current design:
    /design show


RELATED COMMANDS
────────────────

  /ux                - Creates user journeys AND design system
  /implement         - Frontend uses design system for implementation
  /review            - Code review can check design system compliance


MORE INFORMATION
────────────────

  See: /design command documentation
  Location: commands/design.md
  Templates: templates/docs/ux/presets/
```

### If topic = "llm":

```
╔══════════════════════════════════════════════════════════════════╗
║                  LLM INTEGRATION & AI COMPONENTS                 ║
╚══════════════════════════════════════════════════════════════════╝

WHAT IS LLM INTEGRATION?
─────────────────────────

  Every AI component supports DUAL providers:
  • Ollama (local, free) - For development
  • Commercial APIs (OpenAI/Anthropic) - For production reliability
  • Automatic fallback chain - Seamless provider switching
  • Graceful degradation - Rule-based fallback if all LLMs fail


WHY DUAL PROVIDERS?
───────────────────

  ✓ Free development (Ollama = $0 cost)
  ✓ Reliable production (commercial APIs = proven uptime)
  ✓ Privacy-friendly (local models keep data on-premise)
  ✓ Vendor independence (easy to swap providers)
  ✓ Never crashes (always has fallback)


USING THE /llm COMMAND
──────────────────────

  /llm                      # Show provider status
  /llm setup                # Set up providers interactively
  /llm test                 # Test all providers
  /llm providers            # List available providers
  /llm config               # Show configuration


TYPICAL WORKFLOW
────────────────

  1. Start development with Ollama (free, local):
     ollama serve
     /llm test

  2. Add production fallback:
     /llm setup
     → Add OpenAI API key

  3. Build AI features:
     Claude automatically uses dual provider pattern

  4. Deploy:
     ✓ Dev uses Ollama (free)
     ✓ Prod uses OpenAI (reliable)
     ✓ Failures fall back gracefully


IMPLEMENTATION PATTERN
──────────────────────

  All AI features follow this structure:

  import { LLMClient } from '@/lib/llm/client';
  import { z } from 'zod';

  const llm = new LLMClient();  // Auto-configured

  const Schema = z.object({
    tags: z.array(z.string()).min(2).max(5),
  });

  try {
    const result = await llm.completeJSON(prompt, Schema);
    return result.tags;
  } catch (error) {
    // Graceful fallback - NEVER crash
    return extractKeywords(content);
  }


KEY PRINCIPLES
──────────────

  1. ALWAYS use LLMClient (not direct provider)
  2. ALWAYS define Zod schema for structured output
  3. ALWAYS implement graceful fallback
  4. NEVER crash on LLM failure
  5. NEVER hardcode provider choice


FALLBACK CHAIN
──────────────

  1. Try Ollama (local, free)
     ↓ (if unavailable)
  2. Try OpenAI (if API key set)
     ↓ (if unavailable)
  3. Try Anthropic (if API key set)
     ↓ (if all fail)
  4. Use rule-based fallback


COST OPTIMIZATION
─────────────────

  Development: Ollama (free) - 100% of iterations
  CI/CD: Ollama (free) - Fast, no API costs
  Production: OpenAI - Reliable, ~$0.15/1M tokens
  Background jobs: Ollama - When latency not critical


ROBUST JSON PARSING
────────────────────

  Local models often return malformed JSON:
  • Markdown wrapping: ```json\n{...}\n```
  • Trailing commas: {"key": "value",}
  • Single quotes: {'key': 'value'}

  The LLM client handles this automatically with 5 strategies:
  1. Direct parse
  2. Extract from markdown
  3. Extract between braces
  4. Repair syntax errors
  5. Retry with feedback


FILES CREATED
─────────────

  Backend:
    /src/lib/llm/client.ts          - Unified LLM client
    /src/lib/llm/providers/         - Ollama, OpenAI, Anthropic
    /src/lib/llm/json-parser.ts     - Robust JSON parsing
    /src/lib/llm/config.ts          - Configuration loading

  Documentation:
    /docs/architecture/llm-integration.md  - Complete guide


ENVIRONMENT VARIABLES
─────────────────────

  Ollama (local, free):
    OLLAMA_BASE_URL=http://localhost:11434
    OLLAMA_MODEL=llama3.2

  OpenAI (commercial fallback):
    OPENAI_API_KEY=sk-proj-...
    OPENAI_MODEL=gpt-4o-mini

  Anthropic (optional fallback):
    ANTHROPIC_API_KEY=sk-ant-...
    ANTHROPIC_MODEL=claude-3-5-sonnet-20241022


COMMON SCENARIOS
────────────────

  First-time setup:
    /llm
    → Ollama available ✓
    → Ready for development!

  Add production reliability:
    /llm setup
    → Add OpenAI fallback
    → Fallback chain configured ✓

  Check if production-ready:
    /llm
    → ✓ Ollama (dev)
    → ✓ OpenAI (prod fallback)
    → Production ready ✓


RELATED COMMANDS
────────────────

  /llm               - Manage LLM providers
  /plan              - Creates backend plans with LLM patterns
  /implement         - backend-engineer uses dual provider pattern


MORE INFORMATION
────────────────

  See: BACKEND.md - Complete LLM integration guide
  Location: templates/src/lib/llm/ - Code templates
  Command: commands/llm.md - /llm command documentation
```

### If: "mcp" or "model context protocol" or "servers"

```
╔══════════════════════════════════════════════════════════════════╗
║                      MCP SERVERS                                 ║
╚══════════════════════════════════════════════════════════════════╝

MCP (Model Context Protocol) servers extend Claude's capabilities.


WHAT THEY DO
────────────

  Claude + MCP Servers can:

  • Query databases directly (postgres, sqlite)
  • Manage GitHub PRs and issues (github)
  • Automate browsers for testing (puppeteer)
  • Post to Slack/Linear (slack, linear)
  • Remember context across sessions (memory)
  • Access external APIs (fetch)
  • Manage infrastructure (docker, kubernetes)


POPULAR SERVERS
───────────────

  DATABASE ACCESS
    postgres     PostgreSQL queries and management
    sqlite       SQLite queries and management
    redis        Redis cache operations

  DEVELOPMENT WORKFLOW
    github       Create PRs, manage issues, code review
    puppeteer    Browser automation and E2E testing
    fetch        HTTP requests and API testing

  TEAM COLLABORATION
    slack        Post messages and notifications
    linear       Issue tracking and project management
    notion       Documentation access

  INFRASTRUCTURE
    docker       Container management
    kubernetes   Cluster management


COMMANDS
────────

  /mcp                          Show recommendations
  /mcp recommend                Analyze project and recommend servers
  /mcp setup <servers...>       Generate configuration
  /mcp status                   Check server availability
  /mcp guide                    Show usage guide


EXAMPLE WORKFLOW
────────────────

  WITH POSTGRES:
    You: "Query the users table"
    → Claude queries database directly
    → No need to write temporary scripts

  WITH GITHUB:
    You: "Create a PR for the auth feature"
    → Claude creates branch, commits, creates PR
    → All without leaving Claude

  WITH PUPPETEER:
    You: "Test the login flow"
    → Claude navigates browser, fills forms, verifies
    → Interactive debugging of E2E tests


SETUP
─────

  1. Get recommendations for your project:
     → /mcp recommend

  2. Generate configuration:
     → /mcp setup postgres github puppeteer

  3. Add to Claude config file:
     → macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
     → Windows: %APPDATA%\Claude\claude_desktop_config.json

  4. Restart Claude Code

  5. Verify connection:
     → /mcp status


WHEN TO USE MCP SERVERS
───────────────────────

  Planning Phase (after /analyze):
    → implementation-planner suggests appropriate servers
    → Based on project tech stack and requirements

  Implementation Phase:
    → Use postgres MCP to test queries before coding
    → Use puppeteer MCP to verify UI before writing tests

  Testing Phase:
    → test-engineer uses MCP for interactive debugging
    → Direct database verification
    → Real browser testing


PROJECT-SPECIFIC RECOMMENDATIONS
─────────────────────────────────

  Full-stack web app:
    → postgres (database debugging)
    → github (PR workflow)
    → puppeteer (E2E testing)
    → memory (context retention)

  API-only backend:
    → postgres/sqlite (database access)
    → fetch (API testing)
    → github (PR workflow)

  Team project:
    → github (code collaboration)
    → slack (notifications)
    → linear (issue tracking)
    → notion (documentation)


DOCS
────

  Complete guide: /docs/architecture/mcp-integration.md
  Command docs: commands/mcp.md
  Official MCP: https://modelcontextprotocol.io
```
