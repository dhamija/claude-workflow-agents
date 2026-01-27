---
name: help
description: Show help about the workflow system - agents, commands, patterns, and usage
argument-hint: "[topic]"
---

# Help System

Get help on any aspect of the Claude Workflow Agents system.

---

## Usage

```
/help                    # Quick overview
/help workflow           # Two-level workflow
/help agents             # All specialized agents
/help commands           # Available commands
/help patterns           # Development patterns
/help [topic]            # Specific topic
```

---

## Available Topics

| Topic | Description |
|-------|-------------|
| `workflow` | Two-level workflow (app → features) |
| `agents` | All specialized agents |
| `commands` | Available commands |
| `patterns` | Development patterns & examples |
| `git` | Git workflow & conventions |
| `parallel` | Parallel development (teams) |
| `brownfield` | Improving existing code |
| `examples` | Practical examples |

---

## Implementation

Read `$ARGUMENTS` (topic) and display appropriate help:

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
│   2. Design user experience (journeys & design system)          │
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
│   /help workflow     - How the two-level workflow works         │
│   /help agents       - All specialized agents                   │
│   /help commands     - Available commands                       │
│   /help patterns     - Development patterns & examples          │
│   /help git          - Git workflow & conventions               │
│   /help parallel     - Parallel development guide               │
│   /help brownfield   - Improving existing code                  │
│   /help examples     - Practical examples                       │
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
  /docs/ux/design-system.md           - Visual specifications
  /docs/architecture/agent-design.md  - System design
  /docs/plans/overview/               - Full system specs
  /docs/plans/features/               - Per-feature plans
  /docs/plans/implementation-order.md - Build sequence
```

### If topic = "agents":

```
╔══════════════════════════════════════════════════════════════════╗
║            SKILLS + SUBAGENTS ARCHITECTURE (v2.1)                ║
╚══════════════════════════════════════════════════════════════════╝

Claude automatically loads skills and invokes subagents as needed.
You don't call them directly - just describe what you want.


ARCHITECTURE OVERVIEW
─────────────────────

  Skills: Domain expertise (loaded on-demand by Claude)
          Location: ~/.claude/skills/
          Count: 9 skills

  Subagents: Isolated execution environments (separate context)
             Location: ~/.claude/agents/
             Count: 3 subagents


SKILLS (On-Demand Domain Expertise)
────────────────────────────────────

  ┌─────────────────────────────────────────────────────────────┐
  │ WORKFLOW (Orchestration)                                    │
  │ Purpose: L1/L2 phase management, auto-chaining              │
  │ Loads: When managing project phases                         │
  │ Contains: L1 flow, L2 flow, quality gates, issue protocols  │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ UX-DESIGN (Design Principles)                               │
  │ Purpose: UX laws and design principles                      │
  │ Loads: When designing interfaces or reviewing UX            │
  │ Includes: Fitts, Hick, Miller's Laws, accessibility         │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ FRONTEND (UI Development)                                   │
  │ Purpose: Frontend patterns with auto-applied design         │
  │ Loads: When implementing UI                                 │
  │ Includes: Components, state, TypeScript, accessibility      │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ BACKEND (API Development)                                   │
  │ Purpose: Backend patterns and best practices                │
  │ Loads: When implementing APIs/services                      │
  │ Includes: REST, databases, validation, auth, error handling │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ TESTING (Test Strategies)                                   │
  │ Purpose: Test pyramid and coverage strategies               │
  │ Loads: When writing tests                                   │
  │ Includes: Unit/integration/E2E patterns, mocking, factories │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ VALIDATION (Promise Validation)                             │
  │ Purpose: Validate promises are kept (beyond tests passing)  │
  │ Loads: After tests pass, before feature complete            │
  │ Example: Tests pass ≠ user can actually do what we promised │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ DEBUGGING (Debug Protocols)                                 │
  │ Purpose: Systematic debugging approach                      │
  │ Loads: When issues reported                                 │
  │ Process: Reproduce → Isolate → Fix → Test → Verify          │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ CODE-QUALITY (Review Criteria)                              │
  │ Purpose: Code review standards                              │
  │ Loads: After code changes (via hook) or manual /review      │
  │ Checks: Security, performance, correctness, maintainability │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ BROWNFIELD (Codebase Analysis)                              │
  │ Purpose: Understand existing code                           │
  │ Loads: First session in existing project                    │
  │ Process: Detect stack → Scan → Infer intent → Document      │
  └─────────────────────────────────────────────────────────────┘


