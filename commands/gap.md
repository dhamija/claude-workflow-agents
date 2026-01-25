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
description: Analyze gaps between current state and ideal (brownfield L2)
argument-hint: <optional focus area>
---

## Prerequisites

Check audits exist:
- /docs/intent/intent-audit.md (or product-intent.md)
- /docs/ux/ux-audit.md (or user-journeys.md)
- /docs/architecture/agentic-audit.md (or system-design.md)

If missing: "Run /audit first"

## Gap Analysis

Use gap-analyzer subagent to:

1. Read all audit outputs
2. Compare current state against ideal for:
   - Intent compliance (promises kept?)
   - UX quality (journeys smooth?)
   - Architecture (agents where appropriate?)
   - Test coverage (promises verified?)
3. Prioritize gaps by severity and effort
4. Create migration plan

Focus: $ARGUMENTS

## Output

- /docs/gaps/gap-analysis.md - All gaps categorized
- /docs/gaps/migration-plan.md - Phased improvement plan

Next: Run `/improve phase 0` to fix critical issues.
