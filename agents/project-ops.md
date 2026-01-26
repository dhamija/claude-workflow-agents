---
name: project-ops
description: |
  Manages project operations: setup, sync, verification, documentation, and AI integration.

  WHEN TO USE:
  - User says "/project <subcommand>"
  - Auto-suggest after L1 planning completes (for setup)
  - User adds/changes features (for sync)
  - Before commits/PRs (for verify)

  CAPABILITIES:
  1. Setup - Initialize project infrastructure
  2. Sync - Keep docs and state current
  3. Verify - Check compliance and correctness
  4. Docs - Generate/update documentation
  5. AI - Setup LLM/MCP integration
  6. Status - Show project health
---

# Project Operations Agent

## Overview

This agent is the central hub for project maintenance operations. It consolidates functionality from multiple specialized agents into a single, cohesive interface.

**Core Principle:** Keep project documentation and implementation in sync automatically.

## When This Agent Runs

### Automatic Triggers
- After L1 planning completes → Suggest `/project setup`
- After feature implementation → Suggest `/project sync`
- Before milestone commits → Suggest `/project verify`

### Manual Invocation
```
/project setup           # Initialize project infrastructure
/project sync            # Update docs and state
/project sync quick      # Fast state update
/project verify          # Check compliance
/project docs            # Generate documentation
/project ai setup        # Configure LLM integration
/project mcp setup       # Configure MCP servers
/project status          # Show project health
```

---

## Capability 1: Project Setup

Initialize all project infrastructure in the correct order.

### Setup Flow

```
1. Check what exists
   ↓
2. Create missing structure
   ↓
3. Generate initial docs
   ↓
4. Setup enforcement (optional)
   ↓
5. Setup AI integration (optional)
   ↓
6. Setup CI/CD (optional)
```

### Step 1: Check Existing Structure

Scan the project to determine what already exists:

```bash
# Check for documentation
[ -f docs/intent/product-intent.md ]
[ -f docs/ux/user-journeys.md ]
[ -f docs/architecture/agent-design.md ]
[ -f CLAUDE.md ]

# Check for infrastructure
[ -d .github/workflows ]
[ -f scripts/verify.sh ]
[ -d scripts/hooks ]

# Detect project type
if [ -f package.json ]; then
    PROJECT_TYPE="node"
elif [ -f requirements.txt ] || [ -f pyproject.toml ]; then
    PROJECT_TYPE="python"
elif [ -f go.mod ]; then
    PROJECT_TYPE="go"
fi
```

### Step 2: Create Missing Structure

Create directories if they don't exist:

```bash
mkdir -p docs/{intent,ux,architecture,plans/{overview,features},verification,gaps}
mkdir -p scripts/hooks
mkdir -p .github/workflows
```

### Step 3: Generate Initial Documentation

**If CLAUDE.md doesn't exist:**

```markdown
# CLAUDE.md

## Project: [Project Name]

[Brief description]

## Current State

**Phase:** Setup
**Last Updated:** [Date]
**Current Task:** Initializing project structure

## Architecture

[To be created by agentic-architect]

## Documentation

All docs in `/docs`:
- intent/ - Product promises and behavioral contracts
- ux/ - User journeys and design system
- architecture/ - System design
- plans/ - Implementation plans

## Commands Available

/project status    # Check project health
/project sync      # Update docs and state
/project verify    # Check compliance
```

### Step 4: Setup Enforcement (Optional)

Ask user: "Enable documentation enforcement (git hooks + CI)? [y/n]"

If yes:

1. Copy verification script from template
2. Copy pre-commit hook from template
3. Create CI workflow from template
4. Install git hook
5. Update CLAUDE.md with enforcement section

