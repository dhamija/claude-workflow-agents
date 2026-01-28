---
description: LLM user testing - setup, test, fix, and track
---

# LLM User Testing

**Command:** `/llm-user <subcommand>`

**Purpose:** Automated UI testing using LLM-simulated users to validate promises.

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `init` | Generate test infrastructure from L1 docs |
| `test` | Run LLM user tests against your UI |
| `fix` | Systematically fix gaps found by tests |
| `status` | View test results, gaps, and progress |
| `refresh` | Regenerate after doc changes |

---

## Workflow

```
/llm-user init     → Generate personas, scenarios, evaluators
       ↓
/llm-user test     → Run tests, find gaps
       ↓
/llm-user status   → Review gaps by priority
       ↓
/llm-user fix      → Fix gaps (auto-verifies after each)
       ↓
/llm-user test     → Confirm all gaps resolved
```

---

## Commands

### `/llm-user init`

Generate test infrastructure from your L1 workflow docs.

```bash
/llm-user init           # Generate from docs
/llm-user init --force   # Regenerate even if exists
```

**Prerequisites:**
- `docs/intent/product-intent.md`
- `docs/ux/user-journeys.md`
- `docs/architecture/agent-design.md`

**Creates:**
```
tests/llm-user/
├── test-spec.yaml       # Unified test configuration
├── personas/            # Simulated user profiles
└── scenarios/           # Test scenarios

.claude/agents/
├── {{project}}-llm-user.md      # Domain-specific user agent
└── {{project}}-evaluator.md     # Domain-specific evaluator
```

---

### `/llm-user test`

Run LLM user tests against your UI.

```bash
# Run all tests against localhost:3000
/llm-user test

# Test specific URL
/llm-user test https://staging.myapp.com

# Test specific scenario
/llm-user test --scenario=checkout-flow

# Test specific persona
/llm-user test --persona=maria-beginner

# Combine options
/llm-user test https://staging.myapp.com --scenario=checkout --persona=expert
```

**Options:**
| Option | Description |
|--------|-------------|
| `[url]` | Base URL (default: localhost:3000) |
| `--scenario=<id>` | Run specific scenario only |
| `--persona=<id>` | Run with specific persona only |
| `--critical` | Run only critical path scenarios |

**Output:**
```
LLM USER TEST RESULTS
═════════════════════

URL: https://staging.myapp.com
Scenarios: 4 | Passed: 3 | Failed: 1

SCORE: 7.2/10

GAPS FOUND:
🔴 CRITICAL (1)
   GAP-001: No progress tracking visible

🟠 HIGH (2)
   GAP-002: Feedback not level-adaptive
   GAP-003: Loading time >3s

Run /llm-user status for details
Run /llm-user fix to resolve gaps
```

---

### `/llm-user fix`

Fix gaps found by LLM user testing. Auto-verifies after each fix.

```bash
# Fix all gaps (critical first)
/llm-user fix

# Fix only critical gaps
/llm-user fix --critical

# Fix only high priority
/llm-user fix --high

# Fix specific gap
/llm-user fix GAP-001

# Fix up to N gaps
/llm-user fix --limit=3
```

**Options:**
| Option | Description |
|--------|-------------|
| `[gap-id]` | Fix specific gap |
| `--critical` | Only critical gaps |
| `--high` | Critical and high gaps |
| `--limit=N` | Stop after N gaps |

**Workflow per gap:**
1. Create fix specification
2. Implement via workflow agents (backend/frontend/test)
3. Run code review
4. **Auto-verify** by re-running failed scenarios
5. Update gap status (OPEN → CLOSED)
6. Move to next gap

**Output:**
```
FIXING GAPS
═══════════

🎯 GAP-001 (CRITICAL): No progress tracking
   Creating fix spec...
   Implementing 3 tasks...
   ✓ Backend: progress tracking API
   ✓ Frontend: progress dashboard
   ✓ Tests: progress tracking tests

   Verifying...
   Re-running: multi-scene-session
   ✓ Verification PASSED

   Status: OPEN → CLOSED
   Score: 7.2 → 8.5

Continue to GAP-002? [Y/n]
```

