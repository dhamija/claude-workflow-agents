---
description: Debug errors, test failures, or UI issues
argument-hint: [ui | console | network | visual | responsive | <error description>]
---

Debug backend code, tests, or frontend UI issues.

## Backend/Test Debugging

If first argument is NOT a UI mode (ui, console, network, visual, responsive):

Use debugger subagent to investigate and fix:

### Issue

$ARGUMENTS

### Process

1. Gather information:
   - Find exact error message/stack trace
   - Identify reproduction steps
   - Check recent changes

2. Reproduce the issue:
   - Run failing test or trigger error
   - Confirm consistent reproduction

3. Investigate systematically:
   - Form hypotheses
   - Test each one
   - Add debug logging if needed

4. Identify root cause:
   - Explain WHY it happens
   - Confirm explanation matches all symptoms

5. Implement minimal fix:
   - Change only what's necessary
   - Don't refactor while debugging

6. Verify fix:
   - Original issue resolved
   - No regressions

7. Add regression test:
   - Prevent recurrence

8. Clean up:
   - Remove debug logging

### Output

Produce debug report with:
- Issue description
- Investigation steps
- Root cause analysis
- Fix implemented
- Verification results
- Regression test added

Commit fix: `fix([scope]): [description of bug fixed]`

---

## UI Debugging (with Browser MCP)

If first argument is a UI mode: `ui`, `console`, `network`, `visual`, or `responsive`

Launch `ui-debugger` subagent with browser automation.

### `/debug ui [url]`

Full UI debugging session:
- Navigate to URL
- Take screenshot
- Capture console
- Inspect DOM
- Report findings

Example:
```
/debug ui http://localhost:3000/dashboard

Claude: Starting UI debug session...
        [Navigates, screenshots, reports]
```

### `/debug console [url]`

Capture and analyze console output:
- Errors
- Warnings
- Logs

Example:
```
/debug console http://localhost:3000

Claude: Monitoring console...
        Errors: 2
        Warnings: 5
```

### `/debug network [url]`

Monitor network requests:
- Request/response status
- Failed requests
- Slow requests (>1s)

Example:
```
/debug network http://localhost:3000/api-test

Claude: Monitoring network...
        Requests: 8
        Failed: 1 (404 /api/missing)
```

### `/debug visual [url]`

Visual regression check:
- Compare to baseline
- Show differences

Example:
```
/debug visual http://localhost:3000

Claude: Comparing to baseline...
        Differences found in 1 page
```

### `/debug responsive [url]`

Test responsive layouts:
- Desktop (1920px)
- Tablet (768px)
- Mobile (375px)

Example:
```
/debug responsive http://localhost:3000

Claude: Testing viewports...
        Desktop: ✓
        Tablet: ✓
        Mobile: ✗ Layout broken
```

### Requirements

Browser MCP server required for UI debugging:
- `puppeteer` (recommended)
- `browserbase` (cloud)

Check status: `/project ai mcp`

---

## Examples

### Backend Error
```
/debug TypeError: Cannot read property 'id' of undefined

Claude: [Uses debugger agent]
        [Finds root cause]
        [Implements fix]
```

### UI Issue
```
/debug ui http://localhost:3000/form

Claude: [Uses ui-debugger agent]
        [Takes screenshot]
        [Finds button type="button" should be type="submit"]
        [Suggests fix]
```

### Console Errors
```
/debug console http://localhost:3000

Claude: [Captures console]
        Error: Failed to fetch
        at fetchUser (api.ts:45)
        [Analyzes and suggests fix]
```
