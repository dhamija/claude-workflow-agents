<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║ After editing: CLAUDE.md, help, README, tests                                ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
name: workflow-orchestrator
description: |
  **CONTRIBUTOR REFERENCE DOCUMENTATION**

  This file documents the workflow orchestration system architecture.
  It is NOT read by Claude during normal operation.

  Orchestration logic is EMBEDDED in user project CLAUDE.md files.
  This file explains how the system works for contributors/maintainers.

  See templates/project/CLAUDE.md.*.template for actual orchestration.
tools: N/A (reference documentation only)
---

# Workflow Orchestration System

**Purpose:** This document explains how the workflow orchestration system works for contributors and maintainers.

**Important (v3.1):** This is NOT operational documentation. Orchestration logic is in the **workflow skill** (`templates/skills/workflow/SKILL.md`), NOT in project CLAUDE.md files.

Project CLAUDE.md files are now minimal (~80 lines) and contain only state tracking.

---

## Architecture Overview

### Current Architecture (v3.1 - Skills + Hooks)

```
Skills (Domain Expertise)
   ~/.claude/skills/workflow/SKILL.md     ← Orchestration logic
   ~/.claude/skills/ux-design/SKILL.md    ← Design principles
   ~/.claude/skills/frontend/SKILL.md     ← Frontend expertise
   ~/.claude/skills/backend/SKILL.md      ← Backend patterns
   ... (9 skills total)
   ↓
   Loaded ON-DEMAND by Claude (automatic)
   ↓
Subagents (Isolated Tasks)
   ~/.claude/agents/code-reviewer.md      ← Isolated review
   ~/.claude/agents/debugger.md           ← Isolated debugging
   ~/.claude/agents/ui-debugger.md        ← Browser automation
   ↓
   Invoked via Task tool when needed
   ↓
Project CLAUDE.md (~80 lines)
   State only, minimal context
   ↓
Hooks (.claude/settings.json - optional)
   PostToolUse → Quality reminders
   Stop → Completion checklist
```

**Benefits:**
- 90% less upfront context (80 lines vs 750)
- Skills cached between sessions
- On-demand loading = better performance
- Modular and independently updatable

**Key Change:** Orchestration logic moved FROM project CLAUDE.md TO workflow skill.

### Previous Architectures (Historical Reference)

**v2.0 (Self-Contained Templates):**
- 750+ line CLAUDE.md with embedded orchestration
- Problem: Context bloat, poor performance
- Deprecated in v3.1

**v0.9-v1.0 (External Orchestrator):**
- HTML comment pointing to orchestrator.md
- Problem: Unreliable, could be ignored
- Deprecated in v2.0

```
Template: templates/project/CLAUDE.md.greenfield.template
   ↓
   Contains ALL orchestration logic embedded
   ↓
   workflow-init generates → User Project CLAUDE.md
   ↓
   Self-contained, guaranteed to work ✓
```

**Solution:** All orchestration logic embedded in templates. External agent files are optional reference documentation.

---

## Agent Coordination System

### All 15 Specialized Agents

The orchestration system coordinates these agents automatically:

#### L1 Analysis Agents (App Planning)
- **intent-guardian** - Define user promises with criticality levels
- **ux-architect** - Design user experience and design system
- **agentic-architect** - Design system architecture with promise mapping
- **implementation-planner** - Create build plans with validation tasks

#### L1 Support Agents
- **change-analyzer** - Assess impact when user requests changes/additions
- **gap-analyzer** - Find issues in brownfield (existing) codebases
- **brownfield-analyzer** - Initial scan of existing projects

#### L2 Building Agents (Feature Implementation)
- **backend-engineer** - Implement APIs, database, services
- **frontend-engineer** - Implement UI (follows design system)
- **test-engineer** - Write tests and verify implementations

#### L2 Support Agents
- **code-reviewer** - Review code quality, security, intent compliance
- **debugger** - Fix bugs and issues (backend/general)
- **ui-debugger** - Debug UI issues with browser automation
- **acceptance-validator** - Validate promises are kept (not just code working)