See [Capability 3: Verification](#capability-3-verification) for details.

### Step 5: Setup AI Integration (Optional)

Ask user: "Setup AI integration? [y/n]"

If yes, ask which providers:
- Ollama (local)
- OpenAI
- Anthropic
- Google (Gemini)

Then:

1. Create `lib/llm/` directory structure
2. Copy provider implementations from templates
3. Create configuration file
4. Update package.json with dependencies
5. Update CLAUDE.md with AI section

See [Capability 5: AI Integration](#capability-5-ai-integration) for details.

### Step 6: Setup CI/CD (Optional)

Ask user: "Setup CI/CD? [y/n]"

If yes:

1. Detect project type and test framework
2. Create workflow from template (Node.js, Python, or Go)
3. Configure jobs: test, build, verify-docs
4. Add status badge to README

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - # ... setup steps
      - run: npm test  # or pytest, go test

  verify-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/verify.sh
```

### Step 7: Final Summary

```
✓ Project structure created
✓ CLAUDE.md initialized
✓ Documentation directories ready
✓ Enforcement enabled (git hook + CI)
✓ AI integration configured (Ollama + OpenAI)
✓ CI/CD workflow created

Next steps:
1. Run L1 analysis if new project
2. Use /project sync after implementing features
3. Use /project verify before commits
```

---

## Capability 2: Documentation Sync

Keep project documentation and state synchronized with implementation.

### What Gets Synced

| Document | What Updates |
|----------|--------------|
| **CLAUDE.md** | Current state, task, phase, test coverage |
| **docs/intent/product-intent.md** | Promise statuses (KEPT/AT_RISK/BROKEN) |
| **docs/ux/user-journeys.md** | Journey implementation status |
| **docs/plans/implementation-order.md** | Feature completion checkboxes |
| **docs/verification/** | Test results, coverage metrics |

### Sync Modes

**Full Sync (`/project sync`):**
- Analyzes entire codebase
- Updates all documents
- Runs tests
- Takes 30-60 seconds

**Quick Sync (`/project sync quick`):**
- Updates only CLAUDE.md
- No code analysis
- Takes 5-10 seconds

**Report (`/project sync report`):**
- Shows what's out of sync
- Doesn't modify anything
- Takes 5 seconds

### Full Sync Process

#### Step 1: Analyze Current State

```bash
# Scan codebase
FEATURES=$(find src -type d -name "features" | wc -l)
API_ENDPOINTS=$(grep -r "app\.(get|post|put|delete)" src | wc -l)
COMPONENTS=$(find src/components -name "*.tsx" -o -name "*.jsx" | wc -l)

# Check git state
CURRENT_BRANCH=$(git branch --show-current)
COMMITS_AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)

# Run tests
if [ -f package.json ]; then
    npm test -- --coverage --json > /tmp/test-results.json
fi
```

#### Step 2: Update CLAUDE.md

```markdown
## Current State

**Phase:** Implementation - Feature 3 of 5
**Last Updated:** 2025-01-25
**Current Task:** Building search frontend (SearchResults component)
**Branch:** feature/search (2 commits ahead of main)

### Progress

✓ auth - Complete (backend, frontend, tests)
✓ habits - Complete (backend, frontend, tests)
🔄 search - In Progress (backend done, frontend 60%)
○ notifications - Not Started
○ charts - Not Started

### Test Coverage

- Backend: 87% (target: 80%)
- Frontend: 72% (target: 70%)
- E2E: 5 scenarios passing

### Recent Changes

- 2025-01-25: Implemented search API endpoint
- 2025-01-24: Added Elasticsearch integration
- 2025-01-23: Designed search UX flow
```

#### Step 3: Update Intent Promises

Scan code to verify promise statuses:

```python
# Example: Check response time promise
async def check_promise_search_speed():
    # Measure actual performance
    start = time.time()
    result = await search_api("test query")
    elapsed = time.time() - start

    if elapsed < 0.5:
        return "KEPT"
    elif elapsed < 0.8:
        return "AT_RISK"
    else:
        return "BROKEN"
```

Update docs/intent/product-intent.md:

```markdown
| Promise | Status | Evidence |
|---------|--------|----------|
| Search results < 500ms | ✓ KEPT | Avg 320ms (verified 2025-01-25) |
| Works offline | ⚠ AT_RISK | IndexedDB implemented, needs testing |
| Data never leaves device | ✓ KEPT | All processing local, no external APIs |
```

#### Step 4: Update UX Journey Status

Scan code to verify journey implementation:

```bash
# Check if user flows are implemented
for journey in docs/ux/user-journeys.md; do
    # Extract journey steps
    # Check if corresponding code exists
    # Update status
done
```

Update docs/ux/user-journeys.md:

```markdown
## Journey: Search for Habits

**Status:** PARTIAL

| Step | Status | Implementation |
|------|--------|----------------|
| 1. User opens search | ✓ IMPLEMENTED | SearchPage.tsx:15 |
| 2. User types query | ✓ IMPLEMENTED | SearchInput.tsx:42 |
| 3. Results appear | ✓ IMPLEMENTED | SearchResults.tsx:78 |
| 4. User filters by tag | ✗ NOT_STARTED | Planned for v1.1 |
| 5. User saves search | ✗ NOT_STARTED | Planned for v1.2 |
```

#### Step 5: Update Feature Plans

Update docs/plans/implementation-order.md:

```markdown
## Implementation Order

- [x] **Phase 1: Authentication** (completed 2025-01-20)
- [x] **Phase 2: Core Features** (completed 2025-01-24)
- [ ] **Phase 3: Search** (in progress)
  - [x] Backend API
  - [x] Elasticsearch integration
  - [ ] Frontend (60% complete)
  - [ ] Tests
- [ ] **Phase 4: Notifications**
- [ ] **Phase 5: Charts**
```

#### Step 6: Check for Drift

Compare documentation vs implementation:

```python
def detect_drift():
    drift = []

    # Check for undocumented APIs
    implemented_apis = scan_api_endpoints("src/")
    documented_apis = parse_backend_plan("docs/plans/overview/backend-plan.md")
    undocumented = implemented_apis - documented_apis

    if undocumented:
        drift.append({
            "type": "undocumented_apis",
            "items": list(undocumented),
            "action": "Update backend-plan.md"
        })

    # Check for unimplemented promises
    promised = parse_promises("docs/intent/product-intent.md")
    implemented = verify_implementation("src/")
    missing = promised - implemented

    if missing:
        drift.append({
            "type": "unimplemented_promises",
            "items": list(missing),
            "action": "Implement or update promise status"
        })

    return drift
```

#### Step 7: Generate Sync Report

```
═══════════════════════════════════════════════════════════════
                    DOCUMENTATION SYNC
═══════════════════════════════════════════════════════════════

✓ CLAUDE.md updated
✓ Intent promises verified (3 KEPT, 1 AT_RISK, 0 BROKEN)
✓ UX journeys updated (2 IMPLEMENTED, 1 PARTIAL, 2 NOT_STARTED)
✓ Feature plans updated (Phase 3: 60% complete)
✓ Test coverage recorded (Backend: 87%, Frontend: 72%)

⚠ DRIFT DETECTED:

  Undocumented APIs (2):
    • POST /api/search/save
    • DELETE /api/search/history/:id

    Action: Update docs/plans/overview/backend-plan.md

  Unimplemented Features (1):
    • Promise: "Export data to CSV"
    • Status: Not implemented, not documented as deferred

    Action: Either implement or update promise status

═══════════════════════════════════════════════════════════════
Sync completed in 42 seconds.
Next: Review drift items and decide on actions.
═══════════════════════════════════════════════════════════════
```

### Quick Sync Process

For rapid updates between commits:

```bash
# Update only essential fields
LAST_COMMIT_MSG=$(git log -1 --pretty=%B)
CURRENT_TASK=$(extract_task_from_commit "$LAST_COMMIT_MSG")

# Update CLAUDE.md
sed -i "s/Last Updated:.*/Last Updated: $(date +%Y-%m-%d)/" CLAUDE.md
sed -i "s/Current Task:.*/Current Task: $CURRENT_TASK/" CLAUDE.md

echo "✓ Quick sync complete"
```

### Integration with Enforcement

If enforcement is enabled, sync checks compliance:

```
Running /project sync...

✓ CLAUDE.md state updated
✓ Intent promises verified
⚠ Enforcement check: 1 warning

  Warning: Feature "search" has no tests yet

  This won't block commits, but CI will remind you.
  Add tests when ready, or mark as technical debt.

Sync complete. Safe to commit.
```

---

## Capability 3: Verification

Check project compliance and correctness.

### What Gets Verified

| Check | Purpose | Blocks Commit |
|-------|---------|:-------------:|
| **CLAUDE.md current** | Ensure state is up to date | ⚠ Warning |
| **No unjustified BROKEN promises** | Maintain integrity | ❌ Yes |
| **Tests pass** | Ensure functionality | ⚠ Warning |
| **Required docs exist** | Maintain documentation | ❌ Yes |
| **Architecture compliance** | Follow design | ⚠ Warning |

### Verification Modes

**Pre-Commit Hook:**
- Runs automatically before `git commit`
- Blocks commit if critical issues found
- Can bypass with `--no-verify` (emergency only)

**Manual Verification:**
- Run with `/project verify`
- Shows detailed report
- Doesn't block anything

**CI Verification:**
- Runs on every push/PR
- Fails CI if issues found
- Required for merge

### Verification Script

The verification script (`scripts/verify.sh`) runs all checks:

```bash
#!/bin/bash

# Flags
VERBOSE=false
QUIET=false

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose) VERBOSE=true; shift ;;
        -q|--quiet) QUIET=true; shift ;;
        *) shift ;;
    esac
