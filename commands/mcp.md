---
name: mcp
description: Manage MCP server recommendations and configuration for enhanced development capabilities
argument-hint: "[recommend | setup <servers...> | status | guide]"
---

# /mcp Command

Manage Model Context Protocol (MCP) server integration for enhanced development capabilities.

## Usage

```bash
/mcp                          # Show recommendations (same as recommend)
/mcp recommend                # Analyze project and recommend MCP servers
/mcp setup <servers...>       # Generate configuration for specified servers
/mcp status                   # Check MCP server availability
/mcp guide                    # Show usage guide
```

---

## Modes

### `/mcp` or `/mcp recommend` (default)

Analyze project and recommend MCP servers based on:
- Project type (web app, API, data pipeline, etc.)
- Technology stack (PostgreSQL, React, etc.)
- Development needs (testing, deployment, collaboration)

**Output:**
```
MCP Server Recommendations
══════════════════════════

Project: Full-stack web app with PostgreSQL and React
Tech Stack: PostgreSQL, React, Node.js, TypeScript

HIGHLY RECOMMENDED
──────────────────

  ✓ postgres
    Why: Direct database access for debugging, migrations, and queries
    Setup: Requires DATABASE_URL environment variable
    Priority: HIGH

  ✓ github
    Why: Automate PR creation, issue management, and code review
    Setup: Requires GITHUB_PERSONAL_ACCESS_TOKEN
    Priority: HIGH

RECOMMENDED
───────────

  ✓ puppeteer
    Why: Browser automation for E2E testing and visual debugging
    Setup: Requires Chrome/Chromium installed
    Priority: MEDIUM

  ✓ memory
    Why: Persistent context across sessions for better continuity
    Setup: No configuration needed
    Priority: MEDIUM

OPTIONAL (TEAM COLLABORATION)
──────────────────────────────

  ○ slack
    Why: Post notifications to team channels
    Setup: Requires SLACK_BOT_TOKEN
    Use if: Team uses Slack for communication

  ○ linear
    Why: Manage issues and track work
    Setup: Requires LINEAR_API_KEY
    Use if: Team uses Linear for project management

SETUP COMMAND
─────────────

  Quick setup for essentials:
    /mcp setup postgres github puppeteer memory

  Or configure manually in Claude settings.
```

**Analysis Criteria:**

| Project Has | Recommends |
|-------------|------------|
| PostgreSQL database | postgres MCP (HIGH) |
| SQLite database | sqlite MCP (HIGH) |
| MongoDB | Not currently supported by official MCP |
| GitHub repository | github MCP (HIGH) |
| E2E tests | puppeteer MCP (MEDIUM) |
| Team collaboration | slack/linear MCP (MEDIUM) |
| Complex context | memory MCP (MEDIUM) |
| Redis cache | redis MCP (MEDIUM) |
| Docker deployment | docker MCP (LOW) |
| Kubernetes | kubernetes MCP (LOW) |

---

### `/mcp setup <servers...>`

Generate MCP configuration for specified servers.

**Example:**
```bash
/mcp setup postgres github
```

**Output:**
```
MCP Configuration Generated
════════════════════════════

Add to your Claude configuration file:

📁 Location:
   macOS:   ~/Library/Application Support/Claude/claude_desktop_config.json
   Windows: %APPDATA%\Claude\claude_desktop_config.json

📝 Configuration:

{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost:5432/myapp"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}

⚙️ ENVIRONMENT VARIABLES NEEDED
────────────────────────────────

  postgres:
    DATABASE_URL     Your PostgreSQL connection string
                     Example: postgresql://user:pass@localhost:5432/dbname

  github:
    GITHUB_PERSONAL_ACCESS_TOKEN
                     Get token: https://github.com/settings/tokens
                     Permissions needed: repo, workflow (optional)

📋 NEXT STEPS
─────────────

  1. Create GitHub token (if needed):
     → https://github.com/settings/tokens
     → Select scopes: repo, workflow

  2. Update DATABASE_URL with your connection string

  3. Copy configuration to Claude config file

  4. Restart Claude Code

  5. Verify servers are connected:
     → /mcp status

  6. Test with natural prompts:
     → "Query the users table"
     → "Create a PR for this feature"

💡 TIP
──────

  Keep sensitive tokens in your shell environment:

    export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."
    export DATABASE_URL="postgresql://..."

  Then reference in config:
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
```

