# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**Claude Workflow Agents** is a skills-based workflow system for Claude Code that helps build software systematically. The system operates through:

- **Skills** (domain expertise loaded on-demand)
- **Subagents** (isolated execution environments)
- **Commands** (user-facing slash commands)
- **Templates** (project scaffolding)

The architecture emphasizes **context efficiency** - v3.1 uses ~80 lines + on-demand skills vs. v2.0's 750+ lines loaded every session (90% reduction).

## Core Architecture

### Directory Structure

```
agents/                  # 14 agent definitions (orchestration, planning, building)
commands/                # 27 slash commands (/analyze, /audit, /gap, /fix-gaps, etc.)
templates/
  ├── skills/            # 11 domain expertise skills (workflow, ux-design, frontend, etc.)
  ├── project/           # CLAUDE.md templates (greenfield/brownfield)
  ├── docs/              # Documentation templates (intent, UX, architecture)
  ├── infrastructure/    # Scripts, hooks, CI/CD templates
  └── integrations/      # LLM provider & MCP integrations
bin/                     # Utility scripts (workflow-patch, workflow-update, etc.)
tests/                   # 35+ test scripts for system validation
scripts/                 # Maintenance scripts (release, verify, sync)
```

### Key Components

**Skills System (v3.1 Architecture)**
- Skills are loaded on-demand by Claude when needed
- Located in `templates/skills/` during development
- Deployed to `~/.claude/skills/` on installation
- Each skill is a markdown file with frontmatter (name, description) + expertise content
- Core skills: workflow, ux-design, frontend, backend, testing, validation, debugging, code-quality, brownfield, llm-user-testing, gap-resolver

**Agent System**
- Agents orchestrate complex workflows via Claude's Task tool
- Workflow-orchestrator.md is the main controller (reads other agents on-demand)
- Subagents (code-reviewer, debugger, ui-debugger) run in isolated contexts
- Agents trigger each other automatically - users never invoke manually

**Command System**
- Commands are markdown files with frontmatter in `commands/`
- Symlinked to `~/.claude/commands/` on installation
- Critical commands: /fix-gaps (gap resolution), /llm-user (user testing), /audit (brownfield analysis)

**Template System**
- Brownfield vs. greenfield templates have different workflows
- Templates use `{{VARIABLES}}` replaced during `workflow-init`
- CLAUDE.md templates contain workflow state tracking

## Development Commands

### Testing

```bash
# Run full test suite
./tests/run_all_tests.sh

# Run specific test categories
./tests/structural/test_agents_exist.sh       # Verify agents present
./tests/structural/test_commands_exist.sh     # Verify commands present
./tests/structural/test_directory_structure.sh # Verify structure
./tests/install/test_workflow_init_greenfield.sh  # Test greenfield init
./tests/install/test_workflow_init_brownfield.sh  # Test brownfield init
./tests/content/test_template_completeness.sh # Verify templates complete
./tests/consistency/test_agent_references.sh  # Check cross-references

# Run verification scripts
./scripts/verify.sh        # Comprehensive documentation sync check
./scripts/verify-docs.sh   # Documentation verification only
```

### Installation Testing

```bash
# Test local install (doesn't affect global install)
./install.sh

# Test update mechanism
~/.claude-workflow-agents/bin/workflow-update master

# Test in a project
cd /tmp/test-project
workflow-init
# Verify CLAUDE.md created, type detected correctly
```

### Releasing

```bash
# Bump version
./scripts/release.sh [major|minor|patch]
# This updates version.txt, commits, tags, and pushes

# Or manually:
echo "3.2.0" > version.txt
git add version.txt CHANGELOG.md
git commit -m "chore: bump version to 3.2.0"
git tag -a v3.2.0 -m "Release v3.2.0"
git push origin master --tags
```

### Documentation Maintenance

```bash
# Update system docs after changes
./scripts/update-system-docs.sh

# Verify all documentation is in sync
./scripts/verify-docs.sh

# Check specific consistency
./tests/consistency/test_full_sync.sh
./tests/consistency/test_help_coverage.sh
```

