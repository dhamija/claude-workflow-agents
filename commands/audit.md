---
description: Audit existing codebase - understand what exists (brownfield L1)
argument-hint: <optional focus area>
---

Run these audits IN PARALLEL on the existing codebase:

## Parallel Execution

1. **intent-audit** (via intent-guardian)
   - Infer product intent from codebase if no intent doc exists
   - Audit current implementation against intent
   - Save to /docs/intent/product-intent.md (if new)
   - Save audit to /docs/intent/intent-audit.md

2. **ux-audit** (via ux-architect)
   - Map current user journeys from frontend code
   - Identify UX issues and gaps
   - Save to /docs/ux/user-journeys.md (current state)
   - Save audit to /docs/ux/ux-audit.md

3. **aa-audit** (via agentic-architect)
   - Map current system architecture
   - Identify what could be agentic vs what should stay code
   - Save to /docs/architecture/system-design.md (current state)
   - Save audit to /docs/architecture/agentic-audit.md

Focus area (if specified): $ARGUMENTS

## After All Complete

Summary:
- Intent: [inferred/found], [X issues found]
- UX: [Y journeys mapped], [Z issues found]  
- Architecture: [W components], [V agentic opportunities]

Next: Run `/gap` to analyze gaps and create migration plan.
