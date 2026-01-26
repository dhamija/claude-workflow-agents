---
name: project
description: Manage project operations, documentation, and infrastructure
argument-hint: <subcommand> [args]
---

# /project Command

Unified command for all project operations. Consolidates setup, sync, verification, documentation, and AI integration.

---

## Usage

```
/project setup                    # Initialize project infrastructure
/project sync [quick|report]      # Update docs and state
/project verify                   # Check compliance
/project docs <action>            # Manage documentation
/project ai <action>              # LLM integration
/project mcp <action>             # MCP servers
/project status                   # Show project health
/project commit [message]         # Create conventional commit (guided)
/project push                     # Push current branch to remote
/project pr                       # Create pull request (requires GitHub MCP)
```

---

## Subcommands

### /project setup

Initialize project infrastructure (scripts, hooks, CI, docs).

**What it does:**
- Creates documentation structure (`docs/`)
- Initializes CLAUDE.md
- Optionally sets up enforcement (git hooks + CI)
- Optionally configures AI integration
- Optionally creates CI/CD workflows

**When to use:**
- Starting a new project
- After L1 analysis completes
- Adding infrastructure to existing project

**Process:**

```
TASK: User ran /project setup

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Project Setup
ACTION: Initialize Infrastructure

STEPS:
1. Check what already exists (docs/, CLAUDE.md, scripts/, .git/hooks/)
2. Create missing structure
3. Generate initial CLAUDE.md if missing
4. Ask user: "Enable enforcement (git hooks + CI)? [y/n]"
   If yes:
     - Create scripts/verify.sh from template
     - Create scripts/hooks/pre-commit from template
     - Create .github/workflows/verify.yml from template
     - Install git hook
     - Add enforcement section to CLAUDE.md
5. Ask user: "Setup AI integration? [y/n]"
   If yes:
     - Create lib/llm/ structure
     - Ask which providers (Ollama, OpenAI, Anthropic, Google)
     - Generate client code
     - Update CLAUDE.md with AI section
6. Ask user: "Setup CI/CD? [y/n]"
   If yes:
     - Create .github/workflows/ci.yml
     - Configure based on project type
7. Show completion summary

OUTPUT:
Display what was created and suggest next steps.
---
```

**Example:**

```
You: /project setup

Claude: Checking existing structure...

        Found:
          ✓ docs/intent/product-intent.md
          ✓ docs/ux/user-journeys.md
          ✓ docs/architecture/agent-design.md
          ✗ CLAUDE.md missing
          ✗ scripts/ missing
          ✗ .git/hooks/pre-commit missing

        Creating missing infrastructure...

        ✓ CLAUDE.md created
        ✓ scripts/ directory created

        Enable enforcement (git hooks + CI)? [y/n]

You: y

Claude: ✓ scripts/verify.sh created
        ✓ Git pre-commit hook installed
        ✓ CI workflow created (.github/workflows/verify.yml)

        Setup AI integration? [y/n]

You: n

Claude: Setup complete!

        Created:
          • CLAUDE.md
          • scripts/verify.sh
          • scripts/hooks/pre-commit
          • .github/workflows/verify.yml

        Next steps:
          1. Review CLAUDE.md and customize
          2. Use /project sync after implementing features
          3. Use /project status to track progress
```

---

### /project sync [quick|report]

Update documentation and state to match implementation.

**Variants:**

| Command | Speed | What Updates | Use When |
|---------|-------|--------------|----------|
| `/project sync` | 30-60s | Everything | After feature completion |
| `/project sync quick` | 5-10s | CLAUDE.md only | Quick progress update |
| `/project sync report` | 5s | Nothing (read-only) | Check sync status |

**What it does:**
- Analyzes codebase
- Updates CLAUDE.md (current state, phase, progress)
- Updates intent promise statuses
- Updates UX journey implementation status
- Updates feature completion in plans
- Records test coverage
- Detects documentation drift