#### Operations Agent
- **project-ops** - Project setup, sync, docs, verification, AI integration

---

## Orchestration Flows

### Greenfield Flow (New Projects)

```
User describes project
   ↓
L1 Phase: Planning
   ├─► intent-guardian → Create product-intent.md
   ├─► ux-architect → Create user-journeys.md
   ├─► agentic-architect → Create agent-design.md
   └─► implementation-planner → Create feature plans
   ↓
L2 Phase: Building
   For each feature:
      ├─► backend-engineer → Implement backend
      │   ├─► code-reviewer (MANDATORY)
      │   └─► Run tests (MANDATORY)
      ├─► frontend-engineer → Implement frontend
      │   ├─► code-reviewer (MANDATORY)
      │   ├─► Run tests (MANDATORY)
      │   └─► ui-debugger (if available)
      ├─► test-engineer → Write comprehensive tests
      │   └─► Run ALL tests (MANDATORY)
      └─► acceptance-validator → Validate promises KEPT
          ├─► CI verification
          ├─► Update docs
          └─► Feature COMPLETE
```

### Brownfield Flow (Existing Codebases)

```
First session
   ↓
brownfield-analyzer → Scan codebase
   ├─► Detect tech stack
   ├─► Identify features
   ├─► Infer promises
   └─► Estimate test coverage
   ↓
Create [INFERRED] documentation
   ├─► docs/intent/product-intent.md
   ├─► docs/architecture/system-design.md
   └─► docs/plans/current-state.md
   ↓
Ask user what to do:
   ├─► Add feature → change-analyzer → L2 flow
   ├─► Improve code → gap-analyzer → Fix gaps
   ├─► Fix bug → debugger → Fix + test
   └─► Something else
```

### Gap Analysis Flow

```
User requests /gap or "improve codebase"
   ↓
gap-analyzer
   ├─► Compare current vs ideal
   ├─► Categorize gaps (Critical/High/Medium/Low)
   └─► Create migration plan with phases
   ↓
For each gap (by priority):
   ├─► Invoke appropriate engineer agent
   ├─► Apply fix
   ├─► code-reviewer (MANDATORY)
   ├─► Add regression test (MANDATORY)
   └─► Mark gap complete
```

### Change Request Flow

```
User says "add [feature]"
   ↓
change-analyzer
   ├─► Analyze impact on intent/architecture/plans
   ├─► Estimate effort and complexity
   ├─► Identify dependencies and risks
   └─► Present analysis
   ↓
User confirms
   ↓
Update documentation
   ├─► Add promises to intent doc
   ├─► Update architecture if needed
   └─► Create feature plan
   ↓
Continue to L2 building for feature
```

---

## Quality Gates (Automatic Enforcement)

### After Code Changes

**Trigger:** Any file in `src/`, `lib/`, `app/`, etc. created or modified

**Action:**
1. Invoke code-reviewer on changed files
2. If issues: Show, ask to fix
3. If clean: Continue silently

### After Backend/Frontend Steps

**Trigger:** Engineer agent completes

**Action:**
1. code-reviewer on new/modified files (MANDATORY)
2. Run relevant tests (MANDATORY)
3. If fail: invoke debugger, fix, retry
4. If pass: continue

### After Testing Step

**Trigger:** test-engineer completes

**Action:**
1. Run FULL test suite (MANDATORY)
2. All must pass
3. If failures: STOP, fix, retry

### After Feature Complete

**Trigger:** All steps pass

**Action:**
1. Promise Validation (CRITICAL)
   - acceptance-validator
   - If PARTIAL/FAILED: fix and re-validate
   - If VALIDATED: continue
2. CI Verification
   - scripts/verify.sh if exists
   - lint/typecheck if configured
3. Documentation
   - project-ops sync
   - Update intent doc
   - Update CLAUDE.md state

---

## State Tracking

State is maintained in YAML block in user project CLAUDE.md:

