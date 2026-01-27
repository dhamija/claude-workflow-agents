# Quick Reference

> **v2.1 Architecture:** Skills + Hooks for context efficiency. 9 skills loaded on-demand, 3 subagents for isolated tasks, ~80 line CLAUDE.md. 90% less context than v2.0.

> **Getting Started:** Install once globally → `workflow-init` in your project → Just talk!

```bash
# Once (global)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash

# Per project
cd your-project
workflow-init
```

---

## Just Talk

Most common actions - no commands needed:

| Action | Just Say |
|--------|----------|
| Start new project | "Build me a [description]" |
| Add feature | "Add [feature]" |
| Fix bug | "The [thing] is broken - [error]" |
| Improve code | "Analyze this codebase" |
| Continue work | "Continue" |
| Check progress | "Where are we?" |
| Review code | "Review the [thing]" |
| Change something | "Actually, change [thing] to [other]" |
| Save session state | "Save state" or "Before I go" |

---

## Optional Commands

### Project Operations
```
/project setup       # Initialize infrastructure
/project sync        # Update project state & docs
/project sync quick  # Quick state update
/project verify      # Check compliance
/project docs        # Manage documentation
/project ai          # LLM integration
/project mcp         # MCP servers
/project status      # Show project health
```

### Development
```
/review [target]     # Review code (file, dir, or "staged")
/plan show           # Display current plans
/debug               # Launch debugger
/implement           # Implement from plans
```

### Parallel Development (Teams Only)
```
/parallel <feature>  # Create worktree for feature
```

### Help
```
/help                # Quick overview
/help workflow       # Two-level workflow
/help agents         # All 12 agents
/help commands       # All commands
/help patterns       # Usage patterns
/help parallel       # Parallel development
/help brownfield     # Existing codebases
/help examples       # Practical examples
```

---

## Workflow Overview

### New Projects (Greenfield)
```
"Build me a [app]"
      ↓
Analyze (intent → UX + design system → architecture)
      ↓
Plan (features with dependencies)
      ↓
Build (one feature at a time: backend → frontend [follows design system] → tests)
      ↓
Done
```

### Existing Projects (Brownfield)
```
"Analyze this codebase"
      ↓
Audit (infer intent/UX/architecture)
      ↓
Review [INFERRED] docs
      ↓
Gap Analysis (find issues)
      ↓
Improve (fix by priority: Critical → High → Medium → Low)
```

---

## Documents Created

```
/docs
├── intent/
│   └── product-intent.md          # What we promise users
├── ux/
│   ├── user-journeys.md           # How users interact
│   └── design-system.md           # Visual specifications (colors, typography, components)
├── architecture/
│   └── agent-design.md            # System design
├── plans/
│   ├── overview/                  # Full system specs
│   │   ├── backend-plan.md
│   │   ├── frontend-plan.md
│   │   └── test-plan.md
│   ├── features/                  # Per-feature plans
│   │   ├── auth.md
│   │   ├── profile.md
│   │   └── ...
│   └── implementation-order.md    # Build sequence
├── gaps/                          # Brownfield only
│   ├── gap-analysis.md
│   └── migration-plan.md
└── verification/
    └── phase-N-report.md
```

---

## Help Topics

| Topic | Shows |
|-------|-------|
| `workflow` | Two-level workflow (App → Features) |
| `agents` | All 12 agents and when they run |
| `commands` | All available commands |
| `patterns` | Common development patterns |
| `parallel` | Parallel development (teams) |
| `brownfield` | Working with existing code |
| `examples` | Practical examples |

---

## The 11 Agents

### Level 1: App Analysis (Run Once)
| Agent | Creates | Trigger |
|-------|---------|---------|
| **intent-guardian** | Product intent & promises | "build", "create", new project |
| **ux-architect** | User journeys & design system | "build", "UX", new project |
| **agentic-architect** | System architecture | "build", "architecture", new project |
| **implementation-planner** | Implementation plans | After analysis |
| **change-analyzer** | Change impact analysis | "add", "change", "also need" |
| **gap-analyzer** | Gap analysis & migration plan | "analyze", "improve", existing code |

### Level 2: Feature Work (Run Per Feature)
| Agent | Does | Trigger |
|-------|------|---------|
| **backend-engineer** | APIs, database, services | Backend work |
| **frontend-engineer** | Pages, components (follows design system) | Frontend work |
| **test-engineer** | Tests & verification | Testing, after implementation |
| **code-reviewer** | Code quality & security | "review", before milestone |
| **debugger** | Fix bugs & errors | "broken", "error", "bug" |

### Operations
| Agent | Does | Trigger |
|-------|------|---------|
| **project-ops** | Setup, sync, verify, docs, AI | "/project" command |

---

## Quick Examples

### Start New Project
```
You: Build me a recipe app
Claude: [Creates intent, UX, architecture, plans, implements features]
```

### Add Feature
```
You: Add comments on recipes
Claude: [Analyzes impact, updates plans, implements]
```

### Fix Existing Code
```
You: Analyze this codebase
Claude: [Audits code, finds gaps, proposes fixes]
```

### Continue Work
```
You: Continue
Claude: [Picks up where it left off]
```

### Check Status
```
You: Where are we?
Claude: ✓ auth (done), 🔄 recipes (in progress), ○ search (pending)
```

---

## Key Principles

1. **Just talk** - Commands are optional shortcuts
2. **Sequential by default** - One feature at a time
3. **Conversation-driven** - Natural language works
4. **Document-based** - `/docs` is source of truth
5. **Verification included** - Tests after each feature
6. **Parallel is opt-in** - Only for multi-developer teams

---

For detailed explanations, see:
- **README.md** - Comprehensive guide with examples
- **WORKFLOW.md** - Deep dive into workflow
- **EXAMPLES.md** - Real-world scenarios
- **/agent-wf-help** - In-app help system
