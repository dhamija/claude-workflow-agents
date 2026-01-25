<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║ 🔧 MAINTENANCE REQUIRED                                                      ║
║                                                                              ║
║ After editing this file, you MUST also update:                               ║
║   □ CLAUDE.md        → "Current State" section (command count, list)         ║
║   □ commands/agent-wf-help.md → "commands" topic                             ║
║   □ README.md        → commands table                                        ║
║   □ GUIDE.md         → commands list                                         ║
║   □ tests/structural/test_commands_exist.sh → REQUIRED_COMMANDS array        ║
║                                                                              ║
║ Git hooks will BLOCK your commit if these are not updated.                   ║
║ Run: ./scripts/verify-sync.sh to check compliance.                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

---
name: design
description: Manage design system for visual consistency across your project
usage: /design [mode] [args]
category: UX & Design
---

# /design - Design System Management

Manage your project's design system to ensure visual consistency across all UI components.

## Usage

```bash
/design show              # Display current design system
/design update            # Interactively update design system
/design preset <name>     # Apply a design preset
/design reference <url>   # Analyze a website and create design system
```

## Modes

### Show Current Design System

```bash
/design show
```

Displays the current design system from `/docs/ux/design-system.md`:
- Color palette (primary, secondary, semantic colors)
- Typography (fonts, sizes, weights)
- Spacing scale and layout properties
- Component styles (buttons, inputs, cards)
- Implementation snippets (Tailwind config, CSS variables)

**Use when:**
- You want to see what design system is currently in use
- Frontend engineer needs to reference the design spec
- Reviewing visual specifications before implementation

---

### Update Design System

```bash
/design update
```

Interactively update the design system:
1. Asks what you want to change (colors, typography, spacing, components)
2. Shows current values
3. Prompts for new values
4. Updates `/docs/ux/design-system.md`
5. Alerts you if this is a breaking change (affects existing components)

**Use when:**
- You want to change brand colors
- You need to update typography
- You want to adjust spacing/layout
- You're refining component styles

**Example flow:**
```
You: /design update
Claude: What would you like to update?
  1. Colors
  2. Typography
  3. Spacing
  4. Components
  5. Custom

You: 1
Claude: Current primary color: #2563eb
        New primary color:
You: #7c3aed
Claude: ✓ Updated primary color to #7c3aed
        Would you like to update related light/dark variants? (Y/n)
```

---

### Apply Design Preset

```bash
/design preset modern-clean
/design preset minimal
/design preset playful
/design preset corporate
/design preset glassmorphism
```

Apply a pre-configured design system from templates:

**Available Presets:**

| Preset | Description | Best For |
|--------|-------------|----------|
| `modern-clean` | Professional SaaS style (blue, clean, trustworthy) | Business apps, dashboards, productivity tools |
| `minimal` | Ultra-clean, content-focused (black/white) | Blogs, documentation, reading apps |
| `playful` | Vibrant, fun, energetic (purple/pink gradients) | Consumer apps, gaming, creative tools |
| `corporate` | Professional enterprise-grade (dark blue, formal) | B2B platforms, financial apps, enterprise software |
| `glassmorphism` | Modern glass effects with transparency | Modern web apps, portfolios, premium products |

**Use when:**
- Starting a new project and want sensible defaults
- You like a specific visual style and want to apply it quickly
- You want to experiment with different design directions

**Example:**
```bash
/design preset playful

✓ Applied playful design preset
  Primary color: #7c3aed (Purple 600)
  Style: Vibrant, fun, energetic with gradients and animations
  Components: Rounded corners, colorful shadows, bounce effects

  Design system created at: /docs/ux/design-system.md
```

---

### Reference Website Design

```bash
/design reference https://linear.app
/design reference https://vercel.com
/design reference https://stripe.com
```

Analyze a reference website and create a design system based on its visual style:

1. Fetches and analyzes the website
2. Extracts design patterns:
   - Color palette
   - Typography choices
   - Spacing and layout
   - Component patterns
   - Animation/interaction style
3. Creates `/docs/ux/design-system.md` with similar specifications
4. Provides Tailwind config and CSS variables

**Use when:**
- You want your app to look like a specific reference site
- You have design inspiration from existing products
- You want to match a competitor's visual style

**Example:**
```bash
/design reference https://linear.app

Analyzing https://linear.app...

✓ Design system created based on Linear's design language:
  - Color palette: Purple/blue primary, subtle grays
  - Typography: Inter font family
  - Spacing: Tight, efficient layout
  - Components: Minimal shadows, subtle borders, fast transitions
  - Characteristics: Clean, fast, professional

  Design system created at: /docs/ux/design-system.md
  Preset: Similar to 'modern-clean' with purple accent
```

---