**Supported servers:**
- `postgres` - PostgreSQL database access
- `sqlite` - SQLite database access
- `github` - GitHub integration (PRs, issues, etc.)
- `puppeteer` - Browser automation
- `memory` - Persistent memory
- `filesystem` - Extended file access
- `fetch` - HTTP requests
- `slack` - Slack integration
- `linear` - Linear integration
- `notion` - Notion integration
- `redis` - Redis access
- `docker` - Docker management
- `kubernetes` - Kubernetes management

---

### `/mcp status`

Check MCP server availability and connection status.

**Output:**
```
MCP Server Status
═════════════════

✓ CONNECTED (Available)
────────────────────────

  ✓ github         Ready
    Package: @modelcontextprotocol/server-github
    Status: Connected

  ✓ postgres       Ready
    Package: @modelcontextprotocol/server-postgres
    Status: Connected
    Database: myapp (localhost:5432)

  ✓ puppeteer      Ready
    Package: @modelcontextprotocol/server-puppeteer
    Status: Connected

  ✓ memory         Ready
    Package: @modelcontextprotocol/server-memory
    Status: Connected

⚠ CONFIGURED BUT UNAVAILABLE
─────────────────────────────

  ⚠ slack          Connection failed
    Error: Invalid token
    Fix: Update SLACK_BOT_TOKEN in config

○ NOT CONFIGURED
────────────────

  ○ sqlite         Not in config
  ○ linear         Not in config
  ○ notion         Not in config
  ○ redis          Not in config
  ○ docker         Not in config

ACTIONS
───────

  Add servers:        /mcp setup <server-name>
  Troubleshoot:       Check logs in ~/Library/Logs/Claude/
  Restart Claude:     Required after config changes
```

---

### `/mcp guide`

Show comprehensive MCP usage guide.

**Output:**
```
MCP Usage Guide
═══════════════

MCP servers extend Claude's capabilities by connecting to external tools.

WHAT MCP SERVERS DO
───────────────────

  MCP servers allow Claude to:

  • Query databases directly (postgres, sqlite)
  • Manage GitHub PRs and issues (github)
  • Automate browsers for testing (puppeteer)
  • Remember context across sessions (memory)
  • Post to Slack/Linear (slack, linear)
  • Make HTTP requests (fetch)
  • Access files beyond project directory (filesystem)

POPULAR SERVERS
───────────────

  DATABASE ACCESS
    postgres     PostgreSQL queries and management
    sqlite       SQLite queries and management
    redis        Redis cache operations

  DEVELOPMENT WORKFLOW
    github       Create PRs, manage issues, code review
    puppeteer    Browser automation and E2E testing
    fetch        HTTP requests and API testing
    filesystem   Extended file system access

  TEAM COLLABORATION
    slack        Post messages and notifications
    linear       Issue tracking and project management
    notion       Documentation access

  INFRASTRUCTURE
    docker       Container management
    kubernetes   Cluster management

SETUP PROCESS
─────────────

  1. Get recommendations for your project:
     → /mcp recommend

  2. Generate configuration:
     → /mcp setup postgres github puppeteer

  3. Add configuration to Claude config file:
     → macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
     → Windows: %APPDATA%\Claude\claude_desktop_config.json

  4. Set up required tokens/credentials:
     → GitHub: https://github.com/settings/tokens
     → Slack: https://api.slack.com/apps
     → etc.

  5. Restart Claude Code

  6. Verify connection:
     → /mcp status

USAGE EXAMPLES
──────────────

  Once configured, just ask naturally:

  WITH POSTGRES:
    "Query the users table"
    "Show me the schema for orders table"
    "Run this migration"
    → Claude queries database directly

  WITH GITHUB:
    "Create a PR for the auth feature"
    "List open issues labeled 'bug'"
    "Add a comment to PR #123"
    → Claude interacts with GitHub

  WITH PUPPETEER:
    "Test the login flow"
    "Take a screenshot of the dashboard"
    "Check if the search works"
    → Claude automates browser

  WITH MEMORY:
    "Remember that we're using PostgreSQL"
    "What database are we using?"
    → Claude stores and retrieves context

CONFIGURATION FILE FORMAT
──────────────────────────

  {
    "mcpServers": {
      "server-name": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-name"],
        "env": {
          "TOKEN_NAME": "value"
        }
      }
    }
  }

SECURITY BEST PRACTICES
────────────────────────

  • Use environment variables for tokens
  • Use read-only database credentials when possible
  • Limit filesystem access to specific directories
  • Rotate tokens periodically
  • Don't commit tokens to version control

TROUBLESHOOTING
───────────────

  Server won't start:
    → Check logs: ~/Library/Logs/Claude/
    → Verify package name in config
    → Ensure npx is available

  Connection failed:
    → Verify credentials/tokens
    → Check network access
    → Restart Claude after config changes

  Permission errors:
    → Check token scopes (GitHub)
    → Verify database user permissions
    → Check filesystem path permissions

DOCUMENTATION
─────────────

  Full guide: /docs/architecture/mcp-integration.md
  Official MCP docs: https://modelcontextprotocol.io
  Server packages: https://npmjs.com/search?q=%40modelcontextprotocol
```

