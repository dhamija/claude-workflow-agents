# Project State

> **Auto-updated by**: `./scripts/update-claude-md.sh`
>  **Last updated**: 2026-01-28

## Component Counts (v3.2)

| Component | Count | Last Changed |
|-----------|-------|--------------|
| Skills | 11 | 2026-01-28 |
| Subagents | 3 | 2026-01-28 |
| Agent Files (for Task tool invocation) | 17 | 2026-01-29 |
| Commands | 29 | 2026-01-31 |
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
| solution-iterator | L2 Support | ✓ Complete |

**Note:** llm-user-architect was removed in v3.3.1 - functionality now in `llm-user-testing` skill.

## Commands List

| Command | Status |
|---------|--------|
| aa | ✓ Complete |
| aa-audit | ✓ Complete |
| analyze | ✓ Complete |
| audit | ✓ Complete |
| auto | ✓ Complete |
| change | ✓ Complete |
| debug | ✓ Complete |
| design | ✓ Complete |
| gap | ✓ Complete |
| help | ✓ Complete |
| implement | ✓ Complete |
| improve | ✓ Complete |
| intent | ✓ Complete |
| intent-audit | ✓ Complete |
| iterate | ✓ Complete |
| llm-user | ✓ Complete |
| parallel | ✓ Complete |
| plan | ✓ Complete |
| project | ✓ Complete |
| reality-audit | ✓ Complete |
| recover | ✓ Complete |
| replan | ✓ Complete |
| review | ✓ Complete |
| update | ✓ Complete |
| ux | ✓ Complete |
| ux-audit | ✓ Complete |
| verify | ✓ Complete |
| workflow | ✓ Complete |
| workflow-plan | ✓ Complete |

## Recent Changes

| Date | Change | By |
|------|--------|-----|
| 2026-01-30 | **UNIFIED GAP SYSTEM:** Consolidated 3 parallel gap workflows into single system | Claude |
| 2026-01-30 | All gap discovery writes to unified format (GAP-[SOURCE]-[NUMBER]) | Claude |
| 2026-01-30 | Enhanced /improve to handle all gap types (reality, user, analysis) | Claude |
| 2026-01-30 | Created smart /verify with automatic method selection per gap type | Claude |
| 2026-01-30 | Updated /reality-audit to write GAP-R-XXX gaps | Claude |
| 2026-01-30 | Updated /gap to write GAP-A-XXX gaps | Claude |
| 2026-01-30 | Updated /llm-user test to write GAP-U-XXX gaps | Claude |
| 2026-01-30 | Updated /recover to use unified gap commands | Claude |
| 2026-01-30 | Deprecated /llm-user fix in favor of unified /improve | Claude |
| 2026-01-31 | **PLANNING-FIRST PRINCIPLE:** Created mandatory workflow planning | Claude |
| 2026-01-31 | Added /workflow-plan command for explicit planning before implementation | Claude |
| 2026-01-31 | Enhanced workflow skill with planning requirements and state tracking | Claude |
| 2026-01-31 | Added planning verification checklist to prevent ad-hoc coding | Claude |
| 2026-01-30 | Created unified gap repository structure at docs/gaps/ | Claude |
| 2026-01-28 | Added skill version tracking for artifact regeneration (`ui_testing.skill_version`) | Claude |
| 2026-01-28 | Added scene-grounded responses to llm-user-testing skill (v1.1.0) | Claude |
| 2026-01-28 | Consolidated /test-ui and /fix-gaps into /llm-user (27→25 commands) | Claude |
| 2026-01-28 | Added LLM User Testing Architecture section to CLAUDE.md | Claude |
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
