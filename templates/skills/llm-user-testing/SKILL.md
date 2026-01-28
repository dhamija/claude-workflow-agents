---
name: llm-user-testing
description: |
  Domain expertise for LLM-as-User testing. Provides principles, protocols,
  and best practices for simulating real users to test UIs. Loaded on-demand
  when executing /llm-user commands (/llm-user init, /test-ui, /llm-user gaps).
version: 1.0.0
---

# LLM User Testing Skill

**Domain:** Automated user experience testing using LLM-simulated users

**Purpose:** Enable Claude to create and execute domain-specific LLM user tests that find real UX problems by simulating authentic user behavior.

---

## Core Principles

### 1. Authenticity Over Optimization

**Principle:** LLM users must behave like real users, not like AI assistants trying to be helpful.

**What this means:**
- ❌ Don't use developer knowledge to bypass UI confusion
- ❌ Don't persist through frustration when a real user would quit
- ❌ Don't ignore problems to make tests pass
- ✅ Express frustration when things are unclear
- ✅ Give up if abandonment triggers are hit
- ✅ Make mistakes that real users would make

**Example:**
```
BAD (AI assistant behavior):
"I notice the button is mislabeled, but I understand the intent,
 so I'll click it anyway to help the test succeed."

GOOD (authentic user behavior):
"This button says 'Continue' but I'm not sure where it goes.
 The last time I clicked 'Continue' it submitted a form I wasn't
 ready to submit. I'm hesitant... [frustration +0.2]"
```

### 2. Domain-Specific Testing

**Principle:** Tests must validate domain-specific promises, not generic UI patterns.

**What this means:**
- Generic: "Button is clickable" ❌
- Domain-specific: "Spanish feedback helps user apply corrections in next attempt" ✅

**How to achieve:**
- Extract domain knowledge from architecture docs
- Map tests to specific promises from intent docs
- Use domain terminology in evaluation criteria

### 3. Promise-Based Validation

**Principle:** Tests validate promises made to users, not just that code doesn't crash.

**Promise hierarchy:**
```
CORE promises    → Release blockers if failed
IMPORTANT        → High priority but not blockers
NICE_TO_HAVE     → Low priority enhancements
```

**Testing focus:**
- All CORE promises must have test coverage
- Test passes only if promise demonstrably fulfilled
- Partial fulfillment = test failure

### 4. Persona-Driven Behavior

**Principle:** Different user types have different goals, patience levels, and frustration triggers.

**Persona parameters that affect simulation:**
- **Goals:** What they want to accomplish
- **Patience:** How long before they give up (low/medium/high)
- **Tech level:** Affects UI expectations and exploration patterns
- **Frustration triggers:** What annoys this specific user type
- **Success criteria:** What makes them feel satisfied

**Example:**
```yaml
beginner_learner:
  goals: ["Build confidence", "Not feel stupid"]
  patience: medium
  frustration_triggers:
    - "Grammar jargon without explanation"
    - "Feeling judged for mistakes"
  abandonment_threshold: frustration > 0.7

expert_user:
  goals: ["Accomplish task quickly", "Skip basics"]
  patience: low
  frustration_triggers:
    - "Forced tutorials"
    - "Hand-holding"
    - "Slow interactions"
  abandonment_threshold: frustration > 0.5
```

### 5. Evidence-Based Gap Analysis

**Principle:** Every gap must trace back to observable behavior and original requirements.

**Traceability chain:**
```
User frustration during test
    ↓
Specific UI interaction that caused it
    ↓
Step in journey where it occurred
    ↓
Promise that wasn't fulfilled
    ↓
Doc section that specified the promise
    ↓
Actionable recommendation
```

---

## LLM User Simulation Protocol

### State Tracking

**Required state throughout simulation:**
```yaml
persona_state:
  frustration_level: 0.0-1.0   # 0=calm, 1=rage-quit imminent
  motivation_level: 0.0-1.0    # 0=checked out, 1=engaged
  confidence_level: 0.0-1.0    # 0=lost, 1=knows what they're doing
  completed_actions: int        # Track progress
  failed_attempts: int          # Track struggles
```

