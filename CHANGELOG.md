# Changelog

All notable changes to claude-workflow-agents.

Format: [Semantic Versioning](https://semver.org/)

---

## [2.0.0] - 2026-01-26

### BREAKING CHANGES

**Self-Contained CLAUDE.md Templates Architecture**

The orchestration system has been completely redesigned for reliability. CLAUDE.md templates now contain ALL orchestration logic embedded directly, eliminating dependency on external files.

### What Changed

**Before (v1.x):**
- CLAUDE.md had HTML comment: `<!-- READ orchestrator.md -->`
- Relied on Claude reading external files (unreliable)
- HTML comments could be ignored
- Orchestration was "wishful thinking"

**After (v2.0):**
- ALL orchestration logic embedded in CLAUDE.md templates (750+ lines each)
- Self-contained, no external dependencies
- Guaranteed to work
- workflow-orchestrator.md is now contributor documentation only

### Added

- **workflow-update** command - Update workflow system from git repository
  - Pulls latest changes
  - Updates agents, commands, and templates in `~/.claude-workflow-agents/`
  - Recreates symlinks if new agents/commands added
  - Offers to run workflow-patch if in project directory

- **workflow-patch** command - Smart merge of template updates into user CLAUDE.md
  - Detects CLAUDE.md version and type (greenfield/brownfield)
  - **Preserves user data:**
    - Project name and description
    - Workflow state (progress, features, promises)
    - Project context (decisions, notes)
  - **Updates orchestration logic:**
    - Quick Reference tables
    - L1/L2 orchestration flows
    - Issue response protocols
    - Quality gates
    - Design principles
  - **Safety features:**
    - Creates timestamped backup
    - Shows diff preview
    - Requires confirmation
    - Easy rollback

### Changed

- **templates/project/CLAUDE.md.greenfield.template** (793 lines)
  - Embedded complete L1 orchestration flow (Intent → UX → Architecture → Planning)
  - Embedded complete L2 orchestration flow (Backend → Frontend → Testing → Verification)
  - Embedded change request handling (change-analyzer integration)
  - Embedded issue response protocols (debugger, ui-debugger flows)
  - Embedded quality gates (automatic enforcement)
  - Embedded design principles (auto-applied)
  - All operational logic self-contained

- **templates/project/CLAUDE.md.brownfield.template** (795 lines)
  - Embedded brownfield analysis flow (brownfield-analyzer)
  - Embedded gap analysis flow (gap-analyzer)
  - Same L2/quality/issue handling as greenfield
  - All operational logic self-contained

- **agents/workflow-orchestrator.md**
  - Converted to **contributor documentation only**
  - Documents orchestration system architecture for maintainers
  - NOT read by Claude during normal operation
  - Explains template system, agent coordination, maintenance

### Migration Guide

**For users updating from v1.x:**

```bash
# 1. Update workflow system globally
workflow-update

# 2. For EACH project with workflow-enabled CLAUDE.md:
cd /path/to/project
workflow-patch

# 3. Review changes
git diff CLAUDE.md

# 4. Test orchestration works correctly

# 5. Commit updated CLAUDE.md
git add CLAUDE.md
git commit -m "chore: update to workflow v2.0 self-contained template"
```

### Benefits

- **Reliability**: Orchestration guaranteed to work (no external dependencies)
- **Simplicity**: All logic in one place, easier to understand
- **Maintainability**: Templates are source of truth
- **Safety**: Smart patching preserves user customizations
- **Transparency**: Diff preview shows exactly what changes

### Documentation

- Added "Template Architecture (v2.0)" section to CLAUDE.md
- Added "User Update Workflow" section to CLAUDE.md
- Updated README.md with v2.0 update process
- Updated STATE.md with v2.0 release notes

---

## [1.3.0] - 2026-01-25

### Changed
- **Simplified to Global-Only Model** - Removed per-project concepts
  - **Removed commands**: `workflow-init`, `workflow-remove` (no longer needed)
  - **Added command**: `workflow-toggle on/off/status` for global enable/disable
  - Installation automatically enables workflow globally
  - No per-project setup required
  - CLAUDE.md markers removed (were non-functional)

### Rationale
- Claude Code loads agents globally from `~/.claude/` only
- Project-local `.claude/` directories don't work reliably for agents
- Per-project enable/disable was confusing and non-functional
- Simpler user experience: install once, use everywhere

### Migration
- Existing users: No action needed, workflow continues to work
- CLAUDE.md markers (`<!-- workflow: enabled -->`) can be safely removed
- Use `workflow-toggle off` to disable globally if needed

---

## [1.2.0] - 2026-01-25

### Changed
- **Installation with Individual File Symlinks** - Clean coexistence with user's own files
  - Installs to `~/.claude-workflow-agents/` (keeps files separate)
  - Creates individual symlinks in `~/.claude/`:
    - Each workflow agent: `~/.claude/agents/agent-name.md` → `~/.claude-workflow-agents/agents/agent-name.md`
    - Each workflow command: `~/.claude/commands/command.md` → `~/.claude-workflow-agents/commands/command.md`
  - User's own agents/commands coexist in same directories
  - Toggle on/off with `workflow-toggle` command
  - Disable removes only workflow symlinks, preserves user files
  - Uninstall removes symlinks and installation directory
  - Never mixes workflow files with Claude Code's own data

---

## [1.1.0] - 2026-01-25

### Added
- **Template System** - 27 templates for user projects
  - `templates/project/` - User project files (CLAUDE.md, README.md)
  - `templates/docs/` - Documentation templates (intent, ux, architecture)
  - `templates/infrastructure/` - User project infrastructure (scripts, CI)
  - `templates/release/` - Version control templates (CHANGELOG.md, version.txt)
- **New Tests**
  - `test_separation.sh` - Verifies repo/template file separation
  - `test_install_separation.sh` - Verifies only correct files installed
- **Template Usage Documentation** in project-ops.md with examples

### Changed
- **Clear Separation** - Repo files vs user templates
  - Repo CLAUDE.md now clearly marked as "for maintaining THIS repository"
  - User projects get CLAUDE.md from templates/project/CLAUDE.md.template
- **Install System** - Only copies necessary files to global location
  - Installs: agents/, commands/, templates/, version.txt
  - Excludes: repo CLAUDE.md, README.md, tests/, scripts/, .github/
- **workflow-init** - Now uses templates with variable substitution
  - Supports {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{DATE}}
  - Shows helpful message about on-demand file creation

### Fixed
- test_utils.sh pass/fail functions now return proper exit codes

---

## [1.0.0] - 2026-01-25

### Added

**Agents (12)**
- intent-guardian - Define user promises
- ux-architect - Design user experience and design system
- agentic-architect - Design system architecture
- implementation-planner - Create build plans
- change-analyzer - Assess change impact
- gap-analyzer - Find issues in existing code
- backend-engineer - Build APIs and services
- frontend-engineer - Build UI components (follows design system)
- test-engineer - Write and run tests
- code-reviewer - Review code quality
- debugger - Fix bugs
- project-ops - Setup, sync, docs, AI integration, git workflow

**Commands (23)**
- /help - Help system with topics (workflow, agents, commands, patterns, git, parallel, brownfield, examples)
- /workflow - Enable/disable/status workflow
- /project - Project operations (setup, sync, verify, docs, ai, mcp, status, commit, push, pr)
- /analyze - Run all L1 analysis agents
- /audit - Audit existing codebase
- /plan - Generate implementation plans
- /replan - Regenerate plans after changes
- /implement - Implement features
- /verify - Verify phase
- /review - Code review
- /debug - Launch debugger
- /intent - Define product intent
- /intent-audit - Audit implementation vs intent
- /ux - Design user experience
- /ux-audit - Audit user experience
- /aa - Agentic architecture analysis
- /aa-audit - Audit agentic optimizations
- /gap - Find gaps and create migration plan
- /improve - Improve based on migration plan
- /change - Analyze change impact
- /design - Design system management
- /parallel - Parallel development
- /update - Update system state

**Install System**
- Global install to `~/.claude-workflow-agents/`
- Per-project activation with `workflow-init`
- Enable/disable toggle in CLAUDE.md
- Preserves user content on all operations
- Lightweight: Projects only contain CLAUDE.md markers

**Terminal Commands**
- `workflow-init` - Initialize project
- `workflow-remove` - Remove from project
- `workflow-update` - Update installation
- `workflow-uninstall` - Remove installation

**Git Workflow**
- Conventional commit format (feat/fix/refactor/docs/test/chore)
- Branch naming conventions (type/description)
- `/project commit` - Guided conventional commits
- `/project push` - Push current branch
- `/project pr` - Create pull request (with/without GitHub MCP)
- GitHub MCP integration for automatic PR creation

**Two-Level Workflow**
- L1 (App): Intent → UX → Architecture → Plans
- L2 (Feature): Backend → Frontend → Tests → Verify
- Automatic agent orchestration
- Natural language interface

**Design System**
- Presets: modern-clean, minimal, playful, corporate, glassmorphism
- Reference-based design from URLs
- Automatic integration with frontend-engineer
- Visual specifications (colors, typography, components)

**Brownfield Support**
- Audit mode: Infer intent/UX/architecture from existing code
- Gap analysis: Find critical/high/medium/low priority issues
- Migration plan: Prioritized improvement roadmap
- Incremental fixes: Phase-by-phase improvements

**Documentation**
- Automatic sync between code and docs
- Intent tracking: Promise verification
- UX tracking: Journey implementation status
- Architecture compliance checking
- Test coverage reporting

**Verification System**
- Pre-commit hooks (optional)
- CI/CD workflows (optional)
- Documentation drift detection
- Intent compliance checking
- Test coverage validation

### Infrastructure
- 12 specialized agents
- 23 slash commands
- 24 automated tests
- Global installation model
- Version tracking system
- Update mechanism
