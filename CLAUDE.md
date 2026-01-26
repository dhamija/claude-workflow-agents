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
| Agents | 12 |
| Commands | 23 |

### Agents

| Agent | Category | Purpose |
|-------|----------|---------|
| intent-guardian | L1 | Define user promises |
| ux-architect | L1 | Design experience |
| agentic-architect | L1 | Design system |
| implementation-planner | L1 | Create build plan |
| change-analyzer | L1 Support | Assess changes |
| gap-analyzer | L1 Support | Find issues |
| backend-engineer | L2 | Build backend |
| frontend-engineer | L2 | Build frontend |
| test-engineer | L2 | Write tests |
| code-reviewer | L2 Support | Review code |
| debugger | L2 Support | Fix bugs |
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
├── INSTALLED FILES (copied to ~/.claude/)
│   ├── agents/                # Agent definitions (12)
│   ├── commands/              # Command definitions (23)
│   ├── templates/             # User project templates
│   └── version.txt            # Workflow version
│
└── USER TEMPLATES (in templates/, for user projects)
    ├── project/
    │   ├── CLAUDE.md.template     # → user's CLAUDE.md
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

**Global Install (~/.claude/):**
```bash
~/.claude/
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

- Install once: `~/.claude/` (agents, commands, scripts)
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