## Critical Development Patterns

### Workflow-Patch System

`bin/workflow-patch` is the smart merge utility that updates project CLAUDE.md files:

**How it works:**
1. Extracts user's custom sections (Project Context, Workflow State)
2. Loads latest template based on project type (greenfield/brownfield)
3. Merges: template structure + user's preserved content
4. Only updates if template version > current version

**Critical bugs to avoid:**
- Line number extraction must handle duplicate section headers
- Use `awk -F:` when parsing `grep -n` output (format: "line:content")
- CONTEXT_END must find FIRST separator AFTER CONTEXT_START (use awk comparison)
- When extracting from user file: use `tail -1` (last match = actual content)
- When replacing in template: use `head -1` (first match = template location)
- Build files with direct reconstruction (header + content + footer), not intermediate sed deletions

**Testing workflow-patch:**
```bash
cd /tmp/test-project
workflow-init  # Creates v3.1 or v3.2 CLAUDE.md
# Manually edit version in CLAUDE.md to simulate old version
workflow-patch  # Should detect update and apply correctly
```

### Workflow-Update System

`bin/workflow-update` (embedded in install.sh) updates the global installation:

**Critical requirements:**
- Must refresh symlinks in `~/.claude/commands/` after update (ensures new commands appear)
- Must refresh symlinks in `~/.claude/agents/` after update
- Must copy new skills from `templates/skills/` to `~/.claude/skills/`
- Must preserve generated bin scripts (workflow-update itself, workflow-version, etc.)
- Must install NEW bin scripts from repo (workflow-patch, workflow-fix-hooks, workflow-refresh)

**Testing workflow-update:**
```bash
# Make changes to commands/fix-gaps.md
git add commands/fix-gaps.md && git commit -m "test: update fix-gaps" && git push
workflow-update master
ls -la ~/.claude/commands/fix-gaps.md  # Should show updated timestamp
```

### Version Management

Version appears in THREE places that must stay in sync:
1. `version.txt` - Source of truth
2. Templates (`CLAUDE.md.*.template`) - workflow.version field
3. README.md - Multiple mentions

When bumping version:
```bash
echo "3.2.0" > version.txt
# Update all templates: grep -r "version: 3.1" templates/project/
# Update README.md: "Version: 3.1.0" → "Version: 3.2.0"
```

### Skills Development

Skills are the core domain expertise. When modifying skills:

**Structure:**
```markdown
---
name: skill-name
description: Brief description
---

# Skill Content

[Expertise, principles, protocols]
```

**Testing skill changes:**
```bash
# Skills are copied to ~/.claude/skills/ on install
# After modifying templates/skills/workflow/SKILL.md:
workflow-update master  # Refreshes skills
# Or manually: cp -r templates/skills/* ~/.claude/skills/
```

