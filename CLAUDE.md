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
| Commands | 22 |

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
| /analyze | Run all L1 agents |
| /audit | Audit existing code |
| /plan | View/create plans |
| /implement | Build features |
| /verify | Verify phase complete |
| /review | Code review |
| /debug | Fix issues |
| /change | Assess change impact |
| /gap | Find gaps (brownfield) |
| /improve | Fix gaps |
| /intent | Define product intent |
| /intent-audit | Audit intent compliance |
| /ux | Design user experience |
| /ux-audit | Audit UX |
| /aa | Design agent system |
| /aa-audit | Audit agent opportunities |
| /parallel | Parallel development |
| /design | Manage design system |
| /update | Update docs after changes |
| /replan | Regenerate plans |
| /project | Project operations |

---

## Repository Structure

```
├── agents/           # Agent definitions (12)
├── commands/         # Command definitions (22)
├── templates/        # User project templates
├── scripts/
│   ├── verify.sh     # Verify docs in sync
│   └── fix-sync.sh   # Helper for fixing
├── tests/            # Automated tests
├── .github/workflows/# CI (actual enforcement)
├── CLAUDE.md         # This file
├── README.md         # User documentation
└── GUIDE.md          # Quick reference
```

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

---

## Workflow

When users start Claude Code in a project with this system installed:

1. **Natural conversation**: User describes what they want
2. **Auto-orchestration**: Claude selects and runs appropriate agents
3. **L1 (once)**: Create intent, UX design, architecture, build plans
4. **L2 (per feature)**: Implement, test, verify, repeat
5. **Continuous**: Sync state, review code, fix issues as needed

Users don't call agents directly - they talk naturally. Commands are shortcuts for common operations.

---

## For User Projects

When users run `./install.sh --project`, a simplified CLAUDE.md is created in their project with:
- Workflow status (enabled/disabled)
- Feature progress tracking
- Current task and next steps
- Session continuity notes

This maintains state across sessions and guides Claude's work.
