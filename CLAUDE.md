# Claude Workflow Agents - Complete Context

> **For Claude**: This file contains everything you need to understand and work with this repository. Read this fully before making any changes.
>
> **🔄 SELF-UPDATING**: This file must be updated when the repo changes. See "Maintaining This File" section.

---

## What This Repo Is

This is a **multi-agent workflow system for Claude Code** that helps users build software systematically. It provides:

1. **Specialized Agents** - Each handles a specific part of software development
2. **Commands** - Optional shortcuts for common actions
3. **Project Templates** - CLAUDE.md template and docs structure for user projects
4. **CI/CD System** - Intent-aware validation (optional)
5. **Help System** - Comprehensive in-app help via `/agent-wf-help`

When users install this in their project, Claude automatically orchestrates the agents based on natural conversation.

---

## Problem It Solves

Traditional development with Claude Code is ad-hoc. This system provides structure for:
- Capturing and preserving intent
- Designing user experience
- Planning architecture
- Building systematically
- Validating changes don't break promises

While keeping the experience conversational.

---

## Repository Structure

```
claude-workflow-agents/
│
├── agents/                    # 12 specialized agents
│   ├── intent-guardian.md     # L1: Define promises to users
│   ├── ux-architect.md        # L1: Design user experience
│   ├── agentic-architect.md   # L1: Design system architecture
│   ├── implementation-planner.md  # L1: Create build plans
│   ├── change-analyzer.md     # L1: Assess change impact
│   ├── gap-analyzer.md        # L1: Find issues in existing code
│   ├── backend-engineer.md    # L2: Build server-side code
│   ├── frontend-engineer.md   # L2: Build UI
│   ├── test-engineer.md       # L2: Write tests, verify
│   ├── code-reviewer.md       # L2: Review code quality
│   ├── debugger.md            # L2: Fix bugs
│   └── ci-cd-engineer.md      # Setup: CI/CD for user projects
│
├── commands/                  # 20 optional commands
│   ├── agent-wf-help.md       # Comprehensive help system
│   ├── analyze.md             # Run L1 analysis agents
│   ├── audit.md               # Audit existing codebase
│   ├── change.md              # Analyze change impact
│   ├── debug.md               # Launch debugger
│   ├── gap.md                 # Find gaps in brownfield
│   ├── implement.md           # Implement from plans
│   ├── improve.md             # Improve brownfield gaps
│   ├── intent.md              # Run intent-guardian
│   ├── intent-audit.md        # Audit existing intent
│   ├── parallel.md            # Parallel development
│   ├── plan.md                # Show/create plans
│   ├── replan.md              # Regenerate plans
│   ├── review.md              # Code review
│   ├── update.md              # Update docs after changes
│   ├── ux.md                  # Run ux-architect
│   ├── ux-audit.md            # Audit existing UX
│   ├── verify.md              # Verify current phase
│   ├── aa.md                  # Run agentic-architect
│   └── aa-audit.md            # Audit for agentic opportunities
│
├── templates/                 # Templates for user projects
│   ├── CLAUDE.md.template     # Main project orchestrator
│   ├── docs/                  # Document structure template
│   │   ├── intent/
│   │   ├── ux/
│   │   ├── architecture/
│   │   ├── plans/
│   │   ├── gaps/
│   │   └── changes/
│   └── ci/                    # CI/CD templates
│       ├── validate.sh.template
│       ├── github-workflow.yml.template
│       └── validators/
│           ├── intent-validator.sh.template
│           ├── ux-validator.sh.template
│           ├── arch-validator.sh.template
│           └── test-validator.sh.template
│
├── tests/                     # Automated tests
│   ├── run_all_tests.sh       # Master test runner
│   ├── test_utils.sh          # Shared test utilities
│   ├── structural/            # File existence tests
│   │   ├── test_agents_exist.sh
│   │   ├── test_commands_exist.sh
│   │   ├── test_docs_exist.sh
│   │   └── test_directory_structure.sh
│   ├── content/               # Content validation tests
│   │   ├── test_agent_frontmatter.sh
│   │   ├── test_agent_sections.sh
│   │   ├── test_command_frontmatter.sh
│   │   └── test_template_completeness.sh
│   ├── consistency/           # Sync verification tests
│   │   ├── test_agent_references.sh
│   │   ├── test_help_coverage.sh
│   │   ├── test_doc_links.sh
│   │   └── test_full_sync.sh
│   ├── documentation/         # Doc completeness tests
│   │   ├── test_readme_sections.sh
│   │   ├── test_guide_accuracy.sh
│   │   └── test_examples_valid.sh
│   ├── integration/           # Script functionality tests
│   │   ├── test_install_script.sh
│   │   └── test_workflow_simulation.sh
│   ├── MANUAL_TEST_CHECKLIST.md
│   ├── TEST_REPORT_TEMPLATE.md
│   └── README.md
│
├── scripts/                   # Maintenance scripts
│   ├── verify-sync.sh         # Check all docs in sync
│   ├── update-claude-md.sh    # Auto-update this file
│   ├── install-dev-hooks.sh   # Install git hooks
│   └── hooks/
│       └── pre-commit         # Pre-commit verification
│
├── CLAUDE.md                  # THIS FILE - complete context
├── STATE.md                   # Current state tracking
├── README.md                  # User documentation
├── GUIDE.md                   # Quick reference
├── WORKFLOW.md                # Detailed workflow docs
├── EXAMPLES.md                # Usage examples
├── install.sh                 # Installation script
└── uninstall.sh               # Removal script
```