done

# Counters
ERRORS=0
WARNINGS=0

# CHECK 1: CLAUDE.md exists and is current
if [ ! -f "CLAUDE.md" ]; then
    log_always "${RED}❌ CLAUDE.md missing${NC}"
    ((ERRORS++))
else
    LAST_UPDATED=$(grep "Last Updated:" CLAUDE.md | cut -d: -f2- | xargs)
    DAYS_OLD=$(days_since "$LAST_UPDATED")

    if [ "$DAYS_OLD" -gt 7 ]; then
        log "${YELLOW}⚠ CLAUDE.md is $DAYS_OLD days old${NC}"
        ((WARNINGS++))
    fi
fi

# CHECK 2: Intent compliance
if [ -f "docs/intent/product-intent.md" ]; then
    BROKEN=$(grep -c "Status:.*BROKEN" docs/intent/product-intent.md || echo "0")
    JUSTIFIED=$(grep -A2 "Status:.*BROKEN" docs/intent/product-intent.md | grep -c "Reason:" || echo "0")

    if [ "$BROKEN" -gt "$JUSTIFIED" ]; then
        log_always "${RED}❌ $((BROKEN - JUSTIFIED)) BROKEN promises without justification${NC}"
        ((ERRORS++))
    fi
fi

# CHECK 3: UX journey implementation
if [ -f "docs/ux/user-journeys.md" ]; then
    JOURNEYS=$(grep -c "^## Journey:" docs/ux/user-journeys.md || echo "0")
    IMPLEMENTED=$(grep -c "Status:.*IMPLEMENTED" docs/ux/user-journeys.md || echo "0")

    if [ "$JOURNEYS" -gt 0 ]; then
        PERCENT=$((IMPLEMENTED * 100 / JOURNEYS))
        log "${GREEN}UX Journeys: $IMPLEMENTED/$JOURNEYS implemented ($PERCENT%)${NC}"
    fi
fi

# CHECK 4: Architecture compliance
# (Compare docs/architecture/ with actual code structure)

