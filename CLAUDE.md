# Claude Workflow Agents - Repository

> **v3.1 Architecture:** Skills + Hooks + Subagents. 11 skills loaded on-demand, 3 subagents for isolated tasks, minimal CLAUDE.md (~80 lines). 90% context reduction.

> **Instructions for maintaining THIS repository.**
> **This file is NOT installed to user systems.**

---

## 🚨 CLAUDE: READ THIS FIRST

**Before making ANY changes to this repository:**

1. Read the [MANDATORY MAINTENANCE PROTOCOL](#️-mandatory-maintenance-protocol) section below
2. After changes to `agents/` or `commands/`, you MUST run `./scripts/verify.sh`
3. Do NOT commit until verify.sh passes - CI will fail otherwise

---

## ⚠️ Important Distinction

| This Repo | User Projects |
|-----------|---------------|
| **CLAUDE.md** (this file) | **templates/project/CLAUDE.md.template** |
| For maintaining workflow-agents | For user projects |
| NOT installed | Installed and customized |

**Never confuse repo files with user templates!**

---

## Installation Architecture (v3.1)

**Skills + Hooks + Subagents Architecture**

### Directory Structure

```
~/.claude-workflow-agents/           # Installation directory
├── agents/                          # 17 agent files (invoked by workflow via Task tool)
├── commands/                        # 28 command definitions
├── lib/                             # Shared configuration and functions
│   └── config.sh                    # SINGLE SOURCE OF TRUTH for all scripts
├── templates/                       # Templates for user projects
│   ├── project/                     # Project bootstrap templates
│   │   ├── CLAUDE.md.minimal.template (greenfield, ~80 lines)
│   │   └── CLAUDE.md.minimal-brownfield.template (~80 lines)
│   ├── skills/                      # 11 skill templates
│   │   ├── workflow/, ux-design/, frontend/, backend/
│   │   ├── testing/, validation/, debugging/, gap-resolver/
│   │   └── code-quality/, brownfield/, llm-user-testing/
│   └── hooks/                       # Hooks configuration template
│       └── settings.json.template
├── bin/                            # CLI commands (all source lib/config.sh)
│   ├── workflow-init               # Initialize project
│   ├── workflow-toggle             # Enable/disable globally
│   ├── workflow-update             # Update from git
│   ├── workflow-uninstall          # Remove installation
│   └── workflow-version            # Show version
└── version.txt                     # Current version (3.2.0)

~/.claude/                           # Claude Code's directory
├── skills/                          # 11 skills (loaded on-demand by Claude)
│   ├── workflow/, ux-design/, frontend/, backend/
│   ├── testing/, validation/, debugging/, gap-resolver/
│   └── code-quality/, brownfield/, llm-user-testing/
├── agents/                          # 3 subagents (isolated context)
│   ├── code-reviewer.md -> ~/.claude-workflow-agents/agents/code-reviewer.md
│   ├── debugger.md -> ~/.claude-workflow-agents/agents/debugger.md
│   └── ui-debugger.md -> ~/.claude-workflow-agents/agents/ui-debugger.md
└── commands/                        # 28 command symlinks
    ├── analyze.md -> ~/.claude-workflow-agents/commands/analyze.md
    ├── plan.md -> ~/.claude-workflow-agents/commands/plan.md
    └── ... (28 total)
```

### How It Works (v3.2)

1. **Install** (`install.sh`):
   - Downloads to `~/.claude-workflow-agents/`
   - **Copies 11 skills to `~/.claude/skills/`** (loaded on-demand by Claude)
   - **Symlinks 3 subagents to `~/.claude/agents/`** (code-reviewer, debugger, ui-debugger)
   - Symlinks 25 commands to `~/.claude/commands/`
   - Adds bin/ commands to PATH
   - Workflow immediately active for all projects

2. **Init Project** (`workflow-init`):
   - Detects greenfield vs brownfield (code indicators)
   - Creates minimal CLAUDE.md (~80 lines, state only)
   - Optionally sets up hooks (.claude/settings.json)
   - Preserves existing CLAUDE.md content if present

3. **Enable/Disable** (`workflow-toggle on|off|status`):
   - **Global operation** - affects all Claude Code sessions
   - `on`: Creates skills + subagent symlinks
   - `off`: Removes only workflow files, preserves user's own
   - `status`: Shows count of skills/subagents/commands

4. **Update** (`workflow-update`):
   - Pulls latest from git
   - Updates skills in `~/.claude/skills/`
   - Re-creates subagent symlinks
   - Preserves user's own agents/commands

5. **Uninstall** (`workflow-uninstall`):
   - Removes skills from `~/.claude/skills/`
   - Removes workflow symlinks from `~/.claude/agents/` and `~/.claude/commands/`
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

## 📋 Template Architecture (v1.0 - Self-Contained)

**CRITICAL DESIGN CHANGE:** As of v1.0, orchestration logic is self-contained in user project CLAUDE.md files.

### How Orchestration Works

#### Old Architecture (v0.9 - Broken) ❌

```
User Project CLAUDE.md
   ↓
   HTML comment: "READ workflow-orchestrator.md"
   ↓
   Hope Claude reads it
   ↓
   No enforcement → Can be ignored
```

**Problem:** Claude Code doesn't auto-read external files. HTML comments aren't enforced.

#### New Architecture (v1.0 - Self-Contained) ✓

```
Template: templates/project/CLAUDE.md.greenfield.template
   ↓
   Contains ALL orchestration logic embedded (750+ lines)
   ↓
   workflow-init generates → User Project CLAUDE.md
   ↓
   Self-contained, guaranteed to work
```

**Solution:** Orchestration logic embedded directly in templates. External agent files become optional reference documentation.

### Template Files

**Greenfield Template:** `templates/project/CLAUDE.md.greenfield.template` (793 lines)
- Complete L1 orchestration flow (Intent → UX → Architecture → Planning)
- Complete L2 orchestration flow (Backend → Frontend → Testing → Verification)
- Change request handling (change-analyzer integration)
- Issue response protocols (debugger, ui-debugger flows)
- Quality gates (automatic enforcement)
- Design principles (auto-applied)
- Workflow state tracking (YAML)
- Commands reference

**Brownfield Template:** `templates/project/CLAUDE.md.brownfield.template` (795 lines)
- Brownfield analysis flow (brownfield-analyzer)
- Gap analysis flow (gap-analyzer)
- Complete L2 orchestration (same as greenfield)
- Change request handling (same as greenfield)
- Issue response protocols (same as greenfield)
- Quality gates (same as greenfield)
- Design principles (same as greenfield)
- Workflow state tracking (YAML with analysis phase)

### Role of agents/*.md Files (Changed in v1.0)

**Previous (v0.9):** Required for operation. Claude expected to read these files.

**Current (v1.0):** Optional reference documentation for:
- Contributors understanding system architecture
- Users customizing behavior (reading detailed prompts)
- Debugging agent invocations
- System maintenance

**Exception:** `agents/workflow-orchestrator.md` is now **contributor documentation only**. It documents the orchestration system architecture for maintainers. It is NOT read by Claude during operation.

### How workflow-init Works

1. User runs `workflow-init` in project directory
2. Script detects greenfield (empty/new) or brownfield (existing code)
3. Script selects appropriate template:
   - `CLAUDE.md.greenfield.template` for new projects
   - `CLAUDE.md.brownfield.template` for existing codebases
4. Script replaces template variables:
   - `{{PROJECT_NAME}}` - from directory name or user input
   - `{{PROJECT_DESCRIPTION}}` - from user input
   - `{{DATE}}` - current date
   - `{{WORKFLOW_HOME}}` - `~/.claude-workflow-agents`
5. Script generates `CLAUDE.md` in project root
6. User project now has complete self-contained orchestration

### Template Maintenance

**When to update templates:**
- Adding/removing agents
- Changing orchestration flows
- Modifying quality gates
- Adding new workflow features

**After updating templates:**
1. Update `agents/workflow-orchestrator.md` (contributor docs)
2. Update this file (CLAUDE.md) if architecture changed
3. Run `./scripts/verify-docs.sh`
4. Test with `workflow-init` in test directory
5. Verify Claude follows new flow correctly
6. Commit all changes together

**Important:** Changes to templates do NOT automatically propagate to existing user projects. Users must run `workflow-update` (updates repo) and then `workflow-patch` (merges template changes into their CLAUDE.md).

### User Update Workflow

**Users have two commands for keeping their workflow up to date:**

#### 1. workflow-update (Update the Workflow System)

```bash
# From anywhere (updates the global installation)
workflow-update
```

**What it does:**
- Pulls latest changes from git repository
- Updates `~/.claude-workflow-agents/` with new agents, commands, templates
- Recreates symlinks if new agents/commands were added
- Detects if run from a project directory with CLAUDE.md
- Offers to run `workflow-patch` if updates affect orchestration

**When to run:**
- Periodically to get new features and bug fixes
- After seeing announcement of new workflow version
- When new agents/commands become available

#### 2. workflow-patch (Update Project CLAUDE.md)

```bash
# From project directory
cd /path/to/your/project
workflow-patch
```

**What it does:**
- Detects current CLAUDE.md version and type (greenfield/brownfield)
- Loads corresponding template from updated workflow system
- Extracts user sections (preserves your customizations):
  - Project name and description
  - Workflow state (progress, features, promises)
  - Project context (decisions, notes)
- Replaces template sections (updates orchestration logic):
  - Quick Reference tables
  - Session Start Protocol
  - L1/L2 Orchestration Flows
  - Issue Response Protocols
  - Quality Gates
  - Design Principles
  - Commands Reference
- Shows diff preview
- Requires confirmation
- Creates backup before applying

**Safety features:**
- Automatic backup: `CLAUDE.md.backup-<timestamp>`
- Diff preview before applying
- Can show detailed diff with `[D]` option
- Preserves all user customizations
- Aborts on any errors

**When to run:**
- After running `workflow-update` and seeing template changes
- When new orchestration features become available
- When quality gates or protocols are improved

**Example workflow:**

```bash
# 1. Update workflow system globally
workflow-update

# Output:
#   Updated: 0.9 → 1.0
#   Changes: New gap-analyzer flows, improved quality gates
#   Would you like to patch your CLAUDE.md? [Y/n/l]

# 2. Review and apply patches (if run from project directory)
# Or navigate to project and run manually:
cd ~/my-project
workflow-patch

# Shows diff preview:
#   - Old orchestration flows
#   + New orchestration flows
#
#   Apply patch? [Y/n/d]

# 3. Review changes
git diff CLAUDE.md

# 4. Test that orchestration still works
# Claude Code should now use updated flows

# 5. Delete backup if satisfied
rm CLAUDE.md.backup-20260126-143022
```

**Troubleshooting:**

If patch fails or produces unexpected results:

```bash
# Restore from backup
cp CLAUDE.md.backup-<timestamp> CLAUDE.md

# Report issue with:
# - Your CLAUDE.md version
# - Template version you tried to patch to
# - Error message or unexpected behavior
```

---

## Multi-Agent Workflow System

Multi-agent workflow system for Claude Code

## ⚠️ MANDATORY MAINTENANCE PROTOCOL

**CRITICAL: Claude MUST follow this protocol after ANY change to `agents/` or `commands/`.**

**See [Documentation Dependency Map](#-documentation-dependency-map) for complete file interdependencies.**

### Step-by-Step Checklist

When you add, modify, or remove ANY agent or command file:

1. ✅ **Update CLAUDE.md** (Current State section)
   - Update agent/command counts
   - Add new entries to the tables
   - Remove deleted entries

2. ✅ **Update commands/help.md**
   - Add new agents to appropriate section (L1/L2/Operations/Orchestration)
   - Update agent count in header ("THE X AGENTS")
   - Add new commands to the commands list

3. ✅ **Update README.md**
   - Update agent count (line ~124)
   - Update command count (line ~125)
   - Add new entries to agent/command tables

4. ✅ **Update templates/project/*.template** (CRITICAL!)
   - Add agent to "Agents Available" table in both greenfield and brownfield templates
   - Add trigger keywords to "Issue Detection Keywords" table if applicable
   - Add orchestration flow if it's a primary workflow agent (e.g., gap-analyzer, change-analyzer)
   - Update quality gates if agent requires automatic invocation
   - Update agents/workflow-orchestrator.md (contributor docs) to reflect changes

5. ✅ **Update tests**
   - `tests/structural/test_agents_exist.sh` - add to REQUIRED_AGENTS array
   - `tests/structural/test_commands_exist.sh` - add to REQUIRED_COMMANDS array
   - `tests/test_agents.sh` - add to REQUIRED_AGENTS array
   - `tests/test_commands.sh` - add to REQUIRED_COMMANDS array

6. ✅ **RUN VERIFICATION (MANDATORY)**
   ```bash
   ./scripts/verify.sh
   ```

   **YOU MUST RUN THIS COMMAND BEFORE COMMITTING.**

   - If it fails, fix ALL reported issues immediately
   - Do NOT commit until verify.sh passes
   - Do NOT skip this step - CI will fail and block merges
   - **Check 7/7 specifically ensures workflow-orchestrator is in sync!**

7. ✅ **Update lib/config.sh (SINGLE SOURCE OF TRUTH)**

   **All script configuration is centralized in `lib/config.sh`.** When adding/removing skills, subagents, or old agents for cleanup, ONLY update this file.

   ```bash
   # Example: Adding a new skill
   # Edit lib/config.sh:
   WORKFLOW_SKILLS=(
       ...existing...
       "new-skill"   # Add here
   )

   # Example: Adding a new subagent
   CORE_SUBAGENTS=(
       ...existing...
       "new-agent"   # Add here
   )
   ```

   **Run verification after changes:**
   ```bash
   ./scripts/verify-config.sh
   ```

   **What lib/config.sh controls:**
   - `CORE_SUBAGENTS` array - Subagents symlinked to `~/.claude/agents/`
   - `WORKFLOW_SKILLS` array - Skills copied to `~/.claude/skills/`
   - `OLD_WORKFLOW_AGENTS` array - Old agent files to clean up from v2.0
   - Shared functions: `cleanup_*`, `install_*`, `count_*`

   **install.sh note:** The embedded scripts in install.sh source lib/config.sh at runtime after installation. The constants at the top of install.sh must match lib/config.sh - verify-config.sh checks this.

8. ✅ **Update STATE.md**
   - Add entry to Recent Changes section
   - Update component counts if changed
   - Update last updated timestamps

### Why This Matters

- **CI Enforcement**: `./scripts/verify.sh` runs in CI. PRs will be blocked if docs are out of sync.
- **User Experience**: Out-of-sync docs confuse users and break trust.
- **Automatic Detection**: The verify script catches 100% of sync issues before they reach users.

### Automation Helpers

To make this easier:

```bash
# After making changes, run:
./scripts/verify.sh

# If it passes, you're good to commit
git add -A
git commit -m "feat: add new agent"

# If it fails, fix the reported issues and run again
```

### Failure Recovery

If you forgot to run verify.sh and CI fails:

1. Read the CI error output - it shows exactly what's missing
2. Fix the reported issues locally
3. Run `./scripts/verify.sh` to confirm
4. Commit the fixes
5. Push again

**Remember: verify.sh is your friend. It prevents mistakes, not creates them.**

---

## 🔧 SCRIPT ARCHITECTURE (v3.2)

**CRITICAL: All scripts share configuration from `lib/config.sh`. This is the SINGLE SOURCE OF TRUTH.**

### Single Source of Truth

```
lib/config.sh                    # THE SOURCE - All constants and functions
    │
    ├─→ install.sh               # Sources config AFTER downloading
    │   └─→ Generates bin/ scripts that source config at runtime
    │
    ├─→ bin/workflow-update      # Sources: $SCRIPT_DIR/../lib/config.sh
    ├─→ bin/workflow-refresh     # Sources: $SCRIPT_DIR/../lib/config.sh
    ├─→ bin/workflow-patch       # Sources: $SCRIPT_DIR/../lib/config.sh
    └─→ bin/workflow-toggle      # Sources: $SCRIPT_DIR/../lib/config.sh
```

### What lib/config.sh Contains

| Constant | Purpose | Example |
|----------|---------|---------|
| `CORE_SUBAGENTS` | Array of subagents to symlink | `("code-reviewer" "debugger" "ui-debugger")` |
| `WORKFLOW_SKILLS` | Array of skills to install | `("backend" "frontend" ... 10 total)` |
| `OLD_WORKFLOW_AGENTS` | Array of old agents for cleanup | 14 agents from v2.0 |
| `WORKFLOW_SKILL_REGEX` | Generated regex for cleanup | `^(backend|brownfield|...)$` |
| `OLD_AGENT_REGEX` | Generated regex for cleanup | `^(acceptance-validator|...)\.md$` |

| Function | Purpose |
|----------|---------|
| `cleanup_agents()` | Remove old workflow agent files/symlinks |
| `cleanup_commands()` | Remove old workflow command symlinks |
| `cleanup_skills()` | Remove old workflow skill directories |
| `install_skills()` | Copy skills to ~/.claude/skills/ |
| `install_subagents()` | Symlink core subagents |
| `install_commands()` | Symlink commands |
| `count_subagents()` | Count installed subagents |
| `count_skills()` | Count installed skills |
| `count_commands()` | Count installed command symlinks |
| `count_zombies()` | Count zombie agents (should be 0) |

### Making Changes

**Adding a new skill:**
```bash
# 1. Create the skill directory
mkdir -p templates/skills/new-skill/
cat > templates/skills/new-skill/skill.md << 'EOF'
# New Skill
...skill content...
EOF

# 2. Update lib/config.sh (ONLY place to add it)
# Add "new-skill" to WORKFLOW_SKILLS array

# 3. Verify
./scripts/verify-config.sh
./scripts/verify.sh
```

**Adding a new subagent:**
```bash
# 1. Create the agent file
cat > agents/new-agent.md << 'EOF'
# New Agent
...agent content...
EOF

# 2. Update lib/config.sh
# Add "new-agent" to CORE_SUBAGENTS array

# 3. Update documentation (per maintenance protocol)
# CLAUDE.md, help.md, README.md, tests

# 4. Verify
./scripts/verify-config.sh
./scripts/verify.sh
```

**Adding an old agent for cleanup (from previous versions):**
```bash
# Update lib/config.sh
# Add agent name to OLD_WORKFLOW_AGENTS array

# Verify
./scripts/verify-config.sh
```

### Why This Architecture

**Before (v3.1):** Constants scattered across 4+ locations
- CORE_AGENTS in install.sh:164, install.sh:331 (embedded), install.sh:506 (embedded), bin/workflow-refresh:70
- Skill regex in 4 places with inconsistencies
- Changes required updating multiple files manually
- Easy to miss one location → silent bugs

**After (v3.2):** Single source of truth
- All constants in `lib/config.sh`
- All scripts source this file
- `verify-config.sh` ensures consistency
- Changes require ONE edit

### Verification Commands

```bash
# Check config consistency (are all scripts using lib/config.sh?)
./scripts/verify-config.sh

# Check documentation consistency (are all docs in sync?)
./scripts/verify.sh

# Run all tests
./tests/run_all_tests.sh

# Full pre-commit verification
./scripts/verify-config.sh && ./scripts/verify.sh
```

### Troubleshooting

**"Found hardcoded CORE_AGENTS in bin/":**
- A script is defining its own array instead of sourcing config
- Edit the script to add: `source "$SCRIPT_DIR/../lib/config.sh"`
- Remove the hardcoded array

**"Config arrays don't match install.sh":**
- The constants at the top of install.sh must match lib/config.sh
- This is because install.sh can't source config until AFTER downloading
- Update install.sh to match, or run `./scripts/verify-config.sh` to see differences

**"Zombie agents found":**
- Old agent files exist in ~/.claude/agents/ that should have been cleaned up
- Add the agent names to `OLD_WORKFLOW_AGENTS` in lib/config.sh
- Run `workflow-toggle off && workflow-toggle on` to clean up

---

## 🧪 PRE-RELEASE VERIFICATION CHECKLIST

**CRITICAL: Run this checklist BEFORE releasing ANY version to catch installation issues.**

### Why This Exists

Multiple iterations were needed to fix v3.1.0 post-release because installation state wasn't verified:
- workflow-patch missing (TEMP_DIR deleted too early)
- llm-user-architect was subagent but should have been skill
- Zombie agents from v2.0 not cleaned up
- Architecture mismatch: Task tool doesn't recognize custom subagents

These issues were only discovered after users reported them. This checklist prevents that.

### Pre-Release Checklist

**Before tagging a release:**

1. ✅ **Fresh Install Test (Clean Environment)**
   ```bash
   # In a VM or clean user account
   curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
   source ~/.bashrc
   ```

2. ✅ **Run Installation Verification**
   ```bash
   ~/.claude-workflow-agents/scripts/verify-installation.sh
   ```

   Must show:
   - ✓ All 3 subagents present and correctly symlinked
   - ✓ No zombie agents found
   - ✓ All 11 skills present
   - ✓ All bin scripts present and executable
   - ✓ VERIFICATION PASSED

3. ✅ **Check Actual Files (Not Just Counts)**
   ```bash
   # Verify only expected files exist
   ls -la ~/.claude/agents/
   # Should show ONLY 3 symlinks (code-reviewer, debugger, ui-debugger)
   # NO regular files from old versions

   ls ~/.claude/skills/
   # Should show exactly 10 directories

   ls ~/.claude-workflow-agents/bin/
   # Should show all 7 scripts: workflow-init, workflow-update, workflow-version,
   # workflow-toggle, workflow-uninstall, workflow-patch, workflow-fix-hooks
   ```

4. ✅ **Test Upgrade from Previous Version**
   ```bash
   # Install previous stable version first
   curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/v3.1.0/install.sh | bash

   # Verify old files exist (simulate v2.0 upgrade)
   touch ~/.claude/agents/acceptance-validator.md
   touch ~/.claude/agents/agentic-architect.md

   # Now upgrade to new version
   workflow-update master

   # Run verification - should clean up zombie files
   ~/.claude-workflow-agents/scripts/verify-installation.sh
   ```

5. ✅ **Test workflow-init in Sample Project**
   ```bash
   mkdir /tmp/test-greenfield && cd /tmp/test-greenfield
   workflow-init
   # Should detect greenfield, create minimal CLAUDE.md, show all 3 subagents

   mkdir /tmp/test-brownfield && cd /tmp/test-brownfield
   mkdir backend frontend
   echo '{"name":"test"}' > package.json
   workflow-init
   # Should detect brownfield, create minimal-brownfield CLAUDE.md
   ```

6. ✅ **Test workflow-patch (v2.0 → v3.1+ Migration)**
   ```bash
   cd /tmp/test-project
   # Copy a v2.0 CLAUDE.md with "## 🔄 WORKFLOW ACTIVE"
   workflow-patch
   # Should accept both v2.0 and v3.x formats
   ```

7. ✅ **Verify Documentation Accuracy**
   ```bash
   # Check that docs match reality
   grep "subagent" README.md USAGE.md GUIDE.md CLAUDE.md
   # All references should say "3 subagents"

   grep "CORE_AGENTS" install.sh
   # Should include all 3: code-reviewer, debugger, ui-debugger
   ```

8. ✅ **Test Toggle On/Off**
   ```bash
   workflow-toggle status
   workflow-toggle off
   ls ~/.claude/agents/ ~/.claude/skills/
   # Should remove workflow files, keep user's own files

   workflow-toggle on
   ~/.claude-workflow-agents/scripts/verify-installation.sh
   # Should pass verification again
   ```

9. ✅ **Check Post-Install Verification Output**
   ```bash
   # The install.sh should show:
   # Verifying installation...
   #   Subagents: 4/4
   #   Skills:    10/10
   #   Commands:  26
   # ✓ Installed successfully

   # If it shows warnings, FIX BEFORE RELEASE
   ```

10. ✅ **Run All Tests**
    ```bash
    cd ~/dev/claude-workflow-agents
    ./tests/run_all_tests.sh
    # All tests must pass
    ```

### Quick Pre-Release Command

```bash
# Run this one-liner before every release
bash <(curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh) && \
~/.claude-workflow-agents/scripts/verify-installation.sh && \
echo "✓ Ready to release"
```

### What to Do If Verification Fails

1. **DO NOT RELEASE** - Fix issues first
2. Identify root cause (check install.sh, CORE_AGENTS array, cleanup logic)
3. Fix and commit
4. Re-run full checklist
5. Only release after all checks pass

### Success Criteria

- verify-installation.sh shows "✓ VERIFICATION PASSED"
- No zombie files in ~/.claude/agents/
- Exactly 3 subagents (symlinks), 11 skills (directories)
- All 7 bin scripts present and executable
- workflow-init works in both greenfield and brownfield
- Documentation counts match actual installation

**If ANY check fails, DO NOT tag the release.**

---

## 🔢 VERSION BUMP PROTOCOL

**CRITICAL: Follow this protocol when releasing a new version to ensure ALL files are updated.**

### Files That MUST Be Updated

When bumping version (e.g., 3.1.0 → 3.1.0), these files MUST be updated:

1. **`version.txt`** (single line file)
   ```
   3.1.0
   ```

2. **`install.sh`** (line ~8)
   ```bash
   VERSION="3.1.0"
   ```
   **⚠️ MOST COMMONLY FORGOTTEN - Double-check this!**

3. **`CHANGELOG.md`**
   - Rename `[Unreleased]` or create new section to `[3.1.0] - YYYY-MM-DD`
   - Document all changes in appropriate categories (Added/Changed/Fixed/Removed)

4. **All Documentation Files** (automated with sed)
   - README.md
   - CLAUDE.md
   - commands/help.md
   - AGENTS.md, COMMANDS.md, GUIDE.md, WORKFLOW.md, STATE.md, USAGE.md, EXAMPLES.md, PATTERNS.md
   - agents/workflow-orchestrator.md

5. **Template Files**
   - `templates/project/CLAUDE.md.minimal.template` - Update `workflow.version` field
   - `templates/project/CLAUDE.md.minimal-brownfield.template` - Update `workflow.version` field

### Automated Update Commands

**Step 1: Update Core Version Files**
```bash
# Update version.txt
echo "3.1.0" > version.txt

# Update install.sh VERSION variable (line 8)
sed -i '' 's/VERSION="[0-9.]*"/VERSION="3.1.0"/' install.sh

# Update CHANGELOG.md (rename section header)
sed -i '' 's/## \[Unreleased\]/## [3.1.0] - 2026-01-27/' CHANGELOG.md
```

**Step 2: Bulk Update All Documentation References**
```bash
# Replace version references across all docs (adjust OLD_VERSION as needed)
OLD_VERSION="3.1.0"
NEW_VERSION="3.1.0"

for file in README.md CLAUDE.md commands/help.md AGENTS.md COMMANDS.md GUIDE.md WORKFLOW.md STATE.md USAGE.md EXAMPLES.md PATTERNS.md agents/workflow-orchestrator.md; do
  sed -i '' "s/${OLD_VERSION}/${NEW_VERSION}/g" "$file"
  sed -i '' "s/v${OLD_VERSION%.*}/v${NEW_VERSION%.*}/g" "$file"  # Handle vX.Y format
done
```

**Step 3: Update Template Workflow Versions**
```bash
# Update workflow.version in templates (handles both X.Y and X.Y.Z formats)
sed -i '' 's/version: [0-9.]*$/version: 3.1/' templates/project/CLAUDE.md.minimal.template
sed -i '' 's/version: [0-9.]*$/version: 3.1/' templates/project/CLAUDE.md.minimal-brownfield.template
```

**Step 4: Verify All Updates**
```bash
# Run verification to ensure nothing broke
./scripts/verify.sh

# Manually verify critical files
echo "=== version.txt ==="
cat version.txt

echo "=== install.sh VERSION (line 8) ==="
head -n 10 install.sh | grep VERSION

echo "=== CHANGELOG.md (latest version) ==="
head -n 20 CHANGELOG.md | grep -A 5 "\[3.1.0\]"

echo "=== Template workflow versions ==="
grep "version:" templates/project/CLAUDE.md.*.template
```

**Step 5: Git Tag and Release**
```bash
# Commit version bump
git add -A
git commit -m "chore: bump version to 3.1.0"

# Create annotated tag
git tag -a v3.1.0 -m "Release v3.1.0

- Feature 1
- Feature 2
- Bug fix 1"

# Push commit and tag
git push origin main
git push origin v3.1.0
```

### Common Mistakes and How to Avoid Them

| Mistake | Impact | Prevention |
|---------|--------|------------|
| ❌ Forget `install.sh` VERSION | Users get wrong version, updates fail | Run grep check before committing |
| ❌ Inconsistent version refs in docs | Confusion, looks unprofessional | Use automated sed commands |
| ❌ Forget to update templates | New projects initialized with wrong version | Check grep output for all workflow.version fields |
| ❌ Skip CHANGELOG.md update | No release notes, breaks semver tracking | Make it first step before any commits |
| ❌ Typo in version number | Breaking inconsistency | Verify with grep across all files |

### Pre-Release Checklist

Before creating the git tag, confirm:

- [ ] `version.txt` contains new version
- [ ] `install.sh` line 8 has `VERSION="X.Y.Z"` with new version
- [ ] `CHANGELOG.md` has `[X.Y.Z] - YYYY-MM-DD` section with all changes documented
- [ ] All docs have consistent version references (run grep to verify)
- [ ] Templates have `workflow.version: X.Y` updated
- [ ] `./scripts/verify.sh` passes
- [ ] All tests pass (`./tests/run_all_tests.sh`)
- [ ] Git working directory is clean

### Why This Protocol Exists

The user's question **"why is self maintenance not kicking in for these things?"** highlighted a gap in our process. This protocol ensures:

1. **No files are forgotten** - Comprehensive checklist catches everything
2. **Automation reduces errors** - Sed commands eliminate manual find-replace mistakes
3. **Verification is mandatory** - Multiple checkpoints prevent bad releases
4. **Process is documented** - Future maintainers know exactly what to do

**If you're bumping a version and this protocol doesn't cover something, UPDATE THIS PROTOCOL FIRST, then proceed with the version bump.**

---

## 📄 Documentation Dependency Map

**CRITICAL: These files must stay in sync when agents/commands change.**

### Primary Documentation Files

| File | Contains | Must Update When |
|------|----------|------------------|
| **CLAUDE.md** | Repo maintenance, agent/command tables, counts | Any agent/command added/removed |
| **STATE.md** | Current state, agent/command lists, recent changes | Any agent/command added/removed, after major changes |
| **README.md** | User-facing docs, agent/command counts, tables | Any agent/command added/removed |
| **commands/help.md** | In-app help system, agent descriptions ("THE X AGENTS") | Any agent/command added/removed |
| **agents/workflow-orchestrator.md** | Orchestration logic, agent coordination, invocation table | **ANY agent/command added/removed/modified** |
| **AGENTS.md** | Detailed agent documentation | Agent capabilities change |
| **COMMANDS.md** | Detailed command documentation | Command behavior changes |

**⚠️ CRITICAL:** workflow-orchestrator.md is the MOST IMPORTANT file to keep in sync! It coordinates all agents and must know about every single one.

### Cross-Reference Matrix

When you add/remove an agent, it must be updated in:

1. ✅ **CLAUDE.md** - Current State section → Agents table
2. ✅ **STATE.md** - Agents List table + Component Counts
3. ✅ **README.md** - "The X Agents" section + table
4. ✅ **commands/help.md** - "THE X AGENTS" header + agent sections (L1/L2/Operations/Orchestration)
5. ✅ **agents/workflow-orchestrator.md** - "Agents Coordinated" section + invocation table
6. ✅ **tests/structural/test_agents_exist.sh** - REQUIRED_AGENTS array
7. ✅ **tests/test_agents.sh** - REQUIRED_AGENTS array

**CRITICAL: workflow-orchestrator.md must list ALL agents it coordinates!**
- When adding an agent, add it to the appropriate category (L1/L2/Support/Operations)
- Update the "When to Invoke Each Agent" table
- Add orchestration flow if it's a primary workflow agent

When you add/remove a command, it must be updated in:

1. ✅ **CLAUDE.md** - Directory Structure comment (count)
2. ✅ **STATE.md** - Component Counts
3. ✅ **README.md** - Commands count
4. ✅ **commands/help.md** - Commands section (if user-visible)
5. ✅ **tests/structural/test_commands_exist.sh** - REQUIRED_COMMANDS array
6. ✅ **tests/test_commands.sh** - REQUIRED_COMMANDS array

### Workflow Command Scripts

**When you add/modify workflow commands (workflow-*, bin/*), update:**

| Script Location | What to Update | When |
|-----------------|----------------|------|
| **install.sh** (line ~137-169) | `workflow-version` embedded script | New command added, agent/command counts changed |
| **install.sh** (line ~700-710) | Install success message commands list | New command added |
| **bin/workflow-update** | Update logic, change detection | Update process changes, new features |
| **bin/workflow-patch** | Section extraction, merge logic | Template structure changes, new sections |
| **README.md** | Terminal commands table, updating section | New command added, behavior changes |

**Examples:**
- **Add new command** → Update workflow-version output + install.sh success message + README.md
- **Add agent** → Update workflow-version if affects command list
- **Change templates** → Update workflow-patch section extraction logic
- **Add feature** → Update workflow-update to announce it

**Why this matters:**
- workflow-version is the first thing users run to check their installation
- Out-of-sync command lists confuse users
- workflow-patch must know template structure to preserve user data

### Verification System

The `./scripts/verify.sh` script automatically checks (7 checks):

✓ **[1/7]** Agent counts consistent (CLAUDE.md, STATE.md, README.md, help.md)
✓ **[2/7]** Command counts consistent (CLAUDE.md, STATE.md, README.md)
✓ **[3/7]** All agents referenced in CLAUDE.md
✓ **[4/7]** All agents referenced in help.md
✓ **[5/7]** All agents in test files
✓ **[6/7]** All commands in test files
✓ **[7/7]** All agents in STATE.md agents list
✓ **[7/7]** **workflow-orchestrator knows all agents it coordinates**

**NEW:** Check 7 ensures the orchestrator stays in sync when agents change!

**If verify.sh passes, your docs are in sync. If it fails, follow the error messages.**

### Documentation Categories

**User-Facing** (affects end users):
- README.md
- GUIDE.md
- EXAMPLES.md
- WORKFLOW.md
- USAGE.md
- commands/help.md

**Developer-Facing** (affects contributors):
- CLAUDE.md (this file)
- STATE.md
- AGENTS.md
- COMMANDS.md
- BACKEND.md
- FRONTEND.md

**Templates** (not direct docs):
- templates/project/*.template
- templates/docs/**

**Generated** (created during workflow, not maintained):
- docs/gaps/*.md (created by gap-analyzer)

---

## 🧪 LLM USER TESTING ARCHITECTURE (v1.1)

**Purpose:** Automated UI testing using LLM-simulated users to validate that promises to users are kept.

### Design Decisions

#### 1. Consolidated Command Structure (v3.2)

**Previous (27 commands):** Separate commands for each action
- `/llm-user init`, `/test-ui`, `/fix-gaps`

**Current (25 commands):** Single entry point with subcommands
- `/llm-user init|test|fix|status|refresh`

**Rationale:** Clearer mental model, related functionality grouped together, easier discovery.

#### 2. Skill Version Tracking

**Problem:** When the llm-user-testing skill is updated (e.g., v1.0.0 → v1.1.0), existing projects need to regenerate test artifacts to benefit from new features.

**Solution:** Track skill version in CLAUDE.md workflow state:
```yaml
ui_testing:
  initialized: true
  skill_version: "1.1.0"    # Version that generated artifacts
  last_run: null
  last_score: null
  critical_gaps: 0
  test_spec_hash: null       # Hash to detect doc changes
```

**Detection flow:**
1. `/llm-user init` checks `ui_testing.skill_version` vs current skill version
2. If mismatch → warn user and suggest `--upgrade`
3. `/llm-user refresh` also checks version, not just doc hashes

**User commands:**
```bash
/llm-user init --upgrade    # Regenerate with new skill version
/llm-user refresh           # Also checks skill version changes
```

#### 3. Scene-Grounded Responses (v1.1.0)

**Problem:** For scene-based language learning apps, test users were describing objects not in the scene (e.g., "dog" when there's no dog), causing app feedback to be nonsensical.

**Principle:** LLM user responses must ONLY reference elements that exist in the current scene. Make LANGUAGE mistakes (grammar, vocabulary), not PERCEPTION mistakes (wrong objects).

**Implementation:**
1. **Step 0: GROUND IN SCENE** - Before any response, extract all visible elements
2. **Validation** - Check that all nouns in response map to scene elements
3. **Regeneration** - If validation fails, regenerate response using only valid elements

**Recording format includes:**
```json
{
  "scene_grounding": {
    "scene_elements": ["person", "vegetables", "knife", "kitchen"],
    "scene_actions": ["cutting", "preparing food"],
    "NOT_in_scene": ["dog", "park", "walking"]
  },
  "user_response": {
    "validation": {
      "status": "PASS",
      "all_elements_in_scene": true
    }
  }
}
```

#### 4. Gap-Driven Development Flow

**Workflow:**
```
L1 Planning
  /intent → /ux → /architect → /plan
  ↓
L2 Building
  /implement phases
  ↓
L3 Validation (Gap-Driven)
  /llm-user init → /llm-user test → /llm-user fix → Promises validated
```

**Gap resolution:**
1. Test finds gaps → Creates GAP-XXX entries
2. `/llm-user fix` prioritizes by severity (CRITICAL first)
3. Each fix: spec → implement → code review → auto-verify
4. Re-runs failed scenarios to confirm fix
5. Updates gap status (OPEN → CLOSED)

### Files Structure

| File | Purpose |
|------|---------|
| `commands/llm-user.md` | Unified command documentation |
| `templates/skills/llm-user-testing/SKILL.md` | Domain expertise (v1.1.0) |
| `templates/skills/gap-resolver/SKILL.md` | Gap fixing protocols |
| Templates: `ui_testing.skill_version` | Version tracking in workflow state |

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2026-01-28 | Scene-grounded responses, skill version tracking |
| 1.0.0 | 2026-01-27 | Initial release with /llm-user consolidation |

---

## ⚠️ PREVENTING THE ILLUSION OF PROGRESS (Critical Principle)

**THE FUNDAMENTAL RULE:** Never claim something works without actually testing it. Use the Bash tool to run real commands and verify real output.

### The Problem We Discovered

In the Spanish Learner project, we found **PRM-007 (Question-First Learning)** was marked as "VALIDATED" and "COMPLETE" by the workflow, but when we actually tested it:
- The feature didn't exist at all
- No backend logic was implemented
- Tests were passing with mocks
- Users would experience complete failure

This is the **"Illusion of Progress"** - claiming success without real validation.

### How the Illusion Happens

```javascript
// FAKE validation (what we were doing wrong):
describe('PRM-007', () => {
  it('detects questions', () => {
    const mock = jest.fn().mockReturnValue(true);
    expect(mock()).toBe(true); // Always passes!
  });
});

// Workflow agent says: "✓ VALIDATED"
// Reality: Feature doesn't exist
```

### Enforcing Real Validation

#### 1. Use Bash Tool for Everything

```bash
# WRONG - Just claiming it works
echo "✓ Test passes"

# RIGHT - Actually run the test
npm test -- tests/promises/PRM-007.test.js
# See REAL output, REAL failures
```

#### 2. Reality Audit Command

The `/reality-audit` command was created specifically to combat fake validation:

```bash
# What it does:
1. Actually runs tests (npm test)
2. Actually starts the app (npm run dev)
3. Actually makes API calls (curl)
4. Shows REAL output
5. Creates GAP-R-XXX for anything broken
```

#### 3. Recovery Workflow

The `/recover` command exists because we discovered 60-80% of "validated" features were actually broken:

```
Phase 1: Truth Discovery - What ACTUALLY works?
Phase 2: Test Infrastructure - Create REAL tests
Phase 3: Triage - Prioritize what's really broken
Phase 4: Fix with Verification - Fix and ACTUALLY test
Phase 5: Lock in Progress - Prevent regression
```

### Validation Rules (MANDATORY)

1. **Never Mock What You're Testing**
   ```javascript
   // BAD
   jest.mock('./conversation-agent');

   // GOOD
   const response = await request(app).post('/api/conversation');
   expect(response.body.questionDetected).toBe(true);
   ```

2. **Always Use Bash Tool**
   ```bash
   # Run tests - see actual output
   npm test -- --no-coverage tests/integration/

   # Start app - verify it actually runs
   npm run dev

   # Test features - real API calls
   curl -X POST http://localhost:3001/api/conversation \
     -d '{"message": "What is that?"}' \
     -H "Content-Type: application/json"
   ```

3. **Gap Creation for Broken Features**
   - If test fails → Create GAP-R-XXX
   - If feature missing → Create GAP-R-XXX
   - If only mocked → Create GAP-R-XXX

4. **Verification Before Closing**
   ```bash
   # A gap is only closed when:
   1. Real test passes (no mocks)
   2. Manual testing confirms it works
   3. /verify command passes
   ```

### Why This Matters

**Without Real Validation:**
- Users experience broken features
- Trust erodes quickly
- Technical debt compounds
- "Complete" project is actually unusable

**With Real Validation:**
- Features actually work
- Users can rely on promises
- Progress is real and measurable
- Confidence in the system

### Implementation in Commands

All our commands now enforce real validation:

- **`/reality-audit`** - Tests what ACTUALLY works
- **`/recover`** - Fixes what's ACTUALLY broken
- **`/verify`** - Confirms fixes ACTUALLY work
- **`/improve`** - Only marks complete when VERIFIED

### Red Flags to Watch For

1. **Tests that always pass** - Probably mocked
2. **No Bash tool usage** - Not testing reality
3. **Instant "validation"** - Real tests take time
4. **No error messages** - Real systems have real failures
5. **100% success rate** - Suspiciously perfect

### The Recovery Commitment

By using this workflow, we commit to:
- **Accepting painful truth** about broken features
- **Creating real tests** that must pass
- **Fixing what's actually broken**
- **Never claiming false success**

The pain of discovering broken features is temporary.
The confidence of real validation is permanent.

---

## 🔄 UNIFIED GAP SYSTEM ARCHITECTURE (v1.0)

**Purpose:** Consolidate three parallel gap discovery/resolution workflows into a single, coherent system that handles all gap types uniformly.

### Problem Statement

**User Question:** "Reality-audit reveals what is broken, then /recover does the same thing? Should we combine in one command where audit creates artifact then recover uses it? What's the ideal way?"

**Issue Identified:** We had three separate systems doing essentially the same thing:

1. **`/reality-audit` + `/recover`** - Tested real functionality → found broken promises → fixed them
2. **`/gap` + `/improve`** - Analyzed documents → found missing capabilities → implemented them
3. **`/llm-user test` + `/llm-user fix`** - Simulated users → found UX issues → resolved them

This created:
- **Confusion:** Which command to use when?
- **Duplication:** Same gap might be found by multiple methods
- **Inconsistency:** Different workflows for essentially the same task
- **Fragmentation:** No unified view of all project issues

### Architectural Decision: Layered System

**Solution:** Create a layered architecture where specialized discovery feeds into unified resolution:

```
Discovery Layer (Specialized):
  /reality-audit    → Creates GAP-R-XXX gaps
  /llm-user test    → Creates GAP-U-XXX gaps
  /gap              → Creates GAP-A-XXX gaps
        ↓
Gap Repository (Unified):
  docs/gaps/        → All gaps in consistent format
        ↓
Resolution Layer (Unified):
  /improve          → Fixes any gap type
        ↓
Verification Layer (Smart):
  /verify           → Uses appropriate method per gap
```

### Unified Gap Format

All gaps, regardless of discovery source, follow this structure:

```yaml
gap_id: GAP-[SOURCE]-[NUMBER]  # R=reality, U=user, A=analysis
title: "Clear problem description"
category: functionality|ux|architecture|performance|security
severity: CRITICAL|HIGH|MEDIUM|LOW

discovery:
  source: reality-audit|llm-user|gap-analysis
  discovered_at: timestamp
  discovered_by: command

problem:
  description: What's wrong
  evidence: Proof points
  root_cause: Why it happened

resolution:
  approach: How to fix
  effort: small|medium|large
  tasks: [list of steps]

verification:
  method: reality|llm-user|manual|automated
  [method-specific details]

status:
  state: open|in_progress|fixed|verified|closed
```

### Key Design Decisions

#### 1. Why Not Fully Merge Commands?

**Considered:** Merging all discovery into single `/audit` command.

**Rejected Because:**
- Each discovery method has specialized expertise (reality tests, UX simulation, doc analysis)
- Different triggers and contexts (broken build vs UX testing vs planning)
- Users have clear mental models of when to use each

**Decision:** Keep specialized discovery, unify storage and resolution.

#### 2. Smart Verification

**Problem:** Different gap types need different verification methods.

**Solution:** `/verify` intelligently selects method based on gap source:
- Reality gaps (GAP-R-XXX) → Run real tests
- User gaps (GAP-U-XXX) → Re-run LLM user scenarios
- Analysis gaps (GAP-A-XXX) → Check implementation exists

**Implementation:** Gap's `verification.method` field drives verification approach.

#### 3. Artifact Staleness

**Problem:** Gap discovered Monday, fixed Friday - is it still valid?

**Solution:** Staleness detection in gap files:
```yaml
discovery:
  discovered_at: "2024-01-30T10:00:00Z"
  git_commit: "abc123"  # Code state when discovered

# Staleness check:
- Time-based: >24 hours old
- Code-based: git diff since discovery
- Promise-based: Intent doc changed
```

#### 4. Deprecation Strategy

**Deprecated (but still functional):**
- `/llm-user fix` → Use `/improve` instead
- Recovery-specific phases → Use unified gap workflow

**Migration Path:**
- Old commands still work but show deprecation notice
- Documentation guides users to new workflow
- Future version will remove deprecated commands

### Implementation Details

#### Command Updates

**Discovery Commands (write to unified format):**
- `/reality-audit` - Updated to create GAP-R-XXX entries
- `/gap` - Updated to create GAP-A-XXX entries
- `/llm-user test` - Updated to create GAP-U-XXX entries

**Resolution Commands (read from unified format):**
- `/improve` - Enhanced to handle all gap types, filter by severity/source
- `/verify` - New command with smart verification
- `/recover` - Updated to use unified gap commands

#### File Structure

```
docs/gaps/
├── gap-registry.yaml           # Master list of all gaps
├── gap-analysis.md            # Human-readable report
├── migration-plan.md          # Phased fix plan
│
├── gaps/                       # Individual gap files
│   ├── GAP-R-001.yaml         # Reality gap
│   ├── GAP-U-001.yaml         # User testing gap
│   └── GAP-A-001.yaml         # Analysis gap
│
└── artifacts/                  # Supporting evidence
    ├── reality-audit-*.json
    └── llm-user-results-*.json
```

### Usage Examples

#### Discovering Gaps
```bash
# Different methods, same unified output
/reality-audit              # Tests promises → GAP-R-XXX
/llm-user test              # Simulates users → GAP-U-XXX
/gap                        # Analyzes docs → GAP-A-XXX
```

#### Fixing Gaps (Unified)
```bash
# Single command handles all types
/improve --severity=critical     # Fix most urgent
/improve --source=reality        # Fix reality gaps
/improve GAP-R-001              # Fix specific gap
```

#### Verifying Fixes (Smart)
```bash
# Automatic method selection
/verify GAP-R-001               # Runs reality tests
/verify GAP-U-001               # Runs LLM user scenario
/verify --all                   # Verifies all fixed gaps
```

### Benefits Achieved

1. **Mental Model Clarity:** A gap is a gap, regardless of how discovered
2. **No Duplicate Work:** Same issue found by multiple methods tracked once
3. **Unified Prioritization:** All gaps ranked together by impact
4. **Consistent Workflow:** Same fix → verify cycle for all types
5. **Complete Visibility:** Single source of truth at `docs/gaps/`
6. **Smart Automation:** System knows how to handle each gap type

### Future Enhancements

**Planned:**
- Gap deduplication (detect when different methods find same issue)
- Cross-gap dependencies (GAP-R-001 blocks GAP-U-003)
- Automated gap discovery scheduling
- Gap resolution metrics and reporting

**Under Consideration:**
- ML-based gap prediction
- Automated fix generation for common patterns
- Integration with CI/CD for continuous gap discovery

### Lessons Learned

1. **Unification vs Specialization:** Keep specialized discovery, unify everything else
2. **User Mental Models Matter:** Don't break existing command expectations
3. **Progressive Enhancement:** Deprecate gradually, maintain compatibility
4. **Smart Defaults:** System should know what to do without user specifying
5. **Single Source of Truth:** One place for all gaps prevents confusion

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
| Agents | 17 |
| Commands | 28 |

### Agents

| Agent | Category | Purpose |
|-------|----------|---------|
| intent-guardian | L1 | Define user promises with criticality |
| ux-architect | L1 | Design experience |
| agentic-architect | L1 | Design system with promise mapping |
| implementation-planner | L1 | Create build plan with validation tasks |
| change-analyzer | L1 Support | Assess changes |
| gap-analyzer | L1 Support | Find issues |
| brownfield-analyzer | L1 Support | Scan existing codebases |
| backend-engineer | L2 | Build backend |
| frontend-engineer | L2 | Build frontend |
| test-engineer | L2 | Write tests |
| code-reviewer | L2 Support | Review code |
| debugger | L2 Support | Fix bugs |
| ui-debugger | L2 Support | Debug UI with browser automation |
| acceptance-validator | L2 Validation | Validate promises are kept |
| workflow-orchestrator | Orchestration | Auto-chain agents and quality gates |
| project-ops | Ops | Setup, sync, docs |
| solution-iterator | L2 Support | Compare multiple solutions with LLM judges |

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
| /llm-user | LLM user testing (init/test/fix/status/refresh) |
| /iterate | Compare multiple solutions using LLM judges |

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
│   ├── agents/                # Agent definitions (17)
│   ├── commands/              # Command definitions (26)
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