**State updates:**
- After every action
- When expectations violated
- When delighted by good UX
- When frustrated by bad UX

### Action Loop

**For each step in scenario:**

```
1. OBSERVE
   ├─ Take screenshot
   ├─ Read visible text
   ├─ Identify interactive elements
   ├─ Note current screen/page
   └─ Understand context

2. THINK (as persona)
   ├─ What am I trying to do? (from step intent)
   ├─ What options do I see?
   ├─ What do I expect to happen?
   ├─ Given my persona traits, what would I do?
   └─ Decide on action

3. ACT
   ├─ Execute action (click, type, scroll, etc.)
   ├─ Record confidence (0.0-1.0)
   └─ Note reasoning

4. REACT
   ├─ What actually happened?
   ├─ Did it match my expectation?
   ├─ Update frustration (delta: -0.3 to +0.3)
   ├─ Update motivation (delta: -0.3 to +0.3)
   ├─ Update confidence (delta: -0.3 to +0.3)
   └─ Record observation

5. CHECK THRESHOLDS
   ├─ If frustration > abandonment_threshold → Consider quitting
   ├─ If motivation < 0.2 → Consider quitting
   ├─ If stuck for 3+ attempts → Express confusion
   └─ If success → Express satisfaction

6. RECORD
   ├─ Save structured JSON
   ├─ Take screenshot
   └─ Continue or quit
```

### Frustration Dynamics

**Frustration increases (+) when:**
```
+0.05 → Minor annoyance (small delay, unclear label)
+0.10 → Moderate issue (unexpected behavior, confusing flow)
+0.15 → Significant problem (error without explanation)
+0.20 → Major blocker (can't proceed, lost progress)
+0.30 → Critical failure (data loss, crash, insult)
```

**Frustration decreases (-) when:**
```
-0.05 → Small win (found what I was looking for)
-0.10 → Good UX (clear feedback, helpful hint)
-0.15 → Delight (exceeded expectations)
-0.20 → Recovery (app helped me fix my mistake)
```

**Abandonment decision:**
```python
def should_abandon(persona, state):
    # Check hard threshold
    if state.frustration > persona.abandonment_threshold:
        return True, "Frustration threshold exceeded"

    # Check abandonment triggers
    for trigger in persona.abandonment_triggers:
        if trigger_detected(trigger):
            return True, f"Abandonment trigger: {trigger}"

    # Check multiple failures
    if state.failed_attempts >= persona.patience * 3:
        return True, "Too many failed attempts"

    # Check motivation crash
    if state.motivation < 0.2:
        return True, "Lost motivation"

    return False, None
```

### Recording Format

**Structured JSON after each action:**
```json
{
  "step_id": "step-2",
  "action_number": 3,
  "timestamp": "2026-01-27T10:23:45.123Z",

  "persona": {
    "id": "maria-beginner",
    "name": "Maria (Beginner Adult)"
  },

  "state_before": {
    "frustration": 0.15,
    "motivation": 0.75,
    "confidence": 0.60
  },

  "observation": {
    "screen": "Scene description page",
    "visible_elements": ["textarea", "submit button", "hint icon"],
    "current_task": "Write scene description in Spanish"
  },

  "decision": {
    "intent": "Submit my description to get feedback",
    "options_considered": [
      "Click submit button",
      "Click hint icon first",
      "Edit description more"
    ],
    "chosen_action": "Click submit button",
    "reasoning": "I'm nervous but I want to see what happens. Submit button is clear.",
    "confidence": 0.65
  },

  "action": {
    "type": "click",
    "target": "button#submit-description",
    "timestamp": "2026-01-27T10:23:45.500Z"
  },

  "outcome": {
    "success": true,
    "observation": "Button disabled, loading spinner appeared for 1.2s, then feedback displayed",
    "matched_expectation": true,
    "unexpected": "Spinner took longer than expected"
  },

  "reaction": {
    "thought": "Okay, feedback is here. Let me read it...",
    "emotion": "relieved but slightly anxious",
    "frustration_delta": +0.05,
    "motivation_delta": 0.00,
    "confidence_delta": +0.10,
    "reason_for_change": "Wait time was noticeable (+frustration), but outcome was good (+confidence)"
  },

  "state_after": {
    "frustration": 0.20,
    "motivation": 0.75,
    "confidence": 0.70
  },

  "screenshot_before": "screenshots/step-2-action-3-before.png",
  "screenshot_after": "screenshots/step-2-action-3-after.png"
}
```