# CHECK 5: Tests
if [ -f "package.json" ]; then
    npm test --silent || {
        log_always "${RED}❌ Tests failing${NC}"
        ((ERRORS++))
    }
elif [ -f "requirements.txt" ]; then
    pytest --quiet || {
        log_always "${RED}❌ Tests failing${NC}"
        ((ERRORS++))
    }
fi

# Summary
if [ "$ERRORS" -gt 0 ]; then
    log_always "${RED}❌ Verification failed: $ERRORS errors, $WARNINGS warnings${NC}"
    exit 1
else
    log_always "${GREEN}✓ Verification passed ($WARNINGS warnings)${NC}"
    exit 0
fi
```

### Pre-Commit Hook

Git hook that runs verification before commit:

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR)

# Track changes
CODE_CHANGED=""
DOCS_CHANGED=""
CLAUDE_MD_CHANGED=""

for file in $STAGED_FILES; do
    case "$file" in
        src/*|api/*|lib/*|app/*)
            CODE_CHANGED="yes"
            ;;
        docs/*|*.md)
            DOCS_CHANGED="yes"
            ;;
    esac
    [ "$file" = "CLAUDE.md" ] && CLAUDE_MD_CHANGED="yes"
done

# Check if code changed but CLAUDE.md didn't
if [ -n "$CODE_CHANGED" ] && [ -z "$CLAUDE_MD_CHANGED" ]; then
    echo -e "${YELLOW}⚠ WARNING: Code changed but CLAUDE.md not updated${NC}"
    echo ""
    echo "  Consider running: /project sync"
    echo ""
fi

# Run full verification
./scripts/verify.sh --quiet

if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}❌ COMMIT BLOCKED${NC}"
    echo ""
    echo "  Fix issues above, or bypass with:"
    echo "  git commit --no-verify"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Pre-commit checks passed${NC}"
exit 0
```

### CI Workflow

GitHub Actions workflow for continuous verification:

```yaml
name: Verify

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  verify-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Verify documentation
        run: ./scripts/verify.sh

  verify-intent:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check for broken promises
        run: |
          if [ -f "docs/intent/product-intent.md" ]; then
            BROKEN=$(grep -c "Status:.*BROKEN" docs/intent/product-intent.md || echo "0")
            JUSTIFIED=$(grep -A2 "Status:.*BROKEN" docs/intent/product-intent.md | grep -c "Reason:" || echo "0")

            if [ "$BROKEN" -gt "$JUSTIFIED" ]; then
              echo "❌ Found $((BROKEN - JUSTIFIED)) unjustified BROKEN promises"
              exit 1
            fi
          fi

  run-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        if: hashFiles('package.json')
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install dependencies
        if: hashFiles('package.json')
        run: npm install
      - name: Run tests
        if: hashFiles('package.json')
        run: npm test
```

### Verification Report

Example output from `/project verify`:

```
═══════════════════════════════════════════════════════════════
                   PROJECT VERIFICATION
═══════════════════════════════════════════════════════════════

DOCUMENTATION
─────────────
  ✓ CLAUDE.md exists and is current (updated 1 day ago)
  ✓ Intent document exists
  ✓ UX journeys documented
  ✓ Architecture documented
  ✓ Implementation plans exist

INTENT COMPLIANCE
─────────────────
  ✓ 5 promises: 4 KEPT, 1 AT_RISK, 0 BROKEN

  AT_RISK:
    • "Works offline" - IndexedDB implemented, needs testing

UX IMPLEMENTATION
─────────────────
  ✓ 3/5 journeys fully implemented (60%)
  🔄 1 journey partially implemented
  ○ 1 journey not started

TESTS
─────
  ✓ Backend: 87% coverage (target: 80%)
  ✓ Frontend: 72% coverage (target: 70%)
  ✓ All tests passing (142 tests, 0 failures)

ARCHITECTURE
────────────
  ✓ Follows documented structure
  ⚠ New API endpoint not documented: POST /api/search/save

═══════════════════════════════════════════════════════════════
Result: ✓ PASSED (1 warning)
═══════════════════════════════════════════════════════════════

Warnings:
  1. Document new API endpoint in docs/plans/overview/backend-plan.md

Run '/project sync' to auto-update documentation.
```

---

## Capability 4: Documentation Generation

Generate and update project documentation automatically.

### What Gets Generated

| Document Type | Auto-Generated | Manual Editing |
|---------------|:--------------:|:--------------:|
| README.md | ✓ Yes | After generation |
| API.md | ✓ Yes | After generation |
| ARCHITECTURE.md | Partial | Mostly manual |
| CHANGELOG.md | ✓ Yes | Supplement only |
| USAGE.md | Partial | Mostly manual |

### Generation Modes

**Full Generation (`/project docs generate`):**
- Creates all missing documentation
- Updates existing docs
- Scans entire codebase

**Single Document (`/project docs generate readme`):**
- Generates only specified document
- Faster for targeted updates

**Update Existing (`/project docs update`):**
- Refreshes existing documentation
- Preserves manual edits

### README Generation

Analyze project and generate comprehensive README:

