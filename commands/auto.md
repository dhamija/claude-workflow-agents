---
description: Control automatic workflow orchestration
argument-hint: [on | off | status]
---

Control whether workflow runs automatically or manually.

## Usage

### `/auto on` (default)

Enable automatic orchestration:

```
/auto on

Orchestration: AUTOMATIC

Agents will chain automatically.
Quality gates run after each phase.
Documentation updates automatically.
Only pauses for decisions.
```

**What this means:**
- You describe what you want
- Agents run in sequence automatically
- Code review happens after each phase
- Tests run automatically
- Docs sync automatically
- You only intervene for decisions or errors

**Example flow:**
```
You: Build a todo app

Claude: Starting workflow...
        → Intent [auto]
        ✓ Done
        → UX [auto]
        ✓ Done
        → Architecture [auto]
        ✓ Done
        → Planning [auto]
        ✓ Done
        → Building feature 1 [auto]
        ...continues...
```

---

### `/auto off`

Disable automatic orchestration:

```
/auto off

Orchestration: MANUAL

You control each step:
- Manually invoke agents with /intent, /ux, etc.
- Manually run /review
- Manually run /verify
- Manually update docs with /project sync
```

**What this means:**
- You have full control
- Each agent must be invoked manually
- Quality checks must be run manually
- Useful for learning or debugging workflow

**Example flow:**
```
You: Build a todo app
Claude: [Waits for your command]

You: /intent
Claude: [Runs intent-guardian]
        Done. What next?

You: /ux
Claude: [Runs ux-architect]
        Done. What next?
...
```

---

### `/auto status`

Show current orchestration state and queue:

```
/auto status

Orchestration: AUTOMATIC

Current Phase: L2 Building
Feature: search (2 of 6)
Step: frontend

Progress:
  L1: ████████████████████ 100%
  L2: ██████░░░░░░░░░░░░░░  33%

Completed:
  ✓ L1: Intent
  ✓ L1: UX
  ✓ L1: Architecture
  ✓ L1: Planning
  ✓ Feature: auth

In Progress:
  🔄 Feature: search
     ✓ Backend
     🔄 Frontend (current)
     ○ Tests
     ○ Review

Queue:
  1. Complete frontend
  2. Run ui-debugger check
  3. Run code-reviewer
  4. Run test-engineer
  5. Update docs
  6. Start feature: dashboard
  7. Start feature: settings
  ...

Next auto-step in 3s (say "wait" to pause)
```

---

## When to Use Each Mode

### Use `/auto on` (Recommended)

**When:**
- Building a new project from scratch
- You want to move fast
- You trust the workflow
- You're comfortable with automatic decisions

**Benefits:**
- Much faster
- Less manual work
- Consistent quality
- Auto-documentation

### Use `/auto off`

**When:**
- Learning how the workflow works
- Debugging workflow issues
- Want fine control over each step
- Working on complex/unusual project

**Benefits:**
- Full control
- See each step clearly
- Can intervene at any point
- Good for understanding

---

## Implementation

This command controls the `workflow-orchestrator` agent.

### Enable Auto Mode

- Set orchestration flag to `true`
- workflow-orchestrator takes control
- Agents chain automatically

### Disable Auto Mode

- Set orchestration flag to `false`
- workflow-orchestrator steps back
- User controls each step manually

### Check Status

- Read workflow state from CLAUDE.md or memory
- Show current phase, feature, step
- Show queue of upcoming work
- Show progress percentage

---

## Examples

### Switching Modes Mid-Workflow

```
# Start in auto mode
You: Build a recipe app
Claude: [Auto-orchestrates through L1]
        ...L1 complete, starting L2...

# Switch to manual
You: /auto off
Claude: Orchestration now MANUAL
        Current: Feature "search", step "backend"
        What would you like to do next?

You: /implement backend search
Claude: [Runs backend-engineer]
        Done. What next?

# Switch back to auto
You: /auto on
Claude: Orchestration now AUTOMATIC
        Resuming from: Feature "search", completed backend
        Continuing to frontend...
        [Auto-continues]
```

### Pausing Auto Mode

```
# Auto mode running
Claude: → Frontend [starting...]

You: wait
Claude: Orchestration PAUSED
        Feature: search, step: frontend (not started)
        Say "continue" to resume, or use /auto off for manual mode

You: continue
Claude: Orchestration RESUMED
        → Frontend [continuing...]
```

---

## Default Behavior

If `/auto` is never called:
- **Default: AUTOMATIC mode**
- Workflow orchestrates automatically from the start
- User can say "manual mode" or `/auto off` to switch

---

## Tips

**For Speed:**
- Keep `/auto on`
- Let workflow handle orchestration
- Focus on describing what you want

**For Learning:**
- Use `/auto off` initially
- Manually invoke each agent to see what it does
- Switch to `/auto on` once comfortable

**For Debugging:**
- Use `/auto status` to see queue
- Use `/auto off` to pause and inspect
- Use `/auto on` to resume

**Emergency Stop:**
- Say "stop" or "pause" at any time
- Workflow stops immediately
- Say "continue" or `/auto on` to resume
