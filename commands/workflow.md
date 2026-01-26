---
description: Enable, disable, or check workflow status
argument-hint: <on | off | status>
---

Control the workflow system.

## Usage

### `/workflow status`

Shows current status:
```
Workflow Status
───────────────
Status:   enabled
Location: .workflow/
Agents:   12 available
Commands: 22 available

Toggle: /workflow off
```

Or if disabled:
```
Workflow Status
───────────────
Status:   disabled
Location: .workflow/

Claude is in standard mode.
Toggle: /workflow on
```

### `/workflow on`

Enables the workflow system:

- Changes `<!-- workflow: disabled -->` to `<!-- workflow: enabled -->`
- Agents and commands become active
- Project operations resume

Output:
```
Workflow enabled ✓

Agents and commands are now active.
```

### `/workflow off`

Disables the workflow system:

- Changes `<!-- workflow: enabled -->` to `<!-- workflow: disabled -->`
- Agents and commands ignored
- Claude operates as standard Claude Code

Output:
```
Workflow disabled

Claude is now in standard mode.
Your CLAUDE.md content is unchanged.
```

## How It Works

The toggle is a single line at the top of CLAUDE.md:
```markdown
<!-- workflow: enabled -->
```

When Claude sees this file:

- If **enabled** → Use agents, commands, workflow
- If **disabled** → Ignore .workflow/, operate normally
- `/workflow` command always works (to re-enable)

## Implementation

To toggle, just change that line in CLAUDE.md:
```bash
# Enable
sed -i 's/<!-- workflow: disabled -->/<!-- workflow: enabled -->/' CLAUDE.md

# Disable
sed -i 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
```

Or edit manually - it's just one line.