---

## Current State

⚠️ **UPDATE THIS SECTION** when adding/removing agents, commands, or features.

### Agents: 12 total

**L1 Analysis** (run once at project start):
- **intent-guardian** - Define promises to users
- **ux-architect** - Design user experience
- **agentic-architect** - Design system architecture
- **implementation-planner** - Create feature-based build plans

**L1 Support** (run as needed):
- **change-analyzer** - Assess impact of changes
- **gap-analyzer** - Find issues in existing code (brownfield)

**L2 Building** (run per feature):
- **backend-engineer** - Build APIs, database, services
- **frontend-engineer** - Build pages, components, state
- **test-engineer** - Write tests and verify

**L2 Support** (run as needed):
- **code-reviewer** - Review code quality
- **debugger** - Fix bugs

**Setup**:
- **ci-cd-engineer** - Set up CI/CD in user projects

### Commands: 20 total

| Command | Purpose |
|---------|---------|
| `/agent-wf-help` | Comprehensive help system |
| `/analyze` | Run all L1 analysis agents |
| `/audit` | Audit existing codebase (brownfield) |
| `/change` | Analyze change impact |
| `/debug` | Launch debugger |
| `/gap` | Find gaps in brownfield project |
| `/implement` | Implement from plans |
| `/improve` | Improve brownfield gaps |
| `/intent` | Run intent-guardian |
| `/intent-audit` | Audit existing intent |
| `/parallel` | Parallel development with worktrees |
| `/plan` | Show/create implementation plans |
| `/replan` | Regenerate plans after changes |
| `/review` | Code review |
| `/update` | Update docs after changes |
| `/ux` | Run ux-architect |
| `/ux-audit` | Audit existing UX |
| `/verify` | Verify current phase |
| `/aa` | Run agentic-architect |
| `/aa-audit` | Audit for agentic opportunities |

### Help Topics

The `/agent-wf-help` command covers:
- overview (default)
- workflow
- agents
- commands
- patterns
- parallel
- brownfield
- cicd
- examples

### Features

- ✅ Two-level workflow (L1 app, L2 feature)
- ✅ Greenfield support (new projects)
- ✅ Brownfield support (existing code, audit mode)
- ✅ Sequential development (default)
- ✅ Parallel development (opt-in)
- ✅ Feature-based planning
- ✅ CI/CD engineer for user projects
- ✅ Comprehensive help system
- ✅ Self-maintenance system with CLAUDE.md tracking
- ✅ Automated test suite
- ✅ Pre-commit hooks for sync verification

---

## The Two-Level Workflow

### Level 1: App Workflow (Analysis & Planning)

Runs **ONCE** at project start:

```
"Build me a recipe app"
         │
         ▼
┌─────────────────────────────────────────┐
│ 1. INTENT-GUARDIAN                      │
│    → /docs/intent/product-intent.md     │
│    Promises, invariants, boundaries     │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 2. UX-ARCHITECT                         │
│    → /docs/ux/user-journeys.md          │
│    Personas, journeys, screens, states  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 3. AGENTIC-ARCHITECT                    │
│    → /docs/architecture/agent-design.md │
│    Components, AI vs code, data flow    │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 4. IMPLEMENTATION-PLANNER               │
│    → /docs/plans/overview/*             │
│    → /docs/plans/features/*             │
│    Feature plans, dependencies          │
└─────────────────────────────────────────┘
```