---

## Common Workflows

### Workflow 1: Database Development

```
User: /mcp recommend

Claude: [Shows postgres is recommended for PostgreSQL project]

User: /mcp setup postgres

Claude: [Generates configuration]

User: [Adds config and DATABASE_URL, restarts Claude]

User: Query the users table

Claude: [Uses postgres MCP to run query]
        Found 1,234 users. Here's a sample:

        id | email               | created_at
        ---|---------------------|------------
        1  | user@example.com    | 2024-01-15
        ...

User: Add a 'status' column with default 'active'

Claude: [Creates migration, runs it, verifies change]
        ✓ Migration created: 20240115_add_status_column.sql
        ✓ Migration applied successfully
        ✓ Column added: status VARCHAR(20) DEFAULT 'active'
```

### Workflow 2: PR Automation

```
User: /mcp setup github

Claude: [Generates configuration with GitHub token instructions]

User: [Adds token, restarts]

User: Create a PR for the authentication feature

Claude: [Uses github MCP]
        ✓ Created branch: feature/auth
        ✓ Committed changes (5 files)
        ✓ Created PR #42: "Add user authentication"
        ✓ Added reviewers: @alice, @bob

        PR: https://github.com/myorg/myrepo/pull/42
```

### Workflow 3: E2E Testing

```
User: /mcp setup puppeteer

Claude: [Generates configuration]

User: Test the user registration flow

Claude: [Uses puppeteer MCP]
        Opening browser to http://localhost:3000/register

        1. Filled email: test@example.com ✓
        2. Filled password ✓
        3. Clicked "Sign Up" ✓
        4. Verified redirect to /dashboard ✓
        5. Took screenshot: screenshot-1.png ✓

        ✅ Registration flow works correctly
```

---

## Integration with Workflow

### After L1 Planning

After intent-guardian, ux-architect, and agentic-architect complete:

```
Claude: Planning complete!

        Based on your project (Full-stack PostgreSQL app), these MCP servers
        would significantly enhance development:

        ✓ postgres  - Query database directly, test migrations
        ✓ github    - Automate PR workflow
        ✓ puppeteer - E2E testing with real browser

        Run `/mcp setup postgres github puppeteer` to configure.
        (Optional but recommended for faster development)
```

### During Implementation

backend-engineer and frontend-engineer can leverage MCP when available:

```markdown
## Implementation Notes

This feature benefits from MCP servers:
- `postgres` - Test queries before implementing service
- `puppeteer` - Verify UI works before writing tests
```

### During Testing

test-engineer can use MCP for interactive debugging:

```
Instead of just writing tests:
1. Use puppeteer MCP to run scenario
2. See what actually happens
3. Debug issues in real-time
4. Then write/fix test code
```

---

## See Also

- `/docs/architecture/mcp-integration.md` - Complete MCP integration guide
- `/agent-wf-help mcp` - MCP help topic
- Official MCP documentation: https://modelcontextprotocol.io
