# Workflow UI Commands Documentation

> Commands for managing the Workflow Control Center visual interface

## Overview

The Workflow UI provides a visual dashboard for managing your workflow system. These commands help you install, start, stop, and monitor the UI.

## Prerequisites

- Node.js 18+ and npm installed
- Claude Workflow Agents installed (`workflow-version` to check)
- A project with workflow initialized (optional, for project-specific features)

## Commands

### workflow-ui-install

**Purpose:** Install or update the Workflow Control Center UI

**Usage:**
```bash
workflow-ui-install [branch-name]
```

**Default:** Installs from `feature/workflow-ui` branch

**What it does:**
1. Checks Node.js and npm requirements
2. Fetches the specified branch from the repository
3. Installs frontend and server dependencies
4. Sets up UI command symlinks

**Examples:**
```bash
# Install from default feature branch
workflow-ui-install

# Install from specific branch
workflow-ui-install feature/workflow-ui-v2

# Install from master (when merged)
workflow-ui-install master
```

**Troubleshooting:**
- If Node.js is missing: Install from https://nodejs.org/
- If branch not found: Check available branches with `git branch -r`
- If dependencies fail: Try `npm install --legacy-peer-deps`

---

### workflow-ui-start

**Purpose:** Start the Workflow Control Center UI

**Usage:**
```bash
workflow-ui-start [--background]
```

**What it does:**
1. Checks if UI is installed (prompts to install if not)
2. Installs dependencies if needed
3. Starts backend server on port 4000
4. Starts frontend on port 3000
5. Opens browser automatically
6. Shows connection instructions for Claude Code

**Options:**
- `--background`: Run in background mode (returns to shell)

**Project Detection:**
- If run from a project directory (with CLAUDE.md), UI connects to that project
- If run globally, UI operates in standalone mode

**Examples:**
```bash
# Start UI for current project
cd my-project
workflow-ui-start

# Start UI in background
workflow-ui-start --background

# Start UI globally (no specific project)
workflow-ui-start
```

**Output:**
```
╔════════════════════════════════════════════════════════════════╗
║     Workflow Control Center                                   ║
╚════════════════════════════════════════════════════════════════╝

✓ Project detected: my-project
Starting Workflow UI Server...
✓ UI Server started on port 4000
Starting Workflow UI Frontend...
✓ UI Frontend started on port 3000

════════════════════════════════════════════════════════════════
✓ Workflow UI is running!

  Frontend:  http://localhost:3000
  Backend:   http://localhost:4000
  Logs:      ~/.claude-workflow-ui.log

  To stop the UI, run:
    workflow-ui-stop

  In Claude Code, connect with:
    workflow-ui-connect
════════════════════════════════════════════════════════════════
```

---

### workflow-ui-stop

**Purpose:** Stop the Workflow Control Center UI

**Usage:**
```bash
workflow-ui-stop
```

**What it does:**
1. Stops frontend process on port 3000
2. Stops backend server on port 4000
3. Cleans up PID files
4. Shows any remaining processes

**Examples:**
```bash
# Stop the UI
workflow-ui-stop

# Force kill all UI processes (if normal stop fails)
pkill -f 'node.*workflow.*ui'
```

---

### workflow-ui-status

**Purpose:** Check the status of the Workflow Control Center UI

**Usage:**
```bash
workflow-ui-status
```

**What it shows:**
- Installation status (installed/not installed)
- Current branch
- Dependencies status
- Service status (frontend and backend)
- Claude connection status
- Current project context
- Task queue statistics
- Recent errors from logs

**Examples:**
```bash
# Check UI status
workflow-ui-status

# Check status from project directory
cd my-project
workflow-ui-status
```