**When to use:**
- After implementing a feature
- Before committing
- End of day (quick mode)
- Before creating PR

**Process:**

```
TASK: User ran /project sync [MODE]

MODE = $ARGUMENTS (if empty, MODE = "full")

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Documentation Sync
ACTION: Update Docs to Match Implementation
MODE: $MODE

IF MODE = "quick":
  STEPS:
  1. Update CLAUDE.md only:
     - Last Updated timestamp
     - Current Task (from recent git commits)
     - Progress checkboxes
  2. Show brief confirmation

IF MODE = "report":
  STEPS:
  1. Check what's out of sync (don't modify anything)
  2. Show report of drift items
  3. Suggest actions

IF MODE = "full":
  STEPS:
  1. Analyze codebase
     - Count features, API endpoints, components
     - Check git state (branch, commits ahead)
     - Run tests and collect coverage
  2. Update CLAUDE.md
     - Current state, phase, progress
     - Test coverage
     - Recent changes
  3. Update intent promises
     - Verify each promise against code
     - Update statuses (KEPT/AT_RISK/BROKEN)
  4. Update UX journeys
     - Check implementation status
     - Update journey completion
  5. Update feature plans
     - Mark completed features
     - Update implementation-order.md
  6. Detect drift
     - Undocumented APIs
     - Unimplemented promises
     - Outdated architecture
  7. Show comprehensive report

OUTPUT:
Display sync report with any warnings or drift detected.
---
```

**Example (full sync):**

```
You: /project sync

Claude: Analyzing project...

        ✓ Scanned 142 files
        ✓ Found 23 API endpoints
        ✓ Found 45 components
        ✓ Tests: 87% backend, 72% frontend

        Updating documentation...

        ✓ CLAUDE.md updated
        ✓ Intent promises verified (4 KEPT, 1 AT_RISK)
        ✓ UX journeys updated (2 IMPLEMENTED, 1 PARTIAL)
        ✓ Feature plans updated (Phase 3: 65% complete)

        ⚠ DRIFT DETECTED:

          Undocumented APIs (2):
            • POST /api/search/save
            • DELETE /api/search/history/:id

            Action: Update docs/plans/overview/backend-plan.md

        Sync completed in 42 seconds.
```

**Example (quick sync):**

```
You: /project sync quick

Claude: ✓ CLAUDE.md updated
        Last Updated: 2025-01-25
        Current Task: Building search frontend

        Quick sync complete (3 seconds)
```

**Example (report):**

```
You: /project sync report

Claude: Sync Status:

        ✓ CLAUDE.md: Current (updated 2h ago)
        ⚠ Intent: 1 promise needs verification
        ⚠ UX Journeys: 1 journey status outdated
        ✓ Plans: Current

        Run /project sync to update.
```

---

### /project verify

Check project compliance and correctness.

**What it does:**
- Verifies CLAUDE.md is current
- Checks for unjustified BROKEN promises
- Verifies tests pass
- Checks required documentation exists
- Validates architecture compliance

**When to use:**
- Before committing (manual check)
- Before creating PR
- After major changes
- Checking project health

**Note:** This runs automatically in:
- Pre-commit git hook (if enforcement enabled)
- CI workflow on push/PR

**Process:**

```
TASK: User ran /project verify

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Verification
ACTION: Check Project Compliance

STEPS:
1. Check CLAUDE.md exists and is reasonably current
2. Check intent compliance
   - Count BROKEN promises
   - Verify all have justifications
   - Flag any unjustified
3. Check UX implementation
   - Count journeys vs implemented
   - Show percentage
4. Run tests
   - Execute test suite
   - Check coverage vs targets
5. Check architecture compliance
   - Compare docs/architecture/ with actual structure
6. Generate detailed report
   - Show all checks
   - Highlight errors (block commit) vs warnings (advisory)

OUTPUT:
Display comprehensive verification report with:
- ✓ for passing checks
- ⚠ for warnings
- ❌ for errors (would block commit)
---
```

