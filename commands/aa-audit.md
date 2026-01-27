---
description: Analyze existing codebase for agentic optimization opportunities
argument-hint: <optional focus area>
---

Analyze an EXISTING codebase (brownfield) for agentic optimization opportunities.

**This is for existing code. For new apps, use `/aa` instead.**

## Step 1: Explore the current project

Read these files if they exist (skip if missing):
- CLAUDE.md
- README.md
- package.json or pyproject.toml
- /docs/ directory

Then explore the main source directories to understand:
- Current architecture and data flow
- Where business logic lives
- What patterns are used

## Step 2: Use agentic-architect subagent

Have it analyze through an agentic lens:
- What is currently hardcoded that could be an agent decision?
- Where are brittle heuristics/rules that LLMs could handle better?
- What manual processes could become agent workflows?
- Where is there implicit "intelligence" buried in if/else chains?
- Where would adding agents make things WORSE?

Focus area (if specified): $ARGUMENTS

## Step 3: Output

Create `/docs/architecture/agentic-audit.md` with:
- Current state summary
- Agentic opportunities table (component, current state, proposed agent, benefit, risk)
- Components to keep as traditional code
- Migration path recommendations (phases)
- Quick wins vs needs more design

**Usage Examples:**
```
/aa-audit                                # Analyze entire codebase
/aa-audit the notification system        # Focus on specific area
/aa-audit authentication and authorization
```