**Output Example:**
```
╔════════════════════════════════════════════════════════════════╗
║     Workflow UI Status                                        ║
╚════════════════════════════════════════════════════════════════╝

Installation Status:
  UI Directory:     ✓ Installed
  Current Branch:   feature/workflow-ui
  Dependencies:     ✓ Installed

Service Status:
  Backend Server:   ✓ Running on port 4000
  Server Health:    ✓ Healthy
  Frontend:         ✓ Running on port 3000
  URL:              http://localhost:3000

Claude Integration:
  Claude Status:    ○ Not connected
                    In Claude Code, run: workflow-ui-connect

Project Context:
  Current Project:  my-recipe-app
  Project Path:     /Users/john/projects/my-recipe-app

  Task Queue:
    Pending:        2
    In Progress:    1
    Completed:      5

════════════════════════════════════════════════════════════════
✓ Workflow UI is running

  Open in browser:  http://localhost:3000
  Stop UI:          workflow-ui-stop
════════════════════════════════════════════════════════════════
```

---

## Environment Variables

You can customize ports and paths using environment variables:

```bash
# Custom ports
UI_PORT=3001 SERVER_PORT=4001 workflow-ui-start

# Custom log location
UI_LOG_FILE=/tmp/workflow-ui.log workflow-ui-start
```

## Integration with Claude Code

### Connecting Claude to the UI

In your Claude Code session, after starting the UI:

```bash
# Connect to the UI (creates marker file)
workflow-ui-connect

# Or specify custom URL
workflow-ui-connect http://localhost:3001
```

### Task Queue System

The UI communicates with Claude through a file-based task queue:

```
.claude/tasks/
├── pending/     # New tasks from UI
├── progress/    # Tasks being executed
└── completed/   # Finished tasks
```

### How It Works

1. **UI creates task** → Writes to `.claude/tasks/pending/task-123.json`
2. **Claude detects** → Polls or watches for new tasks
3. **Claude executes** → Moves to `progress/`, updates status
4. **Task completes** → Moves to `completed/`
5. **UI updates** → Shows completion in real-time

## Troubleshooting

### UI Won't Start

1. Check Node.js version:
   ```bash
   node --version  # Should be v18+
   ```

2. Check if ports are in use:
   ```bash
   lsof -i:3000
   lsof -i:4000
   ```

3. Install UI if missing:
   ```bash
   workflow-ui-install
   ```

4. Check logs:
   ```bash
   cat ~/.claude-workflow-ui.log
   ```

### UI Not Detecting Project

1. Ensure you're in project directory:
   ```bash
   ls CLAUDE.md  # Should exist
   ```

2. Initialize workflow if needed:
   ```bash
   workflow-init
   ```

### Claude Not Connected

1. Start UI first:
   ```bash
   workflow-ui-start
   ```

2. In Claude Code, connect:
   ```bash
   workflow-ui-connect
   ```

### Dependencies Installation Issues

1. Clean install:
   ```bash
   cd ~/.claude-workflow-agents/ui
   rm -rf node_modules package-lock.json
   npm install --legacy-peer-deps
   ```

2. For server:
   ```bash
   cd ~/.claude-workflow-agents/ui/server
   rm -rf node_modules package-lock.json
   npm install --legacy-peer-deps
   ```

## Best Practices

1. **Project-Specific Usage:** Always start the UI from your project directory for best integration

2. **Keep UI Updated:** Run `workflow-ui-install` periodically to get latest features

3. **Monitor Logs:** Check `~/.claude-workflow-ui.log` if issues occur

4. **Clean Shutdown:** Always use `workflow-ui-stop` instead of killing processes

5. **Task Management:** Periodically clean old completed tasks:
   ```bash
   rm .claude/tasks/completed/*.json
   ```

## Architecture Notes

- **Frontend:** React app on port 3000 (Vite dev server)
- **Backend:** Express server on port 4000 (API and WebSocket)
- **Communication:** File system for tasks, WebSocket for real-time updates
- **State:** Parsed from CLAUDE.md and docs/ directory
- **Security:** Local-only, no external network access

## Future Enhancements

- [ ] Production build mode
- [ ] Docker container support
- [ ] Multi-project dashboard
- [ ] Cloud deployment option
- [ ] Authentication for team usage
- [ ] Direct Claude API integration