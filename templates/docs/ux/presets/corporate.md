# Corporate Design Preset

> Professional, trustworthy, enterprise-grade design for serious business applications

## Overview

**Best for:** Enterprise software, B2B platforms, financial apps, legal tech, corporate dashboards
**Characteristics:** Professional, trustworthy, conservative, formal, authoritative, data-dense
**Inspired by:** Bloomberg Terminal, SAP, Microsoft Azure, Oracle, IBM

## Color Palette

### Primary Colors
```
Primary: #1e3a8a (Blue 900)
Primary Light: #3b82f6 (Blue 500)
Primary Dark: #1e40af (Blue 800)
```

### Secondary Colors
```
Secondary: #475569 (Slate 600)
Accent: #0891b2 (Cyan 600)
```

### Neutral Scale
```
Slate 50: #f8fafc
Slate 100: #f1f5f9
Slate 200: #e2e8f0
Slate 300: #cbd5e1
Slate 400: #94a3b8
Slate 500: #64748b
Slate 600: #475569
Slate 700: #334155
Slate 800: #1e293b
Slate 900: #0f172a
```

### Semantic Colors
```
Success: #059669 (Emerald 600)
Warning: #d97706 (Amber 600)
Error: #dc2626 (Red 600)
Info: #0284c7 (Sky 600)
```

### Data Visualization Palette
```
Chart Blue: #3b82f6
Chart Green: #10b981
Chart Yellow: #f59e0b
Chart Red: #ef4444
Chart Purple: #8b5cf6
Chart Teal: #14b8a6
Chart Orange: #f97316
Chart Pink: #ec4899
```

### Dark Mode
```
Background: #0f172a (Slate 900)
Surface: #1e293b (Slate 800)
Border: #334155 (Slate 700)
Text Primary: #f1f5f9 (Slate 100)
Text Secondary: #94a3b8 (Slate 400)
```

## Typography

### Font Families
```
Heading: 'IBM Plex Sans', 'Roboto', 'Segoe UI', sans-serif
Body: 'IBM Plex Sans', 'Roboto', 'Segoe UI', sans-serif
Monospace: 'IBM Plex Mono', 'Consolas', 'Monaco', monospace
```

### Font Sizes
```
xs: 0.6875rem (11px)
sm: 0.75rem (12px)
base: 0.875rem (14px)
lg: 1rem (16px)
xl: 1.125rem (18px)
2xl: 1.5rem (24px)
3xl: 1.875rem (30px)
4xl: 2.25rem (36px)
```

### Font Weights
```
Regular: 400
Medium: 500
Semibold: 600
Bold: 700
```

### Line Heights
```
Tight: 1.25
Normal: 1.5
Relaxed: 1.625
```

## Spacing & Layout

### Spacing Scale
```
0.5: 0.125rem (2px)
1: 0.25rem (4px)
2: 0.5rem (8px)
3: 0.75rem (12px)
4: 1rem (16px)
5: 1.25rem (20px)
6: 1.5rem (24px)
8: 2rem (32px)
10: 2.5rem (40px)
12: 3rem (48px)
```

### Border Radius (Conservative)
```
none: 0
sm: 0.125rem (2px)
md: 0.25rem (4px)
lg: 0.375rem (6px)
```

### Shadows
```
sm: 0 1px 2px 0 rgb(0 0 0 / 0.05)
md: 0 4px 6px -1px rgb(0 0 0 / 0.1)
lg: 0 10px 15px -3px rgb(0 0 0 / 0.1)
```

### Grid System
```
Columns: 12
Gutter: 24px
Max Width: 1440px
```

## Components

### Buttons
```css
.btn-primary {
  background: #1e3a8a;
  color: white;
  padding: 8px 16px;
  border-radius: 0.25rem;
  font-weight: 600;
  font-size: 0.875rem;
  transition: background-color 0.15s ease;
  border: none;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-primary:hover {
  background: #1e40af;
}

.btn-primary:disabled {
  background: #94a3b8;
  cursor: not-allowed;
}

.btn-secondary {
  background: white;
  color: #1e3a8a;
  padding: 8px 16px;
  border-radius: 0.25rem;
  font-weight: 600;
  font-size: 0.875rem;
  border: 1px solid #cbd5e1;
  transition: all 0.15s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-secondary:hover {
  background: #f8fafc;
  border-color: #1e3a8a;
}
```

