# Minimal Design Preset

> Ultra-clean, content-focused design with maximum clarity and zero distractions

## Overview

**Best for:** Blogs, documentation, reading apps, portfolio sites, content platforms
**Characteristics:** Clean, spacious, typography-focused, distraction-free, timeless
**Inspired by:** Medium, iA Writer, Substack, Apple Human Interface

## Color Palette

### Primary Colors
```
Primary: #000000 (Pure Black)
Primary Light: #374151 (Gray 700)
Primary Dark: #000000 (Pure Black)
```

### Secondary Colors
```
Secondary: #6b7280 (Gray 500)
Accent: #111827 (Gray 900)
```

### Neutral Scale
```
White: #ffffff
Gray 50: #fafafa
Gray 100: #f5f5f5
Gray 200: #e5e5e5
Gray 300: #d4d4d4
Gray 400: #a3a3a3
Gray 500: #737373
Gray 600: #525252
Gray 700: #404040
Gray 800: #262626
Gray 900: #171717
Black: #000000
```

### Semantic Colors
```
Success: #22c55e (Green 500)
Warning: #f59e0b (Amber 500)
Error: #dc2626 (Red 600)
Info: #3b82f6 (Blue 500)
```

### Dark Mode
```
Background: #000000 (Pure Black)
Surface: #0a0a0a
Border: #1a1a1a
Text Primary: #fafafa
Text Secondary: #a3a3a3
```

## Typography

### Font Families
```
Heading: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif
Body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif
Monospace: 'SF Mono', 'Monaco', 'Courier New', monospace
```

### Font Sizes
```
xs: 0.75rem (12px)
sm: 0.875rem (14px)
base: 1rem (16px)
lg: 1.125rem (18px)
xl: 1.25rem (20px)
2xl: 1.5rem (24px)
3xl: 2rem (32px)
4xl: 2.5rem (40px)
5xl: 3.5rem (56px)
```

### Font Weights
```
Regular: 400
Medium: 500
Semibold: 600
```

### Line Heights
```
Tight: 1.25
Normal: 1.5
Relaxed: 1.75
Loose: 2
```

## Spacing & Layout

### Spacing Scale (Generous)
```
1: 0.25rem (4px)
2: 0.5rem (8px)
3: 0.75rem (12px)
4: 1rem (16px)
6: 1.5rem (24px)
8: 2rem (32px)
12: 3rem (48px)
16: 4rem (64px)
24: 6rem (96px)
32: 8rem (128px)
```

### Border Radius
```
none: 0
sm: 0.125rem (2px)
md: 0.25rem (4px)
lg: 0.5rem (8px)
```

### Shadows
```
sm: 0 1px 2px 0 rgb(0 0 0 / 0.05)
md: 0 1px 3px 0 rgb(0 0 0 / 0.1)
```

**Note:** Minimal shadows - rely on borders and spacing for hierarchy

## Components

### Buttons
```css
.btn-primary {
  background: #000000;
  color: white;
  padding: 12px 24px;
  border-radius: 0.25rem;
  font-weight: 500;
  font-size: 0.875rem;
  transition: opacity 0.2s ease;
  border: none;
}

.btn-primary:hover {
  opacity: 0.85;
}

.btn-secondary {
  background: transparent;
  color: #000000;
  padding: 12px 24px;
  border-radius: 0.25rem;
  font-weight: 500;
  font-size: 0.875rem;
  border: 1px solid #e5e5e5;
  transition: border-color 0.2s ease;
}

.btn-secondary:hover {
  border-color: #000000;
}
```

### Inputs
```css
.input {
  padding: 12px 16px;
  border: 1px solid #e5e5e5;
  border-radius: 0.25rem;
  font-size: 1rem;
  transition: border-color 0.2s ease;
  background: white;
  color: #000000;
  font-weight: 400;
}

.input:focus {
  outline: none;
  border-color: #000000;
}

.input::placeholder {
  color: #a3a3a3;
}
```

### Cards
```css
.card {
  background: white;
  border: 1px solid #f5f5f5;
  border-radius: 0.5rem;
  padding: 32px;
  transition: border-color 0.2s ease;
}

.card:hover {
  border-color: #e5e5e5;
}
```

### Typography Components
```css
.prose {
  max-width: 65ch;
  font-size: 1.125rem;
  line-height: 1.75;
  color: #171717;
}

.prose h1 {
  font-size: 2.5rem;
  font-weight: 600;
  line-height: 1.25;
  margin-bottom: 1.5rem;
  color: #000000;
}

.prose h2 {
  font-size: 2rem;
  font-weight: 600;
  line-height: 1.25;
  margin-top: 3rem;
  margin-bottom: 1.5rem;
  color: #000000;
}

.prose p {
  margin-bottom: 1.5rem;
}

.prose a {
  color: #000000;
  text-decoration: underline;
  text-underline-offset: 2px;
  transition: opacity 0.2s ease;
}

.prose a:hover {
  opacity: 0.6;
}
```