```yaml
workflow:
  version: 1.0
  type: greenfield|brownfield
  phase: L1|L2|analysis
  status: not_started|in_progress|paused|complete
  mode: auto|manual

l1:
  intent: { status, output }
  ux: { status, output }
  architecture: { status, output }
  planning: { status, output }

l2:
  current_feature: string
  current_step: backend|frontend|testing|verification
  features: { [name]: { status, backend, frontend, tests, verification, promises } }

promises:
  # PRM-001:
  #   statement: "..."
  #   criticality: CORE|IMPORTANT|NICE_TO_HAVE
  #   status: pending|validated|partial|failed
  #   implementing_features: [...]

quality:
  last_review: timestamp
  last_review_result: pass|fail
  last_test_run: timestamp
  last_test_result: pass|fail

session:
  last_updated: timestamp
  last_action: string
  next_action: string
```

---

## Issue Detection and Response

### Keyword Triggers

| Keywords | Agent Invoked |
|----------|---------------|
| "doesn't work", "broken", "bug", "error", "crash", "exception" | **debugger** |
| "page", "screen", "button", "UI", "display", "layout", "click" + issue | **ui-debugger** |
| "test failing", "tests broken", "spec failed" | **debugger** + **test-engineer** |
| "add [feature]", "also need", "change [thing]" | **change-analyzer** |
| "/gap", "/audit", "improve codebase", "fix tech debt" | **gap-analyzer** |

### Response Protocols

All issue responses follow this pattern:
1. Acknowledge issue
2. Invoke appropriate debugger agent
3. Diagnose root cause
4. Apply fix
5. Add regression test (if applicable)
6. Verify fix with tests
7. code-reviewer on changes (MANDATORY)
8. Update state
9. Announce fix with explanation

---

## Template System

### Template Locations

- `templates/project/CLAUDE.md.greenfield.template` - New projects
- `templates/project/CLAUDE.md.brownfield.template` - Existing codebases

### Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name | "my-app" |
| `{{PROJECT_DESCRIPTION}}` | Brief description | "Spanish learning app" |
| `{{DATE}}` | Initialization date | "2026-01-26" |
| `{{WORKFLOW_HOME}}` | Workflow agents directory | "~/.claude-workflow-agents" |

### How Templates Work

1. User runs `workflow-init` in their project directory
2. Script detects if project is greenfield or brownfield
3. Script selects appropriate template
4. Script replaces `{{VARIABLES}}` with actual values
5. Script generates `CLAUDE.md` in user project root
6. User project now has self-contained orchestration

### When to Update Templates

**Update templates when:**
- Adding/removing agents
- Changing orchestration flows
- Modifying quality gates
- Adding new features to workflow system

**After updating templates:**
1. Run `./scripts/verify-docs.sh` to ensure sync
2. Test with `workflow-init` in a test directory
3. Update this file (workflow-orchestrator.md) with changes
4. Update CLAUDE.md (repo documentation) with changes

---

## Design Principles

### 1. Self-Containment

**Rule:** User project CLAUDE.md must contain ALL operational logic.

**Why:** External files can't be reliably read by Claude. HTML comments can be ignored.

**Implementation:** Embed full orchestration flows in templates.

### 2. Automatic Agent Chaining

**Rule:** User should never manually invoke agents.

**Why:** Reduces cognitive load, ensures consistency, improves developer experience.

**Implementation:** Keyword triggers and phase completion signals auto-invoke next agent.

### 3. Mandatory Quality Gates

**Rule:** code-reviewer and tests run after EVERY code change.

**Why:** Catches issues early, maintains code quality, validates promises.

**Implementation:** MANDATORY checkpoints in L2 flow that cannot be skipped.

### 4. Promise-Based Validation

**Rule:** Features aren't complete until promises are VALIDATED.

**Why:** Tests passing ≠ promises kept. Need explicit validation.

**Implementation:** acceptance-validator runs after all tests pass, validates actual user promises.

### 5. State Transparency

**Rule:** CLAUDE.md state must always reflect current progress.

**Why:** Enables session resumption, tracks progress, provides visibility.

**Implementation:** State updated after every significant action.

---

## Contributor Guidelines

