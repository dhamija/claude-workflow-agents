# Glassmorphism Design Preset

> Modern glass-effect design with frosted backgrounds, transparency, and depth

## Overview

**Best for:** Modern web apps, portfolios, creative tools, design showcases, premium products
**Characteristics:** Translucent, layered, depth, modern, premium, ethereal, sophisticated
**Inspired by:** iOS design language, Windows 11 Fluent Design, macOS Big Sur

## Color Palette

### Primary Colors
```
Primary: #6366f1 (Indigo 500)
Primary Light: #818cf8 (Indigo 400)
Primary Dark: #4f46e5 (Indigo 600)
```

### Secondary Colors
```
Secondary: #8b5cf6 (Violet 500)
Accent: #06b6d4 (Cyan 500)
```

### Glass Background Colors (with transparency)
```
Glass White: rgba(255, 255, 255, 0.1)
Glass Light: rgba(255, 255, 255, 0.15)
Glass Medium: rgba(255, 255, 255, 0.25)
Glass Dark: rgba(0, 0, 0, 0.2)
Glass Darker: rgba(0, 0, 0, 0.3)
```

### Neutral Scale
```
Neutral 50: #fafafa
Neutral 100: #f5f5f5
Neutral 200: #e5e5e5
Neutral 300: #d4d4d4
Neutral 400: #a3a3a3
Neutral 500: #737373
Neutral 600: #525252
Neutral 700: #404040
Neutral 800: #262626
Neutral 900: #171717
```

### Semantic Colors
```
Success: #10b981 (Emerald 500)
Warning: #f59e0b (Amber 500)
Error: #ef4444 (Red 500)
Info: #3b82f6 (Blue 500)
```

### Background Gradients
```
Gradient 1: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
Gradient 2: linear-gradient(135deg, #f093fb 0%, #f5576c 100%)
Gradient 3: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)
Gradient 4: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)
Gradient 5: linear-gradient(135deg, #fa709a 0%, #fee140 100%)
Mesh Gradient: radial-gradient(at 0% 0%, #667eea 0%, transparent 50%),
               radial-gradient(at 100% 0%, #764ba2 0%, transparent 50%),
               radial-gradient(at 100% 100%, #f093fb 0%, transparent 50%),
               radial-gradient(at 0% 100%, #4facfe 0%, transparent 50%)
```

## Typography

### Font Families
```
Heading: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif
Body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif
Monospace: 'JetBrains Mono', 'SF Mono', monospace
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
Bold: 700
```

## Spacing & Layout

### Border Radius (Rounded)
```
sm: 0.5rem (8px)
md: 0.75rem (12px)
lg: 1rem (16px)
xl: 1.5rem (24px)
2xl: 2rem (32px)
```

### Backdrop Blur
```
sm: blur(4px)
md: blur(8px)
lg: blur(12px)
xl: blur(16px)
2xl: blur(24px)
```

### Shadows (Layered)
```
sm: 0 2px 8px 0 rgba(31, 38, 135, 0.15)
md: 0 4px 16px 0 rgba(31, 38, 135, 0.2)
lg: 0 8px 32px 0 rgba(31, 38, 135, 0.25)
xl: 0 12px 48px 0 rgba(31, 38, 135, 0.3)
```

### Glass Borders
```
Light: 1px solid rgba(255, 255, 255, 0.18)
Medium: 1px solid rgba(255, 255, 255, 0.25)
Strong: 1px solid rgba(255, 255, 255, 0.4)
```

## Components

### Glass Card
```css
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 1rem;
  padding: 24px;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
}

.glass-card:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.25);
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.25);
}

.glass-card-dark {
  background: rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
```

### Glass Buttons
```css
.btn-glass {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  color: white;
  padding: 12px 28px;
  border-radius: 9999px;
  font-weight: 600;
  font-size: 0.875rem;
  border: 1px solid rgba(255, 255, 255, 0.18);
  transition: all 0.3s ease;
  box-shadow: 0 4px 16px 0 rgba(31, 38, 135, 0.2);
}

.btn-glass:hover {
  background: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px 0 rgba(31, 38, 135, 0.3);
}

.btn-glass-solid {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  backdrop-filter: blur(8px);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
}
```

