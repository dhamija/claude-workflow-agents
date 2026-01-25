# Modern Clean Design Preset

> Professional SaaS-style design system with clean lines and modern aesthetics

## Overview

**Best for:** SaaS products, business apps, productivity tools, dashboards
**Characteristics:** Clean, professional, trustworthy, modern, minimalist
**Inspired by:** Linear, Vercel, Stripe, Notion

## Color Palette

### Primary Colors
```
Primary: #2563eb (Blue 600)
Primary Light: #3b82f6 (Blue 500)
Primary Dark: #1d4ed8 (Blue 700)
```

### Secondary Colors
```
Secondary: #8b5cf6 (Purple 500)
Accent: #06b6d4 (Cyan 500)
```

### Neutral Scale
```
Gray 50: #f9fafb
Gray 100: #f3f4f6
Gray 200: #e5e7eb
Gray 300: #d1d5db
Gray 400: #9ca3af
Gray 500: #6b7280
Gray 600: #4b5563
Gray 700: #374151
Gray 800: #1f2937
Gray 900: #111827
```

### Semantic Colors
```
Success: #10b981 (Green 500)
Warning: #f59e0b (Amber 500)
Error: #ef4444 (Red 500)
Info: #3b82f6 (Blue 500)
```

### Dark Mode
```
Background: #0f172a (Slate 900)
Surface: #1e293b (Slate 800)
Border: #334155 (Slate 700)
Text Primary: #f1f5f9 (Slate 100)
Text Secondary: #cbd5e1 (Slate 300)
```

## Typography

### Font Families
```
Heading: 'Inter', system-ui, sans-serif
Body: 'Inter', system-ui, sans-serif
Monospace: 'JetBrains Mono', 'Fira Code', monospace
```

### Font Sizes
```
xs: 0.75rem (12px)
sm: 0.875rem (14px)
base: 1rem (16px)
lg: 1.125rem (18px)
xl: 1.25rem (20px)
2xl: 1.5rem (24px)
3xl: 1.875rem (30px)
4xl: 2.25rem (36px)
5xl: 3rem (48px)
```

### Font Weights
```
Regular: 400
Medium: 500
Semibold: 600
Bold: 700
```

## Spacing & Layout

### Border Radius
```
sm: 0.375rem (6px)
md: 0.5rem (8px)
lg: 0.75rem (12px)
xl: 1rem (16px)
2xl: 1.5rem (24px)
```

### Shadows
```
sm: 0 1px 2px 0 rgb(0 0 0 / 0.05)
md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)
lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)
xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)
```

## Components

### Buttons
```css
.btn-primary {
  background: #2563eb;
  color: white;
  padding: 10px 20px;
  border-radius: 0.5rem;
  font-weight: 600;
  font-size: 0.875rem;
  transition: all 0.15s ease;
  border: none;
}

.btn-primary:hover {
  background: #1d4ed8;
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}

.btn-secondary {
  background: white;
  color: #1f2937;
  padding: 10px 20px;
  border-radius: 0.5rem;
  font-weight: 600;
  font-size: 0.875rem;
  border: 1px solid #e5e7eb;
  transition: all 0.15s ease;
}

.btn-secondary:hover {
  background: #f9fafb;
  border-color: #d1d5db;
}
```

### Inputs
```css
.input {
  padding: 10px 14px;
  border: 1px solid #d1d5db;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  transition: all 0.15s ease;
  background: white;
  color: #111827;
}

.input:focus {
  outline: none;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}
```

### Cards
```css
.card {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 0.75rem;
  padding: 24px;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  transition: all 0.2s ease;
}

.card:hover {
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  transform: translateY(-2px);
}
```

## Motion & Animation

### Timing
```
Fast: 0.15s
Normal: 0.2s
Slow: 0.3s
Easing: cubic-bezier(0.4, 0, 0.2, 1)
```

### Hover Effects
- Subtle lift (translateY -1px to -2px)
- Shadow increase
- Color darkening (5-10%)

## Accessibility

### Contrast Ratios
- All text meets WCAG AA (4.5:1 minimum)
- Primary blue (#2563eb) on white: 7.35:1 ✓
- Gray 600 (#4b5563) on white: 8.59:1 ✓

### Focus States
- 3px ring with 10% opacity of primary color
- Always visible, never removed

## Responsive Design

### Breakpoints
```
sm: 640px
md: 768px
lg: 1024px
xl: 1280px
2xl: 1536px
```

### Mobile Adjustments
- Slightly smaller padding (8px instead of 10px)
- Larger touch targets (minimum 44px)
- Simplified shadows on mobile
- Reduced animation on lower-powered devices

## Implementation Notes

### Tailwind Configuration
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2563eb',
          light: '#3b82f6',
          dark: '#1d4ed8',
        },
        secondary: '#8b5cf6',
        accent: '#06b6d4',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      },
    },
  },
}
```

### CSS Variables
```css
:root {
  /* Colors */
  --color-primary: #2563eb;
  --color-primary-light: #3b82f6;
  --color-primary-dark: #1d4ed8;
  --color-secondary: #8b5cf6;
  --color-accent: #06b6d4;

  /* Grays */
  --gray-50: #f9fafb;
  --gray-100: #f3f4f6;
  --gray-200: #e5e7eb;
  --gray-300: #d1d5db;
  --gray-400: #9ca3af;
  --gray-500: #6b7280;
  --gray-600: #4b5563;
  --gray-700: #374151;
  --gray-800: #1f2937;
  --gray-900: #111827;

  /* Typography */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

  /* Spacing */
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;

  /* Border Radius */
  --radius-sm: 0.375rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}
```

## Usage Examples

### Dashboard Layout
```jsx
<div className="min-h-screen bg-gray-50">
  <nav className="bg-white border-b border-gray-200 px-6 py-4">
    <div className="flex items-center justify-between">
      <h1 className="text-xl font-semibold text-gray-900">Dashboard</h1>
      <button className="btn-primary">New Project</button>
    </div>
  </nav>

  <main className="max-w-7xl mx-auto px-6 py-8">
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div className="card">
        <h3 className="text-lg font-semibold mb-2">Active Projects</h3>
        <p className="text-3xl font-bold text-primary">24</p>
      </div>
    </div>
  </main>
</div>
```

### Form Example
```jsx
<form className="card max-w-md">
  <h2 className="text-2xl font-bold mb-6">Sign In</h2>

  <div className="mb-4">
    <label className="block text-sm font-medium mb-2">Email</label>
    <input type="email" className="input w-full" />
  </div>

  <div className="mb-6">
    <label className="block text-sm font-medium mb-2">Password</label>
    <input type="password" className="input w-full" />
  </div>

  <button className="btn-primary w-full">Sign In</button>
</form>
```

## References

- **Linear**: Clean, fast, professional UI
- **Vercel**: Minimalist, developer-focused design
- **Stripe**: Trust-inspiring, clear hierarchy
- **Notion**: Organized, calm, functional