**Example:**

```
You: /project verify

Claude: Running verification...

        ═══════════════════════════════════════════
                   PROJECT VERIFICATION
        ═══════════════════════════════════════════

        DOCUMENTATION
        ─────────────
          ✓ CLAUDE.md current (updated 2h ago)
          ✓ Intent documented
          ✓ UX journeys documented
          ✓ Architecture documented

        INTENT COMPLIANCE
        ─────────────────
          ✓ 5 promises: 4 KEPT, 1 AT_RISK, 0 BROKEN

          AT_RISK:
            • "Works offline" - needs testing

        UX IMPLEMENTATION
        ─────────────────
          ✓ 3/5 journeys implemented (60%)

        TESTS
        ─────
          ✓ Backend: 87% (target: 80%)
          ✓ Frontend: 72% (target: 70%)
          ✓ All tests passing

        ARCHITECTURE
        ────────────
          ✓ Follows documented structure
          ⚠ New endpoint not documented

        ═══════════════════════════════════════════
        Result: ✓ PASSED (1 warning)
        ═══════════════════════════════════════════

        Warning: Document POST /api/search/save in backend-plan.md
```

---

### /project docs <action>

Generate and update project documentation.

**Actions:**

| Action | Purpose | Example |
|--------|---------|---------|
| `generate` | Create all missing docs | `/project docs generate` |
| `generate <doc>` | Create specific document | `/project docs generate readme` |
| `update` | Refresh existing docs | `/project docs update` |
| `changelog` | Generate CHANGELOG.md | `/project docs changelog` |

**Supported documents:**
- README.md
- API.md
- ARCHITECTURE.md
- CHANGELOG.md
- USAGE.md

**What it does:**
- Scans codebase
- Extracts information (APIs, features, tech stack)
- Generates markdown documentation
- Preserves manual edits when updating

**Process:**

```
TASK: User ran /project docs $ACTION [$DOC_TYPE]

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Documentation Generation
ACTION: $ACTION
DOC_TYPE: $DOC_TYPE (if specified)

IF ACTION = "generate":
  IF DOC_TYPE specified:
    STEPS:
    1. Check if document already exists
    2. If exists, ask: "Overwrite existing $DOC_TYPE? [y/n]"
    3. Generate specific document
    4. Show preview
  ELSE:
    STEPS:
    1. Check which docs are missing
    2. Show list: "Will generate: README.md, API.md, CHANGELOG.md"
    3. Ask: "Continue? [y/n]"
    4. Generate all missing docs
    5. Show summary

IF ACTION = "update":
  STEPS:
  1. Find all existing auto-generated docs
  2. Refresh content while preserving manual edits
  3. Show what was updated

IF ACTION = "changelog":
  STEPS:
  1. Parse git history
  2. Group commits by type (feat, fix, docs, etc.)
  3. Generate CHANGELOG.md
  4. Show preview

OUTPUT:
Display generated documentation or summary of what was created.
---
```

**Example:**

```
You: /project docs generate readme

Claude: Analyzing project...

        ✓ Project type: Node.js + Express + PostgreSQL
        ✓ Found 5 features
        ✓ Found 23 API endpoints
        ✓ Found test suite

        Generating README.md...

        ✓ Created README.md (342 lines)

        Sections:
          • Project overview
          • Features
          • Tech stack
          • Getting started
          • Usage
          • API reference (overview)
          • Testing
          • License

        Preview:
        ───────────────────────────────────────
        # Habit Tracker

        A local-first habit tracking app with...

        ## Features

        - Track daily and weekly habits
        - View progress and streaks
        ...
        ───────────────────────────────────────

        README.md created! Review and customize as needed.
```

---

### /project ai <action>

Setup and manage LLM integration.

**Actions:**

