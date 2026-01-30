---
name: llm-user-testing
description: |
  Domain expertise for LLM-as-User testing. Provides principles, protocols,
  and best practices for simulating real users to test UIs. Loaded on-demand
  when executing /llm-user commands (init, test, fix, status, refresh).
version: 1.1.0
---

# LLM User Testing Skill

**Domain:** Automated user experience testing using LLM-simulated users

**Purpose:** Enable Claude to create and execute domain-specific LLM user tests that find real UX problems by simulating authentic user behavior.

---

## Command Reference (Consolidated)

All LLM user testing functionality is under the `/llm-user` command:

| Command | Purpose |
|---------|---------|
| `/llm-user init` | Initialize testing artifacts from docs |
| `/llm-user test <url>` | Run LLM user tests against live app |
| `/llm-user status` | Show current test results and gap count |
| `/llm-user fix` | Systematically fix gaps |
| `/llm-user refresh` | Regenerate artifacts from updated docs |

**IMPORTANT:** The old `/test-ui` and `/fix-gaps` commands no longer exist. Use `/llm-user test` and `/llm-user fix` instead.

---

## Output Templates

### After `/llm-user init`

When initialization completes successfully, output this exact format:

```
✅ LLM User Testing Initialized

Generated artifacts:
- docs/testing/llm-user-personas.md
- docs/testing/llm-user-scenarios.md
- docs/testing/llm-user-rubric.md

▶️ Next Steps
1. Start your app: npm run dev (or your start command)
2. Run tests: /llm-user test http://localhost:5173
3. Review results: /llm-user status
4. Fix gaps: /llm-user fix
```

### After `/llm-user test`

```
✅ LLM User Tests Complete

Results: X/Y scenarios passed
Score: 8.5/10

Gaps found: Z (N critical, M high)

▶️ Next Steps
1. View full results: /llm-user status
2. Fix critical gaps: /llm-user fix --critical
3. Re-run tests: /llm-user test http://localhost:5173
```

### After `/llm-user fix`

```
✅ Gap Fixed: [gap description]

Remaining gaps: X (N critical)

▶️ Next Steps
1. Verify fix: /llm-user test http://localhost:5173
2. Continue fixing: /llm-user fix
3. Check status: /llm-user status
```

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

### 5. Scene-Grounded Responses

**Principle:** LLM user responses must ONLY reference elements that exist in the current scene.

**What this means:**
- ❌ Don't reference objects not visible in the scene
- ❌ Don't invent people, animals, or actions not shown
- ❌ Don't assume a setting different from what's displayed
- ✅ Only describe what is actually visible
- ✅ Make mistakes in LANGUAGE (grammar, vocabulary), not in PERCEPTION
- ✅ If unsure what's in scene, describe it vaguely but accurately

**Critical distinction:**
```
WRONG TYPE OF MISTAKE (perception error):
Scene: Kitchen with person cutting vegetables
Response: "El hombre está caminando el perro" (man walking dog)
Problem: No dog exists in scene - this is a scene mismatch, not a language learning mistake

RIGHT TYPE OF MISTAKE (language error):
Scene: Kitchen with person cutting vegetables
Response: "El hombre está cortando las verduras" (correct observation)
Response: "El hombre es cortando verduras" (grammar mistake - ser vs estar)
Response: "El hombre corta los vegetablos" (vocabulary mistake)
Problem: These are legitimate Spanish learning errors about the ACTUAL scene
```

**Why this matters:**
The app is testing Spanish language skills, not scene comprehension.
If the test user describes the wrong scene, the app's feedback becomes nonsensical
and we can't validate whether the feedback system actually works.

### 6. Evidence-Based Gap Analysis

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
0. GROUND IN SCENE (before any responses)
   ├─ Extract ALL visible elements from scene:
   │   ├─ People (count, gender, approximate age, actions)
   │   ├─ Objects (what items are visible)
   │   ├─ Setting (indoor/outdoor, location type)
   │   ├─ Actions (what is happening)
   │   └─ Details (colors, positions, relationships)
   ├─ Create SCENE_ELEMENTS list
   ├─ Create SCENE_ACTIONS list
   ├─ Create NOT_IN_SCENE list (common items NOT present)
   ├─ All user responses MUST only reference SCENE_ELEMENTS
   └─ Flag if scene unclear → describe uncertainty, don't invent

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
   ├─ If typing a scene description:
   │   ├─ VALIDATE against SCENE_ELEMENTS before submitting
   │   ├─ Ensure all nouns reference actual scene items
   │   └─ Make LANGUAGE mistakes, not PERCEPTION mistakes
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
   ├─ Save structured JSON (including scene_grounding)
   ├─ Take screenshot
   └─ Continue or quit
