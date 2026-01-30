---
description: Analyze gaps between current state and ideal - writes to unified gap system
argument-hint: <optional focus area>
---

## Prerequisites

Check audits exist:
- /docs/intent/intent-audit.md (or product-intent.md)
- /docs/ux/ux-audit.md (or user-journeys.md)
- /docs/architecture/agentic-audit.md (or system-design.md)

If missing: "Run /audit first"

## Gap Analysis (Unified System)

Use gap-analyzer agent to discover gaps and write to unified format:

### 1. Read Audit Outputs
```bash
# Read existing audits
cat docs/intent/intent-audit.md
cat docs/ux/ux-audit.md
cat docs/architecture/agentic-audit.md
```

### 2. Create Gaps in Unified Format

For each gap discovered, create entry:

```yaml
# docs/gaps/gaps/GAP-A-001.yaml
gap_id: GAP-A-001
title: "No Auto-Save Implementation"
category: functionality
severity: HIGH
priority: 2

discovery:
  source: gap-analysis
  discovered_at: "2024-01-30T10:00:00Z"
  discovered_by: "/gap command"

problem:
  description: |
    Intent document promises auto-save every 30s, but no
    auto-save functionality exists in codebase.

  evidence:
    - type: missing_capability
      detail: "No auto-save service or timer found"
    - type: document_mismatch
      detail: "Intent promises feature that doesn't exist"

  affected:
    promises: [auto-save]
    features: [data-persistence]

  root_cause: |
    Feature specified in intent but never implemented.

expected:
  description: |
    Auto-save should trigger every 30 seconds to prevent
    data loss and match user expectations.

  acceptance_criteria:
    - "Auto-save triggers every 30s"
    - "User sees save indicator"
    - "Data persists across sessions"

  references:
    - "docs/intent/product-intent.md#auto-save"

resolution:
  approach: |
    Implement auto-save timer in frontend.
    Add save indicator UI component.
    Ensure backend handles frequent saves efficiently.

  effort: medium
  risk: low

  tasks:
    - "Create auto-save service"
    - "Add save indicator UI"
    - "Optimize backend for frequent saves"
    - "Add tests for auto-save"

verification:
  method: manual

  manual_steps:
    - "Make changes in app"
    - "Wait 30 seconds"
    - "Check that save indicator appears"
    - "Refresh page"
    - "Verify changes persisted"

  success_criteria:
    - "Changes auto-save within 30s"
    - "Save indicator visible to user"
    - "No data loss on refresh"

status:
  state: open
  notes: "Discovered during gap analysis"
```

### 3. Update Gap Registry

```yaml
# docs/gaps/gap-registry.yaml
registry:
  gaps:
    - id: GAP-A-001
      title: "No Auto-Save Implementation"
      severity: HIGH
      state: open
      file: gaps/GAP-A-001.yaml

    - id: GAP-A-002
      title: "Missing Error Recovery Flow"
      severity: MEDIUM
      state: open
      file: gaps/GAP-A-002.yaml
```

### 4. Generate Reports

Create both unified and legacy reports:

```markdown
# docs/gaps/gap-analysis.md

## Summary (Unified Gap System)
- Created 8 GAP-A-XXX entries
- Critical: 2, High: 3, Medium: 3
- All gaps written to: docs/gaps/gaps/

## Gap Categories
- Intent gaps: GAP-A-001 to GAP-A-003
- UX gaps: GAP-A-004 to GAP-A-006
- Architecture gaps: GAP-A-007 to GAP-A-008

## Next Steps
- Fix with: `/improve --source=gap-analysis`
- Or by severity: `/improve --severity=critical`
- Verify with: `/verify --source=gap-analysis`
```

Focus: $ARGUMENTS

## Output

- `/docs/gaps/gaps/GAP-A-*.yaml` - Individual gaps in unified format
- `/docs/gaps/gap-registry.yaml` - Updated registry
- `/docs/gaps/gap-analysis.md` - Human-readable report
- `/docs/gaps/migration-plan.md` - Phased improvement plan

Next: Run `/improve --severity=critical` to fix blocking issues.