| Action | Purpose | Example |
|--------|---------|---------|
| `setup` | Initialize LLM integration | `/project ai setup` |
| `status` | Show current configuration | `/project ai status` |
| `add <provider>` | Add new provider | `/project ai add openai` |

**What it does:**
- Creates `lib/llm/` directory structure
- Generates multi-provider client code
- Sets up cost tracking
- Updates CLAUDE.md with AI section
- Adds dependencies to package.json

**Process:**

```
TASK: User ran /project ai $ACTION [$ARGS]

Invoke the project-ops agent with these instructions:

---
CAPABILITY: AI Integration
ACTION: $ACTION
ARGS: $ARGS

IF ACTION = "setup":
  STEPS:
  1. Check if lib/llm/ already exists
  2. Ask: "Which LLM providers? (Ollama, OpenAI, Anthropic, Google)"
  3. Ask: "Create sample usage examples? [y/n]"
  4. Ask: "Add cost tracking? [y/n]"
  5. Create lib/llm/ structure:
     - index.ts (main export)
     - client.ts (unified client)
     - providers/ (provider implementations)
     - cost-tracker.ts (if enabled)
     - types.ts
  6. Update package.json with dependencies
  7. Update CLAUDE.md with AI section
  8. Show usage example

IF ACTION = "status":
  STEPS:
  1. Check lib/llm/ exists
  2. Show configured providers
  3. Show cost tracking status
  4. Show recent usage stats (if tracking enabled)

IF ACTION = "add":
  STEPS:
  1. Check if provider already exists
  2. Add provider implementation
  3. Update client.ts
  4. Update dependencies
  5. Show configuration instructions

OUTPUT:
Display setup summary and usage examples.
---
```

**Example:**

```
You: /project ai setup

Claude: Which LLM providers?
        1. Ollama (local)
        2. OpenAI
        3. Anthropic
        4. Google (Gemini)

        Enter numbers (e.g., 1,2):

You: 1,2

Claude: Create sample usage examples? [y/n]

You: y

Claude: Add cost tracking? [y/n]

You: y

Claude: Creating LLM integration...

        ✓ lib/llm/ structure created
        ✓ Ollama provider implemented
        ✓ OpenAI provider implemented
        ✓ Unified client created
        ✓ Cost tracking enabled
        ✓ Example created: examples/llm-usage.ts
        ✓ CLAUDE.md updated

        Dependencies added:
          • ollama
          • openai
          • zod (for JSON parsing)

        Usage:
        ──────────────────────────────────────
        import { LLMClient } from './lib/llm';

        const llm = new LLMClient('ollama', {
          model: 'llama2',
          baseURL: 'http://localhost:11434'
        });

        const response = await llm.complete(
          "Your prompt here"
        );
        ──────────────────────────────────────

        Run: npm install
```

---

### /project mcp <action>

Setup and manage Model Context Protocol servers.

**Actions:**

| Action | Purpose | Example |
|--------|---------|---------|
| `setup` | Configure MCP servers | `/project mcp setup` |
| `recommend` | Get server recommendations | `/project mcp recommend` |
| `status` | Show active servers | `/project mcp status` |

**What it does:**
- Analyzes project needs
- Recommends suitable MCP servers
- Creates/updates claude_desktop_config.json
- Configures server parameters
- Shows setup instructions

**Process:**

