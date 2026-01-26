# Project State

> **Auto-updated by**: `./scripts/update-claude-md.sh`
>  **Last updated**: 2026-01-25 18:30:00

## Component Counts

| Component | Count | Last Changed |
|-----------|-------|--------------|
| Agents | 12 | 2026-01-25 |
| Commands | 23 | 2026-01-25 |
| Help Topics | 12 | 2026-01-25 |
| Tests | 24 | 2026-01-25 |

## Agents List

| Agent | Category | Status |
|-------|----------|--------|
| intent-guardian | L1 Analysis | ✓ Complete |
| ux-architect | L1 Analysis | ✓ Complete |
| agentic-architect | L1 Analysis | ✓ Complete |
| implementation-planner | L1 Analysis | ✓ Complete |
| change-analyzer | L1 Support | ✓ Complete |
| gap-analyzer | L1 Support | ✓ Complete |
| backend-engineer | L2 Building | ✓ Complete |
| frontend-engineer | L2 Building | ✓ Complete |
| test-engineer | L2 Building | ✓ Complete |
| code-reviewer | L2 Support | ✓ Complete |
| debugger | L2 Support | ✓ Complete |
| project-ops | Operations | ✓ Complete |

## Commands List

| Command | Status |
|---------|--------|
| agent-wf-help | ✓ Complete |
| analyze | ✓ Complete |
| audit | ✓ Complete |
| change | ✓ Complete |
| debug | ✓ Complete |
| design | ✓ Complete |
| docs | ✓ Complete |
| gap | ✓ Complete |
| implement | ✓ Complete |
| improve | ✓ Complete |
| intent | ✓ Complete |
| intent-audit | ✓ Complete |
| llm | ✓ Complete |
| parallel | ✓ Complete |
| plan | ✓ Complete |
| replan | ✓ Complete |
| review | ✓ Complete |
| sync | ✓ Complete |
| update | ✓ Complete |
| ux | ✓ Complete |
| ux-audit | ✓ Complete |
| verify | ✓ Complete |
| workflow | ✓ Complete |
| aa | ✓ Complete |
| aa-audit | ✓ Complete |
| mcp | ✓ Complete |

## Recent Changes

| Date | Change | By |
|------|--------|-----|
| 2026-01-25 | Added git workflow conventions to project-ops agent | Claude |
| 2026-01-25 | Added /project commit, /project push, /project pr subcommands | Claude |
| 2026-01-25 | Added /help git topic with conventional commits and branch naming | Claude |
| 2026-01-25 | Created test_git_workflow_docs.sh test (24 tests total) | Claude |
| 2026-01-25 | Global install system with per-project activation | Claude |
| 2026-01-25 | Added /workflow command for enable/disable toggle | Claude |
| 2026-01-25 | Created bin/ commands: workflow-init, workflow-remove, workflow-update, workflow-uninstall | Claude |
| 2026-01-25 | Removed per-project tests, simplified to global install | Claude |
| 2026-01-25 | Added version.txt for version tracking | Claude |

## Installation Model

**Global + Per-Project:**
- Install once to `~/.claude-workflow-agents/`
- Per-project: `workflow-init` adds markers to CLAUDE.md
- Lightweight: Projects reference global installation
- Commands in PATH: `workflow-init`, `workflow-remove`, `workflow-update`, `workflow-uninstall`

## Test Results

| Date | Result | Notes |
|------|--------|-------|
| 2026-01-25 | ✓ Pass | All structural and content tests passing |

## Known Issues

None currently

## Planned Work

- [ ] None currently
