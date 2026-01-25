# Claude Workflow Agents

A multi-agent system for Claude Code that helps you build software systematically. Works for both new projects and existing codebases.

**Just talk naturally.** Claude automatically uses the right agents.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage Levels](#usage-levels)
- [New Projects (Greenfield)](#new-projects-greenfield)
- [Existing Projects (Brownfield)](#existing-projects-brownfield)
- [Commands Reference](#commands-reference)
- [Going Deeper](#going-deeper)
- [FAQ](#faq)

---

## Quick Start

### 1. Install
```bash
git clone https://github.com/YOUR_USERNAME/claude-workflow-agents.git
cd claude-workflow-agents
./install.sh --user
```

### 2. Use
```bash
cd your-project
claude
```

Then just talk:
```
You: Build me a recipe app where I can save and search my favorite recipes

Claude: [Creates intent, designs UX, plans architecture, starts building]
```

That's it. Claude handles the rest.

---

## Installation

### Option A: Global Install (Recommended)

Makes agents available in ALL your projects:
```bash
./install.sh --user
```

### Option B: Project Install

For a specific project only (can commit to git for team sharing):
```bash
cd /path/to/your/project
/path/to/claude-workflow-agents/install.sh --project
```

### Option C: Both
```bash
./install.sh --user --project
```

### Verify Installation
```bash
ls ~/.claude/agents/  # Should show 13 .md files
```

---

## Usage Levels

This system supports multiple levels of usage. Start simple, go deeper when needed.

### Level 1: Just Talk (Simplest)

For most projects, just describe what you want:
```
"Build me a todo app"
"Add user authentication"
"The search is broken"
"Continue"
```

Claude figures out what to do. No commands needed.

**Best for:** Small projects, prototypes, learning

### Level 2: Use Commands

For more control, use optional commands:
```
/status              # See progress
/next                # Continue building
/review auth         # Review specific code
/agent-wf-help       # Get help
```

**Best for:** Medium projects, when you want visibility

### Level 3: Parallel Development

For large projects, build features simultaneously:
```
/parallel setup      # Create feature worktrees
/parallel merge      # Merge when done
```

**Best for:** Large projects, teams, time pressure

### Level 4: Direct Agent Control

For maximum control, invoke agents directly:
```
"Use intent-guardian to redefine our promises"
"Use gap-analyzer to check technical debt"
```

**Best for:** Complex projects, specific needs

---

## New Projects (Greenfield)

### Simple: Just Describe It
```
You: Build me a habit tracker app

Claude: I'll help you build a habit tracker. Let me start by understanding
        what we're building...

        [Creates intent document]
        [Designs user experience]

        What design style do you prefer?
        1. modern-clean (professional SaaS)
        2. minimal (ultra-clean)
        3. playful (vibrant, fun)
        4. corporate (enterprise)
        5. glassmorphism (modern glass)
        6. Reference another site

You: modern-clean

Claude: [Creates design system]
        [Plans architecture]
        [Creates feature plans]

        Ready to build. Starting with user authentication...

        [Frontend engineer reads design system first]
        [Builds feature by feature with consistent UI]
```

### With More Detail
```
You: Build me a habit tracker with these requirements:
     - Users can create daily/weekly habits
     - Track streaks and completion rates
     - Send reminder notifications
     - Show progress charts
     - Use React frontend, FastAPI backend, PostgreSQL

Claude: [More detailed planning based on your requirements]
```

### Iterating
```
You: Actually, add social features - users should see friends' habits

Claude: [Analyzes impact]
        This adds:
        - 3 new user journeys
        - 5 API endpoints
        - 2 new pages

        Updating plans and continuing...
```

### Check Progress Anytime
```
You: Where are we?

Claude: Project: Habit Tracker

        ✓ auth - complete
        ✓ habits - complete
        🔄 tracking - in progress (backend done)
        ○ notifications - not started
        ○ charts - not started

        Continue with tracking frontend?
```

### Saving State Between Sessions

Before ending a session:
```
You: Save state before I go

Claude: [Runs /sync]
        ✓ CLAUDE.md updated with current task
        ✓ Documentation synced
        ✓ Test coverage recorded

        Session state saved ✓

        Next session, just say "continue" and I'll know
        exactly where we left off.
```

Next session:
```
You: Continue

Claude: Continuing from where we left off...
        Current task: tracking frontend (SearchResults component)
        [Continues seamlessly]
```

---

## Existing Projects (Brownfield)

### Quick Audit
```
You: What's wrong with this codebase?

Claude: [Scans code]

        Found issues:

        🔴 Critical (2):
           - SQL injection in search endpoint
           - No rate limiting on auth

        🟠 High (4):
           - N+1 queries in dashboard
           - Missing error handling in checkout
           - No input validation on forms
           - Broken password reset flow

        🟡 Medium (6):
           - Duplicated code in services
           - No tests for payment flow
           ...

        Want me to fix the critical issues first?
```

### Full Analysis
```
You: Analyze this codebase completely

Claude: [Deep audit]

        I've analyzed your codebase. Here's what I found:

        INFERRED INTENT:
        This appears to be an e-commerce platform for...

        INFERRED JOURNEYS:
        - Browse products → Add to cart → Checkout
        - User signup → Login → Manage profile
        - Admin: Manage products, View orders

        Is this understanding correct?

You: Yes, but it's specifically for handmade crafts

Claude: [Updates understanding]
        [Creates gap analysis]
        [Creates migration plan]

        Migration plan created with 4 phases:
        - Phase 0: Critical security fixes
        - Phase 1: Broken features
        - Phase 2: Tech debt
        - Phase 3: Enhancements

        Start with Phase 0?
```

### Focused Improvement
```
You: Just fix the security issues

Claude: [Fixes only security-related gaps]

        ✓ Added rate limiting
        ✓ Parameterized SQL queries
        ✓ Added CSRF protection

        Security issues resolved.
        Run /status to see remaining improvements.
```

---

## Commands Reference

### Everyday Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/status` | See project progress | `/status` |
| `/next` | Continue building | `/next` |
| `/review [target]` | Review code quality | `/review auth` |
| `/plan show` | Display current plans | `/plan show` |
| `/sync` | Update project state & docs | `/sync` |
| `/sync quick` | Quick state update | `/sync quick` |
| `/sync report` | Check sync status | `/sync report` |

### Parallel Development

| Command | Purpose | Example |
|---------|---------|---------|
| `/parallel setup` | Create feature worktrees | `/parallel setup` |
| `/parallel status` | Check all features | `/parallel status` |
| `/parallel merge` | Merge completed features | `/parallel merge` |
| `/parallel clean` | Remove merged worktrees | `/parallel clean` |

### Help

| Command | Purpose |
|---------|---------|
| `/agent-wf-help` | Quick overview |
| `/agent-wf-help workflow` | How the system works |
| `/agent-wf-help agents` | All 13 agents |
| `/agent-wf-help commands` | All commands |
| `/agent-wf-help patterns` | Usage patterns |
| `/agent-wf-help design` | Design system & UI consistency |
| `/agent-wf-help parallel` | Parallel development |
| `/agent-wf-help brownfield` | Existing codebases |
| `/agent-wf-help sync` | Project state & maintenance |
| `/agent-wf-help examples` | Practical examples |

---

## Going Deeper

### Understanding the Workflow

The system uses a two-level workflow:

**Level 1 (App):** Runs once at project start
```
Intent → UX → Architecture → Plans
```

**Level 2 (Feature):** Runs for each feature
```
Backend → Frontend → Tests → Verify
```

See `/agent-wf-help workflow` for details.

### The 11 Agents

| Agent | Purpose | Used When |
|-------|---------|-----------|
| intent-guardian | Define what we're building | New project, changes |
| ux-architect | Design user experience | New project, UX changes |
| agentic-architect | Design system architecture | New project, system changes |
| implementation-planner | Create build plans | After analysis |
| change-analyzer | Assess change impact | Adding/changing features |
| gap-analyzer | Find issues in existing code | Brownfield projects |
| backend-engineer | Build server-side code | Implementation |
| frontend-engineer | Build UI | Implementation |
| test-engineer | Write tests, verify | Implementation |
| code-reviewer | Review code quality | Before milestones |
| debugger | Fix bugs | When things break |

See `/agent-wf-help agents` for details.

### Documents Created
```
/docs
├── intent/
│   └── product-intent.md      # What we promise users
├── ux/
│   └── user-journeys.md       # How users interact
├── architecture/
│   └── agent-design.md        # System design
├── plans/
│   ├── overview/              # Full system specs
│   │   ├── backend-plan.md
│   │   ├── frontend-plan.md
│   │   └── test-plan.md
│   ├── features/              # Per-feature plans
│   │   ├── auth.md
│   │   ├── habits.md
│   │   └── ...
│   └── implementation-order.md
├── gaps/                      # Brownfield only
│   ├── gap-analysis.md
│   └── migration-plan.md
└── verification/
    └── phase-N-report.md
```

### Parallel Development

For large projects (5+ features):
```bash
# After Claude creates plans
/parallel setup

# Opens separate folders for each feature
# ../myapp-auth/
# ../myapp-habits/
# ../myapp-tracking/

# Open terminals in each
cd ../myapp-auth && claude
> Build this feature

# When done
cd ../myapp
/parallel merge
```

See `/agent-wf-help parallel` for details.

---

## FAQ

### Do I need to use commands?

No. Just talk naturally. Commands are optional shortcuts.

### How do I start a new project?

Just describe what you want to build:
```
"Build me a [description]"
```

### How do I improve existing code?
```
"Analyze this codebase"
```
or
```
"What's wrong with this code?"
```

### How do I add features?

Just ask:
```
"Add [feature description]"
```

Claude analyzes impact and updates plans.

### How do I continue after a break?
```
"Where were we?"
```
or
```
"Continue"
```

### How do I speed up development?

Use parallel mode:
```
/parallel setup
```

### What if Claude misunderstands?

Just correct it:
```
"No, I meant [clarification]"
```

### How do I review code before shipping?
```
"Review the code"
```
or
```
/review
```

### How do I fix a bug?

Describe the problem:
```
"The login isn't working - I get error X"
```

---

## Testing

### Run All Automated Tests
```bash
./tests/run_all_tests.sh
```

### Run Specific Test Category
```bash
./tests/run_all_tests.sh --structural
./tests/run_all_tests.sh --content
./tests/run_all_tests.sh --consistency
./tests/run_all_tests.sh --documentation
./tests/run_all_tests.sh --integration
```

### Manual Testing

See [tests/MANUAL_TEST_CHECKLIST.md](tests/MANUAL_TEST_CHECKLIST.md) for manual testing procedures that verify functionality with Claude Code.

### Test Report

Use [tests/TEST_REPORT_TEMPLATE.md](tests/TEST_REPORT_TEMPLATE.md) to document test results.

For details, see [tests/README.md](tests/README.md).

---

## More Resources

- [GUIDE.md](GUIDE.md) - Quick reference card
- [WORKFLOW.md](WORKFLOW.md) - Detailed workflow explanation
- [EXAMPLES.md](EXAMPLES.md) - Practical examples
- [FRONTEND.md](FRONTEND.md) - Frontend development best practices
- [COMMANDS.md](COMMANDS.md) - Complete command reference
- [AGENTS.md](AGENTS.md) - All agents documentation
- `/agent-wf-help` - In-app help system

---

## License

MIT