```
TASK: User ran /project mcp $ACTION

Invoke the project-ops agent with these instructions:

---
CAPABILITY: MCP Integration
ACTION: $ACTION

IF ACTION = "recommend":
  STEPS:
  1. Analyze project structure
     - Check for database (Prisma, Drizzle, raw SQL)
     - Check for git repository
     - Check for API integrations (Stripe, etc.)
     - Check for specific needs
  2. Generate recommendations:
     - List suitable servers
     - Explain why each is recommended
     - Show configuration preview
  3. Ask: "Setup recommended servers? [y/n]"

IF ACTION = "setup":
  STEPS:
  1. Run recommendation logic
  2. Show recommended servers
  3. Ask: "Select servers (comma-separated numbers or 'all'):"
  4. For each server:
     - Ask for configuration (DB URL, API keys, etc.)
     - Validate configuration
  5. Create/update claude_desktop_config.json
  6. Show restart instructions

IF ACTION = "status":
  STEPS:
  1. Check if claude_desktop_config.json exists
  2. Parse and show configured servers
  3. Test connections (if possible)
  4. Show health status

OUTPUT:
Display MCP configuration and setup instructions.
---
```

**Example:**

```
You: /project mcp recommend

Claude: Analyzing project...

        Recommended MCP Servers:

        1. ✓ postgres
           Reason: Detected Prisma schema
           Config: postgresql://localhost/habittracker

        2. ✓ github
           Reason: Git repository detected
           Config: Needs GITHUB_TOKEN

        3. ✓ filesystem
           Reason: Always useful for project files
           Config: /path/to/project

        Setup these servers? [y/n]

You: y

Claude: Setting up MCP servers...

        postgres:
          Database URL: postgresql://localhost/habittracker

        github:
          GitHub Token: (enter or skip)

You: ghp_xxxxx

Claude: ✓ claude_desktop_config.json updated

        Configured servers:
          • filesystem (file operations)
          • github (repository access)
          • postgres (database queries)

        ⚠ Restart Claude Code to activate servers

        Test with:
          "Show me the database schema"
          "What's the latest commit?"
```

---

### /project status

Show comprehensive project health and progress.

**What it displays:**
- Project name and current phase
- Feature completion progress
- Documentation status
- Promise compliance
- UX journey implementation
- Test coverage
- Enforcement status
- AI integration status
- Recent activity
- Suggested next steps

**Process:**

```
TASK: User ran /project status

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Status Check
ACTION: Display Project Health

STEPS:
1. Read CLAUDE.md for current state
2. Check git status (branch, commits ahead)
3. Parse feature completion from plans
4. Check documentation timestamps
5. Verify promise statuses from intent
6. Check UX journey implementation
7. Read test coverage
8. Check if enforcement enabled
9. Check if AI integration configured
10. Get recent commits (last 5)
11. Determine suggested next steps

OUTPUT:
Display comprehensive status report with:
- Project overview
- Progress bars/percentages
- Color-coded status indicators
- Warnings/errors highlighted
- Actionable next steps
---
```

**Example:**

```
You: /project status

Claude: ═══════════════════════════════════════════
                  PROJECT STATUS
        ═══════════════════════════════════════════

        PROJECT: Habit Tracker
        PHASE: Implementation (Phase 3 of 5)
        BRANCH: feature/search (2 commits ahead)
        LAST SYNC: 6 hours ago

        PROGRESS
        ────────
          ✓ auth           Complete
          ✓ habits         Complete
          🔄 search        In Progress (65%)
          ○ notifications  Pending
          ○ charts         Pending

        Overall: 3/5 features (60%)

        DOCUMENTATION
        ─────────────
          ✓ Intent         Current (3d ago)
          ✓ UX Journeys    Current (3d ago)
          ⚠ CLAUDE.md      Outdated (6h ago)

          Action: Run /project sync

        PROMISES
        ────────
          ✓ 4 KEPT
          ⚠ 1 AT_RISK

        TESTS
        ─────
          ✓ Backend:  87% (target: 80%)
          ✓ Frontend: 72% (target: 70%)

        ENFORCEMENT
        ───────────
          ✓ Git hook active
          ✓ CI passing

        NEXT STEPS
        ──────────
          1. Complete search frontend
          2. Add tests for search
          3. Run /project sync
          4. Merge to main

        ═══════════════════════════════════════════
```

---

### /project commit [message]

Create a conventional commit with guided workflow.