SUBAGENTS (Isolated Context Execution)
───────────────────────────────────────

  ┌─────────────────────────────────────────────────────────────┐
  │ CODE-REVIEWER                                               │
  │ Type: Read-only isolated review                             │
  │ Triggers: After implementation, via hook, /review           │
  │ Checks: Security, bugs, performance, maintainability        │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ DEBUGGER                                                    │
  │ Type: Isolated debugging session                            │
  │ Triggers: "Broken", "error", "bug", "doesn't work"          │
  │ Does: Root cause analysis, minimal fix, regression test     │
  └─────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────┐
  │ UI-DEBUGGER                                                 │
  │ Type: Browser automation session                            │
  │ Triggers: UI issues, visual bugs (requires puppeteer MCP)   │
  │ Does: Screenshots, console logs, interaction debugging      │
  └─────────────────────────────────────────────────────────────┘


AGENT INVOCATION (Via Workflow Skill)
──────────────────────────────────────

The workflow skill invokes specialized agents via Task tool:

  L1 Planning Agents (invoked by workflow):
  - intent-guardian      → Captures promises
  - ux-architect         → Designs UX
  - agentic-architect    → Designs architecture
  - implementation-planner → Creates plans

  L2 Building Agents (invoked by workflow):
  - backend-engineer     → Implements backend
  - frontend-engineer    → Implements frontend
  - test-engineer        → Writes tests
  - acceptance-validator → Validates promises

  Support Agents (invoked by workflow):
  - change-analyzer      → Assesses change impact
  - gap-analyzer         → Finds code quality gaps
  - brownfield-analyzer  → Scans existing code
  - project-ops          → Project operations


WHY SKILLS + SUBAGENTS?
────────────────────────

  Context Efficiency:
  - v2.0: 750+ lines loaded every session
  - v2.1: ~80 lines + skills loaded only when needed
  - 90% reduction in upfront context

  Performance:
  - Less context = better model performance
  - Skills cache between sessions
  - On-demand loading = faster responses

  Modularity:
  - Skills updated independently
  - Easy to add new expertise
  - Users can create custom skills
```

### If topic = "commands":

```
╔══════════════════════════════════════════════════════════════════╗
║                      AVAILABLE COMMANDS                          ║
╚══════════════════════════════════════════════════════════════════╝

Most of the time, just talk naturally. Commands are optional.


HELP
────
  /help [topic]              This help system


PROJECT OPERATIONS
──────────────────
  /project setup             Initialize project infrastructure
  /project sync              Update docs and state
  /project sync quick        Quick state update
  /project verify            Check compliance
  /project docs <action>     Manage documentation
  /project ai <action>       LLM integration
  /project mcp <action>      MCP servers
  /project status            Show project health
  /project commit [msg]      Create conventional commit
  /project push              Push current branch
  /project pr                Create pull request (needs GitHub MCP)


ANALYSIS & PLANNING
───────────────────
  /analyze                   Run all analysis agents
  /plan                      Generate implementation plans
  /replan                    Regenerate plans after changes
  /audit                     Audit existing codebase
  /intent-audit [focus]      Audit implementation vs intent
  /ux-audit [focus]          Audit user experience
  /aa [focus]                Agentic architecture analysis
  /aa-audit [focus]          Audit agentic optimizations
  /gap [focus]               Find gaps and create migration plan
  /change <description>      Analyze change impact


DEVELOPMENT
───────────
  /implement                 Implement features
  /debug                     Launch debugger
  /review [target]           Code review (file, dir, or "staged")


PARALLEL (Advanced, Opt-In)
───────────────────────────
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

### If topic = "git":