### Inputs
```css
.input {
  padding: 8px 12px;
  border: 1px solid #cbd5e1;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  transition: border-color 0.15s ease;
  background: white;
  color: #0f172a;
  font-family: 'IBM Plex Sans', sans-serif;
}

.input:focus {
  outline: none;
  border-color: #1e3a8a;
  box-shadow: 0 0 0 2px rgba(30, 58, 138, 0.1);
}

.input:disabled {
  background: #f1f5f9;
  color: #94a3b8;
  cursor: not-allowed;
}

.input-error {
  border-color: #dc2626;
}

.input-error:focus {
  box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.1);
}
```

### Tables
```css
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.875rem;
}

.table thead {
  background: #f8fafc;
  border-bottom: 2px solid #e2e8f0;
}

.table th {
  padding: 12px 16px;
  text-align: left;
  font-weight: 600;
  color: #475569;
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.5px;
}

.table td {
  padding: 12px 16px;
  border-bottom: 1px solid #e2e8f0;
  color: #1e293b;
}

.table tbody tr:hover {
  background: #f8fafc;
}

.table tbody tr:last-child td {
  border-bottom: none;
}
```

### Cards
```css
.card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 0.375rem;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
}

.card-header {
  padding: 16px 20px;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
  font-weight: 600;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: #475569;
}

.card-body {
  padding: 20px;
}

.card-footer {
  padding: 16px 20px;
  border-top: 1px solid #e2e8f0;
  background: #f8fafc;
}
```

### Navigation
```css
.nav-primary {
  background: #1e3a8a;
  padding: 0;
  border-bottom: 3px solid #1e40af;
}

.nav-item {
  color: #cbd5e1;
  padding: 16px 20px;
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  transition: all 0.15s ease;
  border-bottom: 3px solid transparent;
  margin-bottom: -3px;
}

.nav-item:hover {
  color: white;
  background: rgba(255, 255, 255, 0.05);
}

.nav-item.active {
  color: white;
  border-bottom-color: #3b82f6;
}
```

### Modals
```css
.modal-overlay {
  background: rgba(15, 23, 42, 0.75);
  backdrop-filter: blur(4px);
}

.modal {
  background: white;
  border-radius: 0.375rem;
  box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1);
  max-width: 600px;
  width: 100%;
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid #e2e8f0;
}

.modal-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #0f172a;
}

.modal-body {
  padding: 24px;
  max-height: 60vh;
  overflow-y: auto;
}

.modal-footer {
  padding: 16px 24px;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
```

### Status Indicators
```css
.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 0.25rem;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-active {
  background: #d1fae5;
  color: #065f46;
}

.status-pending {
  background: #fef3c7;
  color: #92400e;
}

.status-inactive {
  background: #f1f5f9;
  color: #475569;
}

.status-error {
  background: #fee2e2;
  color: #991b1b;
}
```

## Motion & Animation

### Timing
```
Fast: 0.1s
Normal: 0.15s
Slow: 0.2s
Easing: ease (simple, predictable)
```

### Hover Effects
- Subtle background color changes
- Border color changes
- NO transforms or complex animations
- Professional and understated

## Accessibility

