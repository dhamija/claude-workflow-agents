---
description: Audit implementation against product intent
argument-hint: <optional focus area or specific change>
---

## Step 1: Find intent baseline

Check if these FILES exist (not directories):
- /docs/intent/product-intent.md
- /INTENT.md
- /docs/product-intent.md

Use Glob to check: `**/product-intent.md` or `**/INTENT.md`

### IF a product-intent file FOUND:
Read that file. Use it as baseline.

### IF NOT FOUND:
Tell user: "No intent doc found. Inferring from codebase..."

Explore the codebase properly:
1. Use Glob to find key files: `README.md`, `package.json`, `pyproject.toml`
2. Read those specific files (not directories)
3. Use Glob to list source files: `src/**/*.ts`, `api/**/*.py`, etc.
4. Read a sample of key files to understand the app

Then use intent-guardian subagent to:
1. Infer product intent from what you found
2. Create /docs/intent/product-intent.md (marked as `status: inferred`)

## Step 2: Audit

Use intent-guardian subagent to audit implementation against the baseline.

Explore code by:
- Using Glob to list files in directories
- Reading specific files (never read a directory path directly)

Focus: $ARGUMENTS

## Step 3: Output

Save findings to /docs/intent/intent-audit.md
