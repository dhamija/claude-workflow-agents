<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/agent-wf-help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
description: Analyze current project and suggest agentic optimizations
argument-hint: <optional focus area>
---

Use the agentic-architect subagent to:

1. Read and understand the current codebase:
   - Read CLAUDE.md, README.md, and /docs/ if they exist
   - Explore /src or /api and /web directories
   - Understand the current architecture and data flow

2. Analyze through an agentic lens:
   - What is currently hardcoded that could be an agent decision?
   - Where are brittle heuristics/rules that LLMs could handle better?
   - What manual processes could become agent workflows?
   - Where is there implicit "intelligence" buried in if/else chains?

3. Propose agentic optimizations:
   - Which components should become agents?
   - Which should stay as traditional code?
   - What new agents could add capabilities?
   - What's the migration path (not just ideal end state)?

4. Risk assessment:
   - Where would adding agents make things WORSE?
   - What's not ready for agents yet?
   - What would break during migration?

Focus area (if specified): $ARGUMENTS

Save analysis to /docs/architecture/agentic-audit.md
```

**Usage:**
```
/aa food delivery app                    # New project
/aa-audit                                # Analyze current project
/aa-audit the notification system        # Focus on specific area
