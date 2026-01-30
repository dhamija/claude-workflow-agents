# Unified Gap System - Implementation Summary

> **Status:** Implemented
> **Date:** 2026-01-30
> **Version:** 1.0

## Overview

We've unified three parallel gap discovery/resolution systems into a single, cohesive workflow that handles gaps from any source using consistent commands.

## Problem Solved

Previously, we had three separate systems doing essentially the same thing:

1. **`/reality-audit` + `/recover`** - For broken promises discovered by real tests
2. **`/gap` + `/improve`** - For gaps found by document analysis
3. **`/llm-user test` + `/llm-user fix`** - For UX issues found by simulated users

This created confusion about which command to use when, duplicate work, and inconsistent workflows.

## Solution: Layered Architecture

```
Discovery Layer (Specialized):
  /reality-audit    → Creates GAP-R-XXX gaps
  /llm-user test    → Creates GAP-U-XXX gaps
  /gap              → Creates GAP-A-XXX gaps
        ↓
Gap Repository (Unified):
  docs/gaps/        → All gaps in consistent format
        ↓
Resolution Layer (Unified):
  /improve          → Fixes any gap type
        ↓
Verification Layer (Smart):
  /verify           → Uses appropriate method per gap
```

## Key Changes

### 1. Unified Gap Format

All gaps now follow a consistent structure regardless of discovery source:

```yaml
gap_id: GAP-[SOURCE]-[NUMBER]  # R=reality, U=user, A=analysis
title: "Clear description"
category: functionality|ux|architecture|performance|security
severity: CRITICAL|HIGH|MEDIUM|LOW

discovery:
  source: reality-audit|llm-user|gap-analysis
  discovered_at: timestamp

problem:
  description: What's wrong
  evidence: Proof points
  root_cause: Why it happened

resolution:
  approach: How to fix
  tasks: Step-by-step

verification:
  method: reality|llm-user|manual|automated
  [method-specific verification details]

status:
  state: open|in_progress|fixed|verified|closed
```

### 2. Updated Commands

#### Discovery Commands (Write to Unified System)

**`/reality-audit`** (Updated)
- Now creates GAP-R-XXX entries in unified format
- Writes to `docs/gaps/gaps/`
- Includes verification methods for each gap

**`/llm-user test`** (To be updated)
- Will create GAP-U-XXX entries for UX issues
- Same unified format as reality gaps

**`/gap`** (To be updated)
- Will create GAP-A-XXX entries for analysis gaps
- Consistent with other discovery methods

#### Resolution Commands (Read from Unified System)

**`/improve`** (Updated)
- Now handles ALL gap types (R, U, A, I, T)
- Filters by: specific ID, severity, source, or phase
- Selects appropriate agent based on gap category
- Examples:
  ```
  /improve GAP-R-001           # Fix specific gap
  /improve --severity=critical  # Fix all critical gaps
  /improve --source=reality     # Fix gaps from reality audit
  /improve phase 1              # Fix gaps in Phase 1
  ```

**`/verify`** (New - Replaces scattered verification)
- Smart verification based on gap source
- Reality gaps → Run real tests
- User gaps → Re-run LLM user scenarios
- Analysis gaps → Check implementation
- Examples:
  ```
  /verify GAP-R-001        # Verify specific gap
  /verify --all            # Verify all fixed gaps
  /verify --source=reality # Verify reality gaps
  /verify --final          # Pre-release verification
  ```

**`/recover`** (Updated)
- Now uses unified gap system
- Runs `/reality-audit` to create gaps
- Uses `/improve` to fix them
- Uses `/verify` to confirm fixes
- Provides guided 5-phase recovery using unified commands

## Benefits Achieved

1. **Single Mental Model**: A gap is a gap, regardless of discovery method
2. **No Duplicate Work**: Different discovery methods might find same issue - now tracked as one gap
3. **Unified Prioritization**: All gaps ranked together by severity/impact
4. **Consistent Workflow**: Same fix → verify process for all gaps
5. **Smart Verification**: System knows how to verify each gap type
6. **Complete Picture**: All project issues visible in one place
7. **Better Tracking**: Single source of truth at `docs/gaps/`

## File Structure

```
docs/gaps/
├── gap-registry.yaml          # Master list of all gaps
├── gap-analysis.md           # Human-readable report
├── migration-plan.md         # Phased fix plan
│
├── gaps/                      # Individual gap files
│   ├── GAP-R-001.yaml        # Reality gap
│   ├── GAP-U-001.yaml        # User testing gap
│   └── GAP-A-001.yaml        # Analysis gap
│
└── artifacts/                 # Supporting evidence
    ├── reality-audit-*.json
    └── llm-user-results-*.json
```

## Usage Examples

### Discovering Gaps

```bash
# Run reality audit (creates GAP-R-XXX gaps)
/reality-audit

# Run LLM user tests (creates GAP-U-XXX gaps)
/llm-user test

# Run gap analysis (creates GAP-A-XXX gaps)
/gap
```

### Viewing Gaps

```bash
# See all gaps
cat docs/gaps/gap-registry.yaml

# See critical gaps only
grep -l "severity: CRITICAL" docs/gaps/gaps/*.yaml

# See gaps from specific source
grep -l "source: reality-audit" docs/gaps/gaps/*.yaml
```

### Fixing Gaps

```bash
# Fix most critical first
/improve --severity=critical

# Fix specific gap
/improve GAP-R-001

# Fix all gaps from reality audit
/improve --source=reality

# Fix Phase 1 gaps from migration plan
/improve phase 1
```

### Verifying Fixes

```bash
# Verify specific gap (smart method selection)
/verify GAP-R-001

# Verify all fixed gaps
/verify --all

# Pre-release verification
/verify --final
```

### Recovery Workflow

```bash
# Start full recovery (uses unified system)
/recover

# This will:
# 1. Run /reality-audit → Creates GAP-R-XXX gaps
# 2. Show gap summary from registry
# 3. Use /improve to fix critical gaps
# 4. Use /verify to confirm fixes
# 5. Track progress in unified system
```

## Migration Notes

### For Existing Projects

Projects using old commands will continue to work, but should migrate to unified system:

1. Run `/reality-audit` to populate unified gaps
2. Use `/improve` instead of `/recover phase 4`
3. Use `/verify` instead of manual verification
4. Gaps are now at `docs/gaps/` instead of scattered locations

### Deprecated Patterns

These patterns are deprecated but still functional:

- `/recover fix` → Use `/improve`
- `/llm-user fix` → Use `/improve`
- Manual verification → Use `/verify`
- Separate gap reports → Use unified `gap-registry.yaml`

## Next Steps

1. Update `/llm-user test` to write GAP-U-XXX gaps
2. Update `/gap` to write GAP-A-XXX gaps
3. Update help documentation
4. Test full workflow end-to-end
5. Consider deprecating redundant commands in v2.0

## Summary

The Unified Gap System transforms three parallel workflows into one coherent system. Gaps are discovered by specialized tools, stored in a unified format, fixed with a single command, and verified intelligently. This reduces cognitive load, prevents duplicate work, and provides a clear path from discovery to resolution for any type of gap.