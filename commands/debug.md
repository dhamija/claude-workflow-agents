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
description: Debug an error, test failure, or unexpected behavior
argument-hint: <error message, test name, or description of issue>
---

Use debugger subagent to investigate and fix:

## Issue

$ARGUMENTS

## Process

1. Gather information:
   - Find exact error message/stack trace
   - Identify reproduction steps
   - Check recent changes

2. Reproduce the issue:
   - Run failing test or trigger error
   - Confirm consistent reproduction

3. Investigate systematically:
   - Form hypotheses
   - Test each one
   - Add debug logging if needed

4. Identify root cause:
   - Explain WHY it happens
   - Confirm explanation matches all symptoms

5. Implement minimal fix:
   - Change only what's necessary
   - Don't refactor while debugging

6. Verify fix:
   - Original issue resolved
   - No regressions

7. Add regression test:
   - Prevent recurrence

8. Clean up:
   - Remove debug logging

## Output

Produce debug report with:
- Issue description
- Investigation steps
- Root cause analysis
- Fix implemented
- Verification results
- Regression test added

Commit fix: `fix([scope]): [description of bug fixed]`
