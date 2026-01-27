---
name: frontend
description: |
  Frontend development expertise with automatic design principle application.
  Use when:
  - Implementing UI components
  - Building user interfaces
  - Creating responsive layouts
  - Integrating with backend APIs
---

# Frontend Development Skill

## Overview

This skill provides frontend implementation expertise. Automatically applies design principles from the `ux-design` skill.

**Prerequisites:** Load `ux-design` skill for design principles reference.

---

## Component Implementation

### Structure

```
components/
├── ui/           # Reusable UI components (Button, Input, Card)
├── features/     # Feature-specific components
├── layouts/      # Page layouts (Header, Footer, Sidebar)
└── pages/        # Full pages
```

### Component Template

```typescript
// components/ui/Button.tsx
import { forwardRef } from 'react';

interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'tertiary';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  disabled?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = 'primary', size = 'md', loading, disabled, children, onClick }, ref) => {
    return (
      <button
        ref={ref}
        className={`btn btn-${variant} btn-${size}`}
        disabled={disabled || loading}
        onClick={onClick}
        // Design Principle: Fitts's Law (44px min touch target)
        style={{ minHeight: '44px', minWidth: '44px' }}
      >
        {loading ? <Spinner /> : children}
      </button>
    );
  }
);
```

---

## Design Principles (Auto-Applied)

### Fitts's Law
```typescript
// Interactive elements ≥44px
const styles = {
  button: { minHeight: '44px', minWidth: '44px', padding: '12px 24px' },
  input: { height: '44px', padding: '12px' },
  checkbox: { width: '24px', height: '24px' },  // with 44px touch area
};
```

### Hick's Law
```typescript
// ≤7 options visible
function Navigation() {
  const primaryItems = items.slice(0, 5);  // Limit to 5
  const moreItems = items.slice(5);         // Rest under "More"

  return (
    <nav>
      {primaryItems.map(item => <NavItem key={item.id} {...item} />)}
      {moreItems.length > 0 && <MoreMenu items={moreItems} />}
    </nav>
  );
}
```

### Miller's Law
```typescript
// Chunk information
function Form() {
  return (
    <>
      {/* Personal Info - 3 fields */}
      <fieldset>
        <legend>Personal Information</legend>
        <Input label="Name" />
        <Input label="Email" />
        <Input label="Phone" />
      </fieldset>

      {/* Address - 4 fields */}
      <fieldset>
        <legend>Address</legend>
        <Input label="Street" />
        <Input label="City" />
        <Input label="State" />
        <Input label="ZIP" />
      </fieldset>
    </>
  );
}
```

### Doherty Threshold
```typescript
// <400ms feedback
function SaveButton() {
  const [saving, setSaving] = useState(false);

  const handleSave = async () => {
    setSaving(true);  // Instant feedback

    // Optimistic update
    updateLocalState(data);

    try {
      await api.save(data);
    } catch (error) {
      // Rollback on error
      revertLocalState();
    } finally {
      setSaving(false);
    }
  };

  return (
    <Button loading={saving} onClick={handleSave}>
      {saving ? 'Saving...' : 'Save'}
    </Button>
  );
}
```

---

## Responsive Implementation

### Mobile-First CSS

```css
/* Base (Mobile) */
.container {
  padding: 16px;
  display: flex;
  flex-direction: column;
}

/* Tablet (≥640px) */
@media (min-width: 640px) {
  .container {
    padding: 24px;
  }
}

/* Desktop (≥1024px) */
@media (min-width: 1024px) {
  .container {
    padding: 32px;
    flex-direction: row;
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

### Tailwind (if used)

```jsx
<div className="
  flex flex-col           /* Mobile: stack */
  md:flex-row             /* Tablet: side-by-side */
  lg:max-w-screen-xl      /* Desktop: max width */
  px-4 md:px-6 lg:px-8    /* Responsive padding */
">
  {/* Content */}
</div>
```

---

## State Management

### Component State (Simple)

```typescript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <Button onClick={() => setCount(count + 1)}>Increment</Button>
    </div>
  );
}
```

### Global State (Complex)

```typescript
// store/useStore.ts
import { create } from 'zustand';

interface StoreState {
  user: User | null;
  setUser: (user: User) => void;
}

export const useStore = create<StoreState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
}));

// Usage in component
function Profile() {
  const user = useStore((state) => state.user);

  return <div>{user?.name}</div>;
}
```

---

## API Integration

### Fetch with Error Handling

```typescript
async function fetchData() {
  try {
    const response = await fetch('/api/data');

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Fetch error:', error);
    throw error;
  }
}
```

### Loading States

```typescript
function DataList() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchData()
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Skeleton />;
  if (error) return <Error message={error.message} />;

  return <List items={data} />;
}
```

---

## Accessibility

### ARIA Attributes

```jsx
<button
  aria-label="Close dialog"
  aria-pressed={isPressed}
  aria-disabled={isDisabled}
