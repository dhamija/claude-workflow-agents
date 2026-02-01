---
description: Create explicit workflow plan before implementation
argument-hint: <task description>
---

# Workflow Planning

**Command:** `/workflow-plan <task description>`

**Purpose:** Forces planning-first approach by creating explicit workflow execution plan

---

## MANDATORY: Use This Before ANY Implementation

**When user requests a feature/change, ALWAYS run this command first:**

```bash
/workflow-plan "add knowledge graph visualization"
```

## What It Does

1. **Analyzes request against workflow system**
2. **Creates step-by-step plan using workflow commands**
3. **Shows plan to user for approval**
4. **Tracks execution state**

## Output Format

```markdown
# Workflow Plan: Knowledge Graph Visualization

## Analysis Phase
1. `/intent-audit "knowledge graph"` - Check if aligns with promises
2. Load `ux-design` skill - Design multi-panel UI
3. `/gap` - Identify missing capabilities

## Planning Phase
4. `/change "add knowledge graph"` - Analyze impact
5. `/plan --update` - Update implementation plans

## Implementation Phase
6. `/implement backend` - Build graph data structures
7. `/implement frontend` - Build visualization UI
8. `/test-ui` - Run LLM user testing

## Validation Phase
9. `/verify` - Validate promises kept
10. `/reality-audit` - Confirm real functionality

## State Tracking
- [ ] Step 1: Intent audit
- [ ] Step 2: UX design
...

Approve this plan? (y/n)
```

## Execution Tracking

After approval, tracks in CLAUDE.md:

```yaml
workflow_plan:
  created: "2024-01-30T10:00:00Z"
  task: "add knowledge graph visualization"
  steps_total: 10
  steps_completed: 3
  current_step: 4
  current_command: "/change"
  blocked: false
  blockers: []
```

## Examples

### Feature Addition
```bash
/workflow-plan "add user authentication"
# Creates L1→L2 workflow plan
```

### Bug Fix
```bash
/workflow-plan "fix validation errors"
# Creates debugging workflow plan
```

### Performance Improvement
```bash
/workflow-plan "optimize database queries"
# Creates gap analysis → improvement plan
```

## Benefits

1. **Prevents ad-hoc coding** - Must plan first
2. **Shows complete workflow** - User sees all steps
3. **Tracks progress** - Know where you are
4. **Ensures completeness** - Nothing gets skipped
5. **Documents approach** - Plan becomes documentation

## Integration with TodoWrite

Automatically creates todos:

```
TodoWrite creates:
- [ ] Run /intent-audit
- [ ] Load ux-design skill
- [ ] Run /gap analysis
- [ ] Run /improve --severity=critical
- [ ] Run /verify
```

## Failure Recovery

If execution fails:
- Plan remains in CLAUDE.md
- Can resume from last successful step
- Blockers documented for user

## Related Commands

- `/workflow` - Overall workflow management
- `/status` - Check workflow status
- `/next` - Continue workflow execution