---
name: validation
description: |
  Promise validation and acceptance testing. Use after feature completion
  to verify that user promises are ACTUALLY KEPT, not just tests passing.
---

# Validation Skill (Promise Acceptance)

## Purpose

Tests verify code works. Validation verifies **promises to users are kept**.

## Validation Process

### 1. Load Intent Document

```bash
cat docs/intent/product-intent.md
```

Extract promises with their acceptance criteria.

### 2. For Each Promise

```markdown
## Promise Validation: PRM-001

**Statement:** "Auto-save every 30 seconds"
**Criticality:** CORE
**Feature:** auto_save_service

### Validation Steps

1. ✓ Feature implemented (`src/services/auto-save.ts`)
2. ✓ Tests passing (15/15)
3. **Manual Check:**
   - Open app, make changes
   - Wait 30 seconds
   - Check network tab: POST /api/save every 30s
   - Refresh page: changes persisted
4. **Result:** ✅ VALIDATED

### Evidence
- Test: `auto-save.test.ts` line 45
- Code: `useAutoSave` hook with 30s interval
- Screenshot: Network tab showing 30s interval
```

### 3. Validation States

- **VALIDATED**: Promise fully kept
- **PARTIAL**: Mostly works, minor issues
- **FAILED**: Promise not kept
- **BLOCKED**: Depends on incomplete work

### 4. Remediation

If PARTIAL or FAILED:
1. Document what's missing
2. Create specific tasks
3. Implement fixes
4. Re-validate

## Validation Checklist

For each CORE promise:
- [ ] Feature implemented
- [ ] Tests passing
- [ ] Manual verification completed
- [ ] Edge cases handled
- [ ] Performance acceptable
- [ ] User experience matches intent

For each IMPORTANT promise:
- [ ] Feature implemented
- [ ] Tests passing
- [ ] Manual verification completed

For NICE_TO_HAVE:
- [ ] If implemented: validated
- [ ] If not: documented as future work
