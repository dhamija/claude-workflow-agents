# Claude Workflow Agents - Repository

> **Instructions for maintaining THIS repository.**
> **This file is NOT installed to user systems.**

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
├── agents/                          # 15 agent definitions
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
│   └── ... (15 total)
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

## Maintenance Rules

After changing `agents/` or `commands/`:
1. Update this file (Current State section)
2. Update `commands/help.md`
3. Update `README.md`
4. Update tests

**Verify:** `./scripts/verify.sh`
**CI will fail if docs are out of sync.**

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
| Agents | 15 |
| Commands | 24 |

### Agents

| Agent | Category | Purpose |
|-------|----------|---------|
| intent-guardian | L1 | Define user promises |
| ux-architect | L1 | Design experience |
| agentic-architect | L1 | Design system |
| implementation-planner | L1 | Create build plan |
| change-analyzer | L1 Support | Assess changes |
| gap-analyzer | L1 Support | Find issues |
| brownfield-analyzer | L1 Support | Scan existing codebases |
| backend-engineer | L2 | Build backend |
| frontend-engineer | L2 | Build frontend |
| test-engineer | L2 | Write tests |
| code-reviewer | L2 Support | Review code |
| debugger | L2 Support | Fix bugs |
| ui-debugger | L2 Support | Debug UI with browser automation |
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
