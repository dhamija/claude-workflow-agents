---
description: Enable, disable, or check workflow status
argument-hint: <on | off | status>
---

Toggle the workflow system on or off.

**Note:** This command instructs you to run a CLI command. It doesn't directly toggle anything because Claude Code loads agents/commands from ~/.claude/ automatically.

## `/workflow status`

Response:
```bash
Run: workflow-toggle status
```

Output:
```
Workflow Status: enabled
  Agents:   ~/.claude/agents/ -> workflow agents
  Commands: ~/.claude/commands/ -> workflow commands

To disable: workflow-toggle off
```

Or if disabled:
```
Workflow Status: disabled
  Agents:   not linked
  Commands: not linked

To enable: workflow-toggle on
```

## `/workflow on`

Response:
```bash
Run: workflow-toggle on
```

This creates symlinks:
```bash
~/.claude/agents/ -> ~/.claude-workflow-agents/agents/
~/.claude/commands/ -> ~/.claude-workflow-agents/commands/
```

Output:
```
✓ Workflow enabled
  Agents and commands are now active
```

**Protection:** If you have your own agents/commands, they're backed up to:
- `~/.claude/agents.user/`
- `~/.claude/commands.user/`

## `/workflow off`

Response:
```bash
Run: workflow-toggle off
```

This removes workflow symlinks and restores your own agents/commands (if any).

Output:
```
✓ Workflow disabled
  Standard Claude Code mode
```

## How It Works

**Reality:** Claude Code automatically loads all agents/commands from:
- `~/.claude/agents/`
- `~/.claude/commands/`

**The Mechanism:**
- Workflow files installed to: `~/.claude-workflow-agents/`
- Symlinks created: `~/.claude/agents/` → `~/.claude-workflow-agents/agents/`
- Enable/disable by creating/removing symlinks

**CLAUDE.md markers** (`<!-- workflow: enabled -->`) are **documentation only**.
Claude Code doesn't read them. They just remind you of the current state.

## Implementation

The `/workflow` command tells you to run `workflow-toggle`, which:

**Enable:**
```bash
workflow-toggle on

# Creates symlinks:
ln -sf ~/.claude-workflow-agents/agents ~/.claude/agents
ln -sf ~/.claude-workflow-agents/commands ~/.claude/commands

# Backs up user's own files to .user if they exist
```

**Disable:**
```bash
workflow-toggle off

# Removes only workflow symlinks (checks target contains "workflow-agents")
rm ~/.claude/agents  # only if -> workflow-agents
rm ~/.claude/commands  # only if -> workflow-agents

# Restores user's files from .user backup if they exist
```

**Protection:** Your own agents/commands are never deleted, always backed up to `.user`.
