---
description: Evaluate multiple approaches using LLM judges to find optimal solutions
---

# Iterate Command

This command helps you systematically compare different approaches to solve a problem using multiple LLM perspectives as judges.

## When Claude receives this command:

### 1. Parse the command format

The command supports multiple formats:

**Quick comparison (2 approaches):**
```
/iterate "Should I use [A] or [B]?"
```

**Detailed comparison:**
```
/iterate compare
Approach A: [description or code]
Approach B: [description or code]
```

**Multi-approach evaluation:**
```
/iterate evaluate
- Approach A: [description]
- Approach B: [description]
- Approach C: [description]
```

**Progressive refinement:**
```
/iterate refine [current-implementation]
```

**With options:**
```
/iterate --judges="pragmatist,innovator,user" --context="consumer-app"
```

### 2. Load the solution-iteration skill

Load the skill to access evaluation methodology:
```
Loading skill: solution-iteration
```

### 3. Generate missing approaches (if needed)

If user provides only one approach, generate 2-3 alternatives using:
- **Inversion**: Opposite approach
- **Simplification**: Minimal version
- **Enhancement**: Maximal version
- **Analogy**: Pattern from another domain

### 4. Document each approach

Create clear documentation for each approach:
```markdown
## Approach [Name]

### Core Concept
[1-2 sentence description]

### Implementation
[Code snippet or detailed description]

### Key Trade-offs
- Pros: [benefits]
- Cons: [limitations]
```

### 5. Run judge evaluations

For each approach, simulate evaluations from different judge personas:

**Default judges** (pick 3-5 based on context):
- The Pragmatist (simplicity, reliability)
- The Innovator (novelty, future-proofing)
- The User Advocate (UX, accessibility)
- The Business Strategist (ROI, value)
- The Technical Architect (scalability, quality)
- The Security Auditor (safety, compliance)

Each judge provides:
```markdown
### Judge: [Name]
Strengths: [what works]
Concerns: [what doesn't]
Score: X/10
Recommendation: [Adopt/Adapt/Reject]
```

### 6. Synthesize insights

Aggregate all evaluations:
```markdown
## Consensus Strengths
[What most judges liked]

## Consensus Concerns
[What most judges worried about]

## Unique Insights
[Surprising observations]

## Recommended Approach
[Which approach or hybrid to pursue]
```

### 7. Generate refinement (if applicable)

If no approach scores >7/10, generate a refined approach:
```markdown
## Refined Approach

Combines:
- [Best element from A]
- [Best element from B]
- [Addresses main concerns]

Implementation:
[Concrete plan]
```

### 8. Create decision record

Document the decision for future reference:
```markdown
## Decision Record

Date: [today]
Problem: [what we're solving]
Approaches evaluated: [list]
Winner: [chosen approach]
Rationale: [why]
Trade-offs accepted: [what we gave up]
```

## Command Variations

### Quick decision mode
```
/iterate quick "hooks vs class components"
```
→ Fast 2-approach comparison with 2 judges

### Full evaluation mode
```
/iterate full
```
→ Comprehensive evaluation with all judges and synthesis

### Domain-specific mode
```
/iterate --domain="enterprise"
```
→ Adjusts judges and criteria for domain

### Progressive mode
```
/iterate progressive
```
→ Keeps refining until score >8/10 or 3 iterations

## Integration with Workflow

### During planning (L1)
Use to evaluate different architectural approaches:
```
/iterate "microservices vs monolith vs serverless"
```

### During building (L2)
Use to compare implementation strategies:
```
/iterate "pagination vs infinite-scroll vs virtual-scroll"
```

### During debugging
Use to evaluate fix approaches:
```
/iterate "retry-logic vs circuit-breaker vs rate-limiting"
```

### During gap resolution
Use to compare solutions:
```
/iterate "refactor vs rewrite vs patch"
```

## Output Format

Always provide:
1. **Comparison table** - Quick visual reference
2. **Detailed evaluations** - Full judge feedback
3. **Synthesis** - Key insights
4. **Recommendation** - Clear action item
5. **Decision record** - For documentation

Example output:
```markdown
## Comparison Results

| Approach | Pragmatist | Innovator | User Advocate | Overall |
|----------|------------|-----------|---------------|---------|
| Tabs     | 8/10       | 5/10      | 9/10          | 7.3/10  |
| Accordion| 7/10       | 6/10      | 7/10          | 6.7/10  |
| Hybrid   | 9/10       | 8/10      | 8/10          | 8.3/10  |

**Recommendation**: Implement Hybrid approach

### Hybrid Approach
Tabs on desktop (better UX for space), Accordion on mobile (better for scrolling).

### Next Steps
1. Implement responsive tab/accordion component
2. Test on various screen sizes
3. Validate with user testing
```

## Common Patterns

### Pattern: Feature Flag Decision
```
/iterate "gradual rollout vs big-bang vs beta program"
```

### Pattern: Performance Optimization
```
/iterate "caching vs indexing vs denormalization"
```

### Pattern: Error Handling
```
/iterate "try-catch vs result-types vs error-boundaries"
```

### Pattern: Data Fetching
```
/iterate "REST vs GraphQL vs tRPC"
```

## Tips

1. **Be specific** - Include context about constraints
2. **Consider scale** - What works at 100 users may not at 10,000
3. **Time-box** - Don't iterate more than 3 rounds
4. **Document why** - Record not just what, but why
5. **Revisit** - Set triggers for re-evaluation

## Error Handling

If approaches are too vague:
```
"Need more detail. Please provide:
- Specific implementation approach
- Key technical decisions
- Main trade-offs"
```

If context is missing:
```
"What type of project is this?
- Consumer app
- Enterprise software
- Developer tool
- Other: [specify]"
```

If no clear winner:
```
"No approach scored >7/10.
Generating hybrid approach...
Or would you like to explore different alternatives?"
```

## Integration with Other Commands

Works well with:
- `/design` - Evaluate design system choices
- `/implement` - Compare implementation approaches
- `/gap` - Evaluate fix strategies
- `/ux` - Compare UX patterns
- `/audit` - Evaluate refactoring approaches

## Success Criteria

The iteration is successful when:
1. Clear winner identified (>8/10 score)
2. Trade-offs are explicit and acceptable
3. Implementation path is clear
4. Decision is documented
5. Stakeholders understand rationale