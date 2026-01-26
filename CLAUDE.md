# Claude Workflow Agents

> Multi-agent workflow system for Claude Code

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
| /release | Release new version (maintainers) |

---

## Repository Structure

```
├── agents/           # Agent definitions (12)
├── commands/         # Command definitions (23)
├── templates/        # User project templates
├── scripts/
│   ├── verify.sh     # Verify docs in sync
│   └── fix-sync.sh   # Helper for fixing
├── tests/            # Automated tests
├── .github/workflows/# CI (actual enforcement)
├── install.sh        # Global installer
├── version.txt       # Current version
├── CLAUDE.md         # This file
├── README.md         # User documentation
└── GUIDE.md          # Quick reference
```

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
