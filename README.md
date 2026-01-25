# Claude Workflow Agents

A comprehensive multi-agent system for Claude Code that provides structured workflows for both greenfield and brownfield software projects.

## What's Included

### 11 Specialized Agents
| Agent | Purpose |
|-------|---------|
| intent-guardian | Define/verify product intent, promises, invariants |
| ux-architect | Design user journeys and experience |
| agentic-architect | Design multi-agent system architecture |
| implementation-planner | Create technical implementation plans |
| gap-analyzer | Analyze gaps in existing codebases |
| change-analyzer | Analyze impact of requirement changes |
| backend-engineer | Implement backend code |
| frontend-engineer | Implement frontend code |
| test-engineer | Write tests and verify system correctness |
| code-reviewer | Review code quality and security |
| debugger | Debug and fix issues |

### 18 Workflow Commands
| Command | Purpose |
|---------|---------|
| `/analyze` | Run parallel analysis for new project |
| `/plan` | Generate implementation plans |
| `/implement` | Build phase by phase |
| `/verify` | Verify phase correctness |
| `/audit` | Understand existing codebase |
| `/gap` | Find gaps and create migration plan |
| `/improve` | Fix gaps incrementally |
| `/change` | Analyze impact of requirement changes |
| `/update` | Apply changes to artifacts |
| `/replan` | Regenerate plans after changes |
| `/aa`, `/aa-audit` | Agentic architecture (design/audit) |
| `/ux`, `/ux-audit` | User experience (design/audit) |
| `/intent`, `/intent-audit` | Product intent (define/audit) |
| `/review` | Code review |
| `/debug` | Debug issues |

## Quick Start

### Installation
```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-workflow-agents.git
cd claude-workflow-agents

# Install globally (available in all projects)
./install.sh --user

# OR install for current project only
./install.sh --project
```

### Greenfield Project (New)
```bash
/analyze food delivery app connecting restaurants with customers
/plan fastapi react postgres
/implement phase 1
/implement phase 2
/verify final
```

### Brownfield Project (Existing)
```bash
/audit
/gap
/improve phase 0
/improve phase 1
/verify final
```

### Change Management (Mid-Flight Changes)
```bash
# After initial planning/implementation
/change add user roles and permissions with admin, editor, viewer levels
# Reviews impact analysis
/update
# Automatically updates artifacts and replans
/implement phase 2  # Continue with updated plans
```

## Documentation

- [WORKFLOW.md](WORKFLOW.md) - Detailed workflow explanation
- [USAGE.md](USAGE.md) - Usage guide with examples
- [AGENTS.md](AGENTS.md) - Agent reference
- [COMMANDS.md](COMMANDS.md) - Command reference

## Requirements

- Claude Code CLI installed and authenticated
- Bash shell (for install script)

## License

MIT
