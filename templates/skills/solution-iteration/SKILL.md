---
name: solution-iteration
description: Multi-approach evaluation and refinement using LLM judges for iterative solution optimization
---

# Solution Iteration Skill

This skill enables systematic comparison of multiple approaches using diverse LLM perspectives as judges, facilitating convergence on optimal solutions.

## Core Principles

### 1. Multi-Dimensional Evaluation
Solutions are not simply "better" or "worse" - they excel in different dimensions:
- **User Experience**: Intuitiveness, delight, friction
- **Technical Merit**: Performance, maintainability, scalability
- **Business Value**: ROI, time-to-market, differentiation
- **Accessibility**: Inclusivity, device support, localization
- **Innovation**: Novelty, future-proofing, paradigm shifts

### 2. Diverse Judge Personas
Different perspectives reveal different strengths:

**The Pragmatist**
- Focus: Does it work reliably?
- Values: Simplicity, proven patterns, maintainability
- Red flags: Over-engineering, bleeding-edge dependencies

**The Innovator**
- Focus: Is this pushing boundaries?
- Values: Novel approaches, emerging patterns, differentiation
- Red flags: Me-too solutions, missed opportunities

**The User Advocate**
- Focus: Will users love this?
- Values: Intuitive flows, delightful moments, accessibility
- Red flags: Cognitive load, hidden complexity, exclusion

**The Business Strategist**
- Focus: Does this drive value?
- Values: ROI, competitive advantage, market fit
- Red flags: Feature creep, unclear value prop, high TCO

**The Technical Architect**
- Focus: Will this scale and evolve?
- Values: Clean architecture, performance, extensibility
- Red flags: Tech debt, bottlenecks, rigid coupling

**The Security Auditor**
- Focus: Is this safe and compliant?
- Values: Defense in depth, privacy, compliance
- Red flags: Attack surfaces, data leaks, regulatory gaps

### 3. Evaluation Protocol

#### Phase 1: Approach Documentation
Before evaluation, each approach needs clear documentation:
```markdown
## Approach [A/B/C]

### Core Concept
[1-2 sentences describing the key idea]

### Key Decisions
- Decision 1: [what and why]
- Decision 2: [what and why]
- Decision 3: [what and why]

### Trade-offs Accepted
- Gained: [benefits]
- Sacrificed: [costs]

### Implementation Sketch
[Code/mockup/architecture as appropriate]
```

#### Phase 2: Independent Evaluation
Each judge evaluates independently on their dimension:

```markdown
## Judge: [Persona Name]

### Strengths (What works well)
- Strength 1: [specific observation]
- Strength 2: [specific observation]
- Strength 3: [specific observation]

### Concerns (What could be problematic)
- Concern 1: [specific issue + impact]
- Concern 2: [specific issue + impact]
- Concern 3: [specific issue + impact]

### Missing Elements
- Element 1: [what's not addressed]
- Element 2: [what's not addressed]

### Score: X/10
### Recommendation: [Adopt/Adapt/Reject]
```

#### Phase 3: Synthesis
Aggregate evaluations into insights:

```markdown
## Synthesis Report

### Consensus Strengths
[Elements praised by multiple judges]

### Consensus Concerns
[Issues raised by multiple judges]

### Divergent Views
[Where judges disagree and why]

### Unexpected Insights
[Surprising observations from evaluation]

### Hybrid Opportunity
Could we combine:
- [Best element from A]
- [Best element from B]
- [Novel element suggested by judges]

### Recommended Path Forward
[Specific actionable recommendation]
```

#### Phase 4: Refinement
Create refined approach incorporating insights:

```markdown
## Refined Approach

### Incorporates From A
- [Element and why]

### Incorporates From B
- [Element and why]

### Novel Additions
- [New element based on judge feedback]

### Deliberately Omits
- [What we're not including and why]

### Implementation Plan
1. [First step]
2. [Second step]
3. [Third step]
```

## Iteration Patterns

### Pattern 1: Quick Iteration (2 approaches)
```
User: "Should I use tabs or accordion for settings?"

1. Implement both approaches minimally
2. Run 3 judges (Pragmatist, User Advocate, Technical Architect)
3. Get recommendation
4. Implement recommended approach fully
```

### Pattern 2: Design Space Exploration (3-5 approaches)
```
User: "How should we handle user onboarding?"

1. Generate multiple distinct approaches
2. Create low-fi prototypes/descriptions
3. Run all 6 judges
4. Synthesize into 2 refined candidates
5. Prototype refined candidates
6. Run focused evaluation
7. Implement winner with best-of elements
```

### Pattern 3: Progressive Refinement
```
User: "Optimize this checkout flow"

Round 1: Evaluate current vs. quick redesign
Round 2: Refine winner vs. new challenger
Round 3: Polish winner vs. final alternative
→ Convergence on optimal solution
```

### Pattern 4: A/B/n Testing
```
User: "Test these 4 homepage variants"

1. Document each variant's hypothesis
2. Run all judges on all variants
3. Create evaluation matrix
4. Identify winning elements from each
5. Synthesize "best of all" variant
6. Validate synthesis vs. original winner
```

## Implementation Guidelines

### 1. Approach Generation
When user provides only one approach, generate alternatives:

**Techniques:**
- **Inversion**: Flip core assumptions
- **Analogy**: Borrow patterns from other domains
- **Extremes**: Push dimension to limit (simplest vs. most powerful)
- **Combination**: Merge different patterns
- **Subtraction**: Remove assumed requirements

