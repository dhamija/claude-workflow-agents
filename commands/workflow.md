---
description: Enable, disable, or check workflow status
argument-hint: <on | off | status>
---

Toggle the workflow system in current project.

## `/workflow status`

Shows current status:
```
Workflow Status
───────────────
Project:  my-app
Status:   enabled
Home:     ~/.claude-workflow-agents/

Agents:   12 available
Commands: 23 available

Toggle:
  /workflow off    Disable
  /workflow on     Enable
```

Or if disabled:
```
Workflow Status
───────────────
Project:  my-app
Status:   disabled
Home:     ~/.claude-workflow-agents/

Claude is in standard mode.
Toggle: /workflow on
```

## `/workflow on`

Enables workflow:
```bash
# Changes in CLAUDE.md:
<!-- workflow: disabled -->
# becomes:
<!-- workflow: enabled -->
```

Output:
```
✓ Workflow enabled

Agents and commands are now active.
```

## `/workflow off`

Disables workflow:
```bash
# Changes in CLAUDE.md:
<!-- workflow: enabled -->
# becomes:
<!-- workflow: disabled -->
```

Output:
```
Workflow disabled

Claude is now in standard mode.
Your content is unchanged.

Re-enable: /workflow on
```

## How It Works

CLAUDE.md contains two marker lines:
```markdown
<!-- workflow: enabled -->
<!-- workflow-home: ~/.claude-workflow-agents -->
```

When Claude reads CLAUDE.md:
- `enabled` → Load agents from workflow-home path, use commands
- `disabled` → Ignore workflow, operate as standard Claude
- `/workflow` command always works (to re-enable)

## Implementation

To toggle, just change the first line in CLAUDE.md:
```bash
# Enable (macOS)
sed -i '' 's/<!-- workflow: disabled -->/<!-- workflow: enabled -->/' CLAUDE.md

# Disable (macOS)
sed -i '' 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md

# Enable (Linux)
sed -i 's/<!-- workflow: disabled -->/<!-- workflow: enabled -->/' CLAUDE.md

# Disable (Linux)
sed -i 's/<!-- workflow: enabled -->/<!-- workflow: disabled -->/' CLAUDE.md
```

Or edit manually - it's just one line.