---

### `/llm-user status`

View test results, gaps, and fix progress.

```bash
# Show current status
/llm-user status

# Show specific test run
/llm-user status --run=2026-01-28T10:30:00

# Filter by priority
/llm-user status --critical
/llm-user status --high

# Filter by status
/llm-user status --open
/llm-user status --closed

# Export to file
/llm-user status --export
/llm-user status --export=json
```

**Options:**
| Option | Description |
|--------|-------------|
| `--run=<timestamp>` | View specific test run |
| `--critical` | Show only critical gaps |
| `--high` | Show critical and high |
| `--open` | Show only unresolved gaps |
| `--closed` | Show only resolved gaps |
| `--export` | Export to markdown file |
| `--export=json` | Export as JSON |

**Output:**
```
LLM USER TESTING STATUS
═══════════════════════

LATEST RUN: 2026-01-28T10:30:00
SCORE: 8.5/10 (was 7.2)

PROMISE VALIDATION
──────────────────
✓ P1: Scene descriptions work
✓ P2: Helpful corrections
✓ P3: Progress visible (was ✗)
~ P4: Level-adaptive (in progress)

GAPS (2 open, 1 closed)
───────────────────────
🟢 CLOSED
   ✓ GAP-001: Progress tracking

🟠 OPEN - HIGH
   • GAP-002: Feedback not adaptive
   • GAP-003: Loading time >3s

NEXT: /llm-user fix GAP-002
```

---

### `/llm-user refresh`

Regenerate test artifacts after workflow docs change.

```bash
# Detect changes and regenerate
/llm-user refresh

# Force full regeneration
/llm-user refresh --force
```

**When to use:**
- After updating `product-intent.md` (new promises)
- After updating `user-journeys.md` (new personas)
- After architecture changes

---

## Complete Example

```bash
# 1. After L1 planning, set up testing
/llm-user init
# ✓ 3 personas, 5 scenarios generated

# 2. After L2 implementation, test the UI
/llm-user test https://staging.myapp.com
# Score: 7.2/10, 3 gaps found

# 3. Review what's wrong
/llm-user status
# Shows gaps by priority with recommendations

# 4. Fix the issues
/llm-user fix --critical
# Fixes GAP-001, auto-verifies, score improves

/llm-user fix --high
# Fixes GAP-002, GAP-003

# 5. Final verification
/llm-user test https://staging.myapp.com
# Score: 9.5/10, all promises validated

# 6. After doc updates, refresh
/llm-user refresh
# Regenerates test specs with new promises
```

---

## File Structure

```
tests/llm-user/
├── test-spec.yaml           # Test configuration
├── personas/
│   ├── maria-beginner.yaml
│   ├── jake-teen.yaml
│   └── sofia-expert.yaml
├── scenarios/
│   ├── first-scene.yaml
│   ├── error-recovery.yaml
│   └── multi-scene.yaml
└── fixes/                   # Fix specifications
    └── GAP-001-progress.yaml

results/llm-user/
└── 2026-01-28T10-30-00/
    ├── recordings/          # Session recordings
    ├── screenshots/         # Visual evidence
    ├── gap-analysis.md      # Human-readable
    └── gap-analysis.json    # Machine-readable
```

---

## Best Practices

**DO:**
- Run `init` after L1 planning completes
- Test early and often during L2
- Fix critical gaps before release
- Re-test after fixes to confirm

**DON'T:**
- Skip `init` (tests need setup first)
- Ignore critical gaps (they block release)
- Manually edit generated files (use `refresh`)
- Test without L1 docs (garbage in, garbage out)

---

## Troubleshooting

**"Test spec not found"**
→ Run `/llm-user init` first

**"Required docs not found"**
→ Complete L1 planning first (`/intent`, `/ux`, `/architect`)

**"All tests pass but users complain"**
→ Check personas have realistic frustration thresholds
→ Run `/llm-user refresh` to regenerate

**"Fix verification keeps failing"**
→ Review fix specification
→ May need different implementation approach

---

## Related

- `/review` - Code review (different from UX testing)
- `/verify` - Run verification checks
- `/debug` - Debug specific issues
