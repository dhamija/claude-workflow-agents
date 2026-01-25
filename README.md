# Claude Workflow Agents

A conversation-driven multi-agent system for Claude Code. Just talk naturally - Claude automatically orchestrates specialized agents to design, plan, implement, and verify your software projects.

**No slash commands required.** Claude understands your intent and runs the right agents at the right time.

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

# Install to your project
cd your-project
/path/to/claude-workflow-agents/install.sh --project

# This creates:
# - ./.claude/agents/ (11 specialized agents)
# - ./.claude/commands/ (18 optional commands for power users)
# - ./CLAUDE.md (orchestrator configuration)
```

### Usage: Just Talk to Claude

**Greenfield (New Project)**
```
You: I want to build a food delivery app connecting restaurants with customers

Claude: I'll help design this system. Let me start by defining what we're
        promising users and designing the user experience.
        [Automatically launches intent-guardian and ux-architect in parallel]

        I've defined the product intent and user journeys. Key promises:
        - Customers order in under 60 seconds
        - Real-time delivery tracking
        - Restaurants never miss an order

        Next, let me design the system architecture...
        [Launches agentic-architect]

        Ready to create implementation plans?

You: Yes, use FastAPI, React, and PostgreSQL

Claude: [Launches implementation-planner with tech stack]

        Implementation plan ready. I'll start with Phase 1: database + auth +
        restaurant onboarding. Should I begin?

You: Go ahead

Claude: [Launches backend-engineer and frontend-engineer in parallel]
```

**Brownfield (Existing Project)**
```
You: This codebase has technical debt. Help me improve it.

Claude: I'll analyze the current state and create a migration plan.
        [Launches gap-analyzer]

        Found gaps in 3 areas:
        1. No error handling (High priority)
        2. Inconsistent state management (Medium)
        3. Missing tests (High)

        Created a 3-phase migration plan. Should we start with Phase 1:
        Add error boundaries and logging?

You: Yes

Claude: [Launches implementation-planner and backend-engineer]
```

**Mid-Project Changes**
```
You: Actually, we also need user roles - admin, editor, viewer

Claude: Let me analyze the impact of adding user roles.
        [Launches change-analyzer]

        Adding roles affects:
        - Database schema (users table needs role field)
        - Auth system (role-based permissions)
        - 3 existing APIs (need authorization checks)
        - 2 frontend pages (teacher-only views)

        This is a medium-sized change. Should I update the plans and implement it?

You: Yes

Claude: [Updates L1 artifacts, regenerates plans, implements changes]
```

**Debugging**
```
You: The login endpoint is returning 500 errors

Claude: I'll investigate this error.
        [Launches debugger]

        Found the issue. Root cause: Password comparison using = instead of ===
        (type coercion bug).

        Fixed in src/auth/login.ts:45. Added regression test. All tests passing.
```

### Optional: Power User Commands

While conversation mode works automatically, power users can use slash commands:

**Main Project (Analysis & Planning):**
```bash
/analyze <idea>        # Run all analysis agents in parallel
/plan <tech stack>     # Generate feature-based plans
/audit                 # Audit existing codebase
/gap                   # Analyze technical debt
/change <description>  # Analyze change impact
```

**Parallel Development:**
```bash
/parallel <feature>    # Set up git worktree for feature
                       # Creates ../feature-name/ with scoped CLAUDE.md
```

**Quality (Any Context):**
```bash
/debug                 # Launch debugger
/review                # Code review
/verify phase N        # Verify correctness
```

## How It Works

### Two-Level Workflow

**Level 1: Main Project (Analysis & Planning)**
- Define product intent, UX, architecture
- Create feature-based plans (vertical slices)
- Determine what can be built in parallel

**Level 2: Feature Worktrees (Execution)**
- Each developer gets isolated worktree for one feature
- Implement backend + frontend + tests for that feature
- No merge conflicts (different files)
- Push and merge when complete

**Example:**
```
Main project:
  /plan  →  Creates 5 features

Parallel execution:
  Developer 1: /parallel user-auth → ../user-auth/
  Developer 2: /parallel profiles  → ../profiles/
  Developer 3: /parallel notifs    → ../notifs/

All work simultaneously, merge independently.
```

### How It Works

1. **You talk naturally** - No need to memorize commands or agent names
2. **Claude understands intent** - Detects trigger words and context
3. **Agents auto-selected** - Right agents for the job, run in parallel when possible
4. **Results presented** - Claude synthesizes outputs and asks what's next

The system uses:
- **CLAUDE.md** - Project orchestrator configuration (created during install)
- **11 specialized agents** - Each handles specific tasks (analysis, planning, implementation, testing)
- **/docs/** - Documentation artifacts created and used by agents
- **Git worktrees** - Parallel feature development without conflicts
- **Optional commands** - For power users who prefer explicit control

## Agent Auto-Selection

Claude automatically picks agents based on what you say:

| You say... | Claude launches... |
|------------|-------------------|
| "I want to build..." | intent-guardian + ux-architect + agentic-architect |
| "How will users..." | ux-architect |
| "How should this work..." | agentic-architect |
| "Ready to build" | implementation-planner |
| "Implement the backend" | backend-engineer |
| "Implement the UI" | frontend-engineer |
| "Write tests" or "Verify this works" | test-engineer |
| "Review this code" | code-reviewer |
| "It's broken" or "Error" | debugger |
| "Actually, also need..." | change-analyzer |
| "Improve existing code" | gap-analyzer |

## Documentation Structure

Agents create and use `/docs` as the source of truth:

```
/docs
├── intent/
│   └── product-intent.md          # What we promise users
├── ux/
│   └── user-journeys.md           # How users accomplish goals
├── architecture/
│   ├── system-design.md           # System architecture
│   └── agent-topology.md          # Agent design
├── plans/
│   ├── overview/                  # Full system reference
│   │   ├── backend-plan.md        # All endpoints, DB, services
│   │   ├── frontend-plan.md       # All pages, components
│   │   └── test-plan.md           # Test strategy
│   ├── features/                  # Feature-specific (execution)
│   │   ├── user-authentication.md # Vertical slice with all specs
│   │   ├── profile-management.md
│   │   └── ...
│   └── implementation-order.md    # Parallel batches
├── verification/
│   └── phase-N-report.md          # Verification results
├── changes/
│   └── change-[timestamp].md      # Change impact analysis
└── migration/
    └── migration-plan.md          # Brownfield improvement plan
```

## Further Reading

- [WORKFLOW.md](WORKFLOW.md) - Detailed workflow patterns
- [USAGE.md](USAGE.md) - Extended examples
- [AGENTS.md](AGENTS.md) - Agent reference
- [COMMANDS.md](COMMANDS.md) - Command reference

## Requirements

- Claude Code CLI installed and authenticated
- Bash shell (for install script)

## License

MIT
