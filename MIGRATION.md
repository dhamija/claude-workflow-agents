# ARCHIVED - Migration Guide v1 → v2

**Note:** This migration guide is for historical reference only. It documents the v1→v2 agent consolidation that occurred in January 2025.

For current installation instructions, see README.md.

---

# Migration Guide: v1 → v2

Guide for upgrading to the consolidated agent/command structure.

---

## What Changed

### Agent Consolidation (15 → 11)

**Removed:**
- `project-maintainer`
- `project-enforcer`
- `ci-cd-engineer`
- `documentation-engineer`

**Added:**
- `project-ops` (consolidates all 4 above)

### Command Consolidation (26 → 22)

**Removed:**
- `/agent-wf-help` → Use `/help`
- `/sync` → Use `/project sync`
- `/enforce` → Use `/project setup`
- `/docs` → Use `/project docs`
- `/llm` → Use `/project ai`
- `/mcp` → Use `/project mcp`

**Added:**
- `/help` (replaces agent-wf-help)
- `/project` (with subcommands)

### Template Reorganization

**Old structure:**
```
templates/
├── CLAUDE.md.template
├── src/lib/llm/...
├── scripts/...
└── ci/...
```

**New structure:**
```
templates/
├── project/           # Project-level files
├── docs/              # Documentation templates
├── infrastructure/    # Scripts & hooks
├── ci/                # CI/CD templates
└── integrations/      # LLM/MCP code
```

---

## Migration Steps

### Step 1: Update Installation

If you have v1 installed globally:

```bash
cd claude-workflow-agents
git pull origin master
./install.sh --user --force
```

This will:
- Remove old agents
- Install new consolidated agents
- Update templates

### Step 2: Update Project CLAUDEmd

If you have existing projects using v1, update their CLAUDE.md:

**Old format:**
```markdown
### Available Commands
- `/sync` - Update docs
- `/enforce setup` - Enable enforcement
```

**New format:**
```markdown
### Available Commands
- `/project sync` - Update docs
- `/project setup` - Initialize infrastructure (includes enforcement)
```

### Step 3: Update Habits

**Old commands still work** (with deprecation warnings), but update your habits:

| Old Command | New Command | Notes |
|-------------|-------------|-------|
| `/sync` | `/project sync` | All sync modes supported |
| `/sync quick` | `/project sync quick` | Same behavior |
| `/enforce setup` | `/project setup` | More comprehensive |
| `/enforce verify` | `/project verify` | Same behavior |
| `/docs generate` | `/project docs generate` | Same behavior |
| `/llm setup` | `/project ai setup` | Enhanced with cost tracking |
| `/mcp setup` | `/project mcp setup` | Same behavior |
| `/agent-wf-help` | `/help` | Shorter, same content |

### Step 4: Verify Migration

```bash
# In your project
/help                  # Should show new help system
/project status        # Should work
/project sync          # Should work
```

If any commands don't work, reinstall:
```bash
cd claude-workflow-agents
./install.sh --user --force
```

---

## Breaking Changes

### 1. Old Commands Show Warnings

```
You: /sync

Claude: ⚠ /sync is deprecated. Use /project sync

        [Runs /project sync anyway]
```

**Action:** Update muscle memory to use `/project` commands.

### 2. Maintenance Headers Changed

Agent files now reference:
- `commands/help.md` (was `commands/agent-wf-help.md`)
- `./scripts/verify.sh` (was `./scripts/verify-sync.sh`)

**Action:** If you've customized agents, update references.

### 3. Template Paths Changed

If you manually reference templates:

**Old:**
```
templates/CLAUDE.md.template
templates/src/lib/llm/client.ts
```

**New:**
```
templates/project/CLAUDE.md.template
templates/integrations/llm/client.ts
```

**Action:** Update any scripts that reference template paths.

---

## Non-Breaking Changes

These continue to work exactly as before:

- Natural language conversations
- All L1 agents (intent, UX, architecture, planning)
- All L2 agents (backend, frontend, test, review, debug)
- Feature-based workflow
- Brownfield/greenfield modes
- Parallel development
- Design system integration

---

## New Features in v2

### 1. Consolidated Project Operations

One agent (`project-ops`) handles all project management:
- Setup infrastructure
- Sync documentation
- Verify compliance
- Generate docs
- Setup AI/MCP integration
- Show project status

### 2. Better Organization

Templates organized by purpose:
- `project/` - Core project files
- `docs/` - Documentation templates
- `infrastructure/` - Scripts & hooks
- `ci/` - CI/CD templates
- `integrations/` - LLM/MCP code

### 3. Simplified Commands

One command (`/project`) with clear subcommands:
- `setup` - Initialize everything
- `sync` - Update docs
- `verify` - Check compliance
- `docs` - Manage documentation
- `ai` - LLM integration
- `mcp` - MCP servers
- `status` - Show health

---

## FAQ

**Q: Will my existing projects break?**
A: No. Old commands still work with deprecation warnings.

**Q: Do I need to update existing project CLAUDE.md files?**
A: Not required, but recommended for consistency.

**Q: Can I use both old and new commands?**
A: Yes, but you'll see warnings for old commands.

**Q: How do I completely remove old commands?**
A: They'll show deprecation warnings but continue working. Update your usage when convenient.

**Q: What if I have custom agents/commands?**
A: Update maintenance header references:
- `agent-wf-help.md` → `help.md`
- `verify-sync.sh` → `verify.sh`

**Q: Do I need to reinstall in all my projects?**
A: Only if you used `--project` install. `--user` install affects all projects automatically.

---

## Troubleshooting

### Commands not found

```bash
# Reinstall
cd claude-workflow-agents
./install.sh --user --force
```

### Wrong agent count

```bash
ls ~/.claude/agents/*.md | wc -l  # Should be 11
```

If not 11:
```bash
cd claude-workflow-agents
./install.sh --user --force
```

### Help command not working

```bash
# Verify help command exists
ls ~/.claude/commands/help.md

# If missing
cd claude-workflow-agents
./install.sh --user --force
```

---

## Rollback (If Needed)

If you need to rollback to v1:

```bash
cd claude-workflow-agents
git checkout <previous-commit>
./install.sh --user --force
```

---

## Getting Help

- `/help` - In-app help system
- [README.md](README.md) - Full documentation
- [PATTERNS.md](PATTERNS.md) - Common usage patterns
- [GitHub Issues](https://github.com/YOUR_USERNAME/claude-workflow-agents/issues) - Report problems

---

## Summary

**TL;DR:**
1. Old commands still work (with warnings)
2. Update when convenient to new `/project` commands
3. Reinstall with `./install.sh --user --force` if issues
4. 15 agents → 11 agents (consolidated maintenance)
5. Help system: `/agent-wf-help` → `/help`