## Motion & Animation

### Timing
```
Fast: 0.15s
Normal: 0.2s
Slow: 0.3s
Easing: ease (simple, not complex cubic-bezier)
```

### Hover Effects
- Opacity changes (0.85 or 0.6)
- Border color changes
- NO transforms or shadows
- Subtle and quick

## Accessibility

### Contrast Ratios
- Pure black (#000000) on white: 21:1 (AAA) ✓
- Gray 700 (#404040) on white: 10.37:1 (AAA) ✓
- Gray 500 (#737373) on white: 4.69:1 (AA) ✓

### Focus States
- 1px solid black border
- No fancy rings, just simple underlines

## Responsive Design

### Breakpoints
```
sm: 640px
md: 768px
lg: 1024px
```

**Note:** Minimal breakpoints - design works at all sizes

### Mobile Adjustments
- Larger font sizes for readability (18px base)
- More vertical spacing (1.5x)
- Full-width buttons
- Simplified navigation

## Implementation Notes

### Tailwind Configuration
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#000000',
          light: '#374151',
          dark: '#000000',
        },
      },
      fontFamily: {
        sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
        mono: ['SF Mono', 'Monaco', 'Courier New', 'monospace'],
      },
      maxWidth: {
        'prose': '65ch',
      },
      lineHeight: {
        'relaxed': '1.75',
      },
    },
  },
}
```

### CSS Variables
```css
:root {
  /* Colors */
  --color-primary: #000000;
  --color-text: #171717;
  --color-text-light: #737373;
  --color-border: #e5e5e5;
  --color-background: #ffffff;

  /* Typography */
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'SF Mono', 'Monaco', 'Courier New', monospace;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.75;

  /* Spacing */
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;

  /* Layout */
  --max-width-prose: 65ch;
  --border-radius: 0.25rem;
}
```

## Usage Examples

### Article Layout
```jsx
<article className="max-w-prose mx-auto px-6 py-16">
  <h1 className="text-4xl font-semibold mb-4">
    The Art of Simplicity
  </h1>

  <p className="text-gray-500 mb-12">
    Published on January 25, 2026
  </p>

  <div className="prose">
    <p>
      In a world of constant noise and distraction, simplicity
      has become a luxury. The best designs are often the ones
      that get out of the way.
    </p>

    <h2>Less is More</h2>

    <p>
      Every element should serve a purpose. Remove everything
      that doesn't directly support the content or the user's goal.
    </p>
  </div>
</article>
```

### Simple Form
```jsx
<div className="max-w-md mx-auto px-6 py-16">
  <h1 className="text-3xl font-semibold mb-8">Subscribe</h1>

  <form className="space-y-4">
    <input
      type="email"
      placeholder="your@email.com"
      className="input w-full"
    />

    <button className="btn-primary w-full">
      Subscribe
    </button>
  </form>

  <p className="text-sm text-gray-500 mt-4">
    No spam. Unsubscribe anytime.
  </p>
</div>
```

### Navigation
```jsx
<nav className="border-b border-gray-200 px-6 py-4">
  <div className="max-w-5xl mx-auto flex items-center justify-between">
    <a href="/" className="font-semibold text-lg">
      Logo
    </a>

    <div className="flex gap-8">
      <a href="/about" className="text-sm hover:opacity-60 transition">
        About
      </a>
      <a href="/work" className="text-sm hover:opacity-60 transition">
        Work
      </a>
      <a href="/contact" className="text-sm hover:opacity-60 transition">
        Contact
      </a>
    </div>
  </div>
</nav>
```

## Design Principles

1. **Content First**: Design should enhance, not overshadow content
2. **Generous Spacing**: Use whitespace liberally
3. **Limited Palette**: Black, white, gray - that's it (except semantic colors)
4. **Typography Matters**: Invest in excellent fonts and careful sizing
5. **No Decoration**: Remove borders, shadows, gradients unless absolutely necessary
6. **Fast and Light**: Minimal CSS, minimal JavaScript
7. **Timeless**: Avoid trends, focus on clarity

## References

- **Medium**: Reading-focused typography
- **iA Writer**: Distraction-free simplicity
- **Substack**: Clean newsletter layouts
- **Apple HIG**: System-level simplicity
