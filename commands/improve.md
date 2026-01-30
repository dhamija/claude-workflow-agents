---
description: Fix gaps from unified gap system - any source, any type
argument-hint: <gap-id | --severity=X | --source=Y | phase N>
---

## Unified Gap Resolution System

This command fixes gaps discovered by ANY method:
- Reality audit gaps (GAP-R-XXX)
- LLM user test gaps (GAP-U-XXX)
- Analysis gaps (GAP-A-XXX)
- Intent gaps (GAP-I-XXX)
- Technical gaps (GAP-T-XXX)

## Parse Arguments

Target: $ARGUMENTS

### Specific Gap ID (e.g., "GAP-R-001", "GAP-U-012"):
```bash
# Load specific gap from unified system
cat docs/gaps/gaps/GAP-R-001.yaml
```

### Filter by Severity (--severity=critical):
```bash
# Find all gaps matching severity
grep -l "severity: CRITICAL" docs/gaps/gaps/*.yaml
```

### Filter by Source (--source=reality):
```bash
# Find gaps from specific discovery source
grep -l "source: reality-audit" docs/gaps/gaps/*.yaml
```

### Phase-based (phase N):
```bash
# Read migration plan if it exists
cat docs/gaps/migration-plan.md | grep "Phase $N" -A 20
```

### Default (no arguments):
```bash
# Show gap summary and ask what to fix
cat docs/gaps/gap-registry.yaml
echo "What would you like to fix?"
echo "  1. All CRITICAL gaps (3 gaps)"
echo "  2. All HIGH priority (5 gaps)"
echo "  3. Specific gap by ID"
echo "  4. Phase-based from migration plan"
```

## Execution

For each gap to fix:

### 1. Load Gap from Unified System

```bash
# Read gap details
GAP_FILE="docs/gaps/gaps/${GAP_ID}.yaml"
if [ ! -f "$GAP_FILE" ]; then
  echo "Gap $GAP_ID not found"
  exit 1
fi
```

### 2. Analyze Gap Type and Select Agent

Based on gap category and source:

| Category | Source | Primary Agent | Support Agents |
|----------|--------|---------------|----------------|
| functionality | reality-audit | backend/frontend-engineer | test-engineer |
| ux | llm-user | frontend-engineer | ui-debugger |
| architecture | gap-analysis | backend-engineer | agentic-architect |
| performance | any | backend-engineer | - |
| security | any | backend-engineer | code-reviewer |

### 3. Execute Fix Based on Source

#### For Reality Gaps (GAP-R-XXX):
```bash
# These are broken promises/features
echo "Fixing reality gap: $GAP_ID"
echo "This feature claims to work but doesn't"

# 1. Run the failing test to see actual error
npm test -- ${gap.verification.reality_tests[0]}

# 2. Fix the implementation (not the test!)
# Use appropriate engineer agent

# 3. Verify test now passes FOR REAL
npm test -- ${gap.verification.reality_tests[0]}
```

#### For User Gaps (GAP-U-XXX):
```bash
# These are UX issues found by LLM users
echo "Fixing UX gap: $GAP_ID"
echo "LLM user ${gap.problem.affected.personas[0]} had this issue"

# 1. Review the user behavior that led to gap
cat tests/llm-user/results/latest/recordings/${scenario}.json

# 2. Implement UX fix
# Usually frontend-engineer

# 3. Will be verified by re-running LLM user test
```

#### For Analysis Gaps (GAP-A-XXX):
```bash
# These are missing capabilities
echo "Fixing analysis gap: $GAP_ID"
echo "Current state doesn't match intended design"

# 1. Review what should exist
echo ${gap.expected.description}

# 2. Implement missing capability
# Use appropriate engineer

# 3. Manual or automated verification
```

### 4. Update Gap Status

```yaml
# Update docs/gaps/gaps/GAP-XXX.yaml
status:
  state: in_progress  # was: open
  assignee: "improve-command"
  started_at: "2024-01-30T11:00:00Z"
```

### 5. Implement Fix

Use the resolution approach from gap:

```bash
echo "Resolution approach:"
echo "${gap.resolution.approach}"

echo "Tasks to complete:"
for task in ${gap.resolution.tasks}; do
  echo "  - $task"
done
```

### 6. Commit with Proper Message

```bash
# Commit format includes gap ID
git commit -m "fix(${gap.category}): [${GAP_ID}] ${gap.title}

- ${summary_of_changes}
- Fixes ${gap.problem.affected.promises}

Verification: ${gap.verification.method}"
```

## After Each Gap

Verify the fix:
- Does it address the gap?
- Did it break anything else? (run tests)
- Is the promise/journey now working?

## After Phase Complete

Use test-engineer to verify:
1. All tests pass
2. No regressions
3. Gaps in this phase are resolved

Save to /docs/verification/improvement-phase-N-report.md

### If FAIL:
````
⛔ Phase N improvements FAILED

Issues:
- [list]

Fix before proceeding.
````

### If PASS:
````
✅ Phase N improvements complete

Fixed:
- [list gaps fixed]

Remaining:
- Phase N+1: X gaps
- Phase N+2: Y gaps
- Backlog: Z gaps

Run `/improve phase N+1` to continue.
````