**What it does:**
- Prompts for commit type if not provided
- Suggests type based on file changes
- Creates properly formatted commit message
- Follows conventional commit standard

**When to use:**
- When ready to commit changes
- To ensure consistent commit messages
- For better git history and changelog generation

**Process:**

```
TASK: User ran /project commit [$MESSAGE]

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Git Workflow
ACTION: Commit Helper
MESSAGE: $MESSAGE (if provided)

STEPS:
1. Run git status to see what's staged
2. If nothing staged, show error and suggest "git add"
3. If MESSAGE provided:
   - Ask: "Type: feat, fix, refactor, docs, test, or chore?"
   - Format as: "<type>: <message>"
   - Run git commit
4. If NO MESSAGE:
   - Analyze changed files to suggest type:
     • Only docs/ → suggest "docs"
     • Only tests/ → suggest "test"
     • Only package.json/deps → suggest "chore"
     • Otherwise → ask user
   - Show menu:
     1. feat - New feature
     2. fix - Bug fix
     3. refactor - Code restructuring
     4. docs - Documentation
     5. test - Tests
     6. chore - Maintenance
   - Ask: "Describe the change (short, imperative):"
   - Format as: "<type>: <description>"
   - Run git commit
5. Show commit confirmation

OUTPUT:
Display commit message and hash.
---
```

**Example (with message):**

```
You: /project commit "add user authentication"

Claude: Type: feat, fix, refactor, docs, test, or chore?

You: feat

Claude: [Runs: git commit -m "feat: add user authentication"]

        ✓ Committed: feat: add user authentication
        Hash: a3f5b2c
```

**Example (guided):**

```
You: /project commit

Claude: Analyzing changes...

        Staged files:
          • src/auth/login.ts
          • src/auth/logout.ts
          • tests/auth.test.ts

        What type of change is this?
        1. feat - New feature
        2. fix - Bug fix
        3. refactor - Code restructuring
        4. docs - Documentation
        5. test - Tests
        6. chore - Maintenance

You: 1

Claude: Describe the change (short, imperative):

You: add user authentication

Claude: [Runs: git commit -m "feat: add user authentication"]

        ✓ Committed: feat: add user authentication
        Hash: a3f5b2c
```

**Example (smart suggestion):**

```
You: /project commit

Claude: Analyzing changes...

        Staged files:
          • README.md
          • docs/API.md

        Suggested type: docs (only documentation changed)

        Continue with "docs"? [y/n]

You: y

Claude: Describe the change:

You: update API documentation

Claude: [Runs: git commit -m "docs: update API documentation"]

        ✓ Committed: docs: update API documentation
        Hash: b7e9c1a
```

---

### /project push

Push current branch to remote repository.

**What it does:**
- Gets current branch name
- Pushes to remote (with -u flag if first push)
- Shows push result

**When to use:**
- After committing changes
- Before creating PR
- To backup work to remote

**Process:**

```
TASK: User ran /project push

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Git Workflow
ACTION: Push Branch
STEPS:
1. Get current branch: git rev-parse --abbrev-ref HEAD
2. Check if branch has upstream: git rev-parse --abbrev-ref @{u}
3. If NO upstream:
   - Run: git push -u origin <branch>
4. If HAS upstream:
   - Run: git push
5. Show push result (commits pushed, branch URL)

OUTPUT:
Display push confirmation and branch info.
---
```

**Example (first push):**

```
You: /project push

Claude: [Runs: git push -u origin feature/user-auth]

        ✓ Pushed feature/user-auth to origin
        ✓ Upstream branch set

        2 commits pushed:
          • feat: add user authentication (a3f5b2c)
          • test: add auth tests (b7e9c1a)

        Branch: https://github.com/user/repo/tree/feature/user-auth
```

**Example (subsequent push):**

```
You: /project push

Claude: [Runs: git push]

        ✓ Pushed feature/user-auth to origin

        1 commit pushed:
          • fix: resolve login timeout (c8d2e4f)
```

