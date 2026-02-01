---
description: Create explicit workflow plan before implementation
argument-hint: <task description>
---

# Workflow Planning

**Command:** `/workflow-plan <task description>`

**Purpose:** Forces planning-first approach by creating explicit workflow execution plan

**CRITICAL FOR ITERATIONS:** When in iteration mode (--iterate), this command will:
1. Invoke agents to regenerate L1 artifacts (intent v2.0, UX v2.0, architecture v2.0)
2. Create incremental implementation plans
3. Generate gaps for future analysis and LLM user testing

---

## MANDATORY: Use This Before ANY Implementation

**When user requests a feature/change, ALWAYS run this command first:**

```bash
/workflow-plan "add knowledge graph visualization"
```

## What It Does

1. **Detects existing artifacts automatically**
2. **Chooses appropriate mode (standard vs iteration)**
3. **Creates step-by-step plan using workflow commands**
4. **Shows plan to user for approval**
5. **Tracks execution state**

## Automatic Mode Detection

**The command AUTOMATICALLY uses the right mode based on project state:**

```bash
# Automatic detection logic:
if [ -f "docs/intent/product-intent.md" ] && \
   [ -f "docs/ux/user-journeys.md" ] && \
   [ -f "docs/architecture/system-design.md" ]; then
   # Existing project → ITERATION MODE (default)
   echo "📊 Detected existing project with L1 artifacts"
   echo "📈 Using ITERATION mode (preserves 80-90% of existing system)"
else
   # New project → STANDARD MODE
   echo "🆕 New project detected"
   echo "📝 Using STANDARD mode (creating from scratch)"
fi
```

**No flags needed - it just works:**
```bash
# Existing project - automatically uses iteration
/workflow-plan "add AI features"        # → Iteration mode

# New project - automatically uses standard
/workflow-plan "build todo app"         # → Standard mode
```

**Override only for special cases:**
```bash
# Force complete redesign (rare)
/workflow-plan --force-standard "complete rewrite"

# Force iteration on partial project (rare)
/workflow-plan --force-iterate "enhance incomplete system"
```

## Modes (Automatically Selected)

### Standard Mode (New Projects - Auto-detected)
Used when no L1 artifacts exist. Creates everything from scratch.

### Iteration Mode (Existing Projects - Auto-detected)
Used when L1 artifacts exist. Evolves the system preserving 80-90% of functionality.

## Output Format (Standard Mode)

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

## Output Format (Iteration Mode)

```markdown
# Iteration Plan: AI Suggestions Enhancement

## 1. LOAD EXISTING STATE
- Intent v1.0: docs/intent/product-intent.md
- UX v1.0: docs/ux/user-journeys.md
- Architecture v1.0: docs/architecture/system-design.md
- Current features: [list from CLAUDE.md]

## 2. ITERATION ANALYSIS
Task: iteration-analyzer "AI suggestions"
- Compatibility check with existing promises
- Impact on current user journeys
- Architecture extension points

## 3. REGENERATE L1 ARTIFACTS (v2.0)
**CRITICAL: These agents will create new versioned artifacts**

Task: intent-guardian with mode=evolve enhancement="AI suggestions"
→ Creates: /docs/intent/product-intent-v2.0.md
→ Preserves: 80-90% of v1.0 promises
→ Adds: New promises for AI features

Task: ux-architect with mode=evolve enhancement="AI suggestions"
→ Creates: /docs/ux/user-journeys-v2.0.md
→ Preserves: 80-90% of v1.0 journeys
→ Adds: New AI interaction patterns

Task: agentic-architect with mode=evolve enhancement="AI suggestions"
→ Creates: /docs/architecture/README-v2.0.md
→ Preserves: 80-90% of v1.0 architecture
→ Adds: New AI service modules

Task: implementation-planner with mode=incremental
→ Creates: /docs/plans/implementation-v2.0.md
→ Preserves: Completed phases
→ Adds: New phase for enhancements

## 4. DELTA ANALYSIS (Automatic)
Each agent outputs delta analysis:
- New promises: [auto-generated]
- Modified journeys: [auto-generated]
- New components: [auto-generated]
- Preservation rate: 85%

## 5. GAP IDENTIFICATION
/gap --between "v1.0" "v2.0"
→ Creates: GAP-I-001 through GAP-I-XXX
→ Based on: Comparing v1.0 vs v2.0 artifacts

## 6. EXECUTE CHANGES
/improve GAP-I-001  # Implement first gap
/improve GAP-I-002  # Implement second gap
...

## 7. VALIDATION
/verify --iteration
- Test v1.0 features still work
- Test v2.0 features work
- No regressions
- New features integrated
- No regressions

Approve iteration plan? (y/n)
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