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
name: enforce
description: Set up or manage documentation enforcement for this project
argument-hint: [setup | status | verify | disable]
---

Manage documentation enforcement for this project.

## Action: $ARGUMENTS

### If: $ARGUMENTS is empty or "help"

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                      DOCUMENTATION ENFORCEMENT                               ║
╚══════════════════════════════════════════════════════════════════════════════╝

Automatic enforcement keeps your documentation in sync with code.


WHAT IT DOES
────────────

  Git pre-commit hook:
    • Runs before every commit
    • Checks docs are in sync
    • Blocks commit if issues found

  CI workflow:
    • Runs on every PR
    • Verifies promises, state, tests
    • Fails PR if out of sync


WHAT'S CHECKED
──────────────

  ✓ CLAUDE.md has current state
  ✓ No BROKEN promises without reason
  ✓ Tests exist for features
  ✓ Code changes → docs updated


COMMANDS
────────

  /enforce setup     Set up enforcement
  /enforce status    Check if active
  /enforce verify    Run verification manually
  /enforce disable   Remove enforcement


SETUP
─────

  After L1 planning, run:

    /enforce setup

  This creates:
    • /scripts/verify-project.sh
    • /scripts/hooks/pre-commit
    • /.github/workflows/verify.yml


WHAT HAPPENS
────────────

  On commit:
    1. Hook runs verification
    2. If issues → COMMIT BLOCKED
    3. Fix issues, commit again

  On PR:
    1. CI runs verification
    2. If issues → PR FAILS
    3. Must fix before merge


EMERGENCY BYPASS
────────────────

  git commit --no-verify

  Use sparingly! CI will still check on PR.
```

---

### If: $ARGUMENTS is "setup"

**Action:** Invoke the project-enforcer agent.

The agent will:
1. Analyze what documentation exists
2. Create verification script
3. Install git pre-commit hook
4. Create CI workflow
5. Update CLAUDE.md with enforcement section

**Expected output:**
```
╔══════════════════════════════════════════════════════════════════╗
║              PROJECT ENFORCEMENT ENABLED                         ║
╚══════════════════════════════════════════════════════════════════╝

Created:
  ✓ /scripts/verify-project.sh
  ✓ /scripts/hooks/pre-commit
  ✓ /.github/workflows/verify.yml
  ✓ CLAUDE.md updated

Installed:
  ✓ Git pre-commit hook active
```

---

### If: $ARGUMENTS is "status"

**Action:** Check enforcement status.

Show:
```
Enforcement Status
══════════════════

Git Hook:       ✓ Installed (.git/hooks/pre-commit exists)
CI Workflow:    ✓ Present (.github/workflows/verify.yml exists)
Verify Script:  ✓ Exists (scripts/verify-project.sh exists)

Last Verification: [run verify-project.sh to check]
```

If missing:
```
Enforcement Status
══════════════════

Git Hook:       ✗ Not installed
CI Workflow:    ✗ Not found
Verify Script:  ✗ Not found

⚠️ Enforcement is NOT active.

Run: /enforce setup
```

---

### If: $ARGUMENTS is "verify"

**Action:** Run verification manually.

```bash
./scripts/verify-project.sh -v
```

Shows detailed compliance report with all checks.

---

### If: $ARGUMENTS is "disable"

**Action:** Disable enforcement (with warning).

```
⚠️ WARNING: This will disable automatic enforcement.

This removes:
  • Git pre-commit hook (.git/hooks/pre-commit)
  • CI workflow (.github/workflows/verify.yml)

Your documentation may become stale without enforcement.

Proceed? [Yes / No]
```

If user confirms:
```bash
rm -f .git/hooks/pre-commit
rm -f .github/workflows/verify.yml

echo "✓ Enforcement disabled"
echo ""
echo "To re-enable: /enforce setup"
```

---

## Examples

```
User: /enforce setup

Claude: Setting up enforcement for your project...

        Analyzing documentation...
          ✓ Found /docs/intent/product-intent.md
          ✓ Found /docs/ux/user-journeys.md
          ✓ Found CLAUDE.md

        Creating verification script...
          ✓ Created /scripts/verify-project.sh

        Creating git hook...
          ✓ Created /scripts/hooks/pre-commit
          ✓ Installed to .git/hooks/pre-commit

        Creating CI workflow...
          ✓ Created /.github/workflows/verify.yml

        Updating CLAUDE.md...
          ✓ Added enforcement section

        Testing enforcement...
          ✓ Verification passed

        ╔══════════════════════════════════════════════════════════╗
        ║         PROJECT ENFORCEMENT ENABLED                      ║
        ╚══════════════════════════════════════════════════════════╝

        What happens now:
          • Every commit runs verification
          • Blocks if docs are stale
          • CI fails PRs with issues

        Commands:
          ./scripts/verify-project.sh  - Check compliance
          git commit --no-verify       - Emergency bypass
```

```
User: /enforce status

Claude: Checking enforcement status...

        Enforcement Status
        ══════════════════

        Git Hook:       ✓ Installed
        CI Workflow:    ✓ Present
        Verify Script:  ✓ Exists

        To verify compliance: /enforce verify
```

```
User: /enforce verify

Claude: Running verification...

        ╔══════════════════════════════════════════════════════════╗
        ║              PROJECT VERIFICATION                        ║
        ╚══════════════════════════════════════════════════════════╝

        [1/5] Checking Intent Compliance...
          ✓ Intent file exists (5/6 promises kept)
          ⚠ 1 promise(s) at risk

        [2/5] Checking UX Journeys...
          ✓ UX file exists
             Implemented: 4 | Partial: 1 | Not Started: 2

        [3/5] Checking Architecture...
          ✓ Architecture file exists

        [4/5] Checking CLAUDE.md State...
          ✓ CLAUDE.md has Current State section
          ⚠ 2 item(s) marked 'In Progress' - verify these are accurate

        [5/5] Checking Test Coverage...
          ✓ Test directory exists (23 test files)

        [+] Checking staged changes...
          (no files staged)

        ════════════════════════════════════════════════════════════
                              SUMMARY
        ════════════════════════════════════════════════════════════

          Errors:   0
          Warnings: 3

        ⚠ VERIFICATION PASSED WITH WARNINGS

           3 warning(s) - consider addressing these.
```

```
User: /enforce disable

Claude: ⚠️ WARNING: This will disable automatic enforcement.

        This removes:
          • Git pre-commit hook
          • CI workflow

        Your documentation may become stale without enforcement.

        Are you sure? (yes/no)

User: yes

Claude: Removing enforcement...

        ✓ Removed .git/hooks/pre-commit
        ✓ Removed .github/workflows/verify.yml

        Enforcement disabled.

        To re-enable: /enforce setup
```
