# Claude Workflow Agents

A conversation-driven multi-agent system for Claude Code. Just talk naturally - Claude automatically orchestrates specialized agents to design, plan, and implement your software projects **one feature at a time**.

**No slash commands required.** Claude understands your intent, creates feature-based plans, and implements features sequentially by default.

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

### Sequential Development (Default)

1. **You talk naturally** - No need to memorize commands or agent names
2. **Claude analyzes** - Understands product intent, UX, architecture
3. **Claude plans** - Creates feature-based breakdown
4. **Claude implements** - Builds features one by one:
   - Feature 1: backend → frontend → tests → ✓
   - Feature 2: backend → frontend → tests → ✓
   - Feature 3: backend → frontend → tests → ✓
5. **You see progress** - Clear updates after each feature

**Example:**
```
You: Build a task manager

Claude: [Analyzes → Plans → Creates 4 features]

        Implementing feature 1: user-authentication...
        ✓ Complete

        Implementing feature 2: task-management...
        ✓ Complete

        ... (continues)
```

### Parallel Development (Opt-In, Advanced)

**Only for teams with multiple developers** who explicitly want to work in parallel.

Run `/parallel <feature>` to create isolated worktrees. Each developer works on one feature independently.

**Not needed for single developers** - sequential mode is simpler and better.

---

The system uses:
- **CLAUDE.md** - Project orchestrator configuration (created during install)
- **11 specialized agents** - Each handles specific tasks (analysis, planning, implementation, testing)
- **/docs/** - Documentation artifacts created and used by agents
- **Feature-based plans** - Work for both sequential and parallel modes
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

## Getting Help

Once installed, you can access the comprehensive help system:

```bash
/agent-wf-help              # Quick overview
/agent-wf-help workflow     # Two-level workflow explanation
/agent-wf-help agents       # All 11 specialized agents
/agent-wf-help commands     # Available commands
/agent-wf-help patterns     # Development patterns & examples
/agent-wf-help parallel     # Parallel development guide
```

Or just ask Claude:
- "How does this work?"
- "What's next?"
- "What should I do?"

## Further Reading

- [GUIDE.md](GUIDE.md) - Complete guide with all topics
- [WORKFLOW.md](WORKFLOW.md) - Detailed workflow patterns
- [USAGE.md](USAGE.md) - Extended examples
- [AGENTS.md](AGENTS.md) - Agent reference
- [COMMANDS.md](COMMANDS.md) - Command reference

## Requirements

- Claude Code CLI installed and authenticated
- Bash shell (for install script)

## License

MIT