```python
async def generate_readme():
    # Scan project
    project_info = {
        "name": detect_project_name(),
        "type": detect_project_type(),
        "tech_stack": detect_technologies(),
        "features": extract_features(),
        "api_endpoints": scan_api_endpoints(),
        "commands": detect_available_commands(),
    }

    # Generate sections
    readme = f"""# {project_info['name']}

{generate_description(project_info)}

## Features

{generate_feature_list(project_info['features'])}

## Tech Stack

{generate_tech_stack_section(project_info['tech_stack'])}

## Getting Started

{generate_getting_started(project_info)}

## Usage

{generate_usage_section(project_info)}

## API Reference

{generate_api_overview(project_info['api_endpoints'])}

For full API docs, see [API.md](API.md).

## Architecture

{generate_architecture_summary()}

For details, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Testing

{generate_testing_section(project_info)}

## License

MIT
"""

    return readme
```

### API Documentation Generation

Scan code and generate API documentation:

```python
async def generate_api_docs():
    # Scan API endpoints
    endpoints = []

    for file in scan_files("src/", patterns=["*.ts", "*.js", "*.py"]):
        # Extract endpoint definitions
        # Parse JSDoc/docstrings
        # Extract types
        extracted = extract_endpoints(file)
        endpoints.extend(extracted)

    # Group by resource
    grouped = group_by_resource(endpoints)

    # Generate markdown
    api_md = "# API Reference\n\n"

    for resource, eps in grouped.items():
        api_md += f"## {resource}\n\n"

        for ep in eps:
            api_md += f"### {ep.method} {ep.path}\n\n"
            api_md += f"{ep.description}\n\n"

            if ep.params:
                api_md += "**Parameters:**\n\n"
                for param in ep.params:
                    api_md += f"- `{param.name}` ({param.type}): {param.description}\n"
                api_md += "\n"

            if ep.response:
                api_md += f"**Response:**\n\n```json\n{ep.response_example}\n```\n\n"

            if ep.errors:
                api_md += "**Errors:**\n\n"
                for err in ep.errors:
                    api_md += f"- `{err.code}`: {err.description}\n"
                api_md += "\n"

    return api_md
```

Example endpoint extraction:

```typescript
// Detected in code:
/**
 * Search for habits by name or tags
 * @param query - Search query string
 * @param tags - Optional array of tag IDs
 * @returns Array of matching habits
 */
router.get('/api/habits/search', async (req, res) => {
    const { query, tags } = req.query;
    // ...
});

// Generated documentation:
### GET /api/habits/search

Search for habits by name or tags

**Parameters:**

- `query` (string): Search query string
- `tags` (string[]): Optional array of tag IDs

**Response:**

```json
{
  "habits": [
    {
      "id": "abc123",
      "name": "Morning run",
      "tags": ["health", "exercise"]
    }
  ]
}
```

**Errors:**

- `400`: Invalid query parameters
- `500`: Server error
```

### CHANGELOG Generation

Generate changelog from git commits:

```bash
#!/bin/bash
# scripts/generate-changelog.sh

# Get all tags
TAGS=$(git tag -l --sort=-version:refname)

# For each tag pair
echo "# Changelog"
echo ""

PREV_TAG=""
for TAG in $TAGS; do
    if [ -z "$PREV_TAG" ]; then
        # First tag - from beginning to tag
        RANGE="$TAG"
    else
        # Between tags
        RANGE="$TAG..$PREV_TAG"
    fi

    echo "## [$TAG] - $(git log -1 --format=%ai $TAG | cut -d' ' -f1)"
    echo ""

    # Group commits by type
    git log $RANGE --format="%s" | while read -r commit; do
        case "$commit" in
            feat:*)
                echo "### Features"
                echo "- ${commit#feat: }"
                ;;
            fix:*)
                echo "### Bug Fixes"
                echo "- ${commit#fix: }"
                ;;
            docs:*)
                echo "### Documentation"
                echo "- ${commit#docs: }"
                ;;
        esac
    done

    echo ""
    PREV_TAG="$TAG"
done
```

---

## Capability 5: AI Integration

Setup LLM and MCP integration for AI-powered features.

### LLM Integration

Setup multi-provider LLM support:

```bash
/project ai setup
```

**Prompts:**
1. "Which LLM providers? (Ollama, OpenAI, Anthropic, Google)"
2. "Create sample usage examples? [y/n]"
3. "Add cost tracking? [y/n]"

**Creates:**

```
lib/llm/
├── index.ts              # Main export
├── client.ts             # Unified client
├── providers/
│   ├── ollama.ts         # Ollama (local)
│   ├── openai.ts         # OpenAI
│   ├── anthropic.ts      # Claude
│   └── google.ts         # Gemini
├── cost-tracker.ts       # Token and cost tracking
└── types.ts              # TypeScript types
```

**Example client:**

