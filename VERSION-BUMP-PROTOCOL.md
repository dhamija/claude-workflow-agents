# Version Bump Protocol

## 🚨 CRITICAL RULE: Version MUST Be Bumped When Templates Change

**Any change that requires users to run `workflow-patch` MUST trigger a version bump.**

## Version Bump Decision Tree

```
Did you change templates/project/*.template files?
├─ YES → BUMP VERSION (users need workflow-patch)
│   ├─ Added new workflow sections? → MINOR bump (3.4 → 3.5)
│   ├─ Changed orchestration logic? → MINOR bump
│   ├─ Added new skills to workflow? → MINOR bump
│   ├─ Fixed critical bugs in workflow? → PATCH bump (3.4.0 → 3.4.1)
│   └─ Breaking changes? → MAJOR bump (3.x → 4.0)
│
└─ NO → Check other criteria
    ├─ New agent added? → Check if used in templates
    │   ├─ YES (workflow invokes it) → MINOR bump
    │   └─ NO (standalone agent) → NO bump needed
    │
    ├─ New command added? → Check if in template workflow
    │   ├─ YES (part of workflow) → MINOR bump
    │   └─ NO (utility command) → NO bump needed
    │
    ├─ Skill changes? → Check impact
    │   ├─ Changes workflow behavior → MINOR bump
    │   └─ Internal improvements → NO bump needed
    │
    └─ Documentation/tests only? → NO bump needed
```

## What Triggers Version Bumps

### ✅ MUST Bump Version

1. **Template Changes** (PRIMARY TRIGGER)
   - ANY modification to `templates/project/*.template`
   - New sections added to CLAUDE.md templates
   - Workflow orchestration logic changes
   - State tracking format changes
   - Quality gate modifications

2. **Workflow-Affecting Changes**
   - New agents that workflow orchestrator invokes
   - New commands that are part of standard workflow
   - Skills that change workflow behavior
   - Changes to planning/iteration flows

3. **Breaking Changes**
   - Removing commands users depend on
   - Changing command syntax
   - Incompatible state format changes

### ❌ NO Version Bump Needed

1. **Documentation Only**
   - README updates
   - GUIDE improvements
   - Example additions
   - Typo fixes

2. **Internal Improvements**
   - Test additions
   - Verification script improvements
   - Internal refactoring
   - Performance optimizations

3. **Standalone Features**
   - Utility commands not in workflow
   - Helper agents not invoked by workflow
   - Optional features

## Version Numbering

### MAJOR (X.0.0) - Breaking Changes
- Workflow fundamentally restructured
- Incompatible CLAUDE.md format
- Commands removed or renamed
- Requires manual migration

### MINOR (3.X.0) - Feature Additions
- New workflow capabilities
- New sections in CLAUDE.md
- New agents/commands in workflow
- Backward compatible additions

### PATCH (3.4.X) - Bug Fixes
- Critical workflow bug fixes
- Template typo corrections
- State tracking fixes
- Security patches

## Examples

### Example 1: Iteration Workflow (3.3 → 3.4)
```
Changes made:
✅ Modified templates/skills/workflow/SKILL.md - Added iteration flow
✅ Modified templates (implicitly via skill) - New workflow mode
✅ Added iteration-analyzer agent - Used by workflow
✅ Enhanced /workflow-plan - Core workflow command

Decision: MINOR bump (3.3.0 → 3.4.0)
Reason: Templates effectively changed, users need workflow-patch
```

### Example 2: Documentation Update
```
Changes made:
✅ Updated README.md - Better examples
✅ Fixed typos in GUIDE.md
✅ Added troubleshooting section

Decision: NO bump
Reason: No template changes, users don't need workflow-patch
```

### Example 3: Bug Fix in Workflow
```
Changes made:
✅ Fixed templates/project/CLAUDE.md.greenfield.template
   - Corrected state tracking bug
✅ No new features added

Decision: PATCH bump (3.4.0 → 3.4.1)
Reason: Template changed but only bug fix
```

## Automation Check

Add this to pre-commit or CI:

```bash
#!/bin/bash
# Check if templates changed
if git diff --cached --name-only | grep -q "templates/project/.*\.template"; then
  echo "⚠️ Template files changed!"
  echo "Did you bump the version? (Required for template changes)"

  # Check if version.txt was updated
  if ! git diff --cached --name-only | grep -q "version.txt"; then
    echo "❌ ERROR: Template changed but version.txt not updated!"
    echo "Users need workflow-patch for template changes."
    echo "Please bump version before committing."
    exit 1
  fi
fi
```

## User Impact

When version is bumped:

1. **Users see notification**
   ```
   workflow-update
   # "New version 3.4.0 available with template changes"
   ```

2. **workflow-patch detects mismatch**
   ```
   workflow-patch
   # "Your CLAUDE.md is v3.3, new templates are v3.4"
   # "Would you like to update? [Y/n]"
   ```

3. **Users get new features**
   - New workflow capabilities
   - Bug fixes
   - Improved orchestration

## Summary

**Golden Rule:** If users need to run `workflow-patch` to get your changes, you MUST bump the version.

This ensures:
- Users know when updates are available
- workflow-patch can detect version mismatches
- Changes are properly documented in CHANGELOG
- No silent failures from outdated templates