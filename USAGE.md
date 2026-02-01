# Usage Guide

> **v3.3 Architecture:** Skills + Hooks. 11 skills loaded on-demand, 3 subagents for isolated tasks. See README.md for detailed architecture.

## Installation

### Global Install (One-Time)
```bash
# Latest stable release (recommended)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
source ~/.bashrc  # or restart terminal
```

### Version Selection
```bash
# Latest stable (default)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s latest

# Specific version
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s v3.3.0

# Bleeding edge
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s master
```

**What this does:**
- Installs to `~/.claude-workflow-agents/` (global location)
- Creates individual file symlinks in `~/.claude/agents/` and `~/.claude/commands/`
- Workflow immediately active for **all** Claude Code sessions
- No per-project setup required

### Commands Available
- `workflow-toggle on/off/status` - Enable, disable, or check workflow status (global)
- `workflow-update [version]` - Update global installation (latest/v3.3.0/master)
- `workflow-version` - Show current version
- `workflow-uninstall` - Remove global installation

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

### Example 4: Design System Setup
```bash
# Quick start with a preset
/design preset modern-clean

# Or match a competitor's style
/design reference https://linear.app

# Or let UX architect gather preferences
/ux recipe sharing app with social features
# (UX architect will ask about design preferences and create design system)

# View the design system
/design show

# Update brand colors later
/design update
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

## Gap-Driven Development Workflow

Gap-driven development validates that your application keeps its promises to users through LLM-as-user testing, then systematically fixes any gaps found.

### Complete Cycle

```bash
# 1. Build your app (L1 → L2)
/analyze recipe sharing app
/plan node express react postgres
/implement

# 2. Initialize LLM user testing (after UI ready)
/llm-user init
# Generates: test-spec.yaml, personas, scenarios, test subagents

# 3. Run LLM user tests
/llm-user test http://localhost:3000
# Output:
#   ✓ 4 scenarios passed
#   ✗ 1 scenario failed
#   Overall: 7.2/10
#   1 critical gap found

# 4. View gaps and progress
/llm-user status
# Shows:
#   Test Results (last run):
#     ✓ 4 scenarios passed
#     ✗ 1 scenario failed
#
#   Critical Gaps:
#     [CRITICAL] No progress tracking (blocks P2)
#
#   All Gaps:
#     [CRITICAL] GAP-001: No progress tracking
#     [HIGH] GAP-002: Slow response time

# 5. Fix gaps systematically (auto-verifies after each)
/llm-user fix
# Automatically:
#   - Prioritizes by severity (CRITICAL first)
#   - Creates fix specification
#   - Implements through workflow agents
#   - Re-runs failed scenarios to verify
#   - Updates promise status
#   - Shows improvement: 7.2 → 8.5 (+1.3)
# Shows:
#   Score: 7.2 → 9.1 (+1.9)
#   Promises validated: 3/5 → 5/5
#   Release readiness: 70% → 95%
```

### Example 1: Critical Gap Fix

```bash
# After /llm-user test finds critical gap
/llm-user status --filter=critical
# Output: [CRITICAL] Missing auth prevents user from saving work

# Fix only critical gaps
/llm-user fix critical

# Claude:
#   Creating fix spec for GAP-001: Missing auth
#   Tasks:
#     1. Add JWT authentication (backend)
#     2. Create login component (frontend)
#     3. Add auth middleware (backend)
#     4. Add tests
#
#   Implementing tasks...
#   ✓ All tasks complete
#
#   Verifying fix...
#   Re-running scenario: save-recipe (maria-beginner, jake-teen)
#   ✓ Verification passed
#
#   Promise P3: FAILED → VALIDATED
#   Gap GAP-001: CLOSED
```

### Example 2: Focused Gap Fixing

```bash
# Fix specific gap by ID
/llm-user fix GAP-003

# Fix only high-priority gaps
/llm-user fix high

# View gaps filtered by priority
/llm-user status --filter=high
```

### Example 3: Iterative Testing

```bash
# Build → Test → Fix cycle
/implement phase 1
/llm-user test
/llm-user fix critical

/implement phase 2
/llm-user test
/llm-user fix critical

# Final validation
/llm-user test
/llm-user status
# All promises validated → Ready to ship
```

### When to Use Gap-Driven Development

✅ **Use when:**
- UI is accessible (localhost or staging)
- Want to validate promises are kept
- Need systematic issue resolution
- Building user-facing applications
- Want automated regression testing

❌ **Skip when:**
- Building APIs without UI
- App not yet functional
- Still in early prototype phase

### Key Commands

| Command | Purpose |
|---------|---------|
| `/llm-user init` | Generate test infrastructure from docs |
| `/llm-user test [url]` | Run LLM user tests with personas |
| `/llm-user fix [target]` | Fix gaps (all, critical, high, or GAP-XXX) |
| `/llm-user status [--filter]` | View results, gaps, progress |
| `/llm-user refresh` | Regenerate after doc changes |

### Integration with Workflow

Gap-driven development complements the L1/L2 workflow:

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
- Check files are in correct location: `ls ~/.claude-workflow-agents/commands/`
- Verify symlinks exist: `ls -la ~/.claude/commands/`
- Try `workflow-toggle status` to check if workflow is enabled

### "Agent not found"
- Verify agent file exists: `ls ~/.claude-workflow-agents/agents/`
- Check agent name in command matches filename
- Verify symlinks exist: `ls -la ~/.claude/agents/`
- Try `workflow-toggle on` to recreate symlinks

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
| `/design` | Manage design system for UI consistency |
| `/design preset <name>` | Apply design preset (modern-clean, minimal, etc.) |
| `/design show` | View current design system |
| `/design update` | Interactively update design system |
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
│   │   └─ (docs/ux/design-system.md created automatically)
│   ├─ Run /plan <tech stack>
│   ├─ Review docs/plans
│   ├─ Run /implement phase 1
│   │   └─ (frontend-engineer reads design-system.md first)
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

Design System (anytime):
├─ Need to set up UI styling?
│   └─ Run /design preset <name>
├─ Want to match another site?
│   └─ Run /design reference <url>
├─ Need to update colors/fonts?
│   └─ Run /design update
└─ Want to see current design?
    └─ Run /design show
```

## Advanced Usage

### Custom Documentation Locations
By default, agents create docs in `docs/`. To use a different location, modify the command files to specify different paths.

### Team Workflows
```bash
# Each team member installs globally (one-time)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

# Workflow is immediately available for all team members
# No per-project setup needed

# Optional: Disable when not needed
workflow-toggle off

# Re-enable anytime
workflow-toggle on
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
# Global install (once)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

# Workflow immediately available everywhere
# Use commands in any package directory

cd packages/api
/implement auth service

cd ../web
/implement auth UI
```

## Troubleshooting

### Commands Don't Appear
1. Check global installation: `ls ~/.claude-workflow-agents/commands/`
2. Check symlinks exist: `ls -la ~/.claude/commands/`
3. Check workflow status: `workflow-toggle status`
4. Restart Claude Code completely
5. If symlinks missing: `workflow-toggle on`

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