```
╔══════════════════════════════════════════════════════════════════╗
║                    GIT WORKFLOW & CONVENTIONS                    ║
╚══════════════════════════════════════════════════════════════════╝

project-ops handles git workflow with conventional commits,
branch naming, and PR creation.


CONVENTIONAL COMMITS
────────────────────

Format: <type>: <description>

  Types:
  • feat       - New feature
  • fix        - Bug fix
  • refactor   - Code restructuring (no behavior change)
  • docs       - Documentation only
  • test       - Add/update tests
  • chore      - Maintenance (deps, config)

  Examples:
    feat: add user authentication
    fix: resolve login timeout issue
    refactor: extract validation logic
    docs: update API reference
    test: add unit tests for auth
    chore: upgrade to Node 20


BRANCH NAMING
─────────────

Format: <type>/<short-description>

  Examples:
    feature/user-authentication
    feature/password-reset
    fix/login-timeout
    fix/null-user-crash
    refactor/database-layer
    docs/api-reference

  Guidelines:
  • Use lowercase with hyphens
  • Keep description short (2-4 words)
  • Match commit type when possible


COMMANDS
────────

  /project commit [message]    Create conventional commit (guided)
  /project push                Push current branch to remote
  /project pr                  Create pull request (needs GitHub MCP)


WORKFLOW
────────

  Standard flow:

    1. Create feature branch:
       git checkout -b feature/my-feature

    2. Make changes, commit:
       /project commit

    3. Push to remote:
       /project push

    4. Create PR:
       /project pr


COMMIT HELPER
─────────────

  With message:

    You:    /project commit "add user auth"
    Claude: Type: feat, fix, refactor, docs, test, or chore?
    You:    feat
    Claude: ✓ Committed: feat: add user auth


  Guided (no message):

    You:    /project commit
    Claude: What type of change?
            1. feat - New feature
            2. fix - Bug fix
            3. refactor - Code restructuring
            4. docs - Documentation
            5. test - Tests
            6. chore - Maintenance

    You:    1
    Claude: Describe the change (short, imperative):
    You:    add user authentication
    Claude: ✓ Committed: feat: add user authentication


  Smart suggestion:

    You:    /project commit
    Claude: Staged files: README.md, docs/API.md
            Suggested type: docs

            Continue with "docs"? [y/n]


PULL REQUEST HELPER
───────────────────

  With GitHub MCP (recommended):

    You:    /project pr
    Claude: Analyzing branch...

            Generated PR:
            Title: Add user authentication

            Body:
            ## Changes
            - Implemented login/logout
            - Added JWT handling
            - Created auth middleware

            ## Testing
            - 15 new tests passing
            - Manual testing verified

            Create PR? [y/n]

    You:    y
    Claude: ✓ PR created: https://github.com/user/repo/pull/42


  Without GitHub MCP:

    You:    /project pr
    Claude: GitHub MCP not configured. Setup now? [y/n]
    You:    n
    Claude: Manual PR instructions:

            1. git push -u origin feature/my-feature
            2. Visit: https://github.com/user/repo/compare/...
            3. Or: gh pr create --title "..." --body "..."

            Push branch for you? [y/n]


GITHUB INTEGRATION
──────────────────

  For automatic PR creation, setup GitHub MCP:

    /project mcp setup

  Select "github" and provide your GitHub token.

  Benefits:
  • Auto-generate PR title/body from commits
  • Create PRs without leaving Claude
  • Check PR status
  • Streamlined workflow


PHILOSOPHY
──────────

  1. Conventional commits → Clear, searchable history
  2. Descriptive branches → Easy to track work
  3. Guided helpers → Reduce cognitive load
  4. MCP integration → Streamline PR creation
  5. Always optional → Use raw git if preferred


TIPS
────

  • Smart suggestions based on changed files
  • Git commands work alongside /project commands
  • Commit helper prevents malformed commits
  • PR helper generates comprehensive descriptions
  • Setup GitHub MCP for best experience
```

### If topic = "debug" or "ui" or "browser" or "screenshot":