### Adding a New Agent

1. Create agent file in `agents/[name].md`
2. Add to appropriate category (L1/L2/Support/Operations)
3. Update templates:
   - Add to "Agents Available" table
   - Add trigger keywords if applicable
   - Add to appropriate flow if primary agent
4. Update verification:
   - Add to `scripts/verify-docs.sh` COORDINATED_AGENTS array
   - Add to `tests/structural/test_agents_exist.sh`
5. Update repository docs:
   - Add to `CLAUDE.md` maintenance section
   - Add to `README.md` agents table
   - Add to `commands/help.md`
   - Add to `STATE.md`
6. Run `./scripts/verify-docs.sh` to verify sync
7. Commit all changes together

### Modifying Orchestration Flows

1. Update templates (greenfield and/or brownfield)
2. Update this file (workflow-orchestrator.md) to document changes
3. Update `CLAUDE.md` (repo) if needed
4. Test with `workflow-init` in a test directory
5. Verify Claude follows new flow correctly
6. Run `./scripts/verify-docs.sh`
7. Commit

### Testing Orchestration Changes

```bash
# Create test directory
mkdir /tmp/workflow-test-greenfield
cd /tmp/workflow-test-greenfield

# Initialize workflow
workflow-init

# Check generated CLAUDE.md
cat CLAUDE.md

# Verify orchestration logic is embedded
grep -A 10 "## L1 Orchestration Flow" CLAUDE.md

# Test with Claude Code (manually)
# Verify auto-chaining works as expected
```

---

## FAQ for Contributors

### Q: Why not just improve the old HTML comment approach?

**A:** Claude Code doesn't auto-read external files. HTML comments are not enforced and can be easily ignored. Self-contained templates guarantee Claude has the orchestration logic.

### Q: Won't this make templates harder to maintain?

**A:** Templates are larger (750+ lines vs 340), but:
- Easier to debug (all logic in one place)
- More reliable (no external dependencies)
- Better user experience (actually works!)
- Simpler mental model (no "wishful thinking")

### Q: What's the role of agents/*.md files now?

**A:** Reference documentation for:
- Contributors understanding agent capabilities
- Customization (users can read for detailed prompts)
- Debugging agent invocations
- System maintenance

### Q: How do changes propagate to user projects?

**A:** Users run `workflow-update` which:
1. Checks for new template version
2. Merges orchestration changes into their CLAUDE.md
3. Preserves their project-specific state/notes
4. Shows diff before applying

### Q: Can users customize the orchestration?

**A:** Yes! They can edit their CLAUDE.md directly. It's their file. The template is just a starting point. However, they should understand what they're changing.

### Q: How do we version orchestration changes?

**A:** `workflow.version` in state YAML tracks version. When templates change:
1. Increment version
2. Document breaking changes
3. Create migration guide if needed
4. `workflow-update` handles migration

---

## Related Files

- `templates/project/CLAUDE.md.greenfield.template` - Greenfield orchestration (source of truth)
- `templates/project/CLAUDE.md.brownfield.template` - Brownfield orchestration (source of truth)
- `CLAUDE.md` - Repository maintenance documentation
- `scripts/verify-docs.sh` - Documentation sync verification (includes orchestrator check)
- `commands/help.md` - In-app help system

---

## Version History

### v3.1 (2026-01-27)
- **Breaking Change:** Skills + Hooks architecture
- Orchestration logic moved FROM CLAUDE.md TO workflow skill
- 9 skills loaded on-demand by Claude
- Only 3 subagents (isolated tasks)
- Minimal CLAUDE.md (~80 lines, state only)
- Optional hooks for automatic quality gates
- 90% reduction in upfront context
- Better performance and modularity

### v2.0 (2026-01-26)
- **Breaking Change:** Self-contained CLAUDE.md templates (750+ lines)
- All orchestration embedded in project CLAUDE.md
- Deprecated in v3.1 due to context bloat

### v1.0 / v0.9 (Historical)
- External orchestrator file with HTML comment
- Unreliable (could be ignored)
- Deprecated in v2.0