---

### /project pr

Create a pull request from current branch.

**What it does:**
- Generates PR title from recent commits
- Generates PR body with changes summary
- Creates PR via GitHub MCP (if available)
- Provides manual instructions if MCP not configured

**When to use:**
- After pushing feature branch
- When ready for code review
- Before merging to main

**Prerequisites:**
- GitHub MCP server configured (recommended)
- OR manual PR creation via GitHub UI

**Process:**

```
TASK: User ran /project pr

Invoke the project-ops agent with these instructions:

---
CAPABILITY: Git Workflow
ACTION: Create Pull Request

STEPS:
1. Check if GitHub MCP server is available
2. Get current branch
3. Get commits on branch (vs main): git log main..HEAD
4. Generate PR title from commits
5. Generate PR body:
   - ## Changes (list of changes)
   - ## Testing (what was tested)
   - ## Notes (if any breaking changes)

IF GitHub MCP available:
  6. Show preview: "Title: ... Body: ..."
  7. Ask: "Create PR? [y/n]"
  8. If yes: Use GitHub MCP to create PR
  9. Show PR URL

IF GitHub MCP NOT available:
  6. Ask: "GitHub MCP not configured. Setup now? [y/n]"
  7. If yes: Run /project mcp setup (select github)
  8. If no: Show manual instructions:
     - git push command
     - GitHub compare URL
     - gh CLI command (if available)
  9. Ask: "Push branch for you? [y/n]"

OUTPUT:
Display PR URL or manual instructions.
---
```

**Example (with GitHub MCP):**

```
You: /project pr

Claude: Analyzing branch feature/user-auth...

        Found 3 commits:
          • feat: add user authentication (a3f5b2c)
          • test: add auth tests (b7e9c1a)
          • docs: update auth documentation (c8d2e4f)

        Generated PR:

        Title: Add user authentication

        Body:
        ## Changes
        - Implemented login/logout flow
        - Added JWT token handling
        - Created auth middleware
        - Added authentication tests
        - Updated documentation

        ## Testing
        - Unit tests: 15 new tests passing
        - Manual testing: Login/logout flows verified
        - Token expiration tested

        Create PR? [y/n]

You: y

Claude: [Using GitHub MCP to create PR]

        ✓ PR created: https://github.com/user/repo/pull/42

        Title: Add user authentication
        Branch: feature/user-auth → main
        Status: Open
```

**Example (without GitHub MCP):**

```
You: /project pr

Claude: To create a PR, I need the GitHub MCP server.

        GitHub MCP provides:
        - Automatic PR creation
        - Branch status checking
        - PR template integration

        Setup GitHub MCP now? [y/n]

You: n

Claude: No problem. To create PR manually:

        1. Push your branch (if not already pushed):
           git push -u origin feature/user-auth

        2. Visit GitHub to create PR:
           https://github.com/user/repo/compare/feature/user-auth

        3. Or use GitHub CLI:
           gh pr create --title "Add user authentication" --body "..."

        Suggested PR content:
        ──────────────────────────────────────────
        Title: Add user authentication

        Body:
        ## Changes
        - Implemented login/logout flow
        - Added JWT token handling
        - Created auth middleware

        ## Testing
        - Unit tests: 15 new tests passing
        - Manual testing: Login/logout flows verified
        ──────────────────────────────────────────

        Want me to push the branch for you? [y/n]

You: y

Claude: [Runs: git push -u origin feature/user-auth]

        ✓ Pushed to origin

        Create PR at: https://github.com/user/repo/compare/feature/user-auth
```

---

## Command Routing Logic

When user runs `/project <subcommand>`, route to appropriate capability:

