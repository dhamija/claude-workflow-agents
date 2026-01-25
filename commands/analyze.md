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
description: Run all analysis agents in parallel for an app idea
argument-hint: <app idea>
---

Run these three analyses IN PARALLEL for:

$ARGUMENTS

## Parallel Execution

Launch these subagents concurrently:

1. **intent-guardian** → Save to /docs/intent/product-intent.md
   Task: Define product intent, promises, invariants, boundaries

2. **ux-architect** → Save to /docs/ux/user-journeys.md
   Task: Design user personas, journeys, screens, interactions

3. **agentic-architect** → Save to /docs/architecture/agent-design.md
   Task: Design system architecture, agent vs code separation

## After All Complete

Summarize:
- Intent: [one line]
- UX: [key journeys count]
- System: [agent count vs traditional components]

Tell user: "Analysis complete. Run /plan to generate implementation plans."
