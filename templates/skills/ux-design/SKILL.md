---
name: ux-design
description: |
  UX design expertise and design principles. Use when:
  - Designing user interfaces
  - Creating screen specifications
  - Reviewing UI for design principles
  - Building frontend components
  - Evaluating user experience
---

# UX Design Principles

## Overview

This skill provides UX design expertise and core design principles. Apply these automatically when designing or implementing user interfaces.

---

## Core Design Laws

### Fitts's Law
**Law:** The time to acquire a target is a function of distance and size.

**Application:**
- Touch targets ≥44px (iOS HIG) or ≥48dp (Material)
- Large, close buttons for important actions
- Edges and corners are fastest (infinite width)

**Implementation:**
```css
button {
  min-width: 44px;
  min-height: 44px;
  padding: 12px 24px;
}
```

### Hick's Law
**Law:** Decision time increases logarithmically with choices.

**Application:**
- ≤7 options visible at once
- Use progressive disclosure for advanced features
- Group related options
- Provide smart defaults

**Implementation:**
- Initial screen: 3-5 primary actions
- Advanced options: Behind "More" or settings
- Wizards: One decision per step

### Miller's Law
**Law:** Working memory holds 7±2 items.

**Application:**
- Chunk information into groups
- Navigation: ≤7 top-level items
- Forms: Group related fields
- Lists: Use pagination or virtualization

**Implementation:**
```
Navigation:
├─ Dashboard
├─ Projects
├─ Team
├─ Settings
└─ Help
(5 items - within 7±2 limit)
```

### Jakob's Law
**Law:** Users expect your site to work like others they know.

**Application:**
- Follow platform conventions (iOS, Android, Web)
- Logo in top-left links to home
- Search in top-right
- Cart icon in header
- Standard form patterns

**Implementation:**
- iOS: Bottom tab bar, swipe back
- Android: Navigation drawer, FAB
- Web: Header with logo/nav, hero section

### Aesthetic-Usability Effect
**Law:** Beautiful designs are perceived as easier to use.

**Application:**
- Clean, consistent visual design
- Proper spacing (whitespace)
- Clear visual hierarchy
- Professional typography

**Implementation:**
```css
/* Spacing system (8px base) */
--space-1: 8px;
--space-2: 16px;
--space-3: 24px;
--space-4: 32px;
--space-5: 48px;
```

### Progressive Disclosure
**Law:** Show only what's needed now, hide complexity.

**Application:**
- Basic features upfront
- Advanced features in menus
- Expand/collapse sections
- Wizard flows for complex tasks

**Implementation:**
```
User Profile (Initial):
├─ Name
├─ Email
└─ [Advanced Settings] (collapsed)

User Profile (Expanded):
├─ Name
├─ Email
└─ Advanced Settings ▼
    ├─ Timezone
    ├─ Language
    ├─ Privacy
    └─ Notifications
```

### Recognition Over Recall
**Law:** Show options, don't make users remember.

**Application:**
- Dropdowns instead of text input
- Autocomplete for known values
- Recently used items
- Visible navigation

**Implementation:**
```html
<!-- Good: Recognition -->
<select>
  <option>United States</option>
  <option>Canada</option>
  <option>United Kingdom</option>
</select>

<!-- Bad: Recall -->
<input type="text" placeholder="Enter country">
```

### Doherty Threshold
**Law:** Productivity soars when computer responds in <400ms.

**Application:**
- Instant feedback (<100ms)
- Loading states (100-400ms)
- Skeleton screens (>400ms)
- Optimistic UI updates

**Implementation:**
```javascript
// Show loading immediately
setLoading(true);

// Optimistic update
updateUI(data);

// Then send request
await api.save(data);
```

---

## UI Component Specifications

### Buttons

**Primary Button:**
```
Size: 44px min height
Padding: 12px 24px
Border-radius: 8px
Font: 16px, semibold
Color: High contrast (4.5:1 ratio)
State: hover, active, disabled, loading
```

**Button Hierarchy:**
- Primary: 1 per screen (main action)
- Secondary: Supporting actions
- Tertiary: Low-emphasis actions

### Forms

**Best Practices:**
- Label above input (easier to scan)
- Input height: 44-48px
- Error message below input
- Inline validation after blur
- Group related fields

**Layout:**
```
[Label]
[Input field - 44px height]
[Error message (red, 14px)]

[Space: 24px between fields]

[Label]
[Input field - 44px height]
```

### Cards