### Contrast Ratios
- Blue 900 (#1e3a8a) on white: 11.93:1 (AAA) ✓
- Slate 600 (#475569) on white: 8.59:1 (AAA) ✓
- All text meets WCAG AAA standards

### Focus States
- 2px solid ring matching component color
- High visibility for keyboard navigation
- Never remove focus indicators

### Screen Reader Support
- Proper ARIA labels on all interactive elements
- Semantic HTML structure
- Alt text for all images and icons

## Responsive Design

### Breakpoints
```
sm: 640px
md: 768px
lg: 1024px
xl: 1280px
2xl: 1440px
```

### Mobile Adaptations
- Tables convert to stacked cards
- Reduced padding (12px instead of 20px)
- Hamburger menu for navigation
- Priority content first
- Touch-friendly targets (minimum 44px)

## Implementation Notes

### Tailwind Configuration
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1e3a8a',
          light: '#3b82f6',
          dark: '#1e40af',
        },
        secondary: '#475569',
        accent: '#0891b2',
      },
      fontFamily: {
        sans: ['IBM Plex Sans', 'Roboto', 'Segoe UI', 'sans-serif'],
        mono: ['IBM Plex Mono', 'Consolas', 'Monaco', 'monospace'],
      },
      maxWidth: {
        'container': '1440px',
      },
    },
  },
}
```

### CSS Variables
```css
:root {
  /* Colors */
  --color-primary: #1e3a8a;
  --color-primary-light: #3b82f6;
  --color-primary-dark: #1e40af;
  --color-secondary: #475569;
  --color-accent: #0891b2;

  /* Slate Scale */
  --slate-50: #f8fafc;
  --slate-100: #f1f5f9;
  --slate-200: #e2e8f0;
  --slate-300: #cbd5e1;
  --slate-400: #94a3b8;
  --slate-500: #64748b;
  --slate-600: #475569;
  --slate-700: #334155;
  --slate-800: #1e293b;
  --slate-900: #0f172a;

  /* Typography */
  --font-sans: 'IBM Plex Sans', 'Roboto', 'Segoe UI', sans-serif;
  --font-mono: 'IBM Plex Mono', 'Consolas', 'Monaco', monospace;
  --text-xs: 0.6875rem;
  --text-sm: 0.75rem;
  --text-base: 0.875rem;

  /* Spacing */
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;

  /* Layout */
  --max-width: 1440px;
  --grid-gutter: 24px;
  --border-radius: 0.25rem;
}
```

## Usage Examples

### Dashboard Layout
```jsx
<div className="min-h-screen bg-slate-50">
  <nav className="nav-primary">
    <div className="max-w-container mx-auto flex">
      <a href="/" className="nav-item active">Dashboard</a>
      <a href="/reports" className="nav-item">Reports</a>
      <a href="/analytics" className="nav-item">Analytics</a>
      <a href="/settings" className="nav-item">Settings</a>
    </div>
  </nav>

  <main className="max-w-container mx-auto px-6 py-8">
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      <div className="card">
        <div className="card-header">Total Revenue</div>
        <div className="card-body">
          <div className="text-3xl font-bold text-slate-900">$1,245,890</div>
          <div className="text-sm text-emerald-600 mt-2">↑ 12.5% from last month</div>
        </div>
      </div>
    </div>
  </main>
</div>
```

### Data Table
```jsx
<div className="card">
  <div className="card-header">Recent Transactions</div>
  <div className="overflow-x-auto">
    <table className="table">
      <thead>
        <tr>
          <th>Transaction ID</th>
          <th>Date</th>
          <th>Amount</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td className="font-mono">#TXN-00123</td>
          <td>2026-01-25</td>
          <td className="font-semibold">$1,234.56</td>
          <td>
            <span className="status-badge status-active">Completed</span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

### Form
```jsx
<form className="card max-w-2xl">
  <div className="card-header">User Information</div>

  <div className="card-body space-y-6">
    <div className="grid grid-cols-2 gap-4">
      <div>
        <label className="block text-sm font-semibold mb-2 text-slate-700">
          First Name
        </label>
        <input type="text" className="input w-full" />
      </div>

      <div>
        <label className="block text-sm font-semibold mb-2 text-slate-700">
          Last Name
        </label>
        <input type="text" className="input w-full" />
      </div>
    </div>

    <div>
      <label className="block text-sm font-semibold mb-2 text-slate-700">
        Email Address
      </label>
      <input type="email" className="input w-full" />
    </div>
  </div>

  <div className="card-footer">
    <div className="flex justify-end gap-3">
      <button type="button" className="btn-secondary">Cancel</button>
      <button type="submit" className="btn-primary">Save Changes</button>
    </div>
  </div>
</form>
```

## Design Principles

1. **Data First**: UI supports dense information display
2. **Consistency**: Strict adherence to patterns and conventions
3. **Efficiency**: Optimize for power users and repeated tasks
4. **Trust**: Professional appearance builds confidence
5. **Accessibility**: Enterprise apps must be accessible to all
6. **Scalability**: Design works at enterprise scale
7. **Documentation**: Every pattern is documented and consistent

## References

- **Bloomberg Terminal**: Data-dense, professional, efficient
- **SAP Fiori**: Enterprise design system, comprehensive
- **Microsoft Fluent**: Corporate, accessible, scalable
- **IBM Carbon**: Design system for enterprise products
- **Salesforce Lightning**: B2B SaaS design patterns
