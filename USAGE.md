# Usage Guide

## Installation Options

### User-Level (Global)
```bash
./install.sh --user
```
Installs to `~/.claude/agents/` and `~/.claude/commands/`
Available in ALL your projects.

### Project-Level
```bash
./install.sh --project
```
Installs to `.claude/agents/` and `.claude/commands/`
Available only in current project. Can be committed to git for team sharing.

### Both
```bash
./install.sh --user --project
```

## Greenfield Workflow Examples

### Example 1: Simple App
```bash
# Start with an idea
/analyze todo app with reminders and categories

# Generate plans (specify your stack)
/plan node express react postgres

# Build phase by phase
/implement phase 1
/implement phase 2

# Final verification
/verify final
```

### Example 2: Complex App
```bash
# Detailed idea
/analyze B2B SaaS for invoice management with OCR scanning, approval workflows, and accounting integrations

# Plan with specific stack
/plan fastapi react postgres redis

# Implement in phases
/implement phase 1   # Foundation
/implement phase 2   # Core features
/implement phase 3   # Agent integration (OCR, workflows)
/implement phase 4   # Polish

# Verify
/verify final
```

### Example 3: Using Individual Agents
```bash
# Just want agentic architecture design
/aa customer support platform with ticket routing

# Just want UX design
/ux e-commerce checkout flow

# Just want intent definition
/intent subscription management service
```

## Brownfield Workflow Examples

### Example 1: Full Audit & Improvement
```bash
# Understand current state
/audit

# Analyze gaps
/gap

# Fix incrementally
/improve phase 0   # Critical issues
/improve phase 1   # High priority
/improve phase 2   # Medium priority

# Verify
/verify final
```

### Example 2: Focused Audit
```bash
# Audit just the authentication system
/audit the auth module

# Check gaps in that area
/gap authentication

# Fix auth-related gaps
/improve GAP-001
/improve GAP-002
```

### Example 3: Add Agentic Capabilities
```bash
# Audit for agentic opportunities
/aa-audit

# Review suggestions, then implement specific agent
/implement content-classifier agent
```

## Tips & Best Practices

### 1. Review Before Proceeding
After each level, review the output before moving on:
```bash
/analyze my app
# Review docs/intent/, docs/ux/, docs/architecture/
# Adjust if needed, then:
/plan
```

### 2. Use Verification
Don't skip verification:
```bash
/implement phase 1
/verify phase 1    # Catches issues early, auto-syncs on success
/implement phase 2
```

### 3. Save State Between Sessions
Before ending a session:
```bash
/sync              # Updates CLAUDE.md with current state
# Next session: just say "continue"
```

### 4. Iterate on Intent
If implementation reveals intent issues:
```bash
/intent-audit
# Review findings
# Update product-intent.md manually if needed
```

### 5. Focused Improvements
Fix one thing at a time in brownfield:
```bash
/improve GAP-007   # Single gap
# Verify
/improve GAP-008
# Verify
```

### 6. Parallel Work Setup
For parallel implementation with worktrees:
```bash
git worktree add ../myapp-api feature/api
git worktree add ../myapp-web feature/web

# Terminal 1 (in myapp-api)
/implement backend auth

# Terminal 2 (in myapp-web)
/implement frontend shell
```

## Common Issues

### "Unknown slash command"
- Restart Claude Code after installation
- Check files are in correct location: `ls ~/.claude/commands/`

### "Agent not found"
- Verify agent file exists: `ls ~/.claude/agents/`
- Check agent name in command matches filename

### "File read error"
- Agents can't read directories, only files
- Ensure commands use Glob before Read

### Missing Prerequisites
- Commands check for prerequisite files
- Run earlier workflow steps first

## Command Reference Quick Guide

| Command | When to Use |
|---------|-------------|
| `/analyze` | Starting a new project from an idea |
| `/plan` | After analysis, before coding |
| `/implement` | Build each phase of the plan |
| `/verify` | After each phase or at the end |
| `/audit` | Understanding existing codebase |
| `/gap` | Finding issues in existing code |
| `/improve` | Fixing specific gaps |
| `/intent` | Define product vision |
| `/intent-audit` | Check if code matches vision |
| `/ux` | Design user experience |
| `/ux-audit` | Review current UX |
| `/aa` | Design agentic architecture |
| `/aa-audit` | Find opportunities for agents |
| `/review` | Code review |
| `/debug` | Fix errors or bugs |
| `/sync` | Update project state & docs |
| `/sync quick` | Quick state update |
| `/sync report` | Check sync status |

## Workflow Decision Tree

```
Do you have existing code?
├─ NO → Greenfield
│   ├─ Run /analyze <idea>
│   ├─ Review docs/intent, docs/ux, docs/architecture
│   ├─ Run /plan <tech stack>
│   ├─ Review docs/plans
│   ├─ Run /implement phase 1
│   ├─ Run /verify phase 1
│   ├─ Repeat implement + verify for each phase
│   └─ Run /verify final
│
└─ YES → Brownfield
    ├─ Run /audit
    ├─ Review what was found
    ├─ Run /gap
    ├─ Review docs/gaps/migration-plan.md
    ├─ Run /improve phase 0
    ├─ Run /verify phase 0
    ├─ Repeat improve + verify for each phase
    └─ Run /verify final
```

## Advanced Usage

### Custom Documentation Locations
By default, agents create docs in `docs/`. To use a different location, modify the command files to specify different paths.

### Team Workflows
```bash
# Install project-level for team
./install.sh --project

# Commit to git
git add .claude/
git commit -m "Add workflow agents and commands"
git push

# Teammates pull and restart Claude Code
# No installation needed - .claude/ is already there
```

### CI/CD Integration
```bash
# In your CI pipeline
/verify final

# Exit with non-zero if verification fails
# This prevents deployment of broken code
```

### Monorepo Usage
```bash
# Install at monorepo root
./install.sh --project

# Each package can use the commands
cd packages/api
/implement auth service

cd ../web
/implement auth UI
```

## Troubleshooting

### Commands Don't Appear
1. Check installation: `ls ~/.claude/commands/` or `ls .claude/commands/`
2. Restart Claude Code completely
3. Verify file permissions: `chmod 644 ~/.claude/commands/*.md`

### Agents Fail to Read Files
1. Agents can only read files, not directories
2. Commands should use Glob to find files first
3. Check file paths are absolute or relative to project root

### Plans Don't Match Reality
1. Update plan documents manually
2. Re-run `/plan` if needed
3. Commit updated plans with code changes

### Too Many Phases
1. Combine related phases in implementation-order.md
2. Adjust phase granularity based on project size
3. Small projects might only need 1-2 phases

### Verification Fails
1. Read the verification report in docs/verification/
2. Fix issues found
3. Re-run `/verify` for that phase
4. Don't proceed to next phase until verification passes
