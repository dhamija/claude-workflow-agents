# Changelog

All notable changes to claude-workflow-agents.

Format: [Semantic Versioning](https://semver.org/)

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
- **Install System** - Only copies necessary files to ~/.claude-workflow-agents/
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
