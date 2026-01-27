# Claude Workflow Agents - Repository

> **Instructions for maintaining THIS repository.**
> **This file is NOT installed to user systems.**

---

## 🚨 CLAUDE: READ THIS FIRST

**Before making ANY changes to this repository:**

1. Read the [MANDATORY MAINTENANCE PROTOCOL](#️-mandatory-maintenance-protocol) section below
2. After changes to `agents/` or `commands/`, you MUST run `./scripts/verify.sh`
3. Do NOT commit until verify.sh passes - CI will fail otherwise

---

## ⚠️ Important Distinction

| This Repo | User Projects |
|-----------|---------------|
| **CLAUDE.md** (this file) | **templates/project/CLAUDE.md.template** |
| For maintaining workflow-agents | For user projects |
| NOT installed | Installed and customized |

**Never confuse repo files with user templates!**

---

## Installation Architecture

**Global-only model. No per-project enable/disable.**

### Directory Structure

```
~/.claude-workflow-agents/           # Installation directory
├── agents/                          # 16 agent definitions
├── commands/                        # 24 command definitions
├── templates/                       # Templates for user projects
│   └── project/                     # Project bootstrap templates
│       ├── CLAUDE.md.greenfield.template
│       └── CLAUDE.md.brownfield.template
├── bin/                            # CLI commands
│   ├── workflow-init               # Initialize project (NEW)
│   ├── workflow-toggle             # Enable/disable globally
│   ├── workflow-update             # Update from git
│   ├── workflow-uninstall          # Remove installation
│   └── workflow-version            # Show version
└── version.txt                     # Current version

~/.claude/                           # Claude Code's directory
├── agents/                          # Individual file symlinks
│   ├── intent-guardian.md -> ~/.claude-workflow-agents/agents/intent-guardian.md
│   ├── ux-architect.md -> ~/.claude-workflow-agents/agents/ux-architect.md
│   └── ... (16 total)
└── commands/                        # Individual file symlinks
    ├── analyze.md -> ~/.claude-workflow-agents/commands/analyze.md
    ├── plan.md -> ~/.claude-workflow-agents/commands/plan.md
    └── ... (24 total)
```

### How It Works

1. **Install** (`install.sh`):
   - Downloads to `~/.claude-workflow-agents/`
   - Creates individual file symlinks in `~/.claude/agents/` and `~/.claude/commands/`
   - Claude Code automatically loads from `~/.claude/`
   - Workflow immediately active for all projects

2. **Enable/Disable** (`workflow-toggle on|off|status`):
   - **Global operation** - affects all Claude Code sessions
   - `on`: Creates individual file symlinks
   - `off`: Removes only workflow symlinks, preserves user's own files
   - `status`: Shows count of workflow symlinks

3. **Update** (`workflow-update`):
   - Pulls latest from git
   - Re-creates symlinks
   - Preserves user's own agents/commands

4. **Uninstall** (`workflow-uninstall`):
   - Removes workflow symlinks from `~/.claude/`
   - Removes `~/.claude-workflow-agents/` directory
   - Preserves user's own agents/commands

### Key Design Decisions

1. **No per-project control**: Claude Code loads agents globally from `~/.claude/`. Project-local agents don't work reliably.

2. **Individual file symlinks**: User's own agents/commands coexist with workflow files in same directories.

3. **No CLAUDE.md markers**: Earlier versions used `<!-- workflow: enabled -->` markers in project files. These were vestigial - Claude Code doesn't read them. Removed in v1.3.0.

4. **Global toggle only**: `workflow-toggle` affects all projects simultaneously. Cannot enable workflow for only some projects.

### User Experience

- **Install once**: `curl -fsSL ... | bash`
- **Use everywhere**: All projects immediately have access to workflow agents
- **Disable when not needed**: `workflow-toggle off` (global)
- **No per-project setup**: No need to run commands in each project

---

## Multi-Agent Workflow System

Multi-agent workflow system for Claude Code

## ⚠️ MANDATORY MAINTENANCE PROTOCOL

**CRITICAL: Claude MUST follow this protocol after ANY change to `agents/` or `commands/`.**

**See [Documentation Dependency Map](#-documentation-dependency-map) for complete file interdependencies.**

### Step-by-Step Checklist

When you add, modify, or remove ANY agent or command file:

1. ✅ **Update CLAUDE.md** (Current State section)
   - Update agent/command counts
   - Add new entries to the tables
   - Remove deleted entries

2. ✅ **Update commands/help.md**
   - Add new agents to appropriate section (L1/L2/Operations/Orchestration)
   - Update agent count in header ("THE X AGENTS")
   - Add new commands to the commands list

3. ✅ **Update README.md**
   - Update agent count (line ~124)
   - Update command count (line ~125)
   - Add new entries to agent/command tables

4. ✅ **Update agents/workflow-orchestrator.md** (CRITICAL!)
   - Add agent to "Agents Coordinated" section (appropriate category)
   - Add row to "When to Invoke Each Agent" table
   - Add orchestration flow if it's a primary workflow agent (e.g., gap-analyzer, change-analyzer)

5. ✅ **Update tests**
   - `tests/structural/test_agents_exist.sh` - add to REQUIRED_AGENTS array
   - `tests/structural/test_commands_exist.sh` - add to REQUIRED_COMMANDS array
   - `tests/test_agents.sh` - add to REQUIRED_AGENTS array
   - `tests/test_commands.sh` - add to REQUIRED_COMMANDS array

6. ✅ **RUN VERIFICATION (MANDATORY)**
   ```bash
   ./scripts/verify.sh
   ```

   **YOU MUST RUN THIS COMMAND BEFORE COMMITTING.**

   - If it fails, fix ALL reported issues immediately
   - Do NOT commit until verify.sh passes
   - Do NOT skip this step - CI will fail and block merges
   - **Check 7/7 specifically ensures workflow-orchestrator is in sync!**

7. ✅ **Update STATE.md**
   - Add entry to Recent Changes section
   - Update component counts if changed
   - Update last updated timestamps

### Why This Matters

- **CI Enforcement**: `./scripts/verify.sh` runs in CI. PRs will be blocked if docs are out of sync.
- **User Experience**: Out-of-sync docs confuse users and break trust.
- **Automatic Detection**: The verify script catches 100% of sync issues before they reach users.

### Automation Helpers

To make this easier:

```bash
# After making changes, run:
./scripts/verify.sh

# If it passes, you're good to commit
git add -A
git commit -m "feat: add new agent"

# If it fails, fix the reported issues and run again
```

### Failure Recovery

If you forgot to run verify.sh and CI fails:

1. Read the CI error output - it shows exactly what's missing
2. Fix the reported issues locally
3. Run `./scripts/verify.sh` to confirm
4. Commit the fixes
5. Push again

**Remember: verify.sh is your friend. It prevents mistakes, not creates them.**

---

## 📄 Documentation Dependency Map

**CRITICAL: These files must stay in sync when agents/commands change.**

### Primary Documentation Files

| File | Contains | Must Update When |
|------|----------|------------------|
| **CLAUDE.md** | Repo maintenance, agent/command tables, counts | Any agent/command added/removed |
| **STATE.md** | Current state, agent/command lists, recent changes | Any agent/command added/removed, after major changes |
| **README.md** | User-facing docs, agent/command counts, tables | Any agent/command added/removed |
| **commands/help.md** | In-app help system, agent descriptions ("THE X AGENTS") | Any agent/command added/removed |
| **agents/workflow-orchestrator.md** | Orchestration logic, agent coordination, invocation table | **ANY agent/command added/removed/modified** |
| **AGENTS.md** | Detailed agent documentation | Agent capabilities change |
| **COMMANDS.md** | Detailed command documentation | Command behavior changes |

**⚠️ CRITICAL:** workflow-orchestrator.md is the MOST IMPORTANT file to keep in sync! It coordinates all agents and must know about every single one.

### Cross-Reference Matrix

When you add/remove an agent, it must be updated in:

1. ✅ **CLAUDE.md** - Current State section → Agents table
2. ✅ **STATE.md** - Agents List table + Component Counts
3. ✅ **README.md** - "The X Agents" section + table
4. ✅ **commands/help.md** - "THE X AGENTS" header + agent sections (L1/L2/Operations/Orchestration)
5. ✅ **agents/workflow-orchestrator.md** - "Agents Coordinated" section + invocation table
6. ✅ **tests/structural/test_agents_exist.sh** - REQUIRED_AGENTS array
7. ✅ **tests/test_agents.sh** - REQUIRED_AGENTS array

**CRITICAL: workflow-orchestrator.md must list ALL agents it coordinates!**
- When adding an agent, add it to the appropriate category (L1/L2/Support/Operations)
- Update the "When to Invoke Each Agent" table
- Add orchestration flow if it's a primary workflow agent

When you add/remove a command, it must be updated in:

1. ✅ **CLAUDE.md** - Directory Structure comment (count)
2. ✅ **STATE.md** - Component Counts
3. ✅ **README.md** - Commands count
4. ✅ **commands/help.md** - Commands section (if user-visible)
5. ✅ **tests/structural/test_commands_exist.sh** - REQUIRED_COMMANDS array
6. ✅ **tests/test_commands.sh** - REQUIRED_COMMANDS array

### Verification System

The `./scripts/verify.sh` script automatically checks (7 checks):

✓ **[1/7]** Agent counts consistent (CLAUDE.md, STATE.md, README.md, help.md)
✓ **[2/7]** Command counts consistent (CLAUDE.md, STATE.md, README.md)
✓ **[3/7]** All agents referenced in CLAUDE.md
✓ **[4/7]** All agents referenced in help.md
✓ **[5/7]** All agents in test files
✓ **[6/7]** All commands in test files
✓ **[7/7]** All agents in STATE.md agents list
✓ **[7/7]** **workflow-orchestrator knows all agents it coordinates**

**NEW:** Check 7 ensures the orchestrator stays in sync when agents change!

**If verify.sh passes, your docs are in sync. If it fails, follow the error messages.**

### Documentation Categories

**User-Facing** (affects end users):
- README.md
- GUIDE.md
- EXAMPLES.md
- WORKFLOW.md
- USAGE.md
- commands/help.md

**Developer-Facing** (affects contributors):
- CLAUDE.md (this file)
- STATE.md
- AGENTS.md
- COMMANDS.md
- BACKEND.md
- FRONTEND.md

**Templates** (not direct docs):
- templates/project/*.template
- templates/docs/**

**Generated** (created during workflow, not maintained):
- docs/gaps/*.md (created by gap-analyzer)

---

## What This Is

A multi-agent workflow system. Users describe what they want, Claude orchestrates specialized agents to build it.

**Two-level workflow:**
- L1 (once): Understand → Design → Plan
- L2 (per feature): Build → Test → Verify

---

## Current State

| Metric | Count |
|--------|-------|
| Agents | 16 |
| Commands | 24 |

### Agents

| Agent | Category | Purpose |
|-------|----------|---------|
| intent-guardian | L1 | Define user promises with criticality |
| ux-architect | L1 | Design experience |
| agentic-architect | L1 | Design system with promise mapping |
| implementation-planner | L1 | Create build plan with validation tasks |
| change-analyzer | L1 Support | Assess changes |
| gap-analyzer | L1 Support | Find issues |
| brownfield-analyzer | L1 Support | Scan existing codebases |
| backend-engineer | L2 | Build backend |
| frontend-engineer | L2 | Build frontend |
| test-engineer | L2 | Write tests |
| code-reviewer | L2 Support | Review code |
| debugger | L2 Support | Fix bugs |
| ui-debugger | L2 Support | Debug UI with browser automation |
| acceptance-validator | L2 Validation | Validate promises are kept |
| workflow-orchestrator | Orchestration | Auto-chain agents and quality gates |
| project-ops | Ops | Setup, sync, docs |

### Commands

| Command | Purpose |
|---------|---------|
| /help | Help system |
| /workflow | Enable/disable/status |
| /status | Show progress |
| /next | Continue building |
| /plan | View plans |
| /verify | Verify phase |
| /review | Code review |
| /parallel | Parallel development |
| /design | Design system |
| /project | Project operations |

---

## Repository Structure

```
├── REPO FILES (for maintaining THIS repo, NOT installed)
│   ├── CLAUDE.md              # THIS FILE (repo instructions)
│   ├── README.md              # Repo documentation
│   ├── CHANGELOG.md           # Repo releases
│   ├── version.txt            # Repo version
│   ├── scripts/               # Repo scripts
│   ├── tests/                 # Repo tests
│   └── .github/workflows/     # Repo CI
│
├── INSTALLED FILES (copied to ~/.claude-workflow-agents/)
│   ├── agents/                # Agent definitions (15)
│   ├── commands/              # Command definitions (24)
│   ├── templates/             # User project templates
│   └── version.txt            # Workflow version
│
└── USER TEMPLATES (in templates/, for user projects)
    ├── project/
    │   ├── CLAUDE.md.greenfield.template  # → user's CLAUDE.md (new projects)
    │   ├── CLAUDE.md.brownfield.template  # → user's CLAUDE.md (existing code)
    │   └── README.md.template     # → user's README.md
    ├── docs/
    │   ├── intent/                # → user's /docs/intent/
    │   ├── ux/                    # → user's /docs/ux/
    │   └── architecture/          # → user's /docs/architecture/
    ├── infrastructure/
    │   ├── scripts/verify.sh.template      # → user's scripts/
    │   └── github/workflows/verify.yml.template  # → user's .github/
    └── release/
        ├── CHANGELOG.md.template  # → user's CHANGELOG.md
        └── version.txt.template   # → user's version.txt
```

### What Gets Installed Where

**Global Install (~/.claude-workflow-agents/):**
```bash
~/.claude-workflow-agents/
├── agents/              # From repo agents/
├── commands/            # From repo commands/
├── templates/           # From repo templates/
├── version.txt          # Workflow-agents version
└── bin/                 # Created by install.sh
    ├── workflow-init
    ├── workflow-remove
    ├── workflow-update
    └── workflow-version
```

**NOT Installed (Repo-Specific):**
- CLAUDE.md (this file)
- README.md (repo docs)
- CHANGELOG.md (repo changelog)
- scripts/ (repo scripts)
- tests/ (repo tests)
- .github/ (repo CI)

## Installation Model

**Global Install + Per-Project Activation**

- Install once: `~/.claude-workflow-agents/` (agents, commands, scripts)
- Per project: Just `CLAUDE.md` with workflow markers
- Lightweight: Projects reference global installation

**Commands created by install.sh:**
- `workflow-init` - Initialize project
- `workflow-remove` - Remove from project
- `workflow-update` - Update global install
- `workflow-uninstall` - Remove global install

---

## Adding an Agent

1. Create `agents/new-agent.md`
2. Add to this file's agent table
3. Add to `commands/help.md` agents section
4. Add to `README.md` agents table
5. Add to `tests/structural/test_agents_exist.sh`
6. Run `./scripts/verify.sh`
7. Commit all files together

## Adding a Command

1. Create `commands/new-command.md`
2. Add to this file's command table
3. Add to `commands/help.md` commands section
4. Add to `README.md` commands table
5. Add to `tests/structural/test_commands_exist.sh`
6. Run `./scripts/verify.sh`
7. Commit all files together