### Level 2: Feature Workflow (Building)

Runs **FOR EACH FEATURE**:

```
For feature (e.g., auth):
         │
         ▼
┌─────────────────────────────────────────┐
│ 1. BACKEND-ENGINEER                     │
│    APIs, database, services             │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 2. FRONTEND-ENGINEER                    │
│    Pages, components, state             │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 3. TEST-ENGINEER                        │
│    Unit, integration, E2E tests         │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ 4. VERIFY                               │
│    Run tests, check feature works       │
└─────────────────────────────────────────┘
         │
         ▼
Feature complete → Next feature
```

---

## Greenfield vs Brownfield

### Greenfield (New Project)

- L1 agents run in **CREATE** mode
- Generate new docs from scratch
- Flow: Intent → UX → Architecture → Plans → Build

### Brownfield (Existing Code)

- L1 agents run in **AUDIT** mode
- Infer docs from existing code, mark as `[INFERRED]`
- User reviews and confirms
- Gap analyzer finds issues
- Flow: Audit → Review → Gap Analysis → Fix by priority

---

## Sequential vs Parallel

### Sequential (Default)

- Single terminal, features built one at a time
- User says "continue" to proceed
- Best for: Single developer, learning, seeing progress

### Parallel (Opt-in)

- Multiple terminals via `/parallel setup`
- Each worktree gets scoped CLAUDE.md
- Merge with `/parallel merge`
- Best for: Teams, large projects, time pressure

---

## Key Design Decisions

1. **Conversation-Driven** - Users talk naturally, Claude selects agents
2. **Documents as Truth** - Everything documented for verification
3. **Feature-Based Planning** - Vertical slices, not horizontal layers
4. **Verification at Every Step** - Each feature verified before next
5. **Opt-in Complexity** - Simple path works, advanced is opt-in
6. **Self-Maintaining** - CLAUDE.md tracks changes, hooks enforce sync

---

## Files That Must Stay In Sync

| Source of Truth | Must Also Update |
|-----------------|------------------|
| `/agents/*.md` | CLAUDE.md, help, README, GUIDE, tests |
| `/commands/*.md` | CLAUDE.md, help, README, GUIDE, tests |
| `templates/CLAUDE.md.template` | WORKFLOW.md, help "workflow" |
| Any workflow change | CLAUDE.md, help, WORKFLOW.md, README |
| Any feature addition | CLAUDE.md, help, README, GUIDE, EXAMPLES |

---

## 🔧 Maintaining This File (CLAUDE.md)

**CRITICAL**: This file must be updated when the repo changes.

### When to Update CLAUDE.md

| Change Type | What to Update in CLAUDE.md |
|-------------|----------------------------|
| Add/remove agent | "Current State" agents list, count, structure diagram |
| Add/remove command | "Current State" commands table, count, structure diagram |
| Add help topic | "Current State" help topics list |
| Add feature | "Current State" features checklist |
| Change workflow | "Two-Level Workflow" section |
| Change design decision | "Key Design Decisions" section |
| Change file structure | "Repository Structure" diagram |

### Auto-Update Script

Run to update counts and verify structure:

```bash
./scripts/update-claude-md.sh
```

### Manual Verification

After changes, verify CLAUDE.md is accurate:
1. Agent count matches `/agents/*.md` count
2. Command count matches `/commands/*.md` count
3. Structure diagram matches actual structure
4. Features checklist is current

---

## 🔄 Self-Maintenance System

### After ANY Change - Complete Checklist

```
□ STEP 1: Make your changes to agents/commands/etc.

□ STEP 2: Update CLAUDE.md
  □ Update "Current State" section (counts, lists)
  □ Update "Repository Structure" if files added/removed
  □ Update relevant sections if behavior changed

□ STEP 3: Update Help System
  □ /commands/agent-wf-help.md reflects changes
  □ All agents listed in "agents" topic
  □ All commands listed in "commands" topic
  □ New topics added if needed

□ STEP 4: Update Documentation
  □ README.md tables and descriptions
  □ GUIDE.md quick reference
  □ WORKFLOW.md if workflow changed
  □ EXAMPLES.md if new patterns

□ STEP 5: Update Tests
  □ tests/structural/ - REQUIRED_AGENTS, REQUIRED_COMMANDS arrays
  □ Add tests for new functionality
  □ Update existing tests if behavior changed

□ STEP 6: Verify Everything
  □ Run: ./scripts/verify-sync.sh
  □ Run: ./tests/run_all_tests.sh
  □ All checks pass

□ STEP 7: Commit
  □ Commit message describes all changes
  □ All related files committed together
```