---

## Gap Analysis Methodology

### Gap Identification

**A gap exists when:**
1. Promise acceptance criteria not met
2. UX principle violated
3. Persona abandoned due to frustration
4. User couldn't complete intended journey
5. Feedback/behavior doesn't match documentation

**Gap severity classification:**

```
CRITICAL
├─ CORE promise not fulfilled
├─ User data loss
├─ App crash or unrecoverable error
└─ Discriminatory or harmful behavior

HIGH
├─ IMPORTANT promise not fulfilled
├─ User abandons due to frustration
├─ Major UX principle violation (Doherty >3s)
└─ Journey can't be completed

MEDIUM
├─ NICE_TO_HAVE promise not fulfilled
├─ Minor UX principle violation
├─ User completes but frustrated
└─ Confusing but not blocking

LOW
├─ Polish issues
├─ Nice-to-have features missing
└─ Minor aesthetic issues
```

### Root Cause Analysis

**For each gap, identify:**

1. **Symptom:** What went wrong?
2. **Trigger:** What action triggered it?
3. **Persona impact:** Who was affected and how much?
4. **Root cause:** Why did it happen?
5. **Contributing factors:** What made it worse?

**Example:**
```yaml
gap:
  symptom: "User couldn't find progress indicator"

  trigger: "After completing 3rd scene, looked for progress stats"

  persona_impact:
    - persona: "Jake (Impatient Teen)"
      frustration_increase: +0.25
      motivation_decrease: -0.15
      quote: "How many more of these? Am I getting better?"

  root_cause: "No progress UI component implemented"

  contributing_factors:
    - "Multi-scene workflow but no session state visible"
    - "Persona values seeing progress highly"
    - "Violates Zeigarnik Effect (show progress on unfinished tasks)"
```

### Traceability Mapping

**Map each gap back to source requirements:**

```yaml
traceability:
  gap: "No progress tracking"

  source_docs:
    - doc: "/docs/intent/product-intent.md"
      section: "Promise P3"
      quote: "Users feel progress in learning"
      expectation: "Measurable skill improvement visible to user"

    - doc: "/docs/ux/user-journeys.md"
      section: "Multi-scene session journey"
      quote: "After each scene, user sees: scenes completed, skills practiced, improvement graph"
      expectation: "Progress dashboard shown"

    - doc: "/docs/ux/design-principles.md"
      section: "Zeigarnik Effect"
      quote: "Show progress on incomplete tasks to maintain motivation"
      expectation: "Progress indicator always visible"

  gap: "No progress indicator exists anywhere in UI"

  impact: "Promise P3 not fulfilled, Zeigarnik violated, user motivation dropped"
```

### Recommendation Generation

**For each gap, provide:**

