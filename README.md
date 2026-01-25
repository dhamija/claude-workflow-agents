# Claude Workflow Agents

A comprehensive multi-agent system for Claude Code that provides structured workflows for both greenfield and brownfield software projects.

## What's Included

### 10 Specialized Agents
| Agent | Purpose |
|-------|---------|
| intent-guardian | Define/verify product intent, promises, invariants |
| ux-architect | Design user journeys and experience |
| agentic-architect | Design multi-agent system architecture |
| implementation-planner | Create technical implementation plans |
| gap-analyzer | Analyze gaps in existing codebases |
| backend-engineer | Implement backend code |
| frontend-engineer | Implement frontend code |
| test-engineer | Write tests and verify system correctness |
| code-reviewer | Review code quality and security |
| debugger | Debug and fix issues |

### 15 Workflow Commands
| Command | Purpose |
|---------|---------|
| `/analyze` | Run parallel analysis for new project |
| `/plan` | Generate implementation plans |
| `/implement` | Build phase by phase |
| `/audit` | Understand existing codebase |
| `/gap` | Find gaps and create migration plan |
| `/improve` | Fix gaps incrementally |
| `/verify` | Verify phase correctness |
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
