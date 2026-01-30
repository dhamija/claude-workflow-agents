# Claude Workflow Agents

A **skills-based workflow system** for Claude Code that helps you build software systematically. Works for both new projects and existing codebases.

**Just talk naturally.** Claude automatically loads the right skills and uses the right agents.

> **Version:** 3.1.0
> **Architecture:** Skills + Hooks + Subagents

---

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Architecture](#architecture)
- [Usage](#usage)
- [New Projects (Greenfield)](#new-projects-greenfield)
- [Existing Projects (Brownfield)](#existing-projects-brownfield)
- [Commands Reference](#commands-reference)
- [Skills Reference](#skills-reference)
- [Going Deeper](#going-deeper)
- [FAQ](#faq)

---

## Quick Start

### 1. Install (One-Time)
```bash
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
source ~/.bashrc  # or restart terminal
```

Workflow is immediately active for all Claude Code sessions.

### 2. Initialize in Your Project
```bash
cd your-project
workflow-init
```

Choose whether to enable automatic quality gate reminders (hooks).

### 3. Use
Just describe what you want:
```
You: Build me a recipe app where I can save and search my favorite recipes

Claude: [Loads workflow skill → Creates intent → Designs UX → Plans architecture → Starts building]
```

That's it. Claude handles the rest.

---

## Installation

### Quick Install (Latest Stable)
```bash
# Install latest stable release (recommended)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash
```

Then restart your terminal (or `source ~/.bashrc`).

### Version Selection

```bash
# Latest stable release (default)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s latest

# Specific version
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s v3.1.0

# Bleeding edge (master branch)
curl -fsSL https://raw.githubusercontent.com/dhamija/claude-workflow-agents/master/install.sh | bash -s master
```

**What this does:**
- Installs to `~/.claude-workflow-agents/` (global location)
- Copies **12 skills** to `~/.claude/skills/` (loaded on-demand by Claude)
- Symlinks **3 subagents** to `~/.claude/agents/` (for isolated tasks)
- Symlinks **28 commands** to `~/.claude/commands/`
- Adds workflow commands to PATH

### What Gets Installed

#### Skills (Loaded On-Demand)
Skills are domain expertise modules that Claude loads automatically when needed:

| Skill | Purpose |
|-------|---------|
| `workflow` | Orchestration, L1/L2 phase management |
| `ux-design` | UX principles (Fitts's, Hick's, Miller's Laws, etc.) |
| `frontend` | Frontend development + design principle application |
| `backend` | API, database, validation patterns |
| `testing` | Test strategies (unit/integration/E2E) |
| `validation` | Promise acceptance testing |
| `debugging` | Systematic debugging protocols |
| `code-quality` | Code review criteria |
| `brownfield` | Existing codebase analysis |
| `llm-user-testing` | LLM-as-user testing protocols |
| `gap-resolver` | Systematic gap resolution from test results |
| `solution-iteration` | Multi-approach evaluation using LLM judges |

#### Subagents (Isolated Context)
Subagents are isolated execution environments for specific tasks:

| Subagent | Purpose |
|----------|---------|
| `code-reviewer` | Read-only code quality review |
| `debugger` | Isolated debugging sessions |
| `ui-debugger` | UI debugging with browser automation |

#### Terminal Commands

| Command | Description |
|---------|-------------|
| `workflow-init` | Initialize workflow in a project |
| `workflow-toggle on/off/status` | Enable, disable, or check status |
| `workflow-update [version]` | Update to latest/specific version |
| `workflow-version` | Show version info |
| `workflow-uninstall` | Remove installation |

**workflow-update examples:**
```bash
workflow-update           # Update to latest stable release
workflow-update latest    # Update to latest stable release
workflow-update v3.1.0    # Update to specific version
workflow-update master    # Update to bleeding edge
```

#### Claude Commands (In-Project)

| Command | Description |
|---------|-------------|
| `/help` | In-app help system |
| `/workflow on/off/status` | Enable/disable/check workflow |
| `/analyze` | Run all L1 planning agents |
| `/audit` | Audit existing codebase |
| `/gap` | Find code quality gaps |
| `/implement <feature>` | Implement a feature |
| `/review <files>` | Code review |
| `/debug <issue>` | Debug problem |
| `/test-ui` | Run LLM user tests against UI |
| `/llm-user` | LLM user testing commands (init/gaps/refresh) |

See [Commands Reference](#commands-reference) for all 26 commands.

### Verify Installation
```bash
ls ~/.claude/skills/              # Should show 10 directories
ls ~/.claude/agents/*.md          # Should show 3 subagents
workflow-version                  # Should show v3.1.0
```

### Uninstall

```bash
workflow-uninstall
```

Removes skills, symlinks, and installation directory. Preserves user's own agents/commands.

---

## Architecture

### v3.1: Skills + Hooks

Claude Workflow Agents uses a **context-efficient architecture**:

```
~/.claude/skills/                   # Skills (loaded on-demand)
├── workflow/SKILL.md               # Orchestration logic
├── ux-design/SKILL.md              # Design principles
├── frontend/SKILL.md               # Frontend expertise
├── backend/SKILL.md                # Backend expertise
├── testing/SKILL.md                # Test strategies
├── validation/SKILL.md             # Promise validation
├── debugging/SKILL.md              # Debug protocols
├── code-quality/SKILL.md           # Review criteria
└── brownfield/SKILL.md             # Codebase analysis

~/.claude/agents/                   # Subagents (isolated tasks)
├── code-reviewer.md                # Code review
├── debugger.md                     # Debugging
└── ui-debugger.md                  # UI debugging

Project/.claude/settings.json       # Hooks (optional)
                                    # Auto-quality reminders

Project/CLAUDE.md                   # Minimal (~80 lines)
                                    # State only, skills load on-demand
```

### Benefits

**Context Efficiency:**
- v2.0: 750+ lines loaded every session
- v3.1: ~80 lines + skills loaded only when needed
- **90% reduction in upfront context**

**Performance:**
- Less context = better model performance
- On-demand loading = faster responses
- Skills cache between sessions

**Modularity:**
- Skills can be updated independently
- Easy to add new domain expertise
- User can create custom skills

**Automatic Quality:**
- Hooks inject reminders after code changes
- Completion checklist before marking done
- No manual intervention needed

---

## Usage

### Workflow Phases

Claude Workflow follows a structured approach:

**L1: Planning (Greenfield Projects)**
```
Intent → UX → Architecture → Implementation Plans
```

**L2: Building (Per Feature)**
```
Backend → Review → Frontend → Review → Tests → Validate → Complete
```

**Analysis (Brownfield Projects)**
```
Scan Codebase → Infer State → Ask User → Continue with L2
```

### Natural Language Interface

Just describe what you want. Claude loads the appropriate skills automatically:

```
You: "I want to build a recipe app"
→ Claude loads workflow skill → Starts L1 planning

You: "Add authentication"
→ Claude loads change-analysis skill → Assesses impact → Updates docs → Implements

You: "The login button isn't working"
→ Claude loads debugging skill → Diagnoses → Fixes → Adds regression test

You: "Improve the codebase"
→ Claude loads brownfield + gap-analysis skills → Finds issues → Creates migration plan
```

### Automatic Agent Chaining

You never manually invoke agents. Claude orchestrates automatically:

**Example flow:**
1. User: "Build a todo app"
2. Claude loads `workflow` skill
3. Workflow skill triggers intent-guardian (via Task tool)
4. Intent-guardian completes → workflow skill triggers ux-architect
5. UX-architect completes → workflow skill triggers agentic-architect
6. And so on...

### Hooks (Optional Quality Gates)

When you run `workflow-init`, you can enable automatic reminders:

**PostToolUse Hook:**
```
You: [Makes code changes with Edit tool]
Claude: ⚠️  [QUALITY REMINDER] Code changed.
        Consider running code-reviewer subagent after completing current task.
```

**Stop Hook:**
```
You: [Clicks stop]
Claude: ✓ [COMPLETION CHECKLIST]
          • Tests passing?
          • Code reviewed?
          • CLAUDE.md state updated?
          • Documentation synced?
```

Enable hooks during `workflow-init` or manually create `.claude/settings.json` (see templates/hooks/).

---

## New Projects (Greenfield)

### Step 1: Initialize

```bash
mkdir my-app
cd my-app
workflow-init
```

Output:
```
🌱 GREENFIELD PROJECT

   New project.
   Claude will start L1 planning from scratch.

✓ CLAUDE.md created (~80 lines, context-efficient)
✓ Workflow state initialized
✓ Type: greenfield

Skills location: ~/.claude/skills/
Subagents: code-reviewer, debugger, ui-debugger

NEXT STEPS:
1. Open Claude in this project
2. Describe what you want to build
3. Claude will run L1 planning automatically
```

### Step 2: Describe Your Project

```
You: I want to build a Spanish learning app that teaches vocabulary
     through visual associations without any English translations
```

### Step 3: Claude Runs L1 Planning Automatically

**Claude's Process (Automatic):**

1. **Loads workflow skill** (orchestration logic)
2. **Intent Guardian** - Captures your promises:
   - MUST teach Spanish vocabulary
   - MUST use only visual associations
   - MUST NOT show English translations
   - Creates `docs/intent/product-intent.md`

3. **UX Architect** - Designs user experience:
   - Applies Fitts's Law (44px touch targets)
   - Applies Hick's Law (≤7 options visible)
   - Creates journey maps
   - Creates `docs/ux/user-journeys.md`

4. **Agentic Architect** - Designs system:
   - Maps promises to components
   - Designs agent interactions
   - Creates `docs/architecture/agent-design.md`

5. **Implementation Planner** - Creates build plans:
   - Breaks into features
   - Each feature has backend/frontend/test steps
   - Creates `docs/plans/phase-1.md`

### Step 4: Claude Starts L2 Building

For each feature:

```
Backend → code-reviewer → tests
Frontend → code-reviewer → tests → ui-debugger (if available)
Testing → full test suite
Validation → promises validated? → COMPLETE
```

### Step 5: You Review and Approve

Claude asks for confirmation at key points:
- After L1 planning: "Does this match your vision?"
- After each feature: "Tests pass, ready for next feature?"
- After validation: "All promises validated, feature complete?"

---

## Existing Projects (Brownfield)

### Step 1: Initialize in Existing Project

```bash
cd existing-project
workflow-init
```

Output:
```
📦 BROWNFIELD PROJECT

   Existing code detected.
   Claude will analyze the codebase first to understand what's built.

✓ CLAUDE.md created (~80 lines, context-efficient)
✓ Workflow state initialized
✓ Type: brownfield

NEXT STEPS:
1. Open Claude in this project
2. Claude will automatically analyze your codebase
3. Confirm the analysis
4. Continue development from inferred state
```

### Step 2: Claude Analyzes Automatically

**Claude's Process (Automatic):**

1. **Loads brownfield skill** (codebase analysis)
2. **Scans your code:**
   - Detects tech stack
   - Identifies features
   - Infers promises (what the app is supposed to do)
   - Estimates test coverage

3. **Creates [INFERRED] documentation:**
   - `docs/intent/product-intent.md` (marked INFERRED)
   - `docs/architecture/system-design.md` (marked INFERRED)
   - `docs/plans/current-state.md`

4. **Asks what you want to do:**
   - Add a feature?
   - Fix a bug?
   - Improve code quality?
   - Refactor?

### Step 3: Choose Your Path

**Add Feature:**
```
You: Add user authentication

Claude: [Loads change-analysis skill]
        → Analyzes impact on architecture
        → Updates intent doc with new promises
        → Creates feature plan
        → Starts L2 building
```

**Find Issues:**
```
You: Find problems with the codebase

Claude: [Loads gap-analysis skill]
        → Compares current vs. ideal
        → Creates migration plan with priorities
        → Shows Critical/High/Medium/Low gaps
```

**Fix Bug:**
```
You: The login form isn't working

Claude: [Loads debugging skill]
        → Systematic diagnosis
        → Root cause analysis
        → Fix + regression test
        → code-reviewer validates
```

**Improve Quality:**
```
You: Improve code quality

Claude: [Loads gap-analysis skill]
        → Finds gaps (missing tests, tech debt, etc.)
        → Creates prioritized plan
        → Fixes one by one with tests
```

---

## Commands Reference

### Planning Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/analyze` | Run all L1 agents (intent, UX, architecture, plans) | New project, want full planning |
| `/intent` | Define product intent and promises | Capture what app must do |
| `/ux` | Design user experience | Plan user journeys |
| `/plan` | Create implementation plans | After architecture done |
| `/replan` | Regenerate plans after changes | After major architecture change |

### Building Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/implement <feature>` | Build a specific feature | Ready to code |
| `/iterate` | Compare approaches using LLM judges | Evaluating options |
| `/verify` | Run full verification (tests, promises, docs) | Before marking feature complete |
| `/review <files>` | Code review | After implementing |
| `/debug <issue>` | Launch debugger | Something broken |

### Brownfield Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/audit` | Analyze existing codebase | First time in brownfield project |
| `/gap` | Find code quality gaps | Want to improve existing code |
| `/improve <phase>` | Fix gaps from migration plan | Incrementally improve code |
| `/change <feature>` | Analyze impact of adding feature | Before implementing in brownfield |

### UX/Design Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/ux` | Design user experience | Planning UX |
| `/ux-audit` | Audit current UX | Improve existing UX |
| `/design preset <name>` | Apply design system preset | Want consistent styling |
| `/design reference <url>` | Design based on reference site | Match existing design |

### Architecture Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/aa` | Agentic architecture analysis | New project architecture |
| `/aa-audit` | Audit for agentic opportunities | Optimize existing architecture |

### Workflow Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/help` | Show help system | Learn about commands/patterns |
| `/workflow on/off/status` | Enable/disable/check | Toggle workflow |
| `/parallel <features>` | Implement multiple features in parallel | Speed up development |
| `/update` | Update workflow state | Manual state sync |

### Project Operations Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/project setup` | Initialize infrastructure (scripts, CI, hooks) | Setup automation |
| `/project sync` | Sync docs with code | After implementation |
| `/project verify` | Verify everything (tests, docs, intent) | Quality check |
| `/project docs` | Generate documentation | Create docs from code |
| `/project ai setup` | Configure LLM provider | Setup AI features |
| `/project mcp setup` | Configure MCP servers | Setup integrations |
| `/project status` | Show project health | Check overall status |
| `/project commit` | Guided conventional commit | Make clean commits |
| `/project push` | Push current branch | Deploy changes |
| `/project pr` | Create pull request | Open PR with summary |

### Testing Commands

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/llm-user init` | Generate LLM user testing infrastructure | After L1 planning complete |
| `/test-ui` | Run LLM user tests against UI | Test deployed UI |
| `/llm-user gaps` | View detailed gap analysis from tests | After test run |
| `/llm-user refresh` | Regenerate tests after doc changes | Docs updated |

### Git Workflow

The workflow supports conventional commits and PR creation:

```
/project commit
→ Analyzes changed files
→ Suggests commit type (feat/fix/refactor/docs/test/chore)
→ Generates commit message
→ Shows staged changes
→ Asks for confirmation

/project pr
→ Analyzes full branch changes
→ Generates PR title and summary
→ Creates TODO checklist for testing
→ Opens PR (with GitHub MCP if available)
```

---

## Skills Reference

### Workflow Orchestration

**Skill:** `workflow`
**Auto-loaded:** When managing project phases
**Purpose:** Orchestration logic for L1/L2 flows

**Capabilities:**
- L1 planning flow (Intent → UX → Architecture → Plans)
- L2 building flow (Backend → Frontend → Tests → Validate)
- Brownfield flow (Analyze → Infer → Continue)
- Quality gate enforcement
- Issue detection and response

### UX Design Principles

**Skill:** `ux-design`
**Auto-loaded:** When designing interfaces or reviewing UX
**Purpose:** Apply proven UX design laws

**Includes:**
- **Fitts's Law** - Touch target sizing (≥44px)
- **Hick's Law** - Choice reduction (≤7 options)
- **Miller's Law** - Information chunking (7±2 items)
- **Jakob's Law** - Familiar patterns
- **Aesthetic-Usability Effect** - Visual polish
- **Progressive Disclosure** - Complexity hiding
- **Recognition over Recall** - Visible options
- **Doherty Threshold** - Response time (<400ms)

### Frontend Development

**Skill:** `frontend`
**Auto-loaded:** When implementing UI
**Purpose:** Frontend expertise with auto-applied design principles

**Includes:**
- Component patterns (button, input, form, layout)
- State management (Zustand/Redux patterns)
- Design principle application (from ux-design skill)
- TypeScript + React best practices
- Accessibility (ARIA, keyboard nav, screen readers)
- Performance (lazy loading, memoization)

### Backend Development

**Skill:** `backend`
**Auto-loaded:** When implementing APIs/services
**Purpose:** Backend patterns and best practices

**Includes:**
- REST API design (Express/FastAPI/etc.)
- Database patterns (Prisma/TypeORM/SQLAlchemy)
- Validation (Zod/Pydantic)
- Authentication & authorization
- Error handling patterns
- Testing strategies (unit/integration)

### Testing Strategies

**Skill:** `testing`
**Auto-loaded:** When writing tests
**Purpose:** Test pyramid and coverage strategies

**Includes:**
- Test pyramid (70% unit, 20% integration, 10% E2E)
- Unit test patterns
- Integration test patterns
- E2E test patterns (Playwright/Cypress)
- Test data factories
- Mocking strategies

### Promise Validation

**Skill:** `validation`
**Auto-loaded:** After tests pass
**Purpose:** Validate promises are actually kept

**Difference from testing:**
- Tests: Code works correctly
- Validation: Promises are kept

**Example:**
```
Promise: "User can search recipes by ingredient"
Test passing: Search API returns 200 OK
Validation: User can actually find recipes by typing "chicken" in search
```

### Debugging Protocols

**Skill:** `debugging`
**Auto-loaded:** When issues reported
**Purpose:** Systematic debugging approach

**Protocol:**
1. Reproduce issue
2. Isolate root cause
3. Verify hypothesis
4. Apply minimal fix
5. Add regression test
6. Verify fix

### Code Quality Review

**Skill:** `code-quality`
**Auto-loaded:** After code changes (via hook) or manual `/review`
**Purpose:** Code review criteria

**Checks:**
- Security (injection, auth, secrets)
- Performance (N+1, large loops, memory leaks)
- Correctness (logic errors, edge cases)
- Maintainability (complexity, naming, structure)
- Testing (coverage, quality)
- Intent compliance (promises kept?)

### Brownfield Analysis

**Skill:** `brownfield`
**Auto-loaded:** First session in existing project
**Purpose:** Understand existing codebase

**Process:**
1. Detect tech stack
2. Scan file structure
3. Identify features
4. Infer promises
5. Estimate test coverage
6. Create [INFERRED] documentation

### LLM User Testing

**Skill:** `llm-user-testing`
**Auto-loaded:** When working with `/llm-user` or `/test-ui` commands
**Purpose:** Domain-specific LLM-as-user testing protocols

**Provides:**
- LLM user simulation principles (authenticity, persona-driven behavior)
- Action loop protocol (observe → think → decide → act → react)
- Frustration dynamics and abandonment thresholds
- Gap analysis methodology (identification, root cause, traceability)
- Domain-specific testing patterns (learning apps, creative tools, etc.)
- Evaluation rubrics and weighted scoring

**Key insight:** Your L1 docs already contain everything needed to test your app - this skill shows how to synthesize them into executable LLM user tests.

### Gap Resolution

**Skill:** `gap-resolver`
**Auto-loaded:** When working with `/fix-gaps` commands
**Purpose:** Systematic gap resolution from LLM user testing results

**Provides:**
- Gap prioritization logic (CRITICAL > HIGH > MEDIUM > LOW)
- Fix specification templates with structured problem analysis
- Task orchestration through workflow agents
- Verification protocols (re-run failed scenarios)
- Promise validation tracking
- Comprehensive improvement reporting

**Commands:**
```bash
/fix-gaps                   # Start systematic gap resolution
/fix-gaps --priority=critical  # Fix only critical gaps
/fix-gaps status            # Show resolution progress
/fix-gaps verify            # Re-run tests to validate fixes
/fix-gaps report            # Generate improvement report
/fix-gaps list              # List and filter gaps
```

**Gap-Driven Development Cycle:**
```
/test-ui              → Run LLM user tests
/llm-user gaps        → Review identified gaps
/fix-gaps             → Systematically fix gaps
/fix-gaps verify      → Validate fixes work
/fix-gaps report      → Track improvement journey
```

**Key insight:** LLM user testing finds what's broken from the user's perspective - gap-resolver systematically fixes it and proves promises are kept.

### Solution Iteration

**Skill:** `solution-iteration`
**Auto-loaded:** When comparing approaches or making architectural decisions
**Purpose:** Evaluate multiple solutions using diverse LLM perspectives to find optimal approach

**Provides:**
- Multi-dimensional evaluation (UX, technical, business, security perspectives)
- Judge personas (Pragmatist, Innovator, User Advocate, Business Strategist, Technical Architect, Security Auditor)
- Synthesis of insights across evaluations
- Hybrid approach generation combining best elements
- Progressive refinement through multiple rounds

**Commands:**
```bash
/iterate "Should I use X or Y?"     # Quick 2-approach comparison
/iterate compare                    # Detailed comparison with multiple judges
/iterate evaluate                   # Full evaluation of 3+ approaches
/iterate refine                     # Progressive improvement rounds
```

**Evaluation Flow:**
```
Generate Approaches → Document Each → Run Judge Evaluations → Synthesize Insights → Recommend/Refine
```

**Example Use Cases:**
- **Architecture decisions:** REST vs GraphQL vs tRPC
- **State management:** Context vs Redux vs Zustand
- **UI patterns:** Tabs vs Accordion vs Drawer
- **Performance optimization:** Caching vs Indexing vs Redesign

**Key insight:** Different approaches excel in different dimensions. Using multiple LLM judges reveals trade-offs and often leads to hybrid solutions that combine the best elements of each approach.

---

## Going Deeper

### Design Systems

Apply consistent styling with presets or references:

**Presets:**
```
/design preset modern-clean
/design preset minimal
/design preset playful
/design preset corporate
/design preset glassmorphism
```

Creates `docs/ux/design-system.md` with:
- Colors, typography, spacing
- Component specifications
- Visual guidelines

**Reference-based:**
```
/design reference https://example.com
```

Analyzes the site and extracts design system.

### Multi-LLM Integration

Setup AI-powered features in your app:

```
/project ai setup
```

Choose provider:
- Anthropic (Claude)
- OpenAI (GPT)
- Google (Gemini)
- Ollama (local)

Generates:
- LLM client abstraction
- Provider adapters
- Cost tracking
- Error handling

See `templates/integrations/llm/` for code.

### MCP Server Integration

Connect to Model Context Protocol servers:

```
/project mcp setup
```

Configures Claude Code to use MCP servers for:
- GitHub operations (PRs, issues)
- Filesystem access
- Database queries
- Custom integrations

### Parallel Development

Speed up implementation by building multiple features at once:

```
/parallel "user auth, recipe search, favorites"
```

Claude:
1. Plans all features
2. Checks for dependencies
3. Implements in parallel (using multiple Task calls)
4. Runs full test suite after all complete
5. Validates all promises together

### Hooks Customization

Customize `.claude/settings.json` for your workflow:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": { "tool_name": "Write|Edit" },
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Code changed. Run tests?'"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Remember to commit changes!'"
          }
        ]
      }
    ]
  }
}
```

---

## FAQ

### General

**Q: How do I disable the workflow?**
A: Run `workflow-toggle off` or remove the CLAUDE.md file.

**Q: Does this work with existing projects?**
A: Yes! Run `workflow-init` in any directory. Claude analyzes existing code automatically (brownfield mode).

**Q: Can I use this with non-Node.js projects?**
A: Yes! Works with Python, Go, Rust, or any language. Tech stack auto-detected.

**Q: How much context does this use?**
A: ~80 lines from CLAUDE.md + skills loaded on-demand. 90% less than v2.0.

**Q: What if I don't want hooks?**
A: Say "n" during `workflow-init`. Hooks are optional.

### Technical

**Q: Where are skills stored?**
A: `~/.claude/skills/` - Claude loads them automatically when needed.

**Q: Where are subagents stored?**
A: Symlinked from `~/.claude-workflow-agents/agents/` to `~/.claude/agents/`.

**Q: Can I create custom skills?**
A: Yes! Create `~/.claude/skills/my-skill/SKILL.md` with frontmatter `name` and `description`.

**Q: How do I update?**
A: Run `workflow-update`. It updates the global installation (skills, subagents, commands).

**Q: What's the difference between skills and subagents?**
A:
- **Skills** = Domain expertise, loaded in main Claude context
- **Subagents** = Isolated execution environments, separate context

**Q: Do I need to initialize in every project?**
A: Only if you want project-specific CLAUDE.md tracking state. Skills work globally without it.

### Workflow

**Q: Can I skip L1 planning?**
A: For small features in brownfield projects, yes. Just say "add [feature]" and Claude uses change-analysis.

**Q: How do I know what phase I'm in?**
A: Check CLAUDE.md workflow state or run `/workflow status`.

**Q: Can Claude switch between projects?**
A: Skills are global, so yes. Each project has its own CLAUDE.md with independent state.

**Q: What if tests fail?**
A: Claude automatically loads debugger skill, fixes, and retries. Quality gate won't pass until tests pass.

### Customization

**Q: Can I modify the L1/L2 flows?**
A: Yes, edit `~/.claude/skills/workflow/SKILL.md`. Be careful - orchestration logic is complex.

**Q: Can I add my own agents?**
A: Yes, create them in `~/.claude/agents/`. Workflow won't auto-chain them, but you can invoke manually.

**Q: Can I change the design principles?**
A: Yes, edit `~/.claude/skills/ux-design/SKILL.md`.

### Troubleshooting

**Q: Claude isn't loading skills automatically**
A: Check `ls ~/.claude/skills/`. If empty, run `workflow-update` to reinstall.

**Q: Subagents not found**
A: Check `ls ~/.claude/agents/*.md`. Should show 4 files. If not, run `workflow-update`.

**Q: Commands not working**
A: Check `ls ~/.claude/commands/*.md`. Should show 26 files. If not, run `workflow-update`.

**Q: Hook reminders not showing**
A: Check `.claude/settings.json` exists. If not, run `workflow-init` again and enable hooks.

---

## Testing

### For Users

Projects have test infrastructure set up automatically:

```bash
# After Claude implements features
npm test               # Run test suite
npm run test:coverage  # Check coverage
npm run test:e2e       # Run E2E tests
```

Claude writes tests as part of L2 building flow.

### For Contributors

```bash
# Run all workflow system tests
cd claude-workflow-agents
./tests/run_all_tests.sh

# Run specific test category
./tests/structural/test_agents_exist.sh
./tests/install/test_workflow_init_greenfield.sh
```

See [tests/README.md](tests/README.md) for details.

---

## More Resources

- [CHANGELOG.md](CHANGELOG.md) - Release history
- [CLAUDE.md](CLAUDE.md) - Contributor maintenance guide
- [commands/help.md](commands/help.md) - In-app help system
- [agents/workflow-orchestrator.md](agents/workflow-orchestrator.md) - Architecture reference
- [templates/](templates/) - All templates (projects, docs, infrastructure, integrations)

### Documentation Files

- `AGENTS.md` - Agent reference (legacy, now mostly skills)
- `COMMANDS.md` - Command reference
- `EXAMPLES.md` - Example conversations
- `PATTERNS.md` - Common usage patterns
- `GUIDE.md` - Detailed guide
- `WORKFLOW.md` - Workflow deep-dive

---

## Releasing (Maintainers)

### Create Release

```bash
# 1. Update version
echo "2.x.x" > version.txt

# 2. Update CHANGELOG.md
# Add release notes

# 3. Commit
git add version.txt CHANGELOG.md
git commit -m "chore: bump version to 2.x.x"

# 4. Tag
git tag -a v2.x.x -m "Release v2.x.x"

# 5. Push
git push origin master --tags
```

Users update with:
```bash
workflow-update
```

---

## License

MIT License - see LICENSE file
