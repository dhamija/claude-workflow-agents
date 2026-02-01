# Iteration Workflow Example

## Scenario
You've built a recipe app (v1.0) with:
- Basic recipe storage
- Search functionality
- Categories
- User accounts

User requests: "Add AI-powered recipe suggestions based on what's in my fridge"

## Smart Detection in Action

### What Happens Now (With Smart Detection)

```bash
# User just runs:
/workflow-plan "AI recipe suggestions"

# System automatically detects:
🔍 Checking for existing artifacts...
✓ Found: docs/intent/product-intent.md (v1.0)
✓ Found: docs/ux/user-journeys.md (v1.0)
✓ Found: docs/architecture/system-design.md (v1.0)
✓ Found: 4 completed features in CLAUDE.md

📊 Detected existing v1.0 system
📈 Recommending ITERATION MODE

This enhancement appears to extend your existing recipe app.
Using iteration mode will:
- Preserve 90% of existing functionality
- Extend rather than replace documentation
- Implement only the new AI features
- Maintain backward compatibility

Use iteration mode? [Y/n]: Y
```

### If User Chooses Wrong Option

```bash
Use iteration mode? [Y/n]: n

⚠️ WARNING: Standard mode will redesign from scratch
- All existing features will be reimplemented
- Risk of breaking changes
- Estimated 8+ weeks vs 3 weeks for iteration
- User workflows may be disrupted

Are you SURE you want to start over? [y/N]: N

✓ Switching to iteration mode as recommended
```

## Old Approach (Before Smart Detection)

```bash
/workflow-plan --iterate "AI recipe suggestions from fridge ingredients"
```

### Generated Iteration Plan

```markdown
# Iteration Plan: AI Recipe Suggestions

## 1. LOAD EXISTING STATE
✓ Intent v1.0: 7 promises (storage, search, categories, accounts)
✓ UX v1.0: 4 user journeys (browse, search, save, organize)
✓ Architecture v1.0: REST API, React, PostgreSQL
✓ Features complete: All core functionality working

## 2. ITERATION ANALYSIS
/iterate-analyze "AI suggestions from ingredients"

Result:
- Compatible with all existing promises ✓
- Extends search journey (non-breaking) ✓
- Architecture supports via new service ✓
- 90% of system unchanged ✓

## 3. EVOLUTIONARY DESIGN

### Intent v2.0
#### Existing Promises (preserved)
P1-P7: [All current promises intact]

#### New Promises (additions)
P8: AI suggests recipes from available ingredients
P9: Suggestions improve based on preferences

### UX v2.0
#### Existing Journeys (preserved)
- Browse, Save, Organize: Unchanged

#### Enhanced Journey
- Search: Now includes "What can I make?" option

#### New Journey
- Fridge-to-Recipe: Input ingredients → Get suggestions

### Architecture v2.0
#### Existing Components (preserved)
- All current services unchanged

#### New Components
- AI Service (separate microservice)
- Suggestion Engine
- Ingredient Parser

## 4. DELTA ANALYSIS
Changes:
- New promises: 2 (P8, P9)
- Modified journeys: 1 (search)
- New journeys: 1 (fridge-to-recipe)
- New components: 3 (ai_service, parser, engine)
- Preserved: 90%
- Breaking changes: NONE

## 5. GAP IDENTIFICATION
/gap --iteration "v1.0 to v2.0"

Created:
- GAP-I-001: Add AI service infrastructure
- GAP-I-002: Create ingredient parser
- GAP-I-003: Build suggestion engine
- GAP-I-004: Add "What can I make?" UI
- GAP-I-005: Integrate with search flow

## 6. IMPLEMENTATION PLAN
Week 1: GAP-I-001 (AI infrastructure)
Week 2: GAP-I-002, GAP-I-003 (Core logic)
Week 3: GAP-I-004, GAP-I-005 (UI integration)

## 7. VALIDATION PLAN
- All v1.0 tests must still pass
- New AI features get own tests
- Performance benchmarks maintained
- User workflows uninterrupted
```

## Results

### With Iteration Workflow
- **Time**: 3 weeks (only building new parts)
- **Risk**: Low (existing features untouched)
- **User Impact**: Seamless upgrade
- **Code Changed**: 10% new, 90% unchanged

### Without Iteration Workflow
- **Time**: 8+ weeks (rebuilding everything)
- **Risk**: High (might break existing features)
- **User Impact**: Potential disruption
- **Code Changed**: 100% touched

## Key Insights

1. **Preservation is Key**: 90% of v1.0 remains untouched
2. **Extension not Replacement**: Documents build on existing versions
3. **Incremental Implementation**: Only gaps get implemented
4. **Backward Compatibility**: All v1.0 features keep working
5. **Risk Mitigation**: Changes isolated to new components

## State Tracking

```yaml
# In CLAUDE.md
workflow:
  mode: iteration
  base_version: "1.0"
  target_version: "2.0"

iteration:
  enhancement: "AI recipe suggestions"
  preserved_percentage: 90
  new_promises: [P8, P9]
  gaps_created: [GAP-I-001 through GAP-I-005]
  backward_compatible: true
  estimated_weeks: 3
  status: in_progress

  completed_gaps:
    - GAP-I-001: ✓ AI service setup

  current_gap: GAP-I-002

  next_gaps:
    - GAP-I-003
    - GAP-I-004
    - GAP-I-005
```

## Commands Used During Iteration

```bash
# Day 1: Planning
/workflow-plan --iterate "AI suggestions"

# Day 2: Analysis
/iterate-analyze "fridge ingredients to recipes"

# Day 3-5: Design Evolution
/intent --evolve "AI suggestions"
/ux --evolve "ingredient input flow"
/architect --evolve "AI service"

# Week 1: Implementation
/improve GAP-I-001
/verify GAP-I-001

# Week 2: Core Features
/improve GAP-I-002
/improve GAP-I-003
/verify --iteration  # Check no regression

# Week 3: UI Integration
/improve GAP-I-004
/improve GAP-I-005

# Final: Validation
/verify --all
/reality-audit  # Ensure everything works
/llm-user test  # User experience validation
```

## Conclusion

The Iteration Workflow enables **evolution without revolution**, letting you enhance systems while preserving what works. This reduces risk, saves time, and ensures users have a smooth upgrade experience.