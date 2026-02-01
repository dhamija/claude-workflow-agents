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

1. **Detects existing artifacts automatically**
2. **Chooses appropriate mode (standard vs iteration)**
3. **Creates step-by-step plan using workflow commands**
4. **Shows plan to user for approval**
5. **Tracks execution state**

## Smart Detection

**The command automatically detects if you should use iteration mode:**

```bash
# Check for existing artifacts
if [ -f "docs/intent/product-intent.md" ] && \
   [ -f "docs/ux/user-journeys.md" ] && \
   [ -f "docs/architecture/system-design.md" ]; then
   # Artifacts exist - suggest iteration mode
   echo "📊 Detected existing v1.0 artifacts"
   echo "📈 Recommending ITERATION mode to preserve existing functionality"
   echo ""
   echo "Use iteration mode? (preserves 80-90% of existing system) [Y/n]"
fi
```

**Detection triggers when:**
- L1 artifacts exist (intent, ux, architecture)
- CLAUDE.md shows completed features
- Previous version documented

**User can override:**
```bash
# Force standard mode even with existing artifacts
/workflow-plan --force-standard "complete redesign"

# Accept smart recommendation
/workflow-plan "add AI features"  # Auto-detects and suggests iteration
```

## Modes

### Standard Mode (New Features)
```bash
/workflow-plan "add knowledge graph"
```

### Iteration Mode (Evolving Existing System)
```bash
/workflow-plan --iterate "enhance with AI suggestions"
```

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
/iterate-analyze "AI suggestions"
- Compatibility check with existing promises
- Impact on current user journeys
- Architecture extension points

## 3. EVOLUTIONARY DESIGN
/intent --evolve "AI suggestions"     # Creates Intent v2.0
/ux --evolve "AI suggestions"         # Creates UX v2.0
/architect --evolve "AI suggestions"  # Creates Architecture v2.0

## 4. DELTA ANALYSIS
/delta-analysis v1.0 v2.0
- New promises: [list]
- Modified journeys: [list]
- New components: [list]
- Preserved: 85% of existing system

## 5. GAP IDENTIFICATION
/gap --between "v1.0" "v2.0"
- Creates GAP-I-XXX (iteration gaps)

## 6. IMPLEMENTATION PLAN
/plan --incremental
- Preserve: [unchanged components]
- Evolve: [modified components]
- Create: [new components]

## 7. EXECUTE CHANGES
/improve GAP-I-001
/improve GAP-I-002
...

## 8. VALIDATION
/verify --iteration
- Existing features still work
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