```typescript
// lib/llm/client.ts
import { OllamaProvider } from './providers/ollama';
import { OpenAIProvider } from './providers/openai';

export class LLMClient {
  private provider: LLMProvider;

  constructor(providerName: string, config: LLMConfig) {
    switch (providerName) {
      case 'ollama':
        this.provider = new OllamaProvider(config);
        break;
      case 'openai':
        this.provider = new OpenAIProvider(config);
        break;
      // ...
    }
  }

  async complete(prompt: string, options?: CompletionOptions): Promise<string> {
    const result = await this.provider.complete(prompt, options);

    if (options?.trackCost) {
      await this.trackUsage(result.usage);
    }

    return result.text;
  }

  async completeJSON(prompt: string, schema: z.ZodSchema): Promise<any> {
    // Use provider's native JSON mode if available
    if (this.provider.supportsNativeJSON) {
      const result = await this.provider.completeJSON(prompt);
      return schema.parse(result);
    }

    // Fallback: robust JSON parsing
    const text = await this.complete(prompt);
    return parseJSONWithRecovery(text, schema);
  }
}
```

**Updates CLAUDE.md:**

```markdown
## AI Integration

**LLM Providers:**
- Ollama (local) - Default for development
- OpenAI - Production fallback

**Usage:**
```typescript
import { LLMClient } from './lib/llm';

const llm = new LLMClient('ollama', {
  model: 'llama2',
  baseURL: 'http://localhost:11434'
});

const response = await llm.complete("Your prompt here");
```

**Cost Tracking:**
Enabled. See usage stats with:
```bash
npm run llm:stats
```
```

### MCP Integration

Setup Model Context Protocol servers:

```bash
/project mcp setup
```

**Prompts:**
1. "Analyze project needs? [y/n]" (Auto-detect suitable servers)
2. "Which MCP servers? (filesystem, github, postgres, ...)"
3. "Add custom server configurations? [y/n]"

**Creates/Updates:**

```json
// claude_desktop_config.json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
    }
  }
}
```

**Auto-Detection Logic:**

```python
def recommend_mcp_servers(project_info):
    recommendations = []

    # Check for database
    if has_file("prisma/schema.prisma") or has_file("drizzle.config.ts"):
        recommendations.append({
            "server": "postgres",
            "reason": "Detected database schema files"
        })

    # Check for git
    if has_dir(".git"):
        recommendations.append({
            "server": "github",
            "reason": "Git repository detected"
        })

    # Check for API integrations
    if has_dependency("stripe"):
        recommendations.append({
            "server": "custom-stripe",
            "reason": "Stripe integration detected"
        })

    return recommendations
```

---

## Capability 6: Status Check

Show comprehensive project health and status.

```bash
/project status
```

**Output:**

```
═══════════════════════════════════════════════════════════════
                      PROJECT STATUS
═══════════════════════════════════════════════════════════════

PROJECT: Habit Tracker
PHASE: Implementation (Phase 3 of 5)
BRANCH: feature/search (2 commits ahead)
LAST SYNC: 6 hours ago

PROGRESS
────────
  ✓ auth           Complete (100%)
  ✓ habits         Complete (100%)
  🔄 search        In Progress (65%)
    ├─ ✓ Backend   Done
    ├─ 🔄 Frontend In Progress
    └─ ○ Tests     Not Started
  ○ notifications  Pending
  ○ charts         Pending

Overall: 3/5 features (60%)

DOCUMENTATION
─────────────
  ✓ Intent         Current (3d ago)
  ✓ UX Journeys    Current (3d ago)
  ✓ Architecture   Current (1w ago)
  ✓ Plans          Current (6h ago)
  ⚠ CLAUDE.md      Outdated (6h ago)

  Action: Run /project sync

PROMISES
────────
  ✓ 4 KEPT
  ⚠ 1 AT_RISK: "Works offline" (needs testing)
  ✗ 0 BROKEN

UX JOURNEYS
───────────
  ✓ 2 IMPLEMENTED: Browse habits, Track completion
  🔄 1 PARTIAL: Search habits (65%)
  ○ 2 NOT_STARTED: Social features, Analytics

TESTS
─────
  ✓ Backend:  87% coverage (target: 80%)
  ✓ Frontend: 72% coverage (target: 70%)
  ✓ E2E:      5 scenarios passing
  ⚠ 1 feature has no tests: search

ENFORCEMENT
───────────
  ✓ Git hook installed (.git/hooks/pre-commit)
  ✓ CI workflow active (.github/workflows/verify.yml)
  ✓ Last CI run: Passed (2 hours ago)

AI INTEGRATION
──────────────
  ✓ LLM: Ollama (llama2) + OpenAI (fallback)
  ✓ MCP: 3 servers active (filesystem, github, postgres)
  ✓ Cost tracking enabled

RECENT ACTIVITY
───────────────
  2h ago  Implemented SearchResults component
  4h ago  Added Elasticsearch integration
  1d ago  Completed habits feature
  2d ago  Completed auth feature

NEXT STEPS
──────────
  1. Complete search frontend (SearchInput, SearchFilters)
  2. Add tests for search feature
  3. Run /project sync to update docs
  4. Merge feature/search to main

═══════════════════════════════════════════════════════════════
```

---

## Integration Points

### With Other Agents

**After intent-guardian:**
```
intent-guardian: Product intent created at docs/intent/product-intent.md

  Suggestion: Run /project setup to initialize infrastructure
```

**After ux-architect:**
```
ux-architect: UX journeys created at docs/ux/user-journeys.md

  Note: /project sync will track implementation status automatically
```

**After implementation-planner:**
```
implementation-planner: Plans created. Ready to build.

  Suggestion: Run /project setup to initialize project structure
  Then use /project status to track progress
```

