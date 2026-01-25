---
name: parallel
description: Set up parallel development with git worktrees for a feature
subagent_type: general-purpose
---

# /parallel - Parallel Feature Development Setup

Sets up git worktrees for parallel feature development.

## Usage

```bash
/parallel <feature-name>
```

## What This Does

1. **Reads feature plan** from `/docs/plans/features/<feature-name>.md`
2. **Checks dependencies** - warns if blocked features not complete
3. **Creates git worktree** in `../<feature-name>/`
4. **Creates feature branch** `feature/<feature-name>`
5. **Copies scoped CLAUDE.md** with feature-specific instructions
6. **Opens worktree** ready for development

## Example

```bash
# After /plan creates feature plans
/parallel profile-management

# Creates:
# - ../profile-management/ (git worktree)
# - feature/profile-management (branch)
# - ../profile-management/CLAUDE.md (scoped)
```

## Implementation

```bash
#!/bin/bash

FEATURE_NAME="$1"
FEATURE_PLAN="./docs/plans/features/${FEATURE_NAME}.md"
WORKTREE_PATH="../${FEATURE_NAME}"
BRANCH_NAME="feature/${FEATURE_NAME}"

# Validate feature plan exists
if [ ! -f "$FEATURE_PLAN" ]; then
  echo "Error: Feature plan not found: $FEATURE_PLAN"
  echo "Run /plan first to create feature plans"
  exit 1
fi

# Check if worktree already exists
if [ -d "$WORKTREE_PATH" ]; then
  echo "Error: Worktree already exists: $WORKTREE_PATH"
  echo "Use: cd $WORKTREE_PATH"
  exit 1
fi

# Check dependencies
echo "Checking dependencies for $FEATURE_NAME..."
DEPENDS_ON=$(grep "**Depends on:**" "$FEATURE_PLAN" | sed 's/.*: //')
if [[ "$DEPENDS_ON" != "none"* ]]; then
  echo "Warning: This feature depends on: $DEPENDS_ON"
  echo "Ensure dependencies are complete before merging this feature."
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Create git worktree
echo "Creating worktree at $WORKTREE_PATH..."
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"

# Copy scoped CLAUDE.md
echo "Creating scoped CLAUDE.md for feature..."
if [ -f "./templates/CLAUDE-FEATURE.md.template" ]; then
  sed -e "s/\[FEATURE_NAME\]/$FEATURE_NAME/g" \
      "./templates/CLAUDE-FEATURE.md.template" > "$WORKTREE_PATH/CLAUDE.md"
else
  echo "Warning: CLAUDE-FEATURE.md.template not found, skipping"
fi

# Copy feature plan to worktree
cp "$FEATURE_PLAN" "$WORKTREE_PATH/FEATURE.md"

echo ""
echo "✅ Worktree ready for parallel development!"
echo ""
echo "Next steps:"
echo "  cd $WORKTREE_PATH"
echo "  # Start implementing (Claude will read FEATURE.md and scoped CLAUDE.md)"
echo ""
echo "When complete:"
echo "  git push origin $BRANCH_NAME"
echo "  # Create PR to merge into main"
echo "  cd ../<main-project>"
echo "  git worktree remove $WORKTREE_PATH"
```

## Feature Worktree Workflow

### Setup (one time per feature)
```bash
/parallel profile-management
cd ../profile-management
```

### Development (in worktree)
```bash
# Claude reads:
# - FEATURE.md (scope, files, acceptance criteria)
# - CLAUDE.md (scoped to this feature)

# Just talk to Claude:
"Implement this feature"
"The tests are failing, help me debug"
"Review the code before I push"
```

### Completion
```bash
git push origin feature/profile-management
# Create PR on GitHub
# After merge:
cd ../<main-project>
git worktree remove ../profile-management
git pull origin main
```

## Multiple Parallel Features

```bash
# Developer 1
/parallel profile-management
cd ../profile-management
# Works on profile feature

# Developer 2 (same time)
/parallel notification-system
cd ../notification-system
# Works on notifications feature

# Both work independently
# Both merge when ready
# No conflicts (different files)
```

## When NOT to Use

- **Sequential features** - Use main project for Batch 0 foundation
- **Small changes** - Just work on main branch
- **Dependent features** - Wait for dependencies to merge first

## When TO Use

- **Batch 1+ features** - Independent features from implementation-order.md
- **Multiple developers** - Each gets their own worktree
- **Long-running features** - Isolate work without blocking main
- **Experimental features** - Easy to abandon (just remove worktree)

## Scoped CLAUDE.md

The worktree gets a simplified CLAUDE.md:
- **Focused** on single feature
- **No** L1 analysis agents (already done)
- **No** planning agents (plan already exists)
- **Yes** to implementation agents (backend, frontend, test)
- **Yes** to quality agents (review, debug)

This prevents running wrong agents and keeps focus tight.