```yaml
recommendation:
  # What to change
  change: "Add progress dashboard to navigation bar"

  # Specific implementation
  specifics:
    - "Show: Scenes completed / Total scenes"
    - "Show: Vocabulary learned count"
    - "Show: Skill level progression (beginner → intermediate)"
    - "Show: Current streak (days active)"
    - "Update in real-time after each scene"

  # Why this fixes it
  rationale: |
    Directly addresses Promise P3 and Zeigarnik violation.
    Jake specifically asked "How many more?" and "Am I getting better?"
    This gives him clear answers to both questions.

  # Alternative approaches
  alternatives:
    - option: "End-of-session summary only"
      pros: ["Less dev work", "Simpler UI"]
      cons: ["Doesn't help during session", "Jake would still be frustrated"]
      verdict: "Not recommended - doesn't solve the problem"

    - option: "Progress bar at top of each scene"
      pros: ["Always visible", "Simple implementation"]
      cons: ["Doesn't show skill improvement, only count"]
      verdict: "Partial solution - combine with dashboard"

  # Effort and impact
  effort: medium  # Requires new UI component + backend state
  impact: high    # Directly addresses CORE promise + affects all personas

  # Priority
  priority: HIGH  # High impact, affects CORE promise

  # Success criteria for fix
  retest_with:
    - scenario: "multi-scene-session"
      persona: "Jake"
      expected: |
        Jake completes 3 scenes.
        Progress dashboard visible throughout.
        Jake's frustration doesn't increase due to lack of progress info.
        Jake sees measurable improvement and stays motivated.
```

### Priority Matrix

```
           │ Low Impact │ Med Impact │ High Impact
───────────┼────────────┼────────────┼─────────────
Low Effort │ Low        │ Medium     │ HIGH ⭐
───────────┼────────────┼────────────┼─────────────
Med Effort │ Low        │ Medium     │ High
───────────┼────────────┼────────────┼─────────────
High Effort│ Low        │ Medium     │ Medium
```

**Exception:** CRITICAL severity gaps are always top priority regardless of effort.

---

## Domain-Specific Testing Patterns

### Pattern 1: Learning Apps

**Special considerations:**
- Track skill progression over time
- Validate feedback helps user improve
- Test spaced repetition effectiveness
- Ensure errors don't demoralize

**Metrics:**
```yaml
learning_effectiveness:
  - first_attempt_quality: 0.0-1.0
  - last_attempt_quality: 0.0-1.0
  - improvement_rate: (last - first) / attempts
  - correction_application_rate: % of corrections applied
  - confidence_progression: confidence_last - confidence_first
```

### Pattern 2: Creative Tools

**Special considerations:**
- Validate output quality/utility
- Test iteration/refinement flows
- Ensure user feels creative ownership
- Check for "blank canvas" anxiety

**Metrics:**
```yaml
creative_effectiveness:
  - output_satisfaction: 0.0-1.0 (persona judgment)
  - iteration_smoothness: ease of refining
  - creative_confidence: does user feel in control?
  - result_utility: does output serve intended purpose?
```

### Pattern 3: Data Analysis Tools

**Special considerations:**
- Validate insights are actionable
- Test data trust (accuracy, reliability)
- Check cognitive load (not overwhelming)
- Ensure errors/limitations clear

**Metrics:**
```yaml
analysis_effectiveness:
  - insight_actionability: can user act on results?
  - data_trust: does user believe results?
  - clarity: does user understand what they see?
  - context_sufficiency: enough info to decide?
```

### Pattern 4: Productivity Tools

**Special considerations:**
- Test task completion speed
- Validate interruption recovery
- Check mobile usability
- Ensure keyboard shortcuts/power features

**Metrics:**
```yaml
productivity_effectiveness:
  - task_completion_time: seconds
  - steps_to_complete: count
  - error_recovery: can resume after interruption?
  - expert_shortcuts: discoverable and functional?
```

---

## Test Scenario Design

### Scenario Types

**1. Happy Path Scenarios**
- Purpose: Validate core promises work
- Persona: Match intended user
- Expected: Success with high satisfaction

**2. Error Recovery Scenarios**
- Purpose: Validate error handling
- Persona: Likely to make mistakes
- Inject: Intentional errors
- Expected: Clear guidance, successful recovery

**3. Edge Case Scenarios**
- Purpose: Test boundaries
- Conditions: Unusual inputs, edge values
- Expected: Graceful handling

**4. Frustration Detection Scenarios**
- Purpose: Find UX problems
- Persona: Low patience or high expectations
- Expected: Identify abandonment triggers

