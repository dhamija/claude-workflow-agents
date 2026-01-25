# Agent Reference

This document provides detailed information about each specialized agent in the workflow system.

## Table of Contents

- [Analysis Agents](#analysis-agents)
  - [intent-guardian](#intent-guardian)
  - [ux-architect](#ux-architect)
  - [agentic-architect](#agentic-architect)
- [Planning Agents](#planning-agents)
  - [implementation-planner](#implementation-planner)
  - [gap-analyzer](#gap-analyzer)
  - [change-analyzer](#change-analyzer)
- [Implementation Agents](#implementation-agents)
  - [backend-engineer](#backend-engineer)
  - [frontend-engineer](#frontend-engineer)
  - [test-engineer](#test-engineer)
- [Quality Agents](#quality-agents)
  - [code-reviewer](#code-reviewer)
  - [debugger](#debugger)
- [Setup & Maintenance Agents](#setup--maintenance-agents)
  - [ci-cd-engineer](#ci-cd-engineer)
  - [project-maintainer](#project-maintainer)

---

## Analysis Agents

### intent-guardian

**Purpose:** Define and verify product intent, promises, and behavioral contracts

**Tools:** Read, Glob, Grep, WebFetch, WebSearch

**When to use:**
- Starting a new project - define what it promises
- Existing project - audit if code matches intent
- Before major features - verify alignment with core purpose
- When product seems to be drifting from original vision

**What it produces:**
- `/docs/intent/product-intent.md` - Core problem, promises, invariants, boundaries
- Invariants (things that must ALWAYS be true)
- User promises (what users can rely on)
- Behavioral contracts (cause-and-effect rules)
- Anti-behaviors (things app must never do)
- Success criteria and drift signals

**Key philosophy:**
- Intent over implementation
- Promises over features
- Boundaries over scope
- Observable over assumed

**Example invocation:**
```bash
/intent food delivery app that connects restaurants with customers
```

**Red flags it calls out:**
- No clear core problem → product will drift
- Promises that can't be verified → will be broken silently
- No anti-behaviors defined → will slowly become everything
- Invariants have exceptions → not actually invariants

---

### ux-architect

**Purpose:** Design user experience and journeys

**Tools:** Read, Glob, Grep, WebFetch, WebSearch

**When to use:**
- Designing user flows for new features
- Auditing existing UX for issues
- Before implementation - define how users interact
- When user complaints suggest UX problems

**What it produces:**
- `/docs/ux/user-journeys.md` - Complete UX specification
- User personas
- Journey maps (trigger → steps → success)
- Screen/component inventory
- Error and empty states
- Loading and feedback patterns
- Flow diagrams

**Key philosophy:**
- User-first thinking
- Journey-driven design (not feature-driven)
- Decoupled from implementation
- Every journey has a clear "done" state

**Example invocation:**
```bash
/ux e-commerce checkout flow with saved payment methods
```

**Red flags it calls out:**
- Journey requires more than 5 steps
- User must remember info from previous step
- No feedback after user action
- Error message without recovery path
- Feature requires documentation to use

---

### agentic-architect

**Purpose:** Design multi-agent system architecture

**Tools:** Read, Glob, Grep, WebFetch, WebSearch

**When to use:**
- Starting a project with AI/agent components
- Deciding what should be an agent vs traditional code
- Auditing existing system for agentic opportunities
- Before building AI features - design the agent swarm

**What it produces:**
- `/docs/architecture/agent-design.md` - Complete agent architecture
- Agent catalog (name, role, inputs, outputs, tools)
- Agent topology diagram
- Traditional code components (what NOT to make an agent)
- Hybrid patterns (agent + code working together)
- Failure mode analysis
- Cost and latency estimates

**Key philosophy:**
- Use agents for ambiguity, code for precision
- Every agent needs a fallback
- Design for failure from the start
- Extensibility over perfection

**When to use an agent:**
- Natural language understanding/generation
- Ambiguous inputs requiring interpretation
- Tasks where rules would be too brittle
- Decision-making that benefits from reasoning

**When to use traditional code:**
- Deterministic operations (math, transformations)
- Database operations
- Cryptography and security
- Anything where hallucination would be catastrophic

**Example invocation:**
```bash
/aa customer support system with ticket routing and response generation
```

**Red flags it calls out:**
- Agent doing math → should be code
- Agent making security decisions → needs code guardrails
- Agent with no failure fallback → design gap
- Agent calling agent calling agent (3+ deep) → latency explosion

---

## Planning Agents

### implementation-planner

**Purpose:** Translate analysis into detailed technical implementation plans

**Tools:** Read, Glob, Grep, WebFetch, WebSearch

**When to use:**
- After analysis phase completes
- Before implementation begins
- When you need detailed specs for engineers

**Required inputs (must exist):**
1. `/docs/intent/product-intent.md` - What promises to keep
2. `/docs/ux/user-journeys.md` - What interactions to support
3. `/docs/architecture/agent-design.md` - What system components needed

**What it produces:**
- `/docs/plans/backend-plan.md` - Data model, APIs, services, agents
- `/docs/plans/frontend-plan.md` - Components, pages, state, routes
- `/docs/plans/test-plan.md` - Test strategy, unit/integration/E2E
- `/docs/plans/implementation-order.md` - Phased execution plan

**Key philosophy:**
- Every endpoint traces to a user journey
- Every test traces to a promise or invariant
- No ambiguity in specs
- Plan for failure

**Example invocation:**
```bash
/plan fastapi react postgres redis
```

**Planning rules:**
- If no journey needs an endpoint, don't plan it
- If a test doesn't protect intent, reconsider priority
- Engineer should never have to guess
- Flag complexity honestly

---

### gap-analyzer

**Purpose:** Analyze gaps between current state and ideal state

**Tools:** Read, Glob, Grep, WebFetch, WebSearch

**When to use:**
- After auditing existing codebase
- Before starting brownfield improvements
- When assessing technical debt
- To prioritize refactoring work

**Required inputs (audit outputs):**
1. `/docs/intent/product-intent.md` or audit
2. `/docs/ux/user-journeys.md` or audit
3. `/docs/architecture/` - system/agent design or audit

**What it produces:**
- `/docs/gaps/gap-analysis.md` - All gaps categorized by severity
- `/docs/gaps/migration-plan.md` - Phased improvement plan
- Prioritization by impact and effort
- Dependency graph

**Severity levels:**
- **Critical:** Security, data loss, broken promises - fix immediately
- **High:** Major UX issues, missing core functionality - Phase 1
- **Medium:** Improvements, technical debt - Phase 2
- **Low:** Nice to have, polish - Phase 3/backlog

**Example invocation:**
```bash
/gap
```

**Prioritization factors:**
- User impact
- Promise violation
- Risk/blast radius
- Dependencies
- Effort

---

### change-analyzer

**Purpose:** Analyze impact of requirement changes across all artifacts

**Tools:** Read, Glob, Grep

**When to use:**
- Mid-flight requirement changes
- User realizes they need additional features
- Stakeholder requests modifications
- After initial analysis/planning but before completion

**Required inputs (existing artifacts):**
1. `/docs/intent/product-intent.md` - Current intent
2. `/docs/ux/user-journeys.md` - Current UX
3. `/docs/architecture/agent-design.md` - Current architecture
4. `/docs/plans/*.md` - Current plans (if greenfield)
5. `/docs/gaps/migration-plan.md` - Current plan (if brownfield)

**What it produces:**
- `/docs/changes/change-[timestamp].md` - Impact analysis report
- Impact summary table (artifact → impact level → action)
- Detailed changes per artifact
- Conflict detection
- Rework assessment for completed work
- Recommended update sequence
- Effort estimate

**Change categorization:**
- **Addition:** New feature/capability
- **Modification:** Changing existing behavior
- **Removal:** Removing feature
- **Pivot:** Fundamental direction change

**Impact levels:**
- **Minor:** Single component, no architectural impact
- **Medium:** Multiple components, may need new journeys
- **Major:** Core architecture, intent, or multiple journeys
- **Pivot:** Requires rethinking most decisions

**Example invocation:**
```bash
/change add user roles and permissions with admin, editor, viewer levels
```

**What it reports:**
- Impact on each artifact (intent, UX, architecture, plans)
- Dependency ripple effects
- Conflicts with existing decisions
- Completed work affected
- Effort and timeline impact

**Use with:**
- `/update` to apply changes
- `/replan` to regenerate plans

---

## Implementation Agents

### backend-engineer

**Purpose:** Implement backend APIs, database models, services, and agents

**Tools:** Read, Edit, Bash, Glob, Grep

**When to use:**
- Implementing a phase from backend-plan.md
- Building specific backend features
- Fixing backend gaps in brownfield

**Required inputs:**
1. `/docs/plans/backend-plan.md` - Implementation spec
2. `/docs/intent/product-intent.md` - Promises to keep

**Implementation rules:**
- Follow schema exactly from plan
- Match request/response shapes exactly
- Implement ALL error cases listed
- Validate inputs at API boundary
- Always implement agent fallback behavior
- No `any` types, no unhandled exceptions
- Tests written alongside (not after)

**Example invocation:**
```bash
/implement backend auth
```

**What it reports:**
- What was built
- Tests written and passing
- Which promises this protects
- Any concerns or decisions

---

### frontend-engineer

**Purpose:** Implement UI components, pages, state management, and API integration

**Tools:** Read, Edit, Bash, Glob, Grep

**When to use:**
- Implementing a phase from frontend-plan.md
- Building specific UI features
- Fixing frontend gaps in brownfield

**Required inputs:**
1. `/docs/plans/frontend-plan.md` - Implementation spec
2. `/docs/ux/user-journeys.md` - User flows to support
3. `/docs/intent/product-intent.md` - Promises to keep

**Implementation rules:**
- Handle all states: loading, error, empty, success
- Props typed strictly (no `any`)
- Accessible by default
- Match route structure from plan
- Use typed API client
- Validate inline (don't wait for submit)

**Example invocation:**
```bash
/implement frontend dashboard
```

**What it reports:**
- What was built
- States handled (loading, error, empty, success)
- Which user journey this enables
- Component tests passing

---

### test-engineer

**Purpose:** Write tests AND verify system correctness

**Tools:** Read, Edit, Bash, Glob, Grep

**When to use:**
- Writing tests for new features
- Verifying a phase after implementation
- Adding missing test coverage
- Before marking a phase as complete

**Has two modes:**

**Mode 1: Write Tests**
- Unit tests (happy path, edge cases, errors)
- Integration tests (API contracts, service interactions)
- E2E tests (one per critical journey)
- Promise verification tests
- Invariant protection tests

**Mode 2: Verify Phase**
- Run smoke tests (backend starts, frontend starts, DB connects)
- Run full test suite
- Check for regressions
- Validate journeys work
- Verify intent compliance
- Report gaps

**Example invocations:**
```bash
/implement tests for auth service
/verify phase 1
/verify final
```

**Verification output:**
- Status: PASS / FAIL / PARTIAL
- Test results (X passing, Y failing)
- Journeys validated
- Promises verified
- Gaps to address
- Blockers
- Ready for next phase?

**Verification rules:**
- Never mark PASS if smoke tests fail
- Never mark PASS if regressions detected
- Flag missing tests as warnings
- Block next phase only for critical failures

---

## Quality Agents

### code-reviewer

**Purpose:** Review code for quality, security, and adherence to intent

**Tools:** Read, Glob, Grep

**When to use:**
- After implementation, before merging
- When reviewing pull requests
- Before production deployment
- Periodically for code quality audits

**Required inputs:**
1. `/docs/intent/product-intent.md` - Promises and invariants to protect
2. `CLAUDE.md` - Project conventions
3. The code to review

**Review checklist:**
- **Security** (Critical - blocks merge)
  - Injection vulnerabilities
  - Auth/authz properly enforced
  - No data exposure
  - Input validation
- **Bugs** (High - should fix)
  - Null/undefined handling
  - Error handling
  - Edge cases
  - Logic errors
- **Performance** (Medium)
  - N+1 queries
  - Missing indexes
  - Unnecessary re-renders
- **Maintainability** (Low)
  - Code clarity
  - Consistency
  - Duplication
- **Intent Compliance**
  - Promises protected
  - Invariants enforced

**Example invocation:**
```bash
/review src/auth/
```

**Output format:**
- Status: APPROVED / CHANGES REQUESTED / BLOCKED
- Critical issues (must fix)
- High priority issues (should fix)
- Medium priority issues (consider fixing)
- Suggestions (optional)
- What's good
- Intent compliance check

**Severity guidelines:**
- **Critical (blocks):** Security, data loss, promise violations
- **High:** Bugs in error paths, missing error handling
- **Medium:** Performance issues, technical debt
- **Suggestions:** Style, naming, refactoring opportunities

---

### debugger

**Purpose:** Systematic diagnosis and fixing of bugs and errors

**Tools:** Read, Edit, Bash, Glob, Grep

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
5. Prevent recurrence (add test)

**Debugging process:**
1. Gather information (error, stack trace, reproduction steps)
2. Reproduce the issue
3. Form hypothesis
4. Investigate systematically
5. Identify root cause
6. Implement minimal fix
7. Verify fix
8. Add regression test
9. Clean up debug code
10. Document findings

**Example invocation:**
```bash
/debug "TypeError: Cannot read property 'id' of undefined in user service"
```

**Output format:**
- Issue description
- Investigation (hypotheses tested)
- Root cause explanation
- Fix implemented
- Verification steps
- Regression test added
- Prevention recommendations

**Common bug patterns it handles:**
- Null/undefined errors
- Async/timing issues
- Type coercion problems
- Off-by-one errors
- State mutation bugs

**When to escalate:**
- Can't reproduce after 30 minutes
- Root cause unclear after 1 hour
- Fix requires expertise outside knowledge area

---

## Setup & Maintenance Agents

### ci-cd-engineer

**Purpose:** Set up automated CI/CD validation infrastructure in user projects

**Tools:** Read, Write, Edit, Bash, Glob, Grep

**When to use:**
- After L1 planning (intent, UX, architecture docs exist)
- When user requests "set up CI/CD", "validate", "protect the intent"
- Before production deployment
- When working with a team

**What it produces:**
- `/ci/validate.sh` - Master validation script
- `/ci/rules.json` - Generated from /docs (auto-updated when docs change)
- `/ci/validators/` - Intent, UX, architecture, and test validators
- `.git/hooks/pre-commit` - Quick validation before commit
- `.git/hooks/pre-push` - Full validation before push
- `.github/workflows/validate.yml` - GitHub Actions workflow

**How it works:**
1. Reads /docs/intent/, /docs/ux/, /docs/architecture/
2. Generates validation rules from promises, journeys, and constraints
3. Creates validators that check code against those rules
4. Sets up git hooks and CI/CD workflow
5. Auto-regenerates rules when docs change

**Key philosophy:**
- Every rule traces to a specific promise/journey/constraint
- Validation is intent-aware, not generic
- CRITICAL promises block deployment
- HIGH promises warn
- MEDIUM/LOW inform

**Example rule:**
```json
{
  "id": "INTENT-001",
  "severity": "CRITICAL",
  "promise": "User data never leaves device",
  "source": "/docs/intent/product-intent.md:12",
  "pattern": "fetch\\(.*api\\..*sync",
  "message": "Found network call with user data - breaks privacy promise"
}
```

**Opt-in, not mandatory:** Users can decline CI/CD setup.

---

### project-maintainer

**Purpose:** Keep project documentation and state in sync with code reality

**Tools:** Read, Edit, Bash, Glob, Grep

**When to use:**
- **Automatically:** After feature verification (test-engineer triggers)
- **Automatically:** After L1 planning (implementation-planner triggers)
- **Manually:** Before ending session (`/sync` or "save state")
- **Periodically:** Every 3-4 features during long sessions

**What it maintains:**
1. **Project CLAUDE.md - Current State section:**
   - Feature progress table (Backend/Frontend/Tests/Overall status)
   - Current task and next steps
   - Important context from this session
   - Test coverage summary
   - Open questions

2. **Documentation (/docs/) status markers:**
   - /docs/intent/product-intent.md - `[KEPT]`, `[AT RISK]`, `[BROKEN]`
   - /docs/ux/user-journeys.md - `[IMPLEMENTED]`, `[PARTIAL]`, `[NOT STARTED]`
   - /docs/plans/implementation-order.md - Feature completion tracking

3. **Test Coverage Verification:**
   - Completed features have tests
   - Journeys have E2E tests
   - Identify gaps

**Modes:**
- **Full sync** (`/sync`): Complete state update + docs + test coverage
- **Quick sync** (`/sync quick`): CLAUDE.md Current State only
- **Report** (`/sync report`): Show status without making changes

**Session Continuity:**
Running `/sync` before ending a session saves complete context so next session can resume with "continue".

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

Progress: 5/8 features complete
Current: search frontend (SearchBar component)
Next: Continue SearchBar, then ResultsList
```

**Integration:**
- `test-engineer` auto-triggers after successful verification
- `implementation-planner` auto-triggers after planning complete

**Key philosophy:**
- Documentation reflects reality, not aspirations
- Session state enables seamless handoff
- Test coverage tracking prevents technical debt
- Nothing gets lost between sessions

---

## Agent Interaction Patterns

### Sequential Flow (Greenfield)
```
intent-guardian →
ux-architect →
agentic-architect →
implementation-planner →
  └─> project-maintainer (initial sync) →
backend-engineer + frontend-engineer + test-engineer →
code-reviewer →
test-engineer (verify) →
  └─> project-maintainer (sync after feature)
```

### Sequential Flow (Brownfield)
```
[audits run] →
gap-analyzer →
backend-engineer + frontend-engineer + test-engineer →
test-engineer (verify)
```

### Parallel Analysis
```
                    ┌─ intent-guardian
user requirement ─┤
                    ├─ ux-architect
                    └─ agentic-architect
```

### Quality Loop
```
implementation → code-reviewer → [issues found] → debugger → test-engineer
```

## Tool Access Summary

| Agent | Read | Edit | Write | Bash | Glob | Grep | WebFetch | WebSearch |
|-------|------|------|-------|------|------|------|----------|-----------|
| intent-guardian | ✓ | | | | ✓ | ✓ | ✓ | ✓ |
| ux-architect | ✓ | | | | ✓ | ✓ | ✓ | ✓ |
| agentic-architect | ✓ | | | | ✓ | ✓ | ✓ | ✓ |
| implementation-planner | ✓ | | | | ✓ | ✓ | ✓ | ✓ |
| gap-analyzer | ✓ | | | | ✓ | ✓ | ✓ | ✓ |
| change-analyzer | ✓ | | | | ✓ | ✓ | | |
| backend-engineer | ✓ | ✓ | | ✓ | ✓ | ✓ | | |
| frontend-engineer | ✓ | ✓ | | ✓ | ✓ | ✓ | | |
| test-engineer | ✓ | ✓ | | ✓ | ✓ | ✓ | | |
| code-reviewer | ✓ | | | | ✓ | ✓ | | |
| debugger | ✓ | ✓ | | ✓ | ✓ | ✓ | | |
| ci-cd-engineer | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | | |
| project-maintainer | ✓ | ✓ | | ✓ | ✓ | ✓ | | |

**Analysis agents** (Read-only + Web): Research and design, produce documentation
**Implementation agents** (Read + Edit + Bash): Write code, run tests
**Quality agents** (Read + limited Edit): Review and debug
**Setup & Maintenance agents** (Read + Edit/Write + Bash): Set up infrastructure, maintain state