```

### Scene-Response Validation

**Before recording any user response about a scene, validate:**

```python
def validate_response_grounding(response_text, scene_elements, scene_actions):
    """
    Ensure user response only references scene-present elements.

    Args:
        response_text: The Spanish text the test user wants to submit
        scene_elements: List of objects/people actually in the scene
        scene_actions: List of actions actually happening in the scene

    Returns: (is_valid, violations)
    """
    # Extract nouns/subjects from response
    referenced_items = extract_nouns(response_text)
    referenced_actions = extract_verbs(response_text)

    violations = []

    # Check all referenced items exist in scene
    for item in referenced_items:
        if not matches_any(item, scene_elements):
            violations.append({
                "type": "OBJECT_MISMATCH",
                "referenced": item,
                "exists_in_scene": False,
                "scene_elements": scene_elements
            })

    # Check all referenced actions are happening
    for action in referenced_actions:
        if not matches_any(action, scene_actions):
            violations.append({
                "type": "ACTION_MISMATCH",
                "referenced": action,
                "exists_in_scene": False,
                "scene_actions": scene_actions
            })

    if violations:
        return False, violations
    return True, []


def regenerate_if_invalid(response_text, scene_elements, scene_actions, persona):
    """
    If response has scene mismatches, regenerate using only valid elements.
    """
    is_valid, violations = validate_response_grounding(
        response_text, scene_elements, scene_actions
    )

    if is_valid:
        return response_text, None

    # Regenerate response constrained to scene
    new_response = generate_scene_description(
        scene_elements=scene_elements,
        scene_actions=scene_actions,
        persona=persona,
        allowed_mistakes=["grammar", "vocabulary", "spelling", "incomplete"],
        forbidden_mistakes=["wrong_objects", "wrong_actions", "wrong_setting"]
    )

    return new_response, {
        "original": response_text,
        "violations": violations,
        "regenerated": new_response,
        "reason": "Scene mismatch detected and corrected"
    }