**5. Multi-Session Scenarios**
- Purpose: Test progression/persistence
- Duration: Multiple visits
- Expected: State persists, progress visible

### Scenario Completeness

**A complete scenario must have:**
```yaml
scenario:
  ✅ id: unique identifier
  ✅ name: human-readable
  ✅ persona: which user type
  ✅ entry: URL + preconditions
  ✅ steps: ordered list with intents
  ✅ pass_criteria: promise-linked success conditions
  ✅ expected_duration: timeout detection
  ✅ source: link back to UX journey doc
```

---

## Evaluation Rubrics

### Weighted Scoring

**Formula:**
```
overall_score = Σ (criterion_score * criterion_weight)

where:
  criterion_score = 0.0 to 1.0
  criterion_weight = % of total (Σ weights = 1.0)
```

**Example rubric:**
```yaml
rubric:
  domain_criteria:  # 70% total
    - name: "Learning effectiveness"
      weight: 0.35
      score: 0.0-1.0

    - name: "Feedback quality"
      weight: 0.25
      score: 0.0-1.0

    - name: "Motivation maintenance"
      weight: 0.10
      score: 0.0-1.0

  ux_principles:  # 30% total
    - name: "Fitts's Law"
      weight: 0.075
      score: 0.0-1.0

    - name: "Hick's Law"
      weight: 0.075
      score: 0.0-1.0

    - name: "Doherty Threshold"
      weight: 0.075
      score: 0.0-1.0

    - name: "Zeigarnik Effect"
      weight: 0.075
      score: 0.0-1.0

# Overall: 0.0 to 1.0
```

### Criterion Scoring Guidelines

**1.0 = Exemplary**
- Exceeds expectations
- All acceptance criteria met
- Users delighted

**0.8-0.9 = Good**
- Meets expectations
- All acceptance criteria met
- Users satisfied

**0.6-0.7 = Passing**
- Mostly meets expectations
- Most acceptance criteria met
- Users not frustrated

**0.4-0.5 = Warning**
- Some gaps
- Some acceptance criteria failed
- Users moderately frustrated

**0.0-0.3 = Failing**
- Significant gaps
- Most acceptance criteria failed
- Users highly frustrated or abandoned

---

## Best Practices

### DO

✅ **Read architecture docs thoroughly** - Context is critical
✅ **Embody personas authentically** - Be the user, not the AI
✅ **Record everything** - Screenshots, state, observations
✅ **Express genuine reactions** - "This is confusing!" not "I notice potential confusion"
✅ **Give up when appropriate** - Real users quit
✅ **Trace gaps to docs** - Every gap must link to source requirement
✅ **Prioritize by impact** - Fix what matters most
✅ **Provide specific recommendations** - "Add X here" not "improve UX"

### DON'T

❌ **Don't use developer knowledge** - "I know the API" → ignore that
❌ **Don't persist through frustration** - Real users don't
❌ **Don't make tests pass artificially** - Find problems, don't hide them
❌ **Don't use generic criteria** - Every rubric must be domain-specific
❌ **Don't skip documentation reading** - Garbage in, garbage out
❌ **Don't test without clear promises** - What are you even validating?
❌ **Don't ignore persona traits** - They exist for a reason

---

## Success Indicators

**LLM user testing is working well if:**

1. ✅ Tests find real UX problems that humans missed
2. ✅ Gaps map to specific promises from intent docs
3. ✅ Recommendations are actionable and specific
4. ✅ Fixes demonstrably improve scores on retest
5. ✅ Different personas have different experiences
6. ✅ Test setup takes minutes, not days
7. ✅ Gap analysis traces back to source documentation

**LLM user testing needs improvement if:**

1. ❌ Tests always pass but users still complain
2. ❌ Gaps are vague or generic
3. ❌ Recommendations are obvious or unhelpful
4. ❌ Personas all behave identically
5. ❌ Can't trace gaps to specific requirements
6. ❌ Tests feel like "going through the motions"

