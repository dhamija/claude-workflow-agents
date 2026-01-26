---
name: release
description: Release a new version using scripts/release.sh
argument-hint: "[major|minor|patch]"
---

# /release Command

Release a new version of claude-workflow-agents.

**For maintainers only** - requires write access to repository.

---

## Usage

```
/release              # Interactive: asks for bump type
/release patch        # Bug fix: 1.0.0 → 1.0.1
/release minor        # New feature: 1.0.0 → 1.1.0
/release major        # Breaking change: 1.0.0 → 2.0.0
```

---

## Process

When user runs `/release [TYPE]`:

### Step 1: Check Current Version

```bash
cat version.txt
```

Show current version to user.

### Step 2: Determine Bump Type

If `$ARGUMENTS` is empty:
- Ask user: "What type of release? (major/minor/patch)"
- Explain:
  - **major**: Breaking changes (1.0.0 → 2.0.0)
  - **minor**: New features (1.0.0 → 1.1.0)
  - **patch**: Bug fixes (1.0.0 → 1.0.1)

If `$ARGUMENTS` provided, use it.

### Step 3: Run Release Script

```bash
./scripts/release.sh [TYPE]
```

The script will:
- Bump version in version.txt
- Create new CHANGELOG section
- Prompt for confirmation

### Step 4: Edit CHANGELOG

Open CHANGELOG.md and show the new section that was added.

Tell user:
```
I've created a new section in CHANGELOG.md with placeholders.
Let me update it with the actual changes from recent commits.
```

Then:
1. Run `git log` to see recent commits since last release
2. Categorize commits by type (feat/fix/docs/refactor/etc.)
3. Update CHANGELOG.md with actual changes:
   - Remove placeholder "- " lines
   - Add real changes under ### Added, ### Changed, ### Fixed

### Step 5: Run Release-Finish Script

After CHANGELOG is updated, ask user:
```
CHANGELOG.md is ready. Finish the release? [y/n]
```

If yes:
```bash
./scripts/release-finish.sh
```

This will:
- Commit the version bump
- Create git tag
- Push to origin
- GitHub Actions creates the release automatically

### Step 6: Confirm

Show user:
```
✓ Released v[VERSION]

GitHub Actions will create the release at:
https://github.com/dhamija/claude-workflow-agents/releases

Users can update with: workflow-update
```

---

## Example Flow

```
You: /release minor

Claude: Current version: v1.0.0
        Bumping to: v1.1.0

        [Runs ./scripts/release.sh minor]

        ✓ Updated version.txt and CHANGELOG.md

        Let me update CHANGELOG.md with recent changes...

        [Analyzes git log]
        [Updates CHANGELOG.md with actual changes]

        Updated CHANGELOG.md:

        ## [1.1.0] - 2026-01-25

        ### Added
        - Automated release system with GitHub Actions
        - Git workflow conventions (conventional commits)
        - workflow-version command

        ### Changed
        - Improved update system documentation

        Finish the release? [y/n]

You: y

Claude: [Runs ./scripts/release-finish.sh]

        Committing version bump...
        Creating tag v1.1.0...
        Push to origin? [Y/n]

        [Pushes]

        ✓ Released v1.1.0

        GitHub Actions will create the release automatically.
        Users can update with: workflow-update
```

---

## Safety Checks

Before running, verify:
1. Working tree is clean (no uncommitted changes)
2. On master branch
3. Up to date with origin
4. User has confirmed the bump type

If any check fails, explain the issue and stop.

---

## Notes

- This command is for **maintainers only**
- Requires write access to the repository
- Uses existing scripts in `scripts/release.sh` and `scripts/release-finish.sh`
- GitHub Actions handles the actual release creation
- Users get updates via `workflow-update`