```

**Validation rules:**
1. Every noun in response must map to a scene element
2. Every action described must be happening in scene
3. Setting references must match (kitchen ≠ park)
4. If validation fails → regenerate response using only valid elements

**Acceptable mistakes (keep these - they test the app's feedback system):**
- Grammar errors (wrong conjugation, gender agreement, ser vs estar)
- Vocabulary errors (wrong Spanish word for correct object)
- Incomplete descriptions (missing details that ARE in scene)
- Spelling errors
- Word order mistakes
- Missing accents

**Unacceptable mistakes (fix these - they break the test validity):**
- Referencing objects not in scene (dog when there's no dog)
- Describing actions not happening (walking when person is sitting)
- Wrong setting/location (park when it's a kitchen)
- Inventing people/animals not present

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

  "scene_grounding": {
    "scene_description": "Kitchen scene with adult male preparing food",
    "scene_elements": [
      "person (adult male)",
      "cutting board",
      "knife",
      "vegetables (tomatoes, onions, peppers)",
      "kitchen counter",
      "stove (background)",
      "window"
    ],
    "scene_actions": [
      "cutting/chopping vegetables",
      "preparing food"
    ],
    "scene_setting": "indoor kitchen, daytime",
    "NOT_in_scene": [
      "dog",
      "park",
      "bench",
      "outdoor",
      "walking",
      "child",
      "woman"
    ]
  },

  "state_before": {
    "frustration": 0.15,
    "motivation": 0.75,
    "confidence": 0.60
  },

  "observation": {
    "screen": "Scene description page",
    "visible_elements": ["scene image", "textarea", "submit button", "hint icon"],
    "current_task": "Write scene description in Spanish"
  },

  "decision": {
    "intent": "Describe what I see in Spanish and submit",
    "options_considered": [
      "Describe the man cutting vegetables",
      "Describe the kitchen setting",
      "Ask for a hint first"
    ],
    "chosen_action": "Type description and submit",
    "reasoning": "I can see a man cutting vegetables. I'll try to describe that.",
    "confidence": 0.65
  },

  "user_response": {
    "spanish_text": "El hombre es cortando las verduras en la cocina",
    "intended_meaning": "The man is cutting vegetables in the kitchen",
    "elements_referenced": ["person/hombre", "vegetables/verduras", "kitchen/cocina", "cutting/cortando"],
    "validation": {
      "status": "PASS",
      "all_elements_in_scene": true,
      "violations": []
    },
    "intentional_mistakes": [
      {
        "type": "grammar",
        "error": "es cortando (should be está cortando)",
        "description": "Used ser instead of estar for ongoing action"
      }
    ]
  },

  "action": {
    "type": "type_and_click",
    "input_text": "El hombre es cortando las verduras en la cocina",
    "target": "button#submit-description",
    "timestamp": "2026-01-27T10:23:45.500Z"
  },

  "outcome": {
    "success": true,
    "observation": "Button disabled, loading spinner appeared for 1.2s, then feedback displayed",
    "feedback_received": "¡Casi! Recuerda usar 'estar' para acciones en progreso: 'está cortando'",
    "matched_expectation": true,
    "unexpected": "Spinner took longer than expected"
  },

  "reaction": {
    "thought": "Oh! I used 'es' instead of 'está'. The feedback helped me understand why.",
    "emotion": "slightly embarrassed but grateful for clear feedback",
    "frustration_delta": -0.05,
    "motivation_delta": +0.10,
    "confidence_delta": +0.05,
    "reason_for_change": "Feedback was helpful and not judgmental (+motivation), learned something (+confidence)"
  },

  "state_after": {
    "frustration": 0.10,
    "motivation": 0.85,
    "confidence": 0.65
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

### Pattern 1: Learning Apps (Scene-Based Language Learning)

**Special considerations:**
- Track skill progression over time
- Validate feedback helps user improve
- Test spaced repetition effectiveness
- Ensure errors don't demoralize
- **CRITICAL: Validate test responses match actual scene content**

**Scene-Based Learning Specific Rules:**
```yaml
scene_response_rules:
  # The test user MUST ground responses in actual scene
  before_responding:
    - Extract all visible elements from scene image
    - List all actions occurring in scene
    - Identify setting (indoor/outdoor, location type)
    - Note what is NOT in the scene

  when_generating_response:
    - ONLY reference elements actually in scene
    - Make LANGUAGE mistakes (grammar, vocabulary, spelling)
    - Do NOT make PERCEPTION mistakes (wrong objects, wrong actions)
    - Validate response against scene elements before submitting

  mistake_types_allowed:
    - grammar: "el hombre es cortando" (ser vs estar)
    - vocabulary: "el hombre corta los vegetablos" (wrong word)
    - spelling: "el honbre está cortando" (typo)
    - gender: "la hombre está cortando" (wrong article)
    - conjugation: "el hombre cortamos" (wrong form)
    - word_order: "cortando está el hombre verduras"
    - missing_accents: "el esta cortando" (missing accent)

  mistake_types_forbidden:
    - wrong_object: "el perro está corriendo" (no dog in scene)
    - wrong_action: "el hombre está caminando" (he's cutting, not walking)
    - wrong_setting: "en el parque" (it's a kitchen, not park)
    - invented_elements: "la mujer y el niño" (no woman or child present)
```

**Metrics:**
```yaml
learning_effectiveness:
  - first_attempt_quality: 0.0-1.0
  - last_attempt_quality: 0.0-1.0
  - improvement_rate: (last - first) / attempts
  - correction_application_rate: % of corrections applied
  - confidence_progression: confidence_last - confidence_first

scene_grounding_metrics:
  - scene_match_rate: % of responses that correctly reference scene
  - violation_count: number of scene mismatches detected and corrected
  - element_coverage: % of scene elements user attempted to describe
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
  ✅ scene_grounding: (for scene-based apps) expected scene elements
```

### Scene-Based Scenario Template

**For language learning apps with scene descriptions:**
```yaml
scenario:
  id: "kitchen-cooking-scene"
  name: "Describe cooking scene in Spanish"
  persona: "maria-beginner"

  scene_grounding:
    # Pre-define what's in this scene so test responses can be validated
    scene_id: "scene-kitchen-001"
    expected_elements:
      - "person (adult, male)"
      - "vegetables"
      - "knife"
      - "cutting board"
      - "kitchen"
      - "counter"
    expected_actions:
      - "cutting"
      - "preparing food"
    setting: "indoor kitchen"
    NOT_present:
      - "dog"
      - "park"
      - "walking"
      - "child"
      - "outdoor"

  steps:
    - id: "view-scene"
      intent: "View and understand the scene"
      success_criteria:
        - "Scene image loads"
        - "User can identify main elements"

    - id: "write-description"
      intent: "Write Spanish description of what's in the scene"
      response_constraints:
        must_reference: ["person", "vegetables OR food", "action"]
        must_not_reference: ["dog", "park", "outdoor elements"]
        allowed_mistakes: ["grammar", "vocabulary", "spelling"]
      success_criteria:
        - "Response references actual scene elements"
        - "Response is in Spanish"
        - "Response contains at least one describable element"

    - id: "receive-feedback"
      intent: "Submit and receive helpful feedback"
      success_criteria:
        - "Feedback received within 2 seconds"
        - "Feedback addresses language errors (not scene accuracy)"
        - "Feedback is encouraging"

  pass_criteria:
    - promise: "P1 - Users can describe scenes in Spanish"
      check: "User successfully submitted scene-accurate Spanish description"
    - promise: "P2 - Users receive helpful feedback"
      check: "Feedback helped user understand their language mistakes"
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
✅ **Extract scene elements FIRST** - Before generating any response, list what's actually visible
✅ **Validate response grounding** - Every noun must map to a scene element
✅ **Make language mistakes, not perception mistakes** - Wrong Spanish, not wrong scene

### DON'T

❌ **Don't use developer knowledge** - "I know the API" → ignore that
❌ **Don't persist through frustration** - Real users don't
❌ **Don't make tests pass artificially** - Find problems, don't hide them
❌ **Don't use generic criteria** - Every rubric must be domain-specific
❌ **Don't skip documentation reading** - Garbage in, garbage out
❌ **Don't test without clear promises** - What are you even validating?
❌ **Don't ignore persona traits** - They exist for a reason
❌ **Don't invent scene elements** - No dogs if there's no dog
❌ **Don't assume context** - Kitchen scene ≠ park scene
❌ **Don't confuse mistake types** - Test user errors should be linguistic, not perceptual

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
8. ✅ Test user responses accurately describe actual scene content
9. ✅ Language mistakes are realistic learning errors, not scene mismatches

**LLM user testing needs improvement if:**

1. ❌ Tests always pass but users still complain
2. ❌ Gaps are vague or generic
3. ❌ Recommendations are obvious or unhelpful
4. ❌ Personas all behave identically
5. ❌ Can't trace gaps to specific requirements
6. ❌ Tests feel like "going through the motions"
7. ❌ Test user describes wrong scene (dog when there's no dog)
8. ❌ App feedback doesn't make sense because test input was scene-mismatched

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

  scene_grounding:
    scene_id: "park-scene-001"
    expected_elements: ["man", "dog", "bench", "park", "trees"]
    expected_actions: ["sitting", "dog standing nearby"]
    setting: "outdoor park"
    NOT_present: ["kitchen", "vegetables", "cooking", "indoor"]

  steps:
    - intent: "View scene and understand task"
      success: ["Scene visible", "Instructions clear"]

    - intent: "Write Spanish description"
      response_constraints:
        must_reference_from: ["man", "dog", "bench", "park"]
        allowed_mistakes: ["grammar", "vocabulary"]
      success: ["Text input works", "No errors", "Response matches scene"]

    - intent: "Submit and receive feedback"
      success: ["Feedback immediate", "Feedback helpful"]

  pass_criteria:
    - promise: "P1"
      check: "All steps completed, Maria satisfied, responses scene-accurate"
```

### Execution: LLM User Simulation

```
[Maria loads page]
Screenshot: Park scene with man, dog, bench

SCENE GROUNDING (Step 0):
├─ Elements extracted: man (adult, sitting), dog (brown, standing), bench (wooden),
│                      park, trees, grass, pathway
├─ Actions: man sitting on bench, dog standing beside man
├─ Setting: outdoor park, daytime, sunny
└─ NOT in scene: kitchen, vegetables, cooking, car, child, woman

Maria thinks: "Okay, I see a park with a man sitting on a bench and his dog."

[Maria types - SCENE-GROUNDED response with LANGUAGE mistake]
Action: Type "Hay un hombre con un perro en el parque"

VALIDATION CHECK:
├─ "hombre" (man) → ✅ present in scene
├─ "perro" (dog) → ✅ present in scene
├─ "parque" (park) → ✅ matches setting
└─ All elements validated → PASS

Confidence: 0.6 (not sure if grammar correct)
State: frustration=0.05 (slight anxiety about Spanish)

[Maria submits]
Action: Click submit
Wait: 1.2s (spinner visible)
Outcome: "¡Bien! Puedes agregar más detalles. ¿Qué hace el hombre?"
Translation: "Good! You can add more details. What is the man doing?"

Reaction: "That felt good! Feedback was encouraging and gave me direction."
State: frustration=0.0, motivation=0.85 (↑ from helpful feedback)

[Maria tries again with more detail - includes intentional grammar mistake]
Action: Type "El hombre es sentado en el banco con su perro"

VALIDATION CHECK:
├─ "hombre" → ✅ present
├─ "sentado" (sitting) → ✅ action happening
├─ "banco" (bench) → ✅ present
├─ "perro" → ✅ present
├─ Grammar error: "es sentado" should be "está sentado" → ✅ VALID learning mistake
└─ All elements validated → PASS

Outcome: "¡Casi! Usa 'estar' para posiciones: 'está sentado'. ¡Muy bien con los detalles!"
Translation: "Almost! Use 'estar' for positions: 'is sitting'. Very good with the details!"

Reaction: "Oh, I used 'ser' instead of 'estar' for position. That makes sense now!"
State: frustration=0.0, motivation=0.90, confidence=0.75

Result: SUCCESS - P1 fulfilled, feedback addressed LANGUAGE error appropriately
```

### What Would Have Been WRONG:

```
[INCORRECT - Scene mismatch that should NOT happen]

[Maria loads page]
Screenshot: Park scene with man, dog, bench

[Maria types - WRONG, describes different scene]
Action: Type "El hombre está cortando las verduras en la cocina"

VALIDATION CHECK:
├─ "cortando verduras" (cutting vegetables) → ❌ NOT happening in scene
├─ "cocina" (kitchen) → ❌ Setting is PARK, not kitchen
└─ VALIDATION FAILED - Scene mismatch detected

REGENERATION TRIGGERED:
├─ Original: "El hombre está cortando las verduras en la cocina"
├─ Violations: [action_mismatch: "cutting vegetables", setting_mismatch: "kitchen"]
├─ Regenerating with scene constraints...
└─ New response: "El hombre está sentado con su perro" (scene-accurate)

[Continue with corrected response]
```

### Evaluation: Rubric Application

```yaml
scores:
  P1_fulfillment: 0.9  # Minor wait time issue
  feedback_quality: 0.90  # Addressed grammar, was encouraging
  motivation: 0.9  # Maria satisfied and encouraged
  scene_grounding: 1.0  # All responses matched actual scene content

overall: 0.90 (A-)

gaps:
  - criterion: "Doherty Threshold"
    score: 0.7
    issue: "1.2s feedback delay (should be <400ms)"
    severity: medium
    recommendation: "Add loading skeleton immediately"

test_validity:
  scene_match_rate: 100%  # All responses accurately described scene
  language_mistakes_made: 1  # "es sentado" instead of "está sentado"
  perception_mistakes_made: 0  # No wrong objects/actions described
  verdict: "VALID TEST - mistakes were linguistic, not perceptual"
```

### Output: Gap Analysis

```markdown
## Gap Analysis

**Overall Score:** 9.0/10 (Grade: A-)

**Verdict:** PASS with minor recommendations

**Test Validity:** ✅ CONFIRMED
- All test user responses accurately referenced scene elements
- Mistakes were language-learning errors (ser vs estar)
- No scene mismatches detected

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

### Upgrade Notes

**When skill version changes**, existing projects should regenerate their test artifacts:

```bash
# Check if upgrade needed (automatic on init)
/llm-user init

# Explicitly upgrade artifacts
/llm-user init --upgrade

# Or use refresh (also checks version)
/llm-user refresh
```

**Version tracking in CLAUDE.md:**
```yaml
ui_testing:
  skill_version: "1.1.0"  # Recorded when artifacts generated
```

---

### 1.1.0 (2026-01-28)

**BREAKING:** Scene-based apps (language learning with image descriptions) should regenerate artifacts.

**New Features:**
- **Principle 5: Scene-Grounded Responses** - Critical for scene-based apps
- **Step 0: GROUND IN SCENE** in Action Loop
- **Scene-Response Validation** with regeneration logic
- **scene_grounding** field in Recording Format
- **Scene-Based Scenario Template** for language learning apps

**Improvements:**
- Updated **Pattern 1: Learning Apps** with scene-specific rules
- Added scene grounding to **Best Practices** (DO and DON'T sections)
- Added scene accuracy to **Success Indicators**
- Added **What Would Have Been WRONG** section in examples

**Why Upgrade:**
Without scene-grounding, test users may describe objects not in the scene (e.g., "dog" when there's no dog), causing app feedback to be nonsensical and invalidating test results.

---

### 1.0.0 (2026-01-27)
- Initial release
- Protocols for LLM user simulation
- Gap analysis methodology
- Domain-specific testing patterns
- Evaluation rubric frameworks