```
╔══════════════════════════════════════════════════════════════════╗
║                      UI DEBUGGING                                ║
╚══════════════════════════════════════════════════════════════════╝

Debug frontend issues with browser automation.


COMMANDS
────────
  /debug ui [url]         Full debug session
  /debug console [url]    Console errors only
  /debug network [url]    Network monitoring
  /debug visual [url]     Visual regression
  /debug responsive [url] Responsive testing
  /debug <error msg>      Backend/test debugging (existing)


CAPABILITIES
────────────
  ✓ Take screenshots
  ✓ Inspect DOM elements
  ✓ Capture console errors
  ✓ Monitor network requests
  ✓ Test different viewports
  ✓ Compare visual changes
  ✓ Accessibility audit


REQUIRES
────────
  puppeteer MCP server

  Enable with:
    /project ai mcp

  Or add to Claude config:
    {
      "mcpServers": {
        "puppeteer": {
          "command": "npx",
          "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
        }
      }
    }


EXAMPLE
───────
  User: The login button doesn't work

  Claude: [Navigates to login page]
          [Takes screenshot]
          [Clicks button]
          [Captures console]

          Found: onClick handler throws error
          "Cannot read property 'email' of undefined"

          Fix: Add null check in handleSubmit


WORKFLOW
────────

  1. INVESTIGATE
     - Navigate to URL
     - Take screenshots
     - Inspect DOM
     - Check console

  2. DIAGNOSE
     - Identify root cause
     - Gather evidence
     - Explain why it fails

  3. FIX
     - Suggest solution
     - Apply fix (if approved)
     - Verify fix works

  4. PREVENT
     - Add regression test
     - Document the issue


RESPONSIVE TESTING
──────────────────

  Tests multiple viewports automatically:
    - Desktop: 1920x1080
    - Tablet:  768x1024
    - Mobile:  375x667

  Reports which viewports have issues.


VISUAL REGRESSION
─────────────────

  Compares current UI to baseline:
    - Captures screenshots
    - Detects visual differences
    - Highlights changed areas

  Useful after CSS/layout changes.


TIPS
────

  • Run your app locally first (localhost:3000)
  • Use /debug ui for comprehensive investigation
  • Use /debug console for just error logs
  • Use /debug responsive for layout issues
  • puppeteer MCP required for full functionality
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


PATTERN 8: SAVE STATE
─────────────────────

  You:    "Save state before I go"

  Claude: [Runs /project sync]
          ✓ CLAUDE.md updated with current task
          ✓ Documentation synced
          ✓ Test coverage recorded

          Session state saved ✓

          Next session, just say "continue" and I'll know
          exactly where we left off.
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


TIPS
────

  • Let Claude audit first before asking for fixes
  • Review [INFERRED] docs - Claude might misunderstand
  • Start with security (Phase 0)
  • Fix one thing at a time, verify, then continue
  • Use /project status to track remaining gaps
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


KEY TAKEAWAYS
─────────────

  Pattern 1: Just talk - no commands needed
  Pattern 2: Greenfield = Analyze → Plan → Build
  Pattern 3: Brownfield = Audit → Gap → Improve
  Pattern 4: Changes = Analyze Impact → Update
  Pattern 5: Verification at every step
  Pattern 6: Parallel for teams, sequential for solo
  Pattern 7: Save state between sessions


FULL DETAILS
────────────

  See EXAMPLES.md in project root for complete
  conversation transcripts and detailed explanations.
```

### If topic not recognized:

```
I don't have specific help for "<topic>".

Available topics:
  /help                - Quick overview
  /help workflow       - How the two-level workflow works
  /help agents         - All specialized agents
  /help commands       - Available commands
  /help patterns       - Development patterns & examples
  /help git            - Git workflow & conventions
  /help parallel       - Parallel development guide
  /help brownfield     - Improving existing code
  /help examples       - Practical examples

Or just ask me what you want to know!
```

---

## Migration Note

This command replaces `/agent-wf-help`. The old command will still work but shows a deprecation warning:

```
⚠ /agent-wf-help is deprecated. Use /help instead.
```
