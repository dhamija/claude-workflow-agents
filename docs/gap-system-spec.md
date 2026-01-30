# Unified Gap System Specification

> **Version:** 1.0
> **Status:** Active
> **Last Updated:** 2026-01-30

## Overview

The Unified Gap System provides a single, consistent way to discover, track, fix, and verify gaps between the current state and desired state of a project, regardless of how those gaps are discovered.

## Gap ID Format

All gaps follow a consistent ID format:

```
GAP-[SOURCE]-[NUMBER]
```

Where SOURCE is:
- `R` - Reality audit (broken functionality)
- `U` - User testing (UX issues)
- `A` - Analysis (document comparison)
- `I` - Intent (promise violations)
- `T` - Technical (architecture/debt)

Examples:
- `GAP-R-001` - Reality gap #1 (broken feature)
- `GAP-U-012` - UX gap #12 (user frustration)
- `GAP-A-003` - Analysis gap #3 (missing capability)

## Unified Gap Format

Every gap, regardless of discovery method, is stored in this format:

```yaml
gap_id: GAP-R-001
title: "Progress Tracking Completely Broken"
category: functionality  # functionality | ux | performance | security | architecture
severity: CRITICAL      # CRITICAL | HIGH | MEDIUM | LOW
priority: 1             # Numeric priority for ordering

# Discovery metadata
discovery:
  source: reality-audit  # reality-audit | llm-user | gap-analysis | manual
  discovered_at: "2024-01-30T10:00:00Z"
  discovered_by: "/reality-audit command"

# What's wrong
problem:
  description: |
    Promise P3 claims users can track progress, but no progress
    tracking exists in the codebase. Tests for this feature are
    mocked and always return success.

  evidence:
    - type: test_failure
      detail: "npm test -- progress returns mocked success"
    - type: missing_code
      detail: "No progress service or API endpoints exist"
    - type: user_impact
      detail: "Jake abandoned at scene 3 due to no progress visibility"

  affected:
    promises: [P3]
    personas: [jake-teen, maria-beginner]
    features: [progress-tracking, gamification]

  root_cause: |
    Feature was marked complete without implementation.
    Tests were written to pass without real functionality.

# What should exist
expected:
  description: |
    Users should see their learning progress including scenes
    completed, vocabulary learned, and skill improvements.

  acceptance_criteria:
    - "Progress dashboard shows completion stats"
    - "Progress updates after each activity"
    - "Users feel sense of advancement"

  references:
    - "docs/intent/product-intent.md#P3"
    - "docs/ux/user-journeys.md#progress"

# How to fix
resolution:
  approach: |
    Create progress service, API endpoints, and dashboard UI.
    Track user activity and calculate progress metrics.

  effort: medium  # small | medium | large | xlarge
  risk: low       # low | medium | high

  dependencies:
    - "User authentication must be working"
    - "Activity completion events must fire"

  tasks:
    - "Create progress tracking service"
    - "Add API endpoints for progress data"
    - "Build progress dashboard component"
    - "Integrate into activity flow"
    - "Write real tests"

# How to verify
verification:
  method: reality  # reality | llm-user | manual | automated

  reality_tests:
    - "npm test -- tests/integration/progress.test.js"
    - "npm test -- tests/e2e/user-progress.spec.js"

  llm_user_scenarios:
    - scenario: multi-scene-session
      personas: [jake-teen]

  manual_steps:
    - "Complete 3 scenes"
    - "Check progress dashboard shows 3/X scenes"
    - "Verify vocabulary count increased"

  success_criteria:
    - "All progress tests pass without mocks"
    - "Jake completes 5+ scenes without abandoning"
    - "Progress metrics accurately reflect activity"

# Current status
status:
  state: open  # open | in_progress | fixed | verified | closed | wont_fix

  assignee: null
  started_at: null
  fixed_at: null
  verified_at: null
  closed_at: null

  notes: |
    Discovered during reality audit. This is blocking
    release as it violates a core promise to users.
```

## Gap Lifecycle

```
DISCOVERED → TRIAGED → IN_PROGRESS → FIXED → VERIFIED → CLOSED
     ↓           ↓          ↓           ↓         ↓
  [WONT_FIX] [BLOCKED]  [FAILED]   [FAILED]  [REOPENED]
```

## Unified Gap Repository Structure

```
docs/gaps/
├── gap-registry.yaml           # Master list of all gaps
├── gap-analysis.md            # Human-readable gap report
├── migration-plan.md          # Phased fix plan
│
├── discovered/                 # Gaps by discovery source
│   ├── reality-audit.yaml     # Gaps from reality audit
│   ├── llm-user-test.yaml     # Gaps from LLM user testing
│   └── gap-analysis.yaml      # Gaps from document analysis
│
├── gaps/                       # Individual gap details
│   ├── GAP-R-001.yaml
│   ├── GAP-U-001.yaml
│   └── GAP-A-001.yaml
│
└── artifacts/                  # Supporting evidence
    ├── reality-audit-2024-01-30.json
    ├── llm-user-results-latest.json
    └── test-failures.log
```

## Gap Registry Format

The master registry (`gap-registry.yaml`) tracks all gaps:

```yaml
registry:
  version: "1.0"
  last_updated: "2024-01-30T10:00:00Z"

  summary:
    total: 15
    by_state:
      open: 8
      in_progress: 2
      fixed: 3
      verified: 2
      closed: 0

    by_severity:
      critical: 3
      high: 5
      medium: 6
      low: 1

    by_source:
      reality_audit: 5
      llm_user: 7
      gap_analysis: 3

  gaps:
    - id: GAP-R-001
      title: "Progress Tracking Completely Broken"
      severity: CRITICAL
      state: open
      file: gaps/GAP-R-001.yaml

    - id: GAP-U-001
      title: "User Abandonment at Scene 3"
      severity: HIGH
      state: in_progress
      file: gaps/GAP-U-001.yaml
```

## Discovery Source Integration

Each discovery method writes gaps in the unified format:

### Reality Audit → Gap

```javascript
// When reality audit finds broken promise
const gap = {
  gap_id: generateGapId('R'),
  title: "Promise P3 Completely Broken",
  category: "functionality",
  severity: "CRITICAL",
  discovery: {
    source: "reality-audit",
    discovered_by: "/reality-audit command"
  },
  problem: {
    description: "Test passes but feature doesn't exist",
    evidence: [
      { type: "test_failure", detail: "Mocked test" }
    ]
  },
  verification: {
    method: "reality",
    reality_tests: ["npm test -- integration/promise-P3.test.js"]
  }
};

writeGap(gap);
```

### LLM User Test → Gap

```javascript
// When LLM user test finds UX issue
const gap = {
  gap_id: generateGapId('U'),
  title: "User Abandonment Due to No Progress",
  category: "ux",
  severity: "HIGH",
  discovery: {
    source: "llm-user",
    discovered_by: "/llm-user test"
  },
  problem: {
    description: "Jake abandoned at scene 3",
    evidence: [
      { type: "user_behavior", detail: "Frustration: 0.85" }
    ],
    affected: {
      personas: ["jake-teen"]
    }
  },
  verification: {
    method: "llm-user",
    llm_user_scenarios: [
      { scenario: "multi-scene-session", personas: ["jake-teen"] }
    ]
  }
};

writeGap(gap);
```

### Gap Analysis → Gap

```javascript
// When gap analysis finds missing capability
const gap = {
  gap_id: generateGapId('A'),
  title: "No Error Recovery Path",
  category: "architecture",
  severity: "MEDIUM",
  discovery: {
    source: "gap-analysis",
    discovered_by: "/gap command"
  },
  problem: {
    description: "Current: Generic error page. Expected: Recovery flow",
    evidence: [
      { type: "missing_capability", detail: "No error recovery service" }
    ]
  },
  verification: {
    method: "manual",
    manual_steps: ["Trigger error", "Verify recovery options appear"]
  }
};

writeGap(gap);
```

## Command Updates

### Discovery Commands

All discovery commands write to unified format:

```bash
/reality-audit    # Writes GAP-R-XXX gaps
/llm-user test    # Writes GAP-U-XXX gaps
/gap              # Writes GAP-A-XXX gaps
/audit            # May create GAP-I-XXX (intent) or GAP-T-XXX (technical)
```

### Resolution Commands

Single command handles all gap types:

```bash
/improve                      # Shows all gaps from registry
/improve GAP-R-001            # Fix specific gap
/improve --severity=critical  # Fix by severity
/improve --source=reality     # Fix gaps from specific source
/improve phase 1              # Fix by migration plan phase
```

### Verification Commands

Smart verification based on gap type:

```bash
/verify GAP-R-001   # Runs reality tests (npm test)
/verify GAP-U-001   # Runs LLM user scenarios
/verify GAP-A-001   # Runs manual verification steps
/verify --all       # Verifies all fixed gaps
```

## Benefits of Unified System

1. **Single Mental Model**: A gap is a gap, regardless of how discovered
2. **No Duplicate Work**: Reality audit and LLM user test might find same gap
3. **Unified Prioritization**: All gaps ranked together by impact
4. **Consistent Workflow**: Same fix process for all gap types
5. **Smart Verification**: System knows how to verify each gap type
6. **Complete Picture**: See all project issues in one place
7. **Better Tracking**: Single source of truth for project health

## Migration Path

### Phase 1: Add Unified Format (No Breaking Changes)
- Create gap registry structure
- Update commands to ALSO write unified format
- Keep existing command outputs

### Phase 2: Update Commands
- `/improve` reads from gap registry
- `/verify` becomes gap-aware
- Add gap aggregation to `/gap`

### Phase 3: Deprecate Redundancy
- Mark `/recover` as deprecated (use `/improve`)
- Mark `/llm-user fix` as deprecated (use `/improve`)
- Remove duplicate functionality

### Phase 4: Full Unification
- All gaps in unified format
- Single resolution workflow
- Smart verification throughout

## Implementation Priority

1. Create gap registry structure (30 min)
2. Update `/reality-audit` to write gaps (1 hr)
3. Update `/llm-user test` to write gaps (1 hr)
4. Enhance `/improve` to read all gaps (2 hr)
5. Create smart `/verify` (1 hr)
6. Update documentation (30 min)
7. Test full workflow (1 hr)

Total: ~7 hours to unified gap system