### Glass Inputs
```css
.input-glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 0.75rem;
  padding: 12px 16px;
  font-size: 1rem;
  color: white;
  transition: all 0.3s ease;
}

.input-glass::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.input-glass:focus {
  outline: none;
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}
```

### Glass Navigation
```css
.nav-glass {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 9999px;
  padding: 12px 24px;
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.2);
}

.nav-item-glass {
  color: white;
  padding: 8px 16px;
  border-radius: 9999px;
  font-size: 0.875rem;
  font-weight: 500;
  transition: all 0.3s ease;
}

.nav-item-glass:hover {
  background: rgba(255, 255, 255, 0.15);
}

.nav-item-glass.active {
  background: rgba(255, 255, 255, 0.25);
  box-shadow: 0 4px 12px 0 rgba(31, 38, 135, 0.15);
}
```

### Glass Modal
```css
.modal-overlay-glass {
  background: rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.modal-glass {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(24px) saturate(180%);
  -webkit-backdrop-filter: blur(24px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 1.5rem;
  box-shadow: 0 12px 48px 0 rgba(31, 38, 135, 0.3);
  max-width: 500px;
  width: 100%;
}
```

### Glass Badge
```css
.badge-glass {
  display: inline-flex;
  align-items: center;
  padding: 6px 14px;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(4px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  color: white;
}
```

## Motion & Animation

### Timing
```
Fast: 0.2s
Normal: 0.3s
Slow: 0.5s
Easing: cubic-bezier(0.4, 0, 0.2, 1)
Bounce: cubic-bezier(0.34, 1.56, 0.64, 1)
```

### Hover Effects
- Increase background opacity (0.1 → 0.15 or 0.25)
- Strengthen border (increase alpha)
- Subtle lift (translateY -2px)
- Shadow expansion
- Smooth transitions (0.3s)

### Scroll Effects
```css
@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

.float-animation {
  animation: float 6s ease-in-out infinite;
}
```

## Accessibility

### Contrast Ratios
- White text on glass backgrounds: Test with WCAG tools
- Ensure minimum 4.5:1 contrast with background gradients
- Use solid text colors (white/black) on glass surfaces
- Add text shadows for better readability: `text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1)`

### Focus States
- 3px ring with white at 30% opacity
- Increase background opacity on focus
- Never rely solely on glass effects for state

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
- Reduce blur intensity (blur(8px) instead of blur(16px))
- Increase background opacity for readability
- Simplify layering (fewer overlapping glass elements)
- Solid backgrounds for critical content
- Performance: Use `-webkit-backdrop-filter` for iOS

## Implementation Notes

### Tailwind Configuration
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#6366f1',
          light: '#818cf8',
          dark: '#4f46e5',
        },
        secondary: '#8b5cf6',
        accent: '#06b6d4',
      },
      backdropBlur: {
        xs: '2px',
        sm: '4px',
        md: '8px',
        lg: '12px',
        xl: '16px',
        '2xl': '24px',
      },
      backdropSaturate: {
        180: '180%',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
```

### CSS Variables
```css
:root {
  /* Glass Colors */
  --glass-white: rgba(255, 255, 255, 0.1);
  --glass-light: rgba(255, 255, 255, 0.15);
  --glass-medium: rgba(255, 255, 255, 0.25);
  --glass-border: rgba(255, 255, 255, 0.18);

  /* Backdrop Effects */
  --blur-sm: blur(4px);
  --blur-md: blur(8px);
  --blur-lg: blur(12px);
  --blur-xl: blur(16px);
  --saturate: saturate(180%);

  /* Shadows */
  --shadow-glass: 0 8px 32px 0 rgba(31, 38, 135, 0.15);

  /* Gradients */
  --gradient-primary: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  --gradient-mesh: radial-gradient(at 0% 0%, #667eea 0%, transparent 50%),
                   radial-gradient(at 100% 0%, #764ba2 0%, transparent 50%),
                   radial-gradient(at 100% 100%, #f093fb 0%, transparent 50%),
                   radial-gradient(at 0% 100%, #4facfe 0%, transparent 50%);
}
```

### Utility Classes
```css
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.18);
}

.glass-hover:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.25);
}

.glass-dark {
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
```

## Usage Examples

### Hero Section with Glass
```jsx
<section
  className="min-h-screen flex items-center justify-center relative overflow-hidden"
  style={{
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
  }}
>
  {/* Background blur effect */}
  <div className="absolute inset-0 opacity-50">
    <div className="absolute top-20 left-20 w-96 h-96 bg-purple-300 rounded-full mix-blend-multiply filter blur-3xl animate-float" />
    <div className="absolute bottom-20 right-20 w-96 h-96 bg-pink-300 rounded-full mix-blend-multiply filter blur-3xl animate-float" style={{animationDelay: '2s'}} />
  </div>

  <div className="glass-card max-w-2xl mx-6 text-white text-center relative z-10">
    <h1 className="text-5xl font-bold mb-4">
      Welcome to the Future
    </h1>
    <p className="text-xl mb-8 opacity-90">
      Experience design with depth and transparency
    </p>
    <button className="btn-glass">
      Get Started
    </button>
  </div>
</section>
```

### Glass Navigation
```jsx
<nav className="nav-glass">
  <div className="flex items-center gap-2">
    <a href="/" className="nav-item-glass active">Home</a>
    <a href="/about" className="nav-item-glass">About</a>
    <a href="/work" className="nav-item-glass">Work</a>
    <a href="/contact" className="nav-item-glass">Contact</a>
  </div>
</nav>
```

### Glass Dashboard Card
```jsx
<div
  className="min-h-screen p-8"
  style={{
    background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)'
  }}
>
  <div className="glass-card max-w-md">
    <h2 className="text-2xl font-bold text-white mb-6">
      Your Stats
    </h2>

    <div className="space-y-4">
      <div className="glass-card-dark p-4 rounded-lg">
        <div className="text-sm text-white opacity-75">Total Views</div>
        <div className="text-3xl font-bold text-white">24,512</div>
      </div>

      <div className="glass-card-dark p-4 rounded-lg">
        <div className="text-sm text-white opacity-75">Engagement</div>
        <div className="text-3xl font-bold text-white">87%</div>
      </div>
    </div>
  </div>
</div>
```

### Glass Form
```jsx
<form className="glass-card max-w-md text-white">
  <h2 className="text-2xl font-bold mb-6">Sign In</h2>

  <div className="space-y-4">
    <input
      type="email"
      placeholder="Email"
      className="input-glass w-full"
    />

    <input
      type="password"
      placeholder="Password"
      className="input-glass w-full"
    />

    <button className="btn-glass-solid w-full">
      Sign In
    </button>
  </div>
</form>
```

## Design Principles

1. **Layering**: Create depth through overlapping glass elements
2. **Contrast**: Place glass over vibrant gradients
3. **Subtlety**: Don't overuse - balance glass with solid elements
4. **Performance**: Test blur on lower-end devices
5. **Readability**: Ensure text is always legible on glass
6. **Context**: Works best for premium/modern brands
7. **Animations**: Keep animations smooth and purposeful

## Browser Support

### Backdrop Filter Support
```css
/* Fallback for browsers without backdrop-filter */
@supports not (backdrop-filter: blur(12px)) {
  .glass-card {
    background: rgba(255, 255, 255, 0.8);
  }
}
```

### Vendor Prefixes
Always include `-webkit-backdrop-filter` for Safari/iOS support:
```css
backdrop-filter: blur(12px);
-webkit-backdrop-filter: blur(12px);
```

## References

- **iOS Design Language**: Apple's frosted glass effects
- **Windows 11 Fluent Design**: Acrylic materials
- **macOS Big Sur**: Translucent sidebars and menus
- **Dribbble/Behance**: Glassmorphism UI examples
- **CSS-Tricks**: Glassmorphism tutorials and best practices