### Quick Commands

```bash
# Verify everything is in sync
./scripts/verify-sync.sh

# Auto-update CLAUDE.md counts
./scripts/update-claude-md.sh

# Run all tests
./tests/run_all_tests.sh

# Install git hooks (enforces sync on commit)
./scripts/install-dev-hooks.sh
```

---

## Adding Components - Step by Step

### Adding an Agent

```bash
# 1. Create the agent
vim agents/new-agent.md

# 2. Update CLAUDE.md
#    - Add to "Current State" agents list
#    - Update agent count
#    - Update structure diagram if needed

# 3. Update help
vim commands/agent-wf-help.md
#    - Add to "agents" topic
#    - Add triggers

# 4. Update docs
vim README.md   # Add to agents table
vim GUIDE.md    # Add to agents list

# 5. Update tests
vim tests/structural/test_agents_exist.sh
#    - Add to REQUIRED_AGENTS array

# 6. Verify
./scripts/verify-sync.sh
./tests/run_all_tests.sh

# 7. Commit all together
git add -A
git commit -m "feat: add new-agent for X functionality"
```

### Adding a Command

```bash
# 1. Create the command
vim commands/new-command.md

# 2. Update CLAUDE.md
#    - Add to "Current State" commands table
#    - Update command count
#    - Update structure diagram if needed

# 3. Update help
vim commands/agent-wf-help.md
#    - Add to "commands" topic

# 4. Update docs
vim README.md   # Add to commands table
vim GUIDE.md    # Add to commands list

# 5. Update tests
vim tests/structural/test_commands_exist.sh
#    - Add to REQUIRED_COMMANDS array

# 6. Verify and commit
./scripts/verify-sync.sh
./tests/run_all_tests.sh
git add -A
git commit -m "feat: add /new-command for X"
```

### Modifying Workflow

```bash
# 1. Update source of truth
vim templates/CLAUDE.md.template

# 2. Update CLAUDE.md
#    - Update "Two-Level Workflow" section
#    - Update any affected sections

# 3. Update related docs
vim WORKFLOW.md                  # Must match template
vim commands/agent-wf-help.md    # Update "workflow" topic
vim README.md                    # Update if significant
vim EXAMPLES.md                  # Update if patterns changed

# 4. Verify and commit
./scripts/verify-sync.sh
./tests/run_all_tests.sh
git add -A
git commit -m "feat: update workflow to support X"
```

---

## Testing

```bash
# Run all tests
./tests/run_all_tests.sh

# Run specific category
./tests/run_all_tests.sh --structural
./tests/run_all_tests.sh --content
./tests/run_all_tests.sh --consistency
./tests/run_all_tests.sh --documentation
./tests/run_all_tests.sh --integration

# Verify sync only
./scripts/verify-sync.sh
```

---

## Commit Message Format

```
feat: add X agent/command/feature

- Added [files]
- Updated CLAUDE.md, help, README, GUIDE
- Added tests
- All tests pass
```

```
fix: correct X in Y

- Fixed [issue]
- Updated affected docs
- Tests pass
```

```
docs: improve X documentation

- Updated [files]
- No functional changes
```

---

## Installation

Users install this system in their projects:

```bash
# Global installation (all projects)
./install.sh --user

# Project installation (current project only)
./install.sh --project

# Both
./install.sh --user --project
```

This copies agents, commands, and templates to `~/.claude/` and/or `./.claude/`.

---

## For Claude: How to Use This File

When starting work on this repository:

1. **Read this file first** - Get complete context
2. **Check "Current State"** - Know what exists
3. **Follow the workflow** - Understand how pieces fit
4. **Use the checklist** - Ensure nothing is missed
5. **Verify before committing** - Run scripts to check sync

When making changes:

1. **Update this file** - Keep it current (it's in the checklist!)
2. **Update related docs** - Follow checklist for each change type
3. **Run verify-sync.sh** - Catch missing updates
4. **Run tests** - Ensure everything still works

This file is the **source of truth** for understanding the repository. Keep it updated!