### 2. Judge Configuration
Adjust judges based on context:

**For Consumer Apps:**
- Emphasize User Advocate
- Add Accessibility Advocate
- Include Joy Specialist

**For Enterprise:**
- Emphasize Business Strategist
- Add Compliance Officer
- Include Integration Architect

**For Developer Tools:**
- Emphasize Technical Architect
- Add Developer Experience (DX) Expert
- Include Documentation Critic

### 3. Evaluation Criteria
Customize based on project priorities:

**Performance-Critical:**
```python
weights = {
    "latency": 0.3,
    "throughput": 0.3,
    "resource_usage": 0.2,
    "scalability": 0.2
}
```

**UX-Critical:**
```python
weights = {
    "intuitiveness": 0.3,
    "delight": 0.2,
    "accessibility": 0.2,
    "efficiency": 0.2,
    "learnability": 0.1
}
```

### 4. Synthesis Strategies

**Weighted Scoring:**
```python
def calculate_score(evaluations, weights):
    total = 0
    for judge, score in evaluations.items():
        weight = weights.get(judge.expertise, 0.1)
        total += score * weight
    return total
```

**Veto System:**
- Security Auditor can veto on critical vulnerabilities
- Accessibility Advocate can veto on exclusion
- Business Strategist can veto on negative ROI

**Consensus Building:**
- Require 4/6 judges to approve
- Must include at least one from each category (UX, Tech, Business)

### 5. Documentation Templates

**Comparison Matrix:**
```markdown
| Criterion | Approach A | Approach B | Winner | Rationale |
|-----------|------------|------------|---------|-----------|
| Speed     | 200ms      | 150ms      | B       | 25% faster |
| Simplicity| High       | Medium     | A       | Fewer deps |
| Innovation| Low        | High       | B       | Novel UX   |
```

**Decision Record:**
```markdown
## Decision: [What we chose]
## Date: [When]
## Approaches Considered: [List]
## Evaluation Method: [Judges used]
## Key Factors: [What mattered most]
## Trade-offs Accepted: [What we gave up]
## Revisit Trigger: [When to reconsider]
```

## Command Interface

### Basic Comparison
```
/iterate compare "Approach A: [description]" "Approach B: [description]"
```

### Full Evaluation
```
/iterate evaluate --approaches="A,B,C" --judges="all" --context="enterprise"
```

### Progressive Refinement
```
/iterate refine --current="implementation.tsx" --iterations=3
```

### Quick Decision
```
/iterate quick "Should I use hooks or class components?"
```

## Integration with Workflow

### During L1 Planning
When UX-architect generates journeys, could generate alternatives:
```
/iterate evaluate --phase="ux" --approaches="generated-journeys.md"
```

### During L2 Building
When implementing features, compare approaches:
```
/iterate compare --feature="auth" --approaches="jwt,session,oauth"
```

### During Gap Resolution
When fixing issues, evaluate solutions:
```
/iterate evaluate --gap="performance" --solutions="cache,optimize,redesign"
```

## Success Metrics

### Convergence Speed
- Iterations needed to reach consensus
- Time from problem to refined solution

### Decision Quality
- Regression rate (revisiting decisions)
- Stakeholder satisfaction
- Post-implementation validation

### Coverage
- Blind spots identified by judges
- Novel solutions generated
- Trade-offs explicitly documented

## Common Pitfalls

### 1. Analysis Paralysis
**Solution**: Time-box evaluations, set "good enough" thresholds

### 2. Judge Bias
**Solution**: Rotate judge emphasis, use contrarian judges

### 3. Local Maxima
**Solution**: Force exploration of radical alternatives

### 4. Context Loss
**Solution**: Maintain decision records with full context

### 5. Over-Optimization
**Solution**: Define "done" criteria upfront

## Examples

### Example 1: Form Validation Approach
```markdown
Approach A: Client-side only (fast, simple)
Approach B: Server-side only (secure, consistent)
Approach C: Hybrid (optimal UX + security)

Evaluation reveals C is ideal but complex.
Refinement: Simplified hybrid with progressive enhancement.
```

### Example 2: State Management
```markdown
Approach A: Context API (simple, built-in)
Approach B: Redux (powerful, ecosystem)
Approach C: Zustand (middle ground)

Evaluation reveals A sufficient for current scale.
Decision: Start with A, document migration path to C.
```

### Example 3: API Design
```markdown
Approach A: REST (standard, tooling)
Approach B: GraphQL (flexible, efficient)
Approach C: tRPC (type-safe, modern)

Evaluation reveals team expertise favors A.
Refinement: REST with GraphQL-like field selection.
```

## The Iteration Loop

```
DEFINE PROBLEM
    ↓
GENERATE APPROACHES (2-5)
    ↓
DOCUMENT EACH APPROACH
    ↓
RUN JUDGE EVALUATIONS
    ↓
SYNTHESIZE INSIGHTS
    ↓
[Consensus?] → YES → IMPLEMENT
    ↓ NO
REFINE APPROACHES
    ↓
[Loop or timeout?] → LOOP → DOCUMENT EACH
    ↓ TIMEOUT
PICK BEST AVAILABLE → IMPLEMENT
```

This systematic approach ensures decisions are well-considered, trade-offs are explicit, and the best ideas from multiple approaches are captured in the final solution.