## Design System File Location

All modes create or update:
```
/docs/ux/design-system.md
```

This is the **single source of truth** for all visual design decisions. The frontend-engineer agent MUST read this file before implementing any UI.

---

## Integration with Workflow

### During Project Initialization (via /ux)
UX architect will ask about design preferences and create initial design system using one of the modes above.

### During Frontend Implementation (via /implement)
Frontend engineer reads `/docs/ux/design-system.md` and follows it strictly for all visual styling.

### During Design Changes
Use `/design update` or `/design preset` to make systematic design changes that automatically propagate through the design system file.

---

## Design System Components

A complete design system includes:

### 1. Color Palette
- Primary colors (default, light, dark variants)
- Secondary & accent colors
- Neutral scale (grays)
- Semantic colors (success, warning, error, info)
- Dark mode support

### 2. Typography
- Font families (heading, body, monospace)
- Font sizes (xs through 5xl)
- Font weights (regular through bold)
- Line heights
- Text styles (headings, body, labels)

### 3. Spacing & Layout
- Spacing scale (0-16 in rem units)
- Max widths for content areas
- Grid system specifications
- Border radius scale
- Shadow definitions

### 4. Components
Complete CSS/Tailwind specs for:
- Buttons (primary, secondary, variants)
- Inputs (text, select, textarea)
- Cards & containers
- Navigation elements
- Modals & overlays
- Badges & tags
- Tables & lists

### 5. Motion & Animation
- Timing functions
- Transition durations
- Keyframe animations
- Hover/focus/active states

### 6. Accessibility
- Color contrast ratios (WCAG compliance)
- Focus state specifications
- ARIA patterns for components
- Keyboard navigation support

### 7. Responsive Design
- Breakpoints
- Mobile-first approach
- Touch target sizes

### 8. Implementation
- Tailwind configuration code
- CSS variables definitions
- Component library bootstrap instructions

---

## Examples

### Quick Start with Preset
```bash
# Starting a new SaaS product
/design preset modern-clean
```

### Match Reference Site
```bash
# Want to look like Notion
/design reference https://notion.so
```

### Custom Brand Colors
```bash
# Update to match your brand
/design update
> 1 (Colors)
> Primary color: #ff6b6b
> Secondary color: #4ecdc4
```

### Show Current Design
```bash
# Frontend engineer wants to reference design system
/design show

# Output shows current colors, typography, components with code examples
```

---

## Best Practices

1. **Set design system early** - Before any frontend implementation
2. **One source of truth** - All visual decisions documented in design-system.md
3. **Update systematically** - Use `/design update`, not manual file edits
4. **Frontend follows strictly** - No arbitrary colors/fonts/spacing in code
5. **Test consistency** - Verify all components match design system specs

---

## Files Created/Modified

| File | Purpose |
|------|---------|
| `/docs/ux/design-system.md` | Complete visual design specification |
| `tailwind.config.js` | Tailwind configuration (if using Tailwind) |
| `styles/variables.css` | CSS variables (if using vanilla CSS) |

---

## Related Commands

- `/ux` - Creates user journeys AND initial design system
- `/implement` - Frontend engineer uses design system for implementation
- `/review` - Code review can check design system compliance

---

## Error Handling

### If design system doesn't exist:
```
❌ No design system found at /docs/ux/design-system.md

Would you like to:
1. Create one with /design preset <name>
2. Reference a site with /design reference <url>
3. Run /ux to set up full UX design (includes design system)
```

### If trying to update non-existent design system:
```
❌ Cannot update - no design system exists yet

Create one first:
  /design preset modern-clean
  /design reference https://example.com
```

### If reference URL is invalid:
```
❌ Could not fetch https://invalid-url.com

Please provide a valid, accessible website URL.
```

---

## Implementation Notes

**For agents implementing this command:**

1. **show mode**:
   - Read `/docs/ux/design-system.md`
   - Format and display key sections (colors, typography, components)
   - Include code examples (Tailwind config, CSS variables)

2. **update mode**:
   - Read current design system
   - Interactively ask what to change
   - Update specific sections
   - Preserve other sections
   - Alert if changes affect existing components

3. **preset mode**:
   - Copy from `templates/docs/ux/presets/{preset-name}.md`
   - Fill in {{PROJECT_NAME}} and {{DATE}} placeholders
   - Write to `/docs/ux/design-system.md`

4. **reference mode**:
   - Use WebFetch to analyze reference site
   - Extract visual patterns (colors, fonts, spacing)
   - Generate design system matching reference site
   - Document inspiration source

**All modes should:**
- Create `/docs/ux/design-system.md` if it doesn't exist
- Validate completeness (all required sections present)
- Provide Tailwind config AND CSS variables
- Include implementation examples