```python
def handle_project_command(subcommand: str, args: str):
    if subcommand == "setup":
        invoke_agent("project-ops", capability="setup")

    elif subcommand == "sync":
        mode = args or "full"  # full, quick, report
        invoke_agent("project-ops", capability="sync", mode=mode)

    elif subcommand == "verify":
        invoke_agent("project-ops", capability="verify")

    elif subcommand == "docs":
        action = args  # generate, update, changelog
        invoke_agent("project-ops", capability="docs", action=action)

    elif subcommand == "ai":
        action = args  # setup, status, add
        invoke_agent("project-ops", capability="ai", action=action)

    elif subcommand == "mcp":
        action = args  # setup, recommend, status
        invoke_agent("project-ops", capability="mcp", action=action)

    elif subcommand == "status":
        invoke_agent("project-ops", capability="status")

    elif subcommand == "commit":
        message = args  # optional commit message
        invoke_agent("project-ops", capability="git-commit", message=message)

    elif subcommand == "push":
        invoke_agent("project-ops", capability="git-push")

    elif subcommand == "pr":
        invoke_agent("project-ops", capability="git-pr")

    else:
        show_help()
```

---

## Migration from Old Commands

Old commands are deprecated but still work (with warnings):

| Old Command | New Command | Warning Message |
|-------------|-------------|-----------------|
| `/sync` | `/project sync` | "⚠ /sync is deprecated. Use /project sync" |
| `/sync quick` | `/project sync quick` | "⚠ Use /project sync quick" |
| `/enforce setup` | `/project setup` | "⚠ /enforce is deprecated. Use /project setup" |
| `/enforce verify` | `/project verify` | "⚠ Use /project verify" |
| `/docs generate` | `/project docs generate` | "⚠ Use /project docs <action>" |
| `/llm setup` | `/project ai setup` | "⚠ Use /project ai <action>" |
| `/mcp setup` | `/project mcp setup` | "⚠ Use /project mcp <action>" |

---

## Examples

### Complete Workflow

```
# 1. Start new project
You: Build me a habit tracker
Claude: [Creates intent, UX, architecture, plans]

# 2. Initialize infrastructure
You: /project setup
Claude: [Creates docs, scripts, hooks, CI]

# 3. Build features
You: Let's start building
Claude: [Implements auth feature]

# 4. Sync after feature
You: /project sync
Claude: [Updates all docs, marks auth complete]

# 5. Continue building
Claude: [Implements habits feature]

# 6. Before commit
You: /project verify
Claude: [Checks compliance, all passing]

# 7. Check progress
You: /project status
Claude: [Shows 2/5 features complete, 60% tests]

# 8. Add AI integration
You: /project ai setup
Claude: [Sets up Ollama + OpenAI]

# 9. Before shipping
You: /project verify
Claude: [Final check, ready to ship]
```

### Daily Development

```
# Morning: Check status
You: /project status
Claude: [Shows 3/5 features, search in progress]

# Work on feature
[code code code]

# End of day: Quick sync
You: /project sync quick
Claude: [Updates CLAUDE.md, 5 seconds]

# Before commit
You: git add . && git commit -m "feat: add search"
Git Hook: [Auto-verifies, commit succeeds]
```

### Before Milestone

```
# Full sync
You: /project sync
Claude: [Deep analysis, updates everything]

# Verify compliance
You: /project verify
Claude: [Comprehensive check, 1 warning]

# Generate docs
You: /project docs generate
Claude: [Creates README, API.md, CHANGELOG.md]

# Check final status
You: /project status
Claude: [Shows all green, ready to ship]
```

---

## Summary

The `/project` command is your central hub for:

1. **Setup** - Initialize infrastructure correctly
2. **Sync** - Keep docs current automatically
3. **Verify** - Catch issues before they ship
4. **Docs** - Generate documentation from code
5. **AI** - Setup LLM/MCP integration
6. **Status** - Always know project health
7. **Git Workflow** - Conventional commits, push, PR creation

**Philosophy:** One command, comprehensive project management from setup to deployment.
