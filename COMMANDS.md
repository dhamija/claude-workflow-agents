# Command Reference

> **v3.0 Note:** Commands work the same way, but now they leverage **skills** and invoke **subagents** automatically. You don't need to know about the architecture - just use the commands naturally or describe what you want.

This document provides detailed information about each workflow command.

## Table of Contents

- [Greenfield Commands](#greenfield-commands)
  - [/analyze](#analyze)
  - [/plan](#plan)
  - [/implement](#implement)
  - [/verify](#verify)
- [Brownfield Commands](#brownfield-commands)
  - [/audit](#audit)
  - [/gap](#gap)
  - [/improve](#improve)
- [Change Management Commands](#change-management-commands)
  - [/change](#change)
  - [/update](#update)
  - [/replan](#replan)
- [Focused Commands](#focused-commands)
  - [/intent](#intent)
  - [/intent-audit](#intent-audit)
  - [/ux](#ux)
  - [/ux-audit](#ux-audit)
  - [/aa](#aa)
  - [/aa-audit](#aa-audit)
- [Design Commands](#design-commands)
  - [/design](#design)
- [Enhancement Commands](#enhancement-commands)
  - [/mcp](#mcp)
  - [/llm](#llm)
- [Quality Commands](#quality-commands)
  - [/review](#review)
  - [/debug](#debug)
- [Maintenance Commands](#maintenance-commands)
  - [/sync](#sync)

---

## Greenfield Commands

Commands for building new projects from scratch.

### /analyze

**Purpose:** Run parallel analysis for a new project idea

**Usage:**
```bash
/analyze <app idea>
```

**What it does:**
Launches three agents **in parallel**:
1. **intent-guardian** → Creates `/docs/intent/product-intent.md`
2. **ux-architect** → Creates `/docs/ux/user-journeys.md`
3. **agentic-architect** → Creates `/docs/architecture/agent-design.md`

**Output:**
- Product intent with promises, invariants, boundaries
- User personas and journey maps
- System architecture with agent vs code separation

**Next step:**
```bash
/plan <tech stack>
```

**Examples:**
```bash
/analyze food delivery app connecting restaurants with customers

/analyze B2B SaaS for invoice management with OCR and approval workflows

/analyze AI-powered tutoring system with personalized learning paths
```

**When to use:**
- Starting a completely new project
- Have an idea but need structured design
- Want to ensure alignment between intent, UX, and architecture

---

### /plan

**Purpose:** Generate detailed implementation plans from analysis

**Usage:**
```bash
/plan <optional tech stack>
```

**Prerequisites:**
Must have these files (run `/analyze` first):
- `/docs/intent/product-intent.md`
- `/docs/ux/user-journeys.md`
- `/docs/architecture/agent-design.md`

**What it does:**
Uses **implementation-planner** to synthesize all analysis and produce:
1. `/docs/plans/backend-plan.md` - Data model, APIs, services, agents
2. `/docs/plans/frontend-plan.md` - Components, pages, state, routes
3. `/docs/plans/test-plan.md` - Test strategy (unit, integration, E2E)
4. `/docs/plans/implementation-order.md` - Phased execution plan

**Output:**
- Detailed technical specifications
- Database schema
- API endpoints with request/response shapes
- Component inventory
- Test requirements
- Implementation phases

**Next step:**
```bash
/implement phase 1
```

**Examples:**
```bash
/plan fastapi react postgres

/plan node express react postgres redis

/plan python flask vue mysql
```

**When to use:**
- After analysis is complete and reviewed
- Before writing any code
- When you need detailed specs for implementation

---

### /implement

**Purpose:** Build the system phase by phase according to plans

**Usage:**
```bash
/implement <"phase N" or specific component>
```

**Prerequisites:**
Must have plans (run `/plan` first):
- `/docs/plans/backend-plan.md`
- `/docs/plans/frontend-plan.md`
- `/docs/plans/test-plan.md`
- `/docs/plans/implementation-order.md`

**What it does:**
1. Reads the target (phase or component)
2. Delegates to appropriate engineer:
   - **backend-engineer** for APIs, database, services
   - **frontend-engineer** for components, pages, state
   - **test-engineer** for tests
3. Writes code according to specs
4. Runs tests after each item
5. Commits changes
6. Verifies against intent

**After phase completes:**
- Runs **test-engineer** in verification mode
- Checks for regressions
- Validates journeys
- Saves report to `/docs/verification/phase-N-report.md`

**Next step:**
```bash
/verify phase N  # or it auto-verifies
/implement phase N+1
```

**Examples:**
```bash
/implement phase 1

/implement auth endpoints

/implement phase 2

/implement dashboard page
```

**When to use:**
- After plans are complete and reviewed
- To build each phase in sequence
- To implement specific components

**Implementation flow:**
```
/implement phase 1
  → backend-engineer builds APIs
  → frontend-engineer builds shell
  → test-engineer writes tests
  → test-engineer verifies
  → Report saved
```

---

### /verify

**Purpose:** Verify system correctness after a phase

**Usage:**
```bash
/verify <phase N or "final">
```

**What it does:**
Uses **test-engineer** in verification mode to:
1. Run smoke tests (backend starts, frontend starts, DB connects)
2. Run full test suite
3. Check for regressions
4. Validate E2E tests for journeys
5. Verify promise/invariant tests
6. Report gaps

**Output:**
- Verification report saved to `/docs/verification/phase-N-report.md`
- Status: PASS / FAIL / PARTIAL
- Test counts (X passing, Y failing)
- Journeys validated
- Promises verified
- Blockers if FAIL
- Ready for next phase if PASS

**Examples:**
```bash
/verify phase 1

/verify phase 2

/verify final
```

**When to use:**
- After implementing a phase
- Before moving to the next phase
- Before deploying to production
- When you want to ensure correctness

**Verification checklist:**
- ✓ Smoke tests pass
- ✓ All tests pass (no regressions)
- ✓ Journeys work (E2E tests)
- ✓ Promises kept (verification tests)
- ✓ Invariants protected

---

## Brownfield Commands

Commands for working with existing codebases.

### /audit

**Purpose:** Understand what exists in the current codebase

**Usage:**
```bash
/audit <optional focus area>
```

**What it does:**
Runs three audits **in parallel**:
1. **intent-audit** - Infers/audits product intent
   - Creates `/docs/intent/product-intent.md` (if missing)
   - Saves audit to `/docs/intent/intent-audit.md`
2. **ux-audit** - Maps current user journeys
   - Creates `/docs/ux/user-journeys.md` (current state)
   - Saves audit to `/docs/ux/ux-audit.md`
3. **aa-audit** - Maps architecture and agentic opportunities
   - Creates `/docs/architecture/system-design.md` (current state)
   - Saves audit to `/docs/architecture/agentic-audit.md`

**Output:**
- Inferred intent (if no intent doc exists)
- Current user flows and UX issues
- Architecture map and improvement opportunities

**Next step:**
```bash
/gap
```

**Examples:**
```bash
/audit

/audit the authentication system

/audit payment processing
```

**When to use:**
- Working with unfamiliar codebase
- Before making major changes
- To understand current state
- To assess technical debt

---

### /gap

**Purpose:** Analyze gaps between current and ideal state

**Usage:**
```bash
/gap <optional focus area>
```

**Prerequisites:**
Must have audit outputs (run `/audit` first):
- `/docs/intent/intent-audit.md`
- `/docs/ux/ux-audit.md`
- `/docs/architecture/agentic-audit.md`

**What it does:**
Uses **gap-analyzer** to:
1. Read all audit outputs
2. Compare current vs ideal for:
   - Intent compliance
   - UX quality
   - Architecture
   - Test coverage
3. Categorize gaps by severity (Critical, High, Medium, Low)
4. Prioritize by impact and effort
5. Create migration plan

**Output:**
- `/docs/gaps/gap-analysis.md` - All gaps with severity
- `/docs/gaps/migration-plan.md` - Phased improvement plan

**Severity levels:**
- **Critical:** Security, data loss, broken promises → fix immediately
- **High:** Major UX issues, missing functionality → Phase 1
- **Medium:** Improvements, technical debt → Phase 2
- **Low:** Nice to have, polish → Phase 3/backlog

**Next step:**
```bash
/improve phase 0  # Critical fixes
```

**Examples:**
```bash
/gap

/gap security practices

/gap user experience
```

**When to use:**
- After auditing codebase
- Before starting improvements
- To prioritize refactoring work
- To plan migration

---

### /improve

**Purpose:** Fix gaps incrementally based on migration plan

**Usage:**
```bash
/improve <"phase N" or gap ID>
```

**Prerequisites:**
Must have migration plan (run `/gap` first):
- `/docs/gaps/migration-plan.md`
- `/docs/gaps/gap-analysis.md`

**What it does:**
1. Reads the target (phase or specific gap)
2. For each gap:
   - Determines type (intent, UX, architecture, test)
   - Delegates to appropriate engineer
   - Implements the fix
   - Writes/updates tests
   - Commits with gap ID
3. After phase completes:
   - Verifies with **test-engineer**
   - Checks for regressions
   - Confirms gaps resolved

**Output:**
- Code changes fixing the gaps
- Tests verifying fixes
- Verification report in `/docs/verification/improvement-phase-N-report.md`

**Next step:**
```bash
/verify phase N  # or auto-verifies
/improve phase N+1
```

**Examples:**
```bash
/improve phase 0  # Critical issues

/improve GAP-007  # Specific gap

/improve phase 1  # High priority gaps
```

**When to use:**
- After gap analysis complete
- To fix issues incrementally
- To reduce technical debt systematically

**Commit format:**
```
fix(scope): [GAP-XXX] description
```

---

## Change Management Commands

Commands for handling mid-flight requirement changes.

### /change

**Purpose:** Analyze impact of requirement changes across all artifacts

**Usage:**
```bash
/change <description of the change>
```

**What it does:**
Uses **change-analyzer** to:
1. Read all existing artifacts (intent, UX, architecture, plans)
2. Analyze impact on each artifact
3. Detect conflicts with existing decisions
4. Assess rework needed for completed work
5. Estimate effort impact
6. Produce detailed impact analysis report

**Output:**
- `/docs/changes/change-[timestamp].md` - Impact analysis
- Impact summary table (artifact → level → action)
- Detailed changes per artifact
- Conflicts detected
- Rework assessment
- Recommended update sequence
- Effort and timeline estimates

**Next step:**
```bash
/update  # Apply changes if accepted
```

**Examples:**
```bash
/change add user roles and permissions with admin, editor, viewer levels

/change add team workspaces where users can create teams and share tasks

/change remove the export feature - we're pivoting to focus on collaboration
```

**When to use:**
- Mid-flight requirement changes
- User realizes they need additional features
- Stakeholder requests modifications
- Exploring "what if" scenarios

**Change impact levels:**
- **Minor:** Single component, quick to add
- **Medium:** Multiple components, moderate work
- **Major:** Core architecture changes, significant effort
- **Pivot:** Fundamental direction change, may require re-analysis

---

### /update

**Purpose:** Apply changes to artifacts after impact analysis

**Usage:**
```bash
/update <path to change analysis or "latest">
```

**Prerequisites:**
Must have change impact analysis (run `/change` first)

**What it does:**
1. Loads change analysis
2. Updates L1 artifacts in dependency order:
   - product-intent.md (if affected)
   - user-journeys.md (if affected)
   - agent-design.md (if affected)
3. Validates consistency
4. Automatically triggers `/replan`

Uses appropriate agents:
- **intent-guardian** for intent updates
- **ux-architect** for UX updates
- **agentic-architect** for architecture updates

**Output:**
- Updated L1 artifacts (marked with update comments)
- Validation report
- Automatically regenerated plans
- Update log in `/docs/changes/update-[timestamp].md`

**Next step:**
```bash
/implement phase N  # Continue implementation with updated plans
```

**Examples:**
```bash
/update            # Apply latest change analysis
/update latest     # Same as above
/update /docs/changes/change-2025-01-24-143022.md  # Specific analysis
```

**What gets updated:**
- Intent promises, invariants, boundaries
- UX journeys, personas, screens
- Architecture entities, endpoints, agents
- ALL plans (via automatic `/replan`)

**Error handling:**
If any step fails:
- Stops immediately
- Reports which step failed
- Doesn't corrupt remaining artifacts
- User must fix and re-run

---

### /replan

**Purpose:** Regenerate implementation plans after L1 artifact changes

**Usage:**
```bash
/replan <optional: specific plan or "all">
```

**Prerequisites:**
L1 artifacts must exist:
- product-intent.md
- user-journeys.md
- agent-design.md

**What it does:**
Uses **implementation-planner** to:
1. Detect changes in L1 artifacts
2. Check implementation progress (what's complete/in-progress)
3. Preserve completed work where possible
4. Regenerate affected plans
5. Adjust implementation order
6. Create migration tasks for rework

**Output:**
Updated plans:
- backend-plan.md (new endpoints, modified schema)
- frontend-plan.md (new pages, modified components)
- test-plan.md (new tests)
- implementation-order.md (adjusted phases, migration tasks)

Replan summary in `/docs/changes/replan-[timestamp].md`

**Next step:**
```bash
/implement phase N  # Continue with updated plans
```

**Examples:**
```bash
/replan             # Regenerate all affected plans
/replan all         # Same as above
/replan backend     # Just backend plan
/replan frontend    # Just frontend plan
```

**When to use:**
- Automatically called by `/update`
- After manual edits to L1 artifacts
- To refresh plans based on current state

**Preservation rules:**
- ✅ Complete phases: Unchanged (unless affected)
- 🔄 In progress: Extended (not rewritten)
- ⚠️ Affected complete: Migration tasks created
- 🆕 Future phases: Freely updated

**Phase markings:**
- ✅ COMPLETE - Done, no changes
- 🔄 IN PROGRESS (MODIFIED) - Partially done, extended
- ⚠️ NEEDS MIGRATION - Complete but affected
- 🆕 NEW - Added from changes
- (REORDERED) - Sequence changed

---

## Focused Commands

Commands for working on specific aspects.

### /intent

**Purpose:** Define product intent for a new idea

**Usage:**
```bash
/intent <app idea>
```

**What it does:**
Uses **intent-guardian** to define complete product intent:
- Core problem and for whom
- User promises (what users can rely on)
- Invariants (must always be true)
- Behavioral contracts (cause-and-effect rules)
- Anti-behaviors (must never do)
- Boundaries (what it's NOT)
- Success criteria
- Drift signals

**Output:**
- `/docs/intent/product-intent.md`

**Examples:**
```bash
/intent subscription management service

/intent AI code review assistant
```

**When to use:**
- Just want to define intent without full analysis
- Before any other design work
- To clarify product vision

---

### /intent-audit

**Purpose:** Audit if implementation matches product intent

**Usage:**
```bash
/intent-audit <optional focus area>
```

**What it does:**
1. Looks for existing intent doc
2. If not found, infers intent from codebase
3. Uses **intent-guardian** to audit:
   - Are promises kept?
   - Are invariants protected?
   - Are boundaries respected?
   - Any drift from intent?

**Output:**
- `/docs/intent/product-intent.md` (if inferred)
- `/docs/intent/intent-audit.md` (audit findings)

**Examples:**
```bash
/intent-audit

/intent-audit the data privacy promise
```

**When to use:**
- Checking if code matches vision
- After major features added
- Periodically to catch drift

---

### /ux

**Purpose:** Design user experience for a new idea

**Usage:**
```bash
/ux <app idea>
```

**What it does:**
Uses **ux-architect** to design:
- User personas
- User journeys (trigger → steps → success)
- Screens and interactions
- Error and empty states
- Edge case handling
- Flow diagrams

**Output:**
- `/docs/ux/user-journeys.md`

**Examples:**
```bash
/ux e-commerce checkout flow

/ux collaborative document editing
```

**When to use:**
- Just want UX design without full analysis
- Before implementation
- To improve existing flows

---

### /ux-audit

**Purpose:** Audit current user experience

**Usage:**
```bash
/ux-audit <optional focus area>
```

**What it does:**
Uses **ux-architect** to:
1. Map current user flows from frontend
2. Identify friction points
3. Find missing edge cases
4. Suggest improvements

**Output:**
- `/docs/ux/user-journeys.md` (current state)
- `/docs/ux/ux-audit.md` (issues and suggestions)

**Examples:**
```bash
/ux-audit

/ux-audit the onboarding flow
```

**When to use:**
- When users complain about UX
- Before redesigning flows
- To find improvement opportunities

---

### /aa

**Purpose:** Design agentic architecture for new idea

**Usage:**
```bash
/aa <app idea>
```

**What it does:**
Uses **agentic-architect** to design:
- Which components should be agents
- Which should be traditional code
- Agent topology (how they communicate)
- Failure modes and fallbacks
- Cost and latency estimates

**Output:**
- `/docs/architecture/agent-design.md`

**Examples:**
```bash
/aa customer support with ticket routing

/aa content moderation system
```

**When to use:**
- Designing AI-powered features
- Before building agent systems
- To decide agent vs code

---

### /aa-audit

**Purpose:** Find agentic opportunities in existing code

**Usage:**
```bash
/aa-audit <optional focus area>
```

**What it does:**
Uses **agentic-architect** to:
1. Understand current architecture
2. Find hardcoded logic that could be agents
3. Identify brittle rules/heuristics
4. Suggest what should become agents
5. Recommend what should stay code

**Output:**
- `/docs/architecture/system-design.md` (current state)
- `/docs/architecture/agentic-audit.md` (opportunities)

**Examples:**
```bash
/aa-audit

/aa-audit the notification system

/aa-audit content classification
```

**When to use:**
- Looking to add AI capabilities
- Want to replace brittle rules
- Exploring agent migration

---

## Design Commands

Commands for managing design systems and visual consistency.

### /design

**Purpose:** Manage design system for visual consistency

**Usage:**
```bash
/design show                  # Display current design system
/design update                # Interactively update design system
/design preset <name>         # Apply a design preset
/design reference <url>       # Analyze a website and create design system
```

**What it does:**
Manages `/docs/ux/design-system.md` containing complete visual specifications:
- Colors (primary, secondary, neutral, semantic, dark mode)
- Typography (fonts, sizes, weights)
- Spacing & layout (scale, max-widths, grid, border radius, shadows)
- Components (buttons, inputs, cards, modals with CSS/Tailwind specs)
- Motion & animation (timing, easing, keyframes)
- Accessibility (contrast ratios, focus states, ARIA patterns)
- Implementation (Tailwind config, CSS variables)

**Available Presets:**
- `modern-clean` - Professional SaaS style (blue, clean, trustworthy)
- `minimal` - Ultra-clean, content-focused (black/white, typography)
- `playful` - Vibrant, fun, energetic (purple/pink gradients, animations)
- `corporate` - Enterprise-grade, formal (dark blue, professional)
- `glassmorphism` - Modern glass effects with transparency

**Output:**
- Creates or updates `/docs/ux/design-system.md`
- Provides Tailwind configuration code
- Provides CSS variables definitions
- Component library bootstrap guide

**Examples:**
```bash
# Quick start with preset
/design preset modern-clean

# Match competitor's style
/design reference https://linear.app

# Update brand colors
/design update

# View current design
/design show
```

**When to use:**
- During UX phase (usually auto-created by ux-architect)
- Before frontend implementation
- When changing brand colors/fonts
- When starting component library

**Integration:**
- **ux-architect** asks about design preferences and creates initial design system
- **frontend-engineer** reads design system FIRST before implementing any UI
- All components must follow design system strictly (no arbitrary styling)

**Why it matters:**
- Ensures consistent UI across entire app
- Prevents arbitrary color/font/spacing choices
- Makes design changes systematic (update once, applies everywhere)
- Built-in accessibility (WCAG compliance)

---

## Enhancement Commands

Commands for integrating external capabilities and advanced features.

### /mcp

**Purpose:** Manage MCP (Model Context Protocol) server integration

**Usage:**
```bash
/mcp                          # Show recommendations (same as /mcp recommend)
/mcp recommend                # Analyze project and recommend MCP servers
/mcp setup <servers...>       # Generate configuration for specified servers
/mcp status                   # Check MCP server availability
/mcp guide                    # Show usage guide
```

**What it does:**

MCP servers extend Claude's capabilities by connecting to external tools like databases, GitHub, browsers, and collaboration platforms.

**Modes:**

**Recommend Mode** (`/mcp` or `/mcp recommend`):
- Analyzes project tech stack (package.json, requirements.txt, etc.)
- Recommends appropriate MCP servers by priority (HIGH/MEDIUM/LOW)
- Explains why each server would be useful for your project
- Provides quick setup command

**Setup Mode** (`/mcp setup <servers...>`):
```bash
/mcp setup postgres github puppeteer
```
- Generates ready-to-use configuration JSON
- Shows where to add it (Claude desktop config file)
- Lists required environment variables and tokens
- Provides step-by-step setup instructions
- Includes security best practices

**Status Mode** (`/mcp status`):
- Shows which MCP servers are configured
- Indicates connection status (✓ Connected, ⚠ Failed, ○ Not configured)
- Lists available but not configured servers
- Provides troubleshooting hints for failed connections

**Guide Mode** (`/mcp guide`):
- Comprehensive MCP documentation
- Popular servers by category (database, development, collaboration, infrastructure)
- Usage examples for each server type
- Configuration file format
- Security best practices
- Troubleshooting common issues

**Popular MCP Servers:**

| Server | Purpose | When to Use |
|--------|---------|-------------|
| **postgres** | PostgreSQL database access | Direct queries, debugging, migrations |
| **sqlite** | SQLite database access | Local database testing |
| **github** | GitHub automation | PR creation, issue management |
| **puppeteer** | Browser automation | E2E testing, visual debugging |
| **memory** | Persistent context | Remember decisions across sessions |
| **fetch** | HTTP requests | API testing |
| **slack** | Team notifications | Team collaboration |
| **linear** | Issue tracking | Project management |
| **docker** | Container management | DevOps workflows |

**Example Workflows:**

**Database Development:**
```
User: Query the users table

Claude (with postgres MCP):
  SELECT * FROM users LIMIT 5;

  Found 1,234 users. Here's a sample:
  id | email            | created_at
  ---|------------------|------------
  1  | alice@example.com| 2024-01-15
  ...
```

**PR Automation:**
```
User: Create a PR for the auth feature

Claude (with github MCP):
  ✓ Created branch: feature/auth
  ✓ Committed changes (5 files)
  ✓ Created PR #42: "Add user authentication"
  ✓ Added reviewers: @alice, @bob

  PR: https://github.com/myorg/myrepo/pull/42
```

**E2E Testing:**
```
User: Test the login flow

Claude (with puppeteer MCP):
  Opening browser to http://localhost:3000/login

  1. Filled email: test@example.com ✓
  2. Filled password ✓
  3. Clicked "Sign In" ✓
  4. Verified redirect to /dashboard ✓
  5. Took screenshot: screenshot-1.png ✓

  ✅ Login flow works correctly
```

**When to use:**
- **Planning phase:** After `/plan`, setup recommended servers
- **Implementation:** Use MCP for faster debugging (database queries, browser testing)
- **Testing:** Interactive E2E testing with puppeteer, direct database verification
- **Collaboration:** Automate PRs, update team tools

**Integration with Workflow:**

The **implementation-planner** automatically recommends MCP servers based on your project:
- PostgreSQL project → Recommends `postgres` MCP (HIGH priority)
- E2E tests planned → Recommends `puppeteer` MCP (MEDIUM priority)
- GitHub repository → Recommends `github` MCP (HIGH priority)

The **test-engineer** can leverage MCP for interactive testing:
- Use `puppeteer` MCP to debug E2E tests interactively
- Use `postgres` MCP to verify database state directly
- 10x faster debugging with real-time browser/database access

**Configuration Location:**

```
macOS:   ~/Library/Application Support/Claude/claude_desktop_config.json
Windows: %APPDATA%\Claude\claude_desktop_config.json
```

**Example Configuration:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost:5432/db"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."
      }
    }
  }
}
```

**Related:**
- Commands: `/plan` (suggests MCP servers)
- Files: `/docs/architecture/mcp-integration.md` (complete guide)
- Help: `/agent-wf-help mcp`

---

### /llm

**Purpose:** Manage LLM provider integration for AI-powered features

**Usage:**
```bash
/llm                          # Show current configuration
/llm setup                    # Interactive setup wizard
/llm providers                # List available providers
```

**What it does:**

Configures LLM integration for projects that need AI capabilities (chatbots, content generation, analysis, etc.).

**Providers Supported:**
- **Ollama** (local models) - Free, private, no API keys
- **OpenAI** (GPT-4, GPT-3.5) - Commercial API, requires API key
- **Anthropic** (Claude) - Commercial API, requires API key

**Dual Provider Pattern:**

The system recommends a **dual provider architecture**:
1. **Primary:** Ollama (local) for development and cost savings
2. **Fallback:** OpenAI/Anthropic for production or when local unavailable

**When to use:**
- Building chatbots or conversational interfaces
- Need AI-powered content generation
- Implementing semantic search or embeddings
- Adding AI analysis to existing features

**Related:**
- Files: `BACKEND.md` (complete LLM integration guide)
- Templates: `templates/src/lib/llm/` (code templates)

---

## Quality Commands

Commands for code review and debugging.

### /review

**Purpose:** Review code for quality, security, and intent

**Usage:**
```bash
/review <file, directory, or "staged">
```

**What it does:**
Uses **code-reviewer** to check:
- **Security** (Critical)
  - Injection vulnerabilities
  - Auth/authz enforcement
  - Data exposure
- **Bugs** (High)
  - Null handling
  - Error handling
  - Edge cases
- **Performance** (Medium)
  - N+1 queries
  - Missing indexes
- **Maintainability** (Suggestions)
  - Code clarity
  - Consistency
- **Intent Compliance**
  - Promises protected
  - Invariants enforced

**Output:**
- Review report with issues categorized
- Status: APPROVED / CHANGES REQUESTED / BLOCKED
- Specific file:line references
- Fix suggestions

**Examples:**
```bash
/review src/auth/

/review staged

/review src/services/payment.ts
```

**When to use:**
- Before merging code
- After implementation
- Before production deploy
- Regular code quality audits

**Issue severity:**
- **Critical:** Blocks merge (security, data loss)
- **High:** Should fix (bugs, missing error handling)
- **Medium:** Consider fixing (performance, debt)
- **Suggestions:** Optional (style, naming)

---

### /debug

**Purpose:** Systematically debug errors and failures

**Usage:**
```bash
/debug <error message or description>
```

**What it does:**
Uses **debugger** to:
1. Gather information (error, stack trace, repro steps)
2. Reproduce the issue
3. Form and test hypotheses
4. Identify root cause
5. Implement minimal fix
6. Verify fix
7. Add regression test
8. Clean up debug code

**Output:**
- Debug report with investigation
- Root cause explanation
- Fix implemented
- Regression test added
- Commit with fix

**Examples:**
```bash
/debug "TypeError: Cannot read property 'id' of undefined"

/debug test failing: user signup flow

/debug API returning 500 on POST /auth/login
```

**When to use:**
- Test failures
- Production errors
- Unexpected behavior
- Performance issues

**Debugging philosophy:**
1. Understand before fixing
2. Reproduce first
3. Minimal changes
4. Verify thoroughly
5. Prevent recurrence

**Commit format:**
```
fix(scope): description of bug fixed
```

---

## Maintenance Commands

Commands for keeping project state and documentation in sync.

### /docs

**Purpose:** Manage project documentation - verify completeness, update, or generate

**Usage:**
```bash
/docs              # Check documentation completeness (verify)
/docs verify       # Same as above
/docs update       # Update docs from current code
/docs generate     # Generate all documentation
/docs status       # Quick status check
```

**What it does:**
Uses **project-ops** to:

**Verify mode** (default):
- Check if USAGE.md has all implemented features
- Check if API docs have all endpoints
- Check if architecture docs are current
- Check if guides are complete
- Report completeness percentage and gaps

**Update mode:**
- Scan implemented features
- Add missing features to USAGE.md with examples
- Add new endpoints to API docs
- Update architecture if changed
- Add troubleshooting items

**Generate mode:**
- Create complete documentation structure from scratch
- Populate from intent, UX, architecture docs
- Create skeletons for unimplemented features
- Generate API docs from code

**Workflow:**
1. **After L1 Planning (Auto)** - project-ops automatically creates initial structure
2. **During L2 Building** - Run `/docs update` to add completed features
3. **Before Release** - Run `/docs verify` to ensure completeness

**Output example:**
```
Documentation Verification
══════════════════════════

USAGE.md: 95% complete
  ✓ Overview complete
  ✓ Getting Started complete
  ⚠ Features: 4/5 documented
  ✓ Configuration complete
  ○ Troubleshooting: 2 issues (needs more)

API Docs: 100% complete
  ✓ All endpoints documented

Guides: 90% complete
  ⚠ Deployment guide: Missing monitoring setup

Overall: 92% complete

Missing documentation:
  - USAGE.md: search feature examples
  - Deployment guide: monitoring section

Run /docs update to complete missing sections.
```

**Integration with /sync:**
The project-ops agent (triggered by `/sync`) also checks documentation completeness and will suggest running `/docs verify` if gaps are found.

**When to use:**
- After implementing features - to update documentation
- Before release - to verify nothing is undocumented
- When starting new project - to generate initial structure (auto)
- When documentation is stale - to regenerate from code

---

### /sync

**Purpose:** Sync project state, documentation, and test coverage

**Usage:**
```bash
/sync              # Full sync (default)
/sync quick        # Quick CLAUDE.md update only
/sync report       # Status check without changes
```

**What it does:**
Launches **project-ops** agent to:
1. Update CLAUDE.md Current State section with:
   - Feature progress table
   - Current task and next steps
   - Important context from this session
   - Test coverage summary
2. Sync documentation status markers:
   - /docs/intent/ - Mark promises as [KEPT], [AT RISK], or [BROKEN]
   - /docs/ux/ - Mark journeys as [IMPLEMENTED], [PARTIAL], or [NOT STARTED]
   - /docs/plans/ - Update feature completion statuses
3. Verify test coverage and identify gaps
4. Generate comprehensive sync report

**Modes:**

**Full Sync** (default):
- Complete state update
- Documentation sync
- Test coverage verification
- Comprehensive report

**Quick Sync** (`/sync quick`):
- CLAUDE.md Current State only
- Recent changes log
- Brief status report
- Fast checkpoint

**Report Mode** (`/sync report`):
- Compare code vs docs
- Identify what's out of sync
- Show what would be updated
- No changes made

**When to use:**
- **Automatically:** After feature verification (test-engineer triggers)
- **Manually:** Before ending a session ("save state")
- **Periodically:** Every 3-4 features during long sessions
- **Status check:** Use `/sync report` to see current state

**Example output:**
```
✓ CLAUDE.md updated
  - Feature progress table refreshed
  - Current task updated
  - Session continuity notes added

✓ Documentation synced
  - product-intent.md: 6/8 promises KEPT
  - user-journeys.md: 4/6 IMPLEMENTED
  - implementation-order.md: Updated statuses

✓ Test coverage verified
  - Completed features: 100% covered
  - Current feature: Backend tested, frontend pending

╔══════════════════════════════════════════════════╗
║            PROJECT SYNC COMPLETE                 ║
╚══════════════════════════════════════════════════╝

Progress: 5/8 features complete
Current: search frontend (SearchBar component)
Next: Continue SearchBar, then ResultsList
```

**Session Continuity:**

Before ending session:
```bash
/sync              # or say "save state"
```

Next session:
```
You: Continue

Claude: Continuing from where we left off...
        Current task: SearchBar component
        [Resumes seamlessly]
```

**Related:**
- Commands: `/verify` (triggers auto-sync on success)
- Agents: `project-ops`
- Files: CLAUDE.md Current State section

---

## Command Workflows

### Greenfield Workflow
```bash
# Level 1: Analysis
/analyze <idea>

# Level 2: Planning
/plan <tech stack>

# Level 3: Implementation
/implement phase 1
/verify phase 1
/implement phase 2
/verify phase 2
# ... continue
/verify final
```

### Brownfield Workflow
```bash
# Level 1: Audit
/audit

# Level 2: Gap Analysis
/gap

# Level 3: Improvement
/improve phase 0
/verify phase 0
/improve phase 1
/verify phase 1
# ... continue
/verify final
```

### Focused Intent Workflow
```bash
# New project
/intent <idea>

# Existing project
/intent-audit
```

### Focused UX Workflow
```bash
# New project
/ux <idea>

# Existing project
/ux-audit
```

### Focused Agentic Workflow
```bash
# New project
/aa <idea>

# Existing project
/aa-audit
```

### Change Management Workflow
```bash
# Mid-implementation change
/analyze task app
/plan
/implement phase 1
/implement phase 2  # IN PROGRESS

# Change request
/change add team workspaces and sharing
# Review /docs/changes/change-*.md
/update
# Artifacts and plans updated automatically
/implement phase 2  # Continue with updated plans
```

### Quality Workflow
```bash
# Before merge
/review staged

# Fix issues
/debug "<error>"

# Verify fix
/verify <area>
```

---

## Command Prerequisites

| Command | Prerequisites | Next Step |
|---------|--------------|-----------|
| `/analyze` | None | `/plan` |
| `/plan` | Analysis docs | `/implement` |
| `/implement` | Plan docs | `/verify` |
| `/verify` | Implementation | `/implement` next phase |
| `/audit` | None | `/gap` |
| `/gap` | Audit docs | `/improve` |
| `/improve` | Gap docs | `/verify` |
| `/change` | Existing artifacts | `/update` |
| `/update` | Change analysis | `/replan` (auto) |
| `/replan` | L1 artifacts, plans | `/implement` |
| `/intent` | None | Optional |
| `/intent-audit` | None | Optional |
| `/ux` | None | Optional |
| `/ux-audit` | None | Optional |
| `/aa` | None | Optional |
| `/aa-audit` | None | Optional |
| `/review` | Code to review | Fix issues |
| `/debug` | Error/issue | Verify fix |

---

## Tips

1. **Run analysis in parallel** - `/analyze` runs 3 agents concurrently
2. **Audit before improving** - Always `/audit` → `/gap` → `/improve`
3. **Verify frequently** - Run `/verify` after each phase, not just at end
4. **Review before merging** - Use `/review` to catch issues early
5. **Debug systematically** - Let `/debug` find root cause, don't guess
6. **Focus when needed** - Use focused commands for specific aspects
7. **Check prerequisites** - Commands will tell you what's missing
8. **Read the output** - Review docs generated before proceeding
9. **Iterate** - Plans and audits are starting points, refine as needed
10. **Commit often** - Agents commit after each item, making progress traceable
