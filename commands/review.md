---
description: Review code for quality, security, and intent compliance
argument-hint: <file path, directory, or "staged" for git staged files>
---

Use code-reviewer subagent to review:

## Target

$ARGUMENTS

If "staged" or empty: Review git staged files (`git diff --cached`)
If file path: Review that specific file
If directory: Review all code files in that directory

## Process

1. Read /docs/intent/product-intent.md for promises to protect
2. Read CLAUDE.md for project conventions
3. Review the code using full checklist:
   - Security (critical)
   - Bugs (high)
   - Performance (medium)
   - Maintainability (suggestions)
   - Intent compliance

## Output

Produce review report with:
- Summary (status, issue counts)
- Critical issues (must fix)
- High issues (should fix)
- Medium issues (consider)
- Suggestions (optional)
- What's good (positive feedback)
- Intent compliance check

Save to /docs/reviews/review-[timestamp].md if significant issues found.

If BLOCKED: List critical issues that must be fixed.
If CHANGES REQUESTED: List high issues that should be fixed.
If APPROVED: Note any optional suggestions.
