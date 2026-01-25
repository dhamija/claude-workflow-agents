<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
description: Analyze current project and suggest agentic optimizations
argument-hint: <optional focus area>
---

Analyze THIS codebase for agentic optimization opportunities.

## Step 1: Explore the current project structure
Read these files if they exist (skip if missing):
- CLAUDE.md
- README.md  
- package.json or pyproject.toml
- /docs/ directory

Then explore the main source directories to understand the architecture.

## Step 2: Use agentic-architect subagent
Have it analyze what you found and identify:
- Hardcoded logic that could be agent decisions
- Brittle rules/heuristics that LLMs could handle
- Manual processes that could become agent workflows
- What should stay as traditional code

Focus area (if specified): $ARGUMENTS

## Step 3: Output
Create a new file at /docs/architecture/agentic-audit.md with:
- Current state summary
- Agentic opportunities table
- Components to keep as code
- Migration path recommendations
- Quick wins vs needs more design

IMPORTANT: You are analyzing the existing codebase, not reading from agentic-audit.md.