**Structure:**
```
Card:
├─ Image (16:9 aspect ratio)
├─ Padding: 16-24px
├─ Title: 18-20px, bold
├─ Body: 14-16px, regular
├─ Action: Button or link
└─ Shadow: Subtle elevation
```

### Navigation

**Patterns:**
- **Mobile:** Bottom tab bar (3-5 items)
- **Desktop:** Top header + sidebar
- **Tablet:** Adaptive (collapsible sidebar)

**Implementation:**
- Active state clearly visible
- Icons + labels (not icons alone)
- Consistent positioning

### Spacing

**8px Grid System:**
```
Micro: 4px   (icon-text gap)
XS:    8px   (tight spacing)
S:     16px  (comfortable)
M:     24px  (section spacing)
L:     32px  (major sections)
XL:    48px  (page sections)
XXL:   64px  (hero spacing)
```

---

## Color & Accessibility

### Contrast Requirements

**WCAG AA (minimum):**
- Normal text: 4.5:1 ratio
- Large text (18px+): 3:1 ratio
- UI components: 3:1 ratio

**Implementation:**
Always check contrast:
```
Text on background: ≥4.5:1
Button on background: ≥3:1
Icons on background: ≥3:1
```

### Color Palette

**Structure:**
```
Primary:   Brand color (CTAs, links)
Secondary: Supporting color
Success:   Green (#22c55e)
Warning:   Orange (#f59e0b)
Error:     Red (#ef4444)
Neutral:   Grays (backgrounds, borders)
```

**Shades:**
Each color: 50, 100, 200, ..., 900
- 50-100: Backgrounds
- 200-300: Borders
- 400-600: Interactive elements
- 700-900: Text

---

## Responsive Design

### Breakpoints

```
Mobile:  < 640px
Tablet:  640px - 1024px
Desktop: > 1024px
```

### Mobile-First Approach

```css
/* Mobile (base) */
.container {
  padding: 16px;
}

/* Tablet */
@media (min-width: 640px) {
  .container {
    padding: 24px;
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .container {
    padding: 32px;
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

---

## Animation & Motion

### Timing

```
Micro-interactions: 100-200ms
Transitions:        200-300ms
Complex animations: 300-500ms
```

### Easing

```
Entering: ease-out (start fast, end slow)
Exiting:  ease-in (start slow, end fast)
Moving:   ease-in-out (smooth)
```

### Implementation

```css
button {
  transition: all 200ms ease-out;
}

.modal-enter {
  animation: fadeIn 300ms ease-out;
}

.modal-exit {
  animation: fadeOut 200ms ease-in;
}
```

---

## Validation Checklist

Use this for every UI:

### Layout
- [ ] Touch targets ≥44px
- [ ] Proper spacing (8px grid)
- [ ] Visual hierarchy clear
- [ ] Responsive (mobile, tablet, desktop)

### Content
- [ ] Options ≤7 visible
- [ ] Progressive disclosure for complexity
- [ ] Recognition over recall

### Accessibility
- [ ] Color contrast ≥4.5:1
- [ ] Keyboard navigation works
- [ ] Screen reader friendly
- [ ] Focus states visible

### Interaction
- [ ] Loading states (<400ms)
- [ ] Error states with messages
- [ ] Success feedback
- [ ] Disabled states clear

### Consistency
- [ ] Follows platform conventions
- [ ] Consistent styling
- [ ] Predictable behavior
- [ ] Familiar patterns

---

## Output Format

When creating UX specifications, use this structure:

```markdown
## [Screen Name]

### Purpose
[What this screen does]

### User Journey
[How user arrives here]

### Components

#### [Component Name]
- **Type:** Button/Input/Card/etc.
- **Size:** [dimensions]
- **Content:** [what it contains]
- **Behavior:** [interactions]
- **States:** [default, hover, active, etc.]

### Layout
[ASCII or description of layout]

### Responsive Behavior
- Mobile: [how it adapts]
- Tablet: [how it adapts]
- Desktop: [how it adapts]

### Design Principles Applied
- [ ] Fitts's Law: [how]
- [ ] Hick's Law: [how]
- [ ] Miller's Law: [how]
- [ ] Jakob's Law: [how]
- [ ] Aesthetic-Usability: [how]
- [ ] Progressive Disclosure: [how]
- [ ] Recognition: [how]
- [ ] Doherty Threshold: [how]
```

---

## Integration with Frontend Skill

When frontend-engineer implements UI:
1. Load this ux-design skill for reference
2. Apply design principles automatically
3. Use spacing system (8px grid)
4. Implement responsive breakpoints
5. Add loading/error/success states
6. Ensure accessibility standards
7. No need to ask user about these standards - just apply them
