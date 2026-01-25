<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/agent-wf-help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
name: docs
description: Manage project documentation - verify completeness, update, or generate
argument-hint: "[verify | update | generate | status]"
---

# Documentation Management

Manage project documentation with the documentation-engineer agent.

---

## Usage

```
/docs              # Default: verify documentation
/docs verify       # Check documentation completeness
/docs update       # Update docs from current code
/docs generate     # Generate all documentation
/docs status       # Quick status
```

---

## Actions

### (default) or "verify"

Check documentation completeness:
- All features documented in USAGE.md?
- All endpoints in API docs?
- All components in architecture?
- All examples working?

**Launches:** documentation-engineer in verification mode

**Example output:**
```
Documentation Verification
══════════════════════════

USAGE.md
  ✓ Overview complete
  ✓ Getting Started complete
  ⚠ Features: 3/5 documented
  ✓ Configuration complete
  ○ Troubleshooting: empty

API Documentation
  ✓ Auth endpoints: 3/3
  ⚠ Recipe endpoints: 4/6
  ○ Search endpoints: 0/3

Architecture
  ✓ Overview complete
  ✓ Components documented
  ⚠ Decisions: 2 undocumented

Overall: 65% complete

Missing documentation:
  - USAGE.md: search feature, dashboard feature
  - API: GET /search, POST /search/advanced
  - Architecture: Caching decision, AI model decision

Run /docs update to generate missing sections.
```

---

### "update"

Update documentation based on current code:
- Scan implemented features
- Update USAGE.md with missing features
- Update API docs with new endpoints
- Update architecture if changed
- Add examples for completed features

**Launches:** documentation-engineer in update mode

**Example output:**
```
Documentation updated ✓

USAGE.md
  + Added "Search" feature documentation
  + Added 3 usage examples
  + Added search configuration

docs/api/README.md
  + Added GET /api/search endpoint
  + Added POST /api/search/advanced endpoint
  + Added request/response examples

All updates based on current implementation ✓
```

---

### "generate"

Generate documentation from scratch:
- Create all doc files if missing
- Populate from intent, UX, and architecture docs
- Create skeletons for unimplemented features
- Generate API docs from code

**Launches:** documentation-engineer in generation mode

**When to use:**
- New project after L1 planning
- Documentation was deleted/lost
- Major refactor requiring doc rebuild

**Example output:**
```
Documentation generated ✓

Created:
  README.md              - Project overview
  USAGE.md               - Usage guide (skeleton)
  docs/api/README.md     - API documentation
  docs/guides/
    developer-guide.md   - Developer guide
    deployment-guide.md  - Deployment guide

Populated from:
  /docs/intent/product-intent.md
  /docs/ux/user-journeys.md
  /docs/architecture/

Run /docs verify to check completeness.
```

---

### "status"

Quick documentation status:

**Example output:**
```
Documentation Status
════════════════════

USAGE.md:     80% complete
API Docs:     60% complete
Architecture: 90% complete
Guides:       70% complete

Run /docs verify for details.
```

---

## Integration

### Auto-Generated After L1

After implementation-planner completes:
```
You: [Finish L1 planning]

implementation-planner:
  Plans created ✓

  Launching documentation-engineer...

documentation-engineer:
  Documentation structure created ✓

  README.md, USAGE.md, API docs initialized.
  Will be populated as features are built.
```

---

### Updated During L2

After features are implemented:
```
You: "Document the search feature"

documentation-engineer:
  Search feature documented ✓

  USAGE.md: Added search section with examples
  API docs: Added 3 search endpoints
```

---

### Verified Before Release

```
You: /docs verify

documentation-engineer:
  Documentation: 95% complete

  Missing:
  - USAGE.md: 1 FAQ entry
  - Deployment guide: Monitoring setup

  Ready for release after these additions.
```

---

## What Gets Documented

### USAGE.md
- Overview and features
- Installation and quick start
- Every feature with examples
- Every user journey step-by-step
- Configuration options
- Troubleshooting common issues
- FAQ

### README.md
- Project overview (1-2 paragraphs)
- Key features list
- Quick start (5 minutes to running)
- Link to full documentation
- Architecture overview
- Development setup

### /docs/api/
- All API endpoints
- Request/response schemas
- Examples for each endpoint
- Error codes
- Authentication
- Rate limiting

### /docs/guides/developer-guide.md
- Development environment setup
- Project structure
- Development workflow
- Testing
- Debugging

### /docs/guides/deployment-guide.md
- Deployment options
- Environment configuration
- Production checklist
- Monitoring
- Rollback procedure

---

## Natural Language Triggers

You can also just ask:
- "Document the API"
- "Update the usage guide"
- "Is documentation complete?"
- "Generate README"
- "What's missing from docs?"

Claude will recognize these and run the documentation-engineer.

---

## Tips

1. **Run after L1 planning** - Get doc structure early
2. **Run after each feature** - Keep docs current
3. **Run before release** - Verify completeness
4. **Test all examples** - Ensure commands actually work

---

## See Also

- `documentation-engineer` agent
- `/sync` - Includes documentation completeness check
- `/verify` - Verifies features work (used for doc examples)