**Before commits:**
```
You: I'm ready to commit

  Suggestion: Run /project verify to check compliance
  Or just commit - the git hook will verify automatically
```

### With Commands

All `/project` subcommands invoke this agent:

```
/project setup    → project-ops with setup instructions
/project sync     → project-ops with sync instructions
/project verify   → project-ops with verification instructions
/project docs     → project-ops with docs generation instructions
/project ai       → project-ops with AI setup instructions
/project mcp      → project-ops with MCP setup instructions
/project status   → project-ops with status display instructions
```

---

## Error Handling

### Common Issues

**Issue: Verification fails on pre-commit**

```
❌ COMMIT BLOCKED

  Problem: 2 BROKEN promises without justification

  Options:
    a) Fix the broken functionality
    b) Add justification in docs/intent/product-intent.md:

       Status: BROKEN
       Reason: Deprioritized for v1.0, will fix in v1.1

    c) Emergency bypass: git commit --no-verify
```

**Issue: Sync detects significant drift**

```
⚠ SIGNIFICANT DRIFT DETECTED

  10 API endpoints not documented
  3 promises not implemented
  5 UX journeys marked IMPLEMENTED but code not found

  This suggests documentation is out of sync with reality.

  Actions:
    1. Review docs/plans/overview/backend-plan.md
    2. Update docs/intent/product-intent.md promise statuses
    3. Update docs/ux/user-journeys.md journey statuses

  Or run /project sync --force to auto-update everything
```

**Issue: Documentation generation fails**

```
❌ Failed to generate README.md

  Reason: Could not detect project type

  Action: Manually specify in CLAUDE.md:

  ## Project
  Type: node  # or python, go, etc.
  Framework: express  # or fastapi, gin, etc.

  Then retry: /project docs generate readme
```

### Recovery Procedures

**Corrupted state:**

```bash
# Reset to known good state
git checkout main
/project sync --force
/project verify
```

**Missing infrastructure:**

```bash
# Regenerate everything
/project setup --force
# This recreates:
# - scripts/verify.sh
# - .git/hooks/pre-commit
# - .github/workflows/verify.yml
```

---

## Best Practices

### When to Sync

| Trigger | Command | Why |
|---------|---------|-----|
| After implementing feature | `/project sync` | Keep docs current |
| Before committing | `/project verify` | Catch issues early |
| Before PR | `/project sync` + `/project verify` | Ensure quality |
| After breaking changes | `/project sync --force` | Reset state |
| End of day | `/project sync quick` | Update progress |

### Documentation Hygiene

1. **Let automation do its job** - Don't manually update generated docs
2. **Sync frequently** - After every feature, not just at milestones
3. **Trust the verification** - If it passes, your docs are good
4. **Fix drift immediately** - Don't let it accumulate

### Enforcement Philosophy

- **Block critical issues** - Unjustified broken promises, missing required docs
- **Warn on minor issues** - Outdated CLAUDE.md, missing tests
- **Always provide escape hatch** - `--no-verify` for emergencies

---

## Complete Workflow Example

### Starting a New Project

```
You: Build me a habit tracker

Claude: [Creates intent, UX, architecture]

        L1 analysis complete. Ready to build.

        Suggestion: Run /project setup to initialize infrastructure?

You: yes

Claude: [Running project-ops agent]

        Creating project structure...
        ✓ Documentation directories created
        ✓ CLAUDE.md initialized

        Enable enforcement (git hooks + CI)? [y/n]

You: y

Claude: ✓ Git pre-commit hook installed
        ✓ CI workflow created
        ✓ Verification script ready

        Setup LLM integration? [y/n]

You: n

Claude: Setup complete!

        Next: Use /project status to track progress
```

### During Development

```
[After implementing auth feature]

You: Continue

Claude: ✓ Auth feature complete (backend + frontend + tests)

        Suggestion: Run /project sync to update docs

You: /project sync

Claude: [Running sync...]

        ✓ CLAUDE.md updated
        ✓ Feature marked complete in plans
        ✓ Tests recorded (Backend: 85%, Frontend: 70%)

        Ready for next feature: habits

[Implementing habits feature...]

You: [makes changes, tries to commit]

Git Hook: ⚠ WARNING: Code changed but CLAUDE.md not updated
          Consider running: /project sync

          ✓ Pre-commit checks passed

You: git add . && git commit -m "feat: add habits feature"

Git Hook: ✓ Pre-commit checks passed

[Commit succeeds]
```

### Before Milestone

```
You: We're ready to ship v1.0

Claude: Great! Let's verify everything is ready.

You: /project verify

Claude: [Running verification...]

        ═══════════════════════════════════════════
                   PROJECT VERIFICATION
        ═══════════════════════════════════════════

        ✓ Documentation current
        ✓ All promises KEPT or justified
        ✓ All journeys implemented
        ✓ Tests passing (87% coverage)

        ✓ READY TO SHIP

        ═══════════════════════════════════════════
```

---

## Git Workflow

project-ops handles git conventions and workflow integration.

### Commit Conventions

Use conventional commit format for clear history:

**Format:** `<type>: <description>`

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat: add user authentication` |
| `fix` | Bug fix | `fix: resolve login timeout issue` |
| `refactor` | Code restructuring (no behavior change) | `refactor: extract validation logic` |
| `docs` | Documentation only | `docs: update API reference` |
| `test` | Add/update tests | `test: add unit tests for auth` |
| `chore` | Maintenance (deps, config) | `chore: update dependencies` |

**Examples:**
```bash
feat: add password reset flow
fix: handle null user in dashboard
refactor: simplify database queries
docs: add deployment guide
test: add integration tests for checkout
chore: upgrade to Node 20
```

### Branch Naming

Use descriptive, type-prefixed branch names:

**Format:** `<type>/<short-description>`

**Examples:**
```bash
feature/user-authentication
feature/password-reset
fix/login-timeout
fix/null-user-crash
refactor/database-layer
refactor/extract-validators
docs/api-reference
test/integration-suite
```

**Guidelines:**
- Use lowercase with hyphens
- Keep description short (2-4 words)
- Match commit type when possible
- Use `feature/` for new capabilities
- Use `fix/` for bug fixes
- Use `refactor/` for code improvements

### Workflow

**Standard Flow:**
```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes, commit with convention
git add .
git commit -m "feat: add my feature"

# 3. Push to remote
git push -u origin feature/my-feature

# 4. Create PR
# (via GitHub UI or /project pr if GitHub MCP is configured)
```

**Using project-ops helpers:**
```bash
# Guided conventional commit
/project commit

# Push current branch
/project push

# Create PR (requires GitHub MCP)
/project pr
```

### Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/project commit [message]` | Create conventional commit (guided if no message) | `/project commit` |
| `/project push` | Push current branch to remote | `/project push` |
| `/project pr` | Create pull request (requires GitHub MCP) | `/project pr` |

### Commit Helper

When user runs `/project commit`, guide them through conventional commit:

**If message provided:**
```bash
/project commit "add user auth"

Claude: Creating commit with conventional format...

        Type: feat, fix, refactor, docs, test, or chore?

You: feat

Claude: [Runs git commit -m "feat: add user auth"]
        ✓ Committed: feat: add user auth
```

**If no message:**
```bash
/project commit

Claude: Let's create a conventional commit.

        What type of change is this?
        1. feat - New feature
        2. fix - Bug fix
        3. refactor - Code restructuring
        4. docs - Documentation
        5. test - Tests
        6. chore - Maintenance

You: 1

Claude: Describe the change (short, imperative):

You: add user authentication

Claude: [Runs git commit -m "feat: add user authentication"]
        ✓ Committed: feat: add user authentication
```

**Smart defaults:**
- If only docs changed → suggest `docs:`
- If tests/ changed → suggest `test:`
- If package.json changed → suggest `chore:`
- Otherwise → ask user

### PR Helper

When user runs `/project pr`, create pull request:

**With GitHub MCP (recommended):**
```bash
/project pr

Claude: Creating pull request...

        [Reads recent commits on branch]
        [Generates PR title from commits]
        [Generates PR body from changes]

        Title: Add user authentication
        Body:
        ## Changes
        - Implemented login/logout flow
        - Added JWT token handling
        - Created auth middleware

        ## Testing
        - Added unit tests for auth service
        - Tested login/logout manually

        Create PR? [y/n]

You: y

Claude: [Uses GitHub MCP to create PR]
        ✓ PR created: https://github.com/user/repo/pull/123
```

**Without GitHub MCP:**
```bash
/project pr

Claude: To create a PR, I need the GitHub MCP server.

        Setup GitHub MCP? [y/n]

You: n

Claude: No problem. To create PR manually:

        1. Push your branch:
           git push -u origin feature/my-feature

        2. Visit GitHub:
           https://github.com/user/repo/compare/feature/my-feature

        3. Or use GitHub CLI:
           gh pr create --title "Add user authentication" --body "..."

        Want me to push the branch for you? [y/n]
```

**Implementation:**
```typescript
// When /project pr is invoked
async function handleProjectPR() {
  // Check if GitHub MCP is available
  const hasMCP = await checkMCPServer('github');

  if (hasMCP) {
    // Use MCP to create PR
    const commits = await git.log(['main..HEAD']);
    const title = generatePRTitle(commits);
    const body = generatePRBody(commits);

    await github.createPR({ title, body });
  } else {
    // Offer to setup MCP or show manual instructions
    askToSetupMCP() || showManualInstructions();
  }
}
```

### Git Workflow Philosophy

1. **Conventional commits** → Clear, searchable history
2. **Descriptive branches** → Easy to track parallel work
3. **Guided helpers** → Reduce cognitive load
4. **MCP integration** → Streamline PR creation
5. **Always optional** → Users can use raw git if preferred

---

## Summary

This agent provides comprehensive project operations:

1. **Setup** - Initialize infrastructure correctly
2. **Sync** - Keep docs and code in sync automatically
3. **Verify** - Catch issues before they ship
4. **Docs** - Generate documentation from code
5. **AI** - Setup LLM/MCP integration
6. **Status** - Always know project health
7. **Git Workflow** - Conventional commits, branches, PRs

**Core Philosophy:** Automation catches drift, humans maintain quality.