**Skill loading behavior:**
- Claude loads skills automatically based on context
- Skills can reference other skills
- Skills should be self-contained (don't assume other skills loaded)

### Command Development

Commands are slash commands exposed to users.

**Structure:**
```markdown
---
description: What this command does
---

[Detailed instructions for Claude on how to execute this command]
```

**Testing new commands:**
```bash
# After creating commands/my-command.md:
ln -sf $(pwd)/commands/my-command.md ~/.claude/commands/my-command.md
# Now /my-command should be available in Claude Code
```

**Command naming:**
- Use kebab-case: /fix-gaps, /llm-user
- Keep names short and memorable
- Prefix subcommands with parent: /fix-gaps status, /llm-user init

## Important Context for Bug Fixes

### Common Issues

**Issue: New commands not appearing after workflow-update**
- **Root cause:** workflow-update wasn't refreshing symlinks
- **Fix:** Added symlink refresh logic to install.sh (lines 282-337)
- **Test:** Add new command, push, run workflow-update master, verify symlink exists

**Issue: workflow-patch failing with "illegal line count" or "sed command expected"**
- **Root causes:**
  1. Multiple "## Project Context" sections in user's CLAUDE.md
  2. CONTEXT_END calculation getting line BEFORE CONTEXT_START (backwards range)
  3. Missing -F: flag in awk (can't parse grep -n output)
  4. Off-by-one errors in tail commands
- **Fixes:** All fixed in commits aa1c1df, b969680, 8a01723, 8a06d52
- **Test:** Create CLAUDE.md with duplicate sections, run workflow-patch

**Issue: Skills not loading**
- **Check:** ls ~/.claude/skills/ should show 11 directories
- **Fix:** workflow-update master OR cp -r templates/skills/* ~/.claude/skills/

### Testing Discipline

**Before committing changes to core systems (workflow-patch, workflow-update, install.sh):**

1. Test in clean environment:
   ```bash
   cd /tmp && mkdir test-workflow && cd test-workflow
   curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
   workflow-init
   ```

2. Test update path:
   ```bash
   # From your dev repo:
   git add . && git commit -m "test" && git push
   # From clean environment:
   workflow-update master
   # Verify changes applied
   ```

3. Test workflow-patch:
   ```bash
   # Simulate old version
   sed -i '' 's/version: 3.2/version: 3.1/' CLAUDE.md
   workflow-patch
   # Should detect 3.1 → 3.2 and update
   ```

4. Run test suite:
   ```bash
   ./tests/run_all_tests.sh
   ```

### Documentation Standards

**When adding new features:**
1. Add to appropriate command (commands/*.md)
2. Add to appropriate skill (templates/skills/*/SKILL.md)
3. Update README.md commands reference
4. Update templates if workflow changes
5. Add tests to verify feature works
6. Run `./scripts/verify-docs.sh`

**Documentation hierarchy:**
- README.md - User-facing overview
- GUIDE.md - Detailed user guide
- WORKFLOW.md - Technical workflow details
- AGENTS.md - Agent reference (legacy)
- COMMANDS.md - Command reference
- PATTERNS.md - Common usage patterns
- EXAMPLES.md - Example conversations

### Shell Script Conventions

**All shell scripts should:**
- Use `set -e` (exit on error)
- Define colors at top if using colored output
- Use `$(command)` not backticks
- Quote variables: `"$VAR"` not `$VAR`
- Use absolute paths when possible
- Provide usage instructions
- Return meaningful exit codes

**Testing shell scripts:**
```bash
# Run shellcheck (if available)
shellcheck bin/workflow-patch

# Test all error paths
# Test with missing files
# Test with invalid input
# Test with edge cases (empty files, duplicate sections, etc.)
```

## Git Workflow

**Branch strategy:**
- Main branch: `master`
- All changes go through commits to master
- Tags for releases: `v3.1.0`, `v3.2.0`

**Commit conventions:**
```
feat: Add new command or feature
fix: Bug fix
docs: Documentation updates
chore: Maintenance (version bumps, dependency updates)
test: Test additions or fixes
refactor: Code restructuring without behavior change
```

**Release workflow:**
1. Make changes, commit to master
2. Run `./scripts/release.sh [major|minor|patch]`
3. Script handles: version bump, CHANGELOG update, git tag, push
4. Users update with: `workflow-update`

## Key Files to Understand

**Core system files:**
- `install.sh` - Installation script (generates workflow-update, workflow-init, etc.)
- `bin/workflow-patch` - Smart merge utility for CLAUDE.md updates
- `bin/workflow-update` - Auto-generated by install.sh, clones from GitHub
- `agents/workflow-orchestrator.md` - Main orchestration agent
- `templates/skills/workflow/SKILL.md` - Workflow orchestration skill

**Template files:**
- `templates/project/CLAUDE.md.greenfield.template` - New projects
- `templates/project/CLAUDE.md.brownfield.template` - Existing codebases
- `templates/project/CLAUDE.md.minimal*.template` - Compact versions for workflow-init

**Critical utilities:**
- `tests/run_all_tests.sh` - Master test runner
- `scripts/verify-docs.sh` - Documentation sync checker
- `scripts/release.sh` - Release automation

## Common Development Tasks

**Adding a new command:**
```bash
# 1. Create command file
vim commands/my-command.md
# Add frontmatter and instructions

# 2. Test locally
ln -sf $(pwd)/commands/my-command.md ~/.claude/commands/my-command.md

# 3. Update documentation
# Add to README.md Commands Reference section

# 4. Commit and push
git add commands/my-command.md README.md
git commit -m "feat: add /my-command for X"
git push
```

**Adding a new skill:**
```bash
# 1. Create skill directory and file
mkdir -p templates/skills/my-skill
vim templates/skills/my-skill/SKILL.md
# Add frontmatter (name, description) and expertise

# 2. Update installation script
# Add 'my-skill' to skill list in install.sh (line ~314, ~441, ~953)

# 3. Test locally
cp -r templates/skills/my-skill ~/.claude/skills/

# 4. Update documentation
# Add to README.md Skills Reference section

# 5. Commit and push
git add templates/skills/my-skill install.sh README.md
git commit -m "feat: add my-skill for X"
git push
```

**Fixing a workflow-patch bug:**
```bash
# 1. Reproduce the issue
cd /tmp/test && workflow-init
# Manually create conditions that trigger bug

# 2. Fix bin/workflow-patch

# 3. Test fix locally
bash bin/workflow-patch  # Should work now

# 4. Deploy to global install for further testing
rm -f ~/.claude-workflow-agents/bin/workflow-patch
cp bin/workflow-patch ~/.claude-workflow-agents/bin/workflow-patch

# 5. Test in actual project
cd /tmp/test && workflow-patch  # Should work

# 6. Commit and push
git add bin/workflow-patch
git commit -m "fix: workflow-patch handles X correctly"
git push
```

**Updating a template:**
```bash
# 1. Edit template
vim templates/project/CLAUDE.md.greenfield.template

# 2. Bump version if needed
# If adding new features, increment workflow.version in template

# 3. Update corresponding brownfield template (keep in sync)
vim templates/project/CLAUDE.md.brownfield.template

# 4. Test workflow-patch picks up changes
cd /tmp/test && workflow-init
# Simulate old version, run workflow-patch

# 5. Commit
git add templates/project/
git commit -m "feat: add X to templates"
git push
```

## When Things Break

**Installation not working:**
```bash
# Check global install
ls ~/.claude-workflow-agents/
ls ~/.claude/skills/
ls ~/.claude/commands/
ls ~/.claude/agents/

# Reinstall
workflow-uninstall
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
```

**Commands not appearing:**
```bash
# Check symlinks
ls -la ~/.claude/commands/ | grep workflow-agents

# Refresh symlinks
workflow-refresh

# Or manually
for f in ~/.claude-workflow-agents/commands/*.md; do
  ln -sf "$f" ~/.claude/commands/$(basename "$f")
done
```

**workflow-patch not working:**
```bash
# Check CLAUDE.md has workflow marker
grep "WORKFLOW ACTIVE" CLAUDE.md

# Check version detection
grep "version:" CLAUDE.md

# Run with debug output
bash -x ~/.claude-workflow-agents/bin/workflow-patch
```

**Tests failing:**
```bash
# Run specific failing test
bash -x ./tests/structural/test_agents_exist.sh

# Check test expectations match reality
# Tests are in tests/ with descriptive names
# Each test is self-contained and can be read/modified
```

## Philosophy

**Context efficiency:** Keep runtime context minimal. Load expertise on-demand via skills.

**User simplicity:** Users just describe what they want. Claude handles orchestration automatically.

**Maintainability:** Clear separation: skills (expertise), agents (orchestration), commands (user interface), templates (scaffolding).

**Testing:** Every core system component has tests. Run `./tests/run_all_tests.sh` before releases.

**Self-maintenance:** The system should work reliably. workflow-update, workflow-patch, workflow-init must be bulletproof - they're the update mechanism.
