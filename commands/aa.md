---
description: Design agentic architecture for a new app idea
argument-hint: <app idea>
---

Design an agentic architecture for a NEW project (greenfield).

**This is for NEW apps, not existing codebases. For existing code, use `/aa-audit` instead.**

## Requirements

You must provide an app idea. Example: `/aa recipe sharing app with social features`

## Step 1: Understand the app idea

Parse the app description from $ARGUMENTS and clarify:
- What is the core purpose?
- Who are the users?
- What are the main features?

## Step 2: Use agentic-architect subagent

Have it design an architecture that identifies:
- Which components should be AI agents (vs traditional code)?
- What decisions should agents make?
- Where LLMs add value vs where they'd be overkill
- Agent collaboration patterns
- Human-in-the-loop touchpoints

## Step 3: Output

Create `/docs/architecture/agentic-architecture.md` with:
- App overview
- Architecture diagram (text)
- Agent definitions (what each agent does)
- Traditional code components
- Data flow and agent interactions
- Why this agent mix (rationale)

**Usage Examples:**
```
/aa food delivery app with smart routing
/aa customer support platform with ticket classification
/aa content moderation system
```
