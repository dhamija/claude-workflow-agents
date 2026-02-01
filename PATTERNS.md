# Common Usage Patterns

> **v3.3 Note:** Patterns work the same way. Skills load automatically, subagents invoked when needed. Just use these patterns naturally.

Quick reference for common development scenarios.

---

## Pattern 1: New Project (Greenfield)

```
You: Build me a task manager

Claude: [Analyzes] → Creates intent, UX, architecture
        [Plans] → Creates feature plans
        [Builds] → Implements features one by one
```

**Key Points:**
- Just describe what you want
- Claude handles agent orchestration
- Sequential by default
- Use `/project setup` after planning for infrastructure

---

## Pattern 2: Add Feature to Existing Project

```
You: Add comments to tasks

Claude: [change-analyzer] → Analyzes impact
        [Updates docs] → Updates intent, UX, plans
        [Implements] → Builds feature
        [project-ops] → Suggests /project sync
```

**Key Points:**
- Claude automatically updates affected documentation
- No need to manually update plans
- Verification happens at every step

---

## Pattern 3: Improve Existing Codebase (Brownfield)

```
You: Analyze this codebase

Claude: [Audits] → Infers intent/UX/architecture (marked [INFERRED])
        Asks: "Is this understanding correct?"

You: Yes, but it's for team collaboration

Claude: [Updates] → Refines understanding
        [gap-analyzer] → Finds 12 gaps
        Suggests: "Fix critical gaps first?"

You: Yes

Claude: [Implements fixes] → By priority
```

**Key Points:**
- Let Claude audit first before asking for changes
- Review [INFERRED] docs carefully
- Fixes are prioritized: Critical → High → Medium → Low

---

## Pattern 4: Save State Between Sessions

```
[End of session]
You: Save state before I go

Claude: [project-ops runs /project sync]
        ✓ CLAUDE.md updated with current task
        ✓ Documentation synced
        ✓ Progress recorded

[Next session]
You: Continue

Claude: Continuing from where we left off...
        Current task: SearchBar component
        [Resumes seamlessly]
```

**Key Points:**
- Always sync before ending session
- "Continue" works across sessions
- CLAUDE.md preserves context

---

## Pattern 5: Parallel Development (Teams)

```
[After L1 planning]
You: /parallel auth

Claude: Created worktree: ../myapp-auth/

[New terminal]
$ cd ../myapp-auth
$ claude

You: Implement this feature

Claude: [Builds feature in isolation]
        ✓ Complete

[Back in main]
$ git merge feature/auth
```

**Key Points:**
- Only for independent features
- Each worktree has scoped CLAUDE.md
- Merge when complete

---

## Pattern 6: Code Review Before Shipping

```
You: Review the code before we ship

Claude: [code-reviewer analyzes]

        Summary: APPROVED with 2 suggestions

        🟠 High: Reset tokens don't expire
        🟡 Medium: Missing rate limiting

        Fix high-priority issues?

You: Yes

Claude: [Fixes issues]
        ✓ All critical issues resolved
```

**Key Points:**
- Use before milestones/deploys
- Claude prioritizes issues
- Can fix automatically or just report

---

## Pattern 7: Debugging

```
You: Login is broken - I get "Invalid token"

Claude: [debugger analyzes]
        Found: Token validation logic reversed
        Fixed: auth/service.ts:45
        Added: Regression test

        ✓ Issue resolved
```

**Key Points:**
- Provide error message
- Claude finds root cause
- Always adds regression test

---

## Pattern 8: Design System Usage

```
[During UX phase]
Claude: What design style do you prefer?
        1. modern-clean (professional SaaS)
        2. minimal (content-focused)
        3. playful (vibrant)
        ...

You: 1

Claude: ✓ Applied modern-clean preset
        ✓ Created /docs/ux/design-system.md

[Later, during frontend work]
Claude: [frontend-engineer reads design-system.md FIRST]
        [Uses only colors/fonts/spacing from design system]
        [All UI automatically consistent]
```

**Key Points:**
- Design system created during UX phase
- Frontend engineer MUST follow it
- No arbitrary styling decisions
- Visual consistency enforced

---

## Pattern 9: Project Operations

```
# Initialize infrastructure
You: /project setup
Claude: [Creates scripts, hooks, CI, docs structure]

# After implementing features
You: /project sync
Claude: [Updates all docs to match implementation]

# Before committing
You: /project verify
Claude: [Checks compliance, runs tests]

# Check project health
You: /project status
Claude: [Shows progress, tests, promises, next steps]
```

**Key Points:**
- Setup once at project start
- Sync after each feature
- Verify before commits
- Status anytime

---

## Pattern 10: LLM Integration

```
You: /project ai setup

Claude: Which providers?

You: Ollama for dev, OpenAI for prod

Claude: ✓ Created lib/llm/ structure
        ✓ Dual provider setup
        ✓ Automatic fallback chain
        ✓ Cost tracking enabled

[Later in code]
// Automatically uses Ollama locally,
// falls back to OpenAI if needed
const result = await llm.complete(prompt);
```

**Key Points:**
- Dual provider for reliability
- Local (Ollama) for development = free
- Commercial (OpenAI) for production = reliable
- Automatic fallback, never crashes

---

## Anti-Patterns (What NOT to Do)

❌ **Don't manually update CLAUDE.md** → Use `/project sync`
❌ **Don't skip design system** → Leads to inconsistent UI
❌ **Don't ignore warnings** → They prevent bigger issues
❌ **Don't use parallel for tightly coupled features** → Creates merge conflicts
❌ **Don't forget to sync before ending session** → Loses context
❌ **Don't bypass verification hooks without reason** → Breaks documentation sync

---

## Quick Decision Tree

```
Starting new project?
└─ Just describe it → Claude handles rest

Adding to existing project?
├─ New feature → Just ask → Claude updates docs
└─ Fix existing code → "Analyze this" → Review → Fix

Want infrastructure?
└─ /project setup → Done

Want to see progress?
└─ /project status → Shows everything

Before committing?
└─ /project verify → Checks compliance

Multiple developers?
└─ /parallel <feature> → Work in parallel

Need help?
└─ /help <topic> → In-app documentation
```

---

For detailed examples, see [EXAMPLES.md](EXAMPLES.md).
