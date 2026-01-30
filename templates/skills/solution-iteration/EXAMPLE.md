# Solution Iteration Examples

## Example 1: Form Validation Strategy

### User Request
"Should I validate forms on client-side or server-side?"

### Approach Generation
```markdown
## Approach A: Client-Side Only
- Immediate feedback
- No server round-trips
- JavaScript validation rules
- Risk: Security bypass, inconsistency

## Approach B: Server-Side Only
- Single source of truth
- Secure validation
- Database constraint enforcement
- Risk: Poor UX, network latency

## Approach C: Hybrid Progressive
- Client-side for UX feedback
- Server-side for security
- Progressive enhancement
- Risk: Complexity, duplication
```

### Judge Evaluations

**The Pragmatist:**
"Approach A is simple but insecure. Approach B is secure but frustrating. Approach C is the 'right' way but adds complexity. For an MVP, I'd say Approach B with good error messages. Score: B=7/10, C=6/10, A=3/10"

**The User Advocate:**
"Users hate waiting for validation! Approach A gives instant feedback. Approach C is ideal - immediate feedback with security. Approach B will frustrate users. Score: A=8/10, C=9/10, B=4/10"

**The Security Auditor:**
"Approach A is unacceptable - never trust the client. Approach B is secure. Approach C is best IF client validation is purely cosmetic. Score: C=9/10, B=10/10, A=0/10"

### Synthesis
```markdown
## Consensus
- Pure client-side (A) is eliminated - security veto
- Pure server-side (B) technically sound but poor UX
- Hybrid (C) satisfies all concerns if implemented correctly

## Refined Approach
Progressive enhancement hybrid:
1. Server-side validation as foundation (works without JS)
2. Add client-side for enhanced UX (duplicate rules)
3. Use schema validation library (Zod) for shared rules
4. Client shows warnings, server enforces

Implementation:
- Shared validation schema (zod)
- Server middleware for validation
- React Hook Form with zod resolver
- Graceful degradation
```

### Decision
**Choice: Refined Hybrid Approach**
- Satisfies security requirements
- Provides optimal UX
- Manageable complexity with right tools
- Future-proof architecture

---

## Example 2: State Management for React App

### User Request
"I'm building a medium-sized React app. What state management should I use?"

### Approach Generation
```markdown
## Approach A: Context API + useReducer
- Built into React
- No dependencies
- Good TypeScript support
- Risk: Performance at scale

## Approach B: Redux Toolkit
- Industry standard
- Excellent DevTools
- Predictable state updates
- Risk: Boilerplate, learning curve

## Approach C: Zustand
- Minimal boilerplate
- Great DX
- TypeScript friendly
- Risk: Smaller ecosystem

## Approach D: Jotai
- Atomic state management
- React Suspense support
- Fine-grained updates
- Risk: Newer, less proven
```

### Context Provided
"Team of 3 developers, 6-month timeline, e-commerce features"

### Judge Evaluations

**The Pragmatist:**
"For a team of 3 on 6-month timeline, Context API (A) will hit limits. Redux (B) is overkill. Zustand (C) is the sweet spot. Jotai (D) too experimental. Score: C=9/10, A=6/10, B=5/10, D=3/10"

**The Technical Architect:**
"E-commerce needs cart, user, products, orders - complex state. Redux (B) best for this. Zustand (C) acceptable. Context (A) will cause re-render issues. Score: B=9/10, C=7/10, D=6/10, A=4/10"

**The Developer Advocate:**
"Team productivity matters. Zustand (C) has best DX. Redux Toolkit (B) much better than old Redux. Context (A) familiar but footguns. Score: C=10/10, B=7/10, A=6/10, D=5/10"

**The Innovator:**
"Jotai (D) is the future - atomic state is perfect for e-commerce. Zustand (C) is innovative yet practical. Redux (B) is yesterday's solution. Score: D=9/10, C=8/10, A=4/10, B=3/10"