---

## Example: Complete Test Flow

### Input: Workflow Docs

```yaml
# From docs/intent/product-intent.md
promises:
  - id: P1
    statement: "Users can describe scenes in Spanish"
    criticality: CORE
    acceptance_criteria:
      - "User can view scene"
      - "User can type Spanish description"
      - "User receives immediate feedback"

# From docs/ux/user-journeys.md
personas:
  - name: "Maria (Beginner Adult)"
    goals: ["Learn conversational Spanish"]
    frustrations: ["Confusing grammar"]
    tech_level: intermediate

journeys:
  - name: "First scene description"
    persona: "Maria"
    steps:
      - action: "View scene image"
        expected: "Scene loads clearly"
      - action: "Read prompt"
        expected: "Understand what to do"
      - action: "Type description"
        expected: "Input accepted"
      - action: "Submit"
        expected: "Feedback received"
```

### Generated: Test Spec

```yaml
scenario:
  id: "first-scene-description"
  persona: "maria-beginner"

  steps:
    - intent: "View scene and understand task"
      success: ["Scene visible", "Instructions clear"]

    - intent: "Write Spanish description"
      success: ["Text input works", "No errors"]

    - intent: "Submit and receive feedback"
      success: ["Feedback immediate", "Feedback helpful"]

  pass_criteria:
    - promise: "P1"
      check: "All steps completed, Maria satisfied"
```

### Execution: LLM User Simulation

```
[Maria loads page]
Screenshot: Park scene with dog, man, bench
Maria thinks: "Okay, I see a park. Instructions say 'Describe en español'"

[Maria types]
Action: Type "Hay un hombre con un perro"
Confidence: 0.6 (not sure if correct)
State: frustration=0.05 (slight anxiety)

[Maria submits]
Action: Click submit
Wait: 1.2s (spinner visible)
Outcome: "¡Bien! Puedes agregar más detalles sobre el perro."
Reaction: "That felt good! Feedback was encouraging."
State: frustration=0.0, motivation=0.85 (↑ from feedback)

Result: SUCCESS - P1 fulfilled
```

### Evaluation: Rubric Application

```yaml
scores:
  P1_fulfillment: 0.9  # Minor wait time issue
  feedback_quality: 0.85  # Good but could be more specific
  motivation: 0.9  # Maria satisfied and encouraged

overall: 0.88 (B+)

gaps:
  - criterion: "Doherty Threshold"
    score: 0.7
    issue: "1.2s feedback delay (should be <400ms)"
    severity: medium
    recommendation: "Add loading skeleton immediately"
```

### Output: Gap Analysis

```markdown
## Gap Analysis

**Overall Score:** 8.8/10 (Grade: B+)

**Verdict:** PASS with recommendations

### Gaps Found

#### [MEDIUM] Feedback delay violates Doherty Threshold

**Location:** Scene description submission

**Observation:**
Maria submitted description and waited 1.2s for feedback.
Spinner visible but delay noticeable.

**Expected** (from design principles):
Response <400ms for maintained flow state

**Gap:** 800ms over threshold

**Impact:** Minor frustration increase during wait

**Recommendation:**
- Immediate: Show loading skeleton instantly
- Long-term: Optimize feedback generation (<400ms)

**Priority:** Medium (low effort, medium impact)
```

---

## Related Concepts

**See Also:**
- **intent-guardian skill**: Defines testable promises
- **ux-design skill**: Defines personas and journeys
- **validation skill**: Manual acceptance testing complement
- **testing skill**: Unit/integration testing (different from LLM user testing)

**Integration Points:**
- L1 docs → Test spec generation
- L2 implementation → Test execution
- Gap analysis → Issue tracking
- Recommendations → L2 iteration

---

## Version History

### 1.0.0 (2026-01-27)
- Initial release
- Protocols for LLM user simulation
- Gap analysis methodology
- Domain-specific testing patterns
- Evaluation rubric frameworks
