# Project State

> **Auto-updated by**: `./scripts/update-claude-md.sh`
>  **Last updated**: 2026-01-27

## Component Counts (v2.1)

| Component | Count | Last Changed |
|-----------|-------|--------------|
| Skills | 9 | 2026-01-27 |
| Subagents | 3 | 2026-01-27 |
| Agent Files (for Task tool invocation) | 16 | 2026-01-26 |
| Commands | 24 | 2026-01-26 |
| Templates | 27 | 2026-01-25 |
| Help Topics | 13 | 2026-01-26 |
| Tests | 32 | 2026-01-26 |

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
| ui-debugger | L2 Support | ✓ Complete |
| workflow-orchestrator | Orchestration | ✓ Complete |
| brownfield-analyzer | L1 Support | ✓ Complete |
| acceptance-validator | L2 Validation | ✓ Complete |
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
| 2026-01-26 | **v2.0.0 RELEASE:** Self-contained CLAUDE.md templates architecture | Claude |
| 2026-01-26 | BREAKING: Embedded all orchestration logic in CLAUDE.md templates (750+ lines each) | Claude |
| 2026-01-26 | workflow-orchestrator.md converted to contributor documentation only | Claude |
| 2026-01-26 | Created workflow-patch command for safe CLAUDE.md updates with diff preview | Claude |
| 2026-01-26 | Created workflow-update command with automatic patch offering | Claude |
| 2026-01-26 | Templates now self-contained: no external file dependencies required | Claude |
| 2026-01-26 | Added smart section extraction preserving user customizations | Claude |
| 2026-01-26 | Added automatic backup system for CLAUDE.md patching | Claude |
| 2026-01-26 | Added intent-to-validation traceability system (promises, acceptance, validation) | Claude |
| 2026-01-26 | Added MCP auto-enable protocol for ui-debugger (automatic puppeteer setup) | Claude |
| 2026-01-26 | Added comprehensive agent utilization instructions to CLAUDE.md templates | Claude |
| 2026-01-26 | Added automatic quality gates (code-reviewer after code, tests after steps) | Claude |
| 2026-01-26 | Added issue response protocols (debugger keyword detection, auto-invocation) | Claude |
| 2026-01-26 | Created workflow initialization system (workflow-init detects greenfield/brownfield) | Claude |
| 2026-01-26 | Created brownfield-analyzer agent (scans existing code, infers state) | Claude |
| 2026-01-26 | Added session resume protocol to workflow-orchestrator | Claude |
| 2026-01-26 | Created CLAUDE.md.greenfield.template and CLAUDE.md.brownfield.template | Claude |
| 2026-01-26 | Added state tracking (quality gates, CI status, open issues) | Claude |
| 2026-01-26 | Added workflow orchestrator for automatic agent chaining | Claude |
| 2026-01-26 | Added UI debugger agent with browser automation (puppeteer MCP) | Claude |
| 2026-01-25 | Changed installation path to ~/.claude-workflow-agents/ (where Claude Code looks) | Claude |
| 2026-01-25 | Separated repo files from user templates (templates/ directory) | Claude |
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