### Synthesis
```markdown
## Insights
- Context API will likely hit performance walls
- Redux provides structure but may slow team
- Zustand balances simplicity with power
- Jotai too risky for 6-month timeline

## Recommendation: Zustand with Escape Hatches

Start with Zustand because:
1. Fastest development velocity
2. Sufficient for e-commerce complexity
3. Easy onboarding for team
4. Migration path to Redux if needed

Implementation Strategy:
- Separate stores per domain (cart, user, products)
- Use immer for immutable updates
- Add Redux DevTools connection
- Document patterns early

If Zustand hits limits, refactor to Redux Toolkit (similar patterns).
```

---

## Example 3: API Architecture

### User Request
"Building a new API. REST vs GraphQL vs tRPC?"

### Context
"Full-stack TypeScript team, building SaaS product, expecting 10K users year 1"

### Approach Generation
```markdown
## Approach A: RESTful API
- Standard HTTP verbs
- Resource-based routes
- OpenAPI documentation
- Simple caching

## Approach B: GraphQL
- Flexible queries
- Single endpoint
- Type generation
- Complex caching

## Approach C: tRPC
- End-to-end type safety
- No schema duplication
- RPC-style calls
- TypeScript-first
```

### Judge Evaluations

**The Pragmatist:**
"REST is proven, tooling everywhere, everyone knows it. tRPC amazing for TypeScript teams. GraphQL solves problems you don't have at 10K users. Score: A=8/10, C=9/10, B=5/10"

**The Innovator:**
"tRPC is the future for TypeScript teams! GraphQL still powerful for public APIs. REST is showing its age. Score: C=10/10, B=7/10, A=4/10"

**The Business Strategist:**
"Will you have external API consumers? REST easier to monetize/document. GraphQL good for partners. tRPC locks you into TypeScript ecosystem. Score: A=8/10, B=6/10, C=5/10"

**The Technical Architect:**
"Full-stack TypeScript = tRPC no-brainer. Type safety prevents bugs. Refactoring is trivial. REST requires coordination. Score: C=10/10, A=6/10, B=7/10"

### Synthesis & Recommendation
```markdown
## Decision: tRPC for Internal, REST for External

### Implementation Plan

Phase 1: tRPC for internal app (Month 1-3)
- Full type safety
- Rapid development
- No API documentation needed

Phase 2: REST API for public (Month 4-6)
- OpenAPI spec
- Standard authentication
- Partner/customer friendly

### Architecture
```
[React App] <-tRPC-> [API Server] <-REST-> [Public API]
                          |
                      [Database]
```

This gives:
- Perfect DX for team (tRPC)
- Standard interface for customers (REST)
- Option to add GraphQL later if needed
```

---

## Example 4: Progressive Refinement - Search Implementation

### Round 1
**Question**: "Basic search: SQL LIKE vs Full-text index?"

**Quick Evaluation**:
- SQL LIKE: Simple, no setup, slow at scale
- Full-text: Fast, complex setup, overkill for MVP

**Decision**: Start with SQL LIKE, plan for full-text migration

### Round 2 (1 month later)
**Question**: "Search is slow. PostgreSQL full-text vs Elasticsearch?"

**Evaluation**:
- PostgreSQL FTS: Good enough, no new infrastructure
- Elasticsearch: Superior, requires operations expertise

**Decision**: PostgreSQL FTS (can handle 100K records fine)

### Round 3 (6 months later)
**Question**: "Need faceted search. Elasticsearch vs Algolia?"

**Evaluation**:
- Elasticsearch: Full control, operational overhead
- Algolia: Managed service, expensive at scale

**Decision**: Algolia for fast shipping, plan Elasticsearch migration at Series A

---

## Lessons from Examples

1. **Context Matters** - Same problem, different context = different solution
2. **Judges Disagree** - This is feature, not bug. Synthesis finds balance
3. **Hybrid Often Wins** - Best elements from multiple approaches
4. **Progressive Enhancement** - Start simple, evolve based on real needs
5. **Document Decisions** - Future you will thank current you
6. **Time-box Analysis** - Perfect is enemy of shipped
7. **Veto Power** - Security/Accessibility can override scores