>
  <Icon name="close" aria-hidden="true" />
</button>
```

### Keyboard Navigation

```typescript
function Dialog({ isOpen, onClose }) {
  const dialogRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!isOpen) return;

    // Trap focus inside dialog
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
      }
      // Trap focus logic here
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  return isOpen ? (
    <div ref={dialogRef} role="dialog" aria-modal="true">
      {/* Content */}
    </div>
  ) : null;
}
```

### Focus Management

```typescript
// Auto-focus first input in form
function LoginForm() {
  const emailRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    emailRef.current?.focus();
  }, []);

  return (
    <form>
      <Input ref={emailRef} label="Email" />
      <Input label="Password" type="password" />
      <Button type="submit">Login</Button>
    </form>
  );
}
```

---

## Performance

### Code Splitting

```typescript
// Lazy load heavy components
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyComponent />
    </Suspense>
  );
}
```

### Memoization

```typescript
import { memo, useMemo, useCallback } from 'react';

// Memo component (re-render only if props change)
const ExpensiveComponent = memo(({ data }) => {
  // Expensive render logic
  return <div>{data}</div>;
});

// Memo value
function DataProcessor({ items }) {
  const processed = useMemo(
    () => items.map(expensiveProcess),
    [items]
  );

  return <List items={processed} />;
}

// Memo callback
function Parent() {
  const handleClick = useCallback(() => {
    // Handle click
  }, []);  // Dependencies

  return <Child onClick={handleClick} />;
}
```

---

## Styling Approaches

### CSS Modules

```typescript
import styles from './Button.module.css';

export function Button({ children }) {
  return <button className={styles.button}>{children}</button>;
}
```

### Tailwind CSS

```jsx
<button className="
  min-h-[44px] px-6 py-3
  bg-blue-600 hover:bg-blue-700
  text-white font-semibold rounded-lg
  transition-colors duration-200
  disabled:opacity-50 disabled:cursor-not-allowed
">
  Click Me
</button>
```

### CSS-in-JS (Styled Components)

```typescript
import styled from 'styled-components';

const Button = styled.button`
  min-height: 44px;
  padding: 12px 24px;
  background: ${props => props.theme.colors.primary};
  color: white;
  border: none;
  border-radius: 8px;
  transition: all 200ms ease-out;

  &:hover {
    background: ${props => props.theme.colors.primaryDark};
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
`;
```

---

## Testing

### Component Tests

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click Me</Button>);
    expect(screen.getByText('Click Me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click</Button>);

    fireEvent.click(screen.getByText('Click'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button loading>Click</Button>);
    expect(screen.getByRole('button')).toHaveAttribute('disabled');
  });
});
```

---

## Quality Checklist

Before completing frontend work, verify:

### Functionality
- [ ] All features work as specified
- [ ] API integration successful
- [ ] Error handling in place
- [ ] Loading states implemented

### Design Principles
- [ ] Touch targets ≥44px (Fitts's Law)
- [ ] ≤7 options visible (Hick's Law)
- [ ] Information chunked (Miller's Law)
- [ ] Platform conventions followed (Jakob's Law)
- [ ] Clean visual design (Aesthetic-Usability)
- [ ] Complexity hidden (Progressive Disclosure)
- [ ] Options shown (Recognition over Recall)
- [ ] Fast feedback <400ms (Doherty Threshold)

### Responsive
- [ ] Works on mobile (< 640px)
- [ ] Works on tablet (640-1024px)
- [ ] Works on desktop (> 1024px)
- [ ] Touch-friendly on mobile

### Accessibility
- [ ] Color contrast ≥4.5:1
- [ ] Keyboard navigation works
- [ ] ARIA labels present
- [ ] Focus states visible
- [ ] Screen reader tested

### Performance
- [ ] Code split appropriately
- [ ] Images optimized
- [ ] Bundle size reasonable
- [ ] No unnecessary re-renders

### Code Quality
- [ ] TypeScript types complete
- [ ] No console errors
- [ ] Component tests passing
- [ ] Code reviewed

---

## Integration with Other Skills

### With ux-design Skill
Load ux-design for design principles reference. Apply them automatically during implementation.

### With backend Skill
Coordinate API contract:
- Endpoint URLs
- Request/response formats
- Error codes
- Authentication

### With testing Skill
Write component tests for:
- Rendering
- User interactions
- State changes
- API integration

### With code-quality Skill
Follow code standards:
- Naming conventions
- File structure
- Type safety
- Documentation
