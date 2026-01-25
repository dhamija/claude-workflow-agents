# Frontend Development Guide

Best practices and workflows for building consistent, accessible, maintainable frontends using the claude-workflow-agents system.

---

## Table of Contents

1. [Design System First](#design-system-first)
2. [Frontend Workflow](#frontend-workflow)
3. [Component Library](#component-library)
4. [State Management](#state-management)
5. [API Integration](#api-integration)
6. [Testing](#testing)
7. [Accessibility](#accessibility)
8. [Performance](#performance)
9. [Common Patterns](#common-patterns)
10. [Troubleshooting](#troubleshooting)

---

## Design System First

### CRITICAL: Read Design System Before Writing Any Code

**The frontend-engineer agent MUST read `/docs/ux/design-system.md` before implementing any UI.**

This prevents:
- ❌ Arbitrary color choices (`bg-blue-500`, `bg-indigo-600`, etc.)
- ❌ Inconsistent fonts and typography
- ❌ Random spacing values (`px-3`, `px-4`, `px-5` across different components)
- ❌ Different button/input/card styles across pages
- ❌ Accessibility issues (poor contrast, missing focus states)

This ensures:
- ✅ Consistent UI across entire app
- ✅ All colors from design system
- ✅ All typography from design system
- ✅ All spacing from design system
- ✅ Built-in accessibility (WCAG compliance)
- ✅ Easy design updates (change once, applies everywhere)

### Setting Up Design System

#### Option 1: Let UX Architect Create It (Recommended)
```bash
/ux your app idea

# UX architect will ask:
# "What design style do you prefer?"
# 1. modern-clean (professional SaaS)
# 2. minimal (ultra-clean)
# 3. playful (vibrant, fun)
# 4. corporate (enterprise)
# 5. glassmorphism (modern glass effects)
# 6. Reference another site
# 7. Custom specifications
```

#### Option 2: Apply a Preset
```bash
/design preset modern-clean
```

#### Option 3: Reference a Site
```bash
/design reference https://linear.app
```

### Design System Contents

`/docs/ux/design-system.md` includes:

1. **Color Palette**
   - Primary colors (default, light, dark variants)
   - Secondary & accent colors
   - Neutral scale (grays)
   - Semantic colors (success, warning, error, info)
   - Dark mode support

2. **Typography**
   - Font families (heading, body, monospace)
   - Font sizes (xs through 5xl)
   - Font weights (regular through bold)
   - Line heights, text styles

3. **Spacing & Layout**
   - Spacing scale (0-16 in rem units)
   - Max widths, grid system
   - Border radius scale
   - Shadow definitions

4. **Components**
   - Buttons (primary, secondary, variants)
   - Inputs, forms, validation states
   - Cards, modals, navigation
   - Badges, alerts, tables
   - Complete CSS/Tailwind specifications

5. **Motion & Animation**
   - Transition durations
   - Easing functions
   - Hover/focus/active states
   - Keyframe animations

6. **Accessibility**
   - WCAG color contrast ratios
   - Focus state specifications
   - ARIA patterns
   - Keyboard navigation

7. **Implementation**
   - Tailwind configuration code
   - CSS variables definitions
   - Component library bootstrap guide

---

## Frontend Workflow

### Step 1: Read Design System

```bash
# Frontend engineer ALWAYS starts here
Read /docs/ux/design-system.md
```

### Step 2: Set Up Styling Framework

#### If using Tailwind CSS:
```bash
# Copy Tailwind config from design system
# See "Tailwind Configuration" section in design-system.md

# Example:
# tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2563eb',
          light: '#3b82f6',
          dark: '#1d4ed8',
        },
        // ... rest from design system
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        // ... rest from design system
      },
      // ... spacing, shadows, radius from design system
    },
  },
}
```

#### If using vanilla CSS:
```bash
# Copy CSS variables from design system
# See "CSS Variables" section in design-system.md

# Example:
# styles/variables.css
:root {
  --color-primary: #2563eb;
  --color-primary-light: #3b82f6;
  --color-primary-dark: #1d4ed8;
  --font-sans: 'Inter', system-ui, sans-serif;
  /* ... rest from design system */
}
```

### Step 3: Bootstrap Component Library

Create base components BEFORE building pages:

```
src/components/ui/
├── Button.tsx        (primary, secondary, ghost variants)
├── Input.tsx         (text, email, password, textarea)
├── Card.tsx          (base card with consistent styling)
├── Modal.tsx         (using design system modal specs)
├── Badge.tsx         (status badges with semantic colors)
├── Alert.tsx         (success, warning, error, info)
└── index.ts          (export all components)
```

**Example Button.tsx (using Tailwind):**
```tsx
// GOOD: Uses design system via Tailwind config
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  children: React.ReactNode;
  onClick?: () => void;
}

export function Button({ variant = 'primary', children, onClick }: ButtonProps) {
  const variants = {
    primary: 'bg-primary hover:bg-primary-dark text-white',
    secondary: 'bg-white hover:bg-gray-50 text-gray-900 border border-gray-300',
    ghost: 'bg-transparent hover:bg-gray-100 text-gray-700',
  };

  return (
    <button
      className={`
        ${variants[variant]}
        px-6 py-3 rounded-md font-semibold text-sm
        transition-all duration-200
        focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
        disabled:opacity-50 disabled:cursor-not-allowed
      `}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
```

**BAD Example (arbitrary styling):**
```tsx
// ❌ NEVER DO THIS - arbitrary hex codes
<button className="bg-[#3b82f6] px-4 py-2">Click me</button>

// ❌ NEVER DO THIS - inconsistent spacing
<button className="bg-blue-500 px-3 py-2.5">Button 1</button>
<button className="bg-indigo-600 px-4 py-2">Button 2</button>
```

### Step 4: Build Pages Using Component Library

```tsx
// GOOD: Uses components from library
import { Button, Input, Card } from '@/components/ui';

export function LoginPage() {
  return (
    <Card>
      <h1 className="text-2xl font-bold mb-6">Sign In</h1>

      <Input type="email" placeholder="Email" />
      <Input type="password" placeholder="Password" />

      <Button variant="primary">Sign In</Button>
    </Card>
  );
}
```

### Step 5: Handle All States

Every component/page must handle:

1. **Loading State**
   ```tsx
   {isLoading && <Spinner />}
   ```

2. **Error State**
   ```tsx
   {error && <Alert variant="error">{error.message}</Alert>}
   ```

3. **Empty State**
   ```tsx
   {items.length === 0 && <EmptyState message="No items yet" />}
   ```

4. **Success State**
   ```tsx
   {items.map(item => <ItemCard key={item.id} {...item} />)}
   ```

---

## Component Library

### Core Components Needed

1. **Button**
   - Variants: primary, secondary, ghost, danger
   - Sizes: sm, md, lg
   - States: default, hover, active, disabled, loading

2. **Input**
   - Types: text, email, password, number, textarea, select
   - States: default, focus, error, disabled
   - With label and error message support

3. **Card**
   - Base card with consistent padding, radius, shadow
   - Optional header/footer sections

4. **Modal**
   - Overlay with backdrop
   - Close button
   - Header/body/footer sections
   - Focus trap for accessibility

5. **Badge**
   - Semantic variants: success, warning, error, info, neutral
   - Sizes: sm, md, lg

6. **Alert**
   - Variants: success, warning, error, info
   - Dismissible option
   - Icon support

7. **Spinner/Loader**
   - Consistent loading indicator
   - Sizes: sm, md, lg

8. **EmptyState**
   - Illustration/icon
   - Message
   - Optional CTA button

### Component Checklist

Every component should have:
- ✅ TypeScript types (no `any`)
- ✅ Uses design system values ONLY
- ✅ Handles all states (default, hover, active, disabled, focus)
- ✅ Accessible (ARIA labels, keyboard navigation)
- ✅ Responsive (mobile-first)
- ✅ Unit tests
- ✅ Storybook/documentation (optional but recommended)

---

## State Management

### Local State (Component-Level)

Use `useState` for component-specific state:
```tsx
const [isOpen, setIsOpen] = useState(false);
const [formData, setFormData] = useState({ email: '', password: '' });
```

### Global State (App-Level)

Use Zustand, Redux, or Context:
```tsx
// stores/auth.ts
import create from 'zustand';

export const useAuthStore = create((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  logout: () => set({ user: null }),
}));
```

### Server State (API Data)

Use React Query or SWR - **do NOT duplicate server state locally**:

```tsx
// GOOD: React Query manages server state
import { useQuery } from '@tanstack/react-query';

function TaskList() {
  const { data: tasks, isLoading, error } = useQuery({
    queryKey: ['tasks'],
    queryFn: () => api.getTasks(),
  });

  if (isLoading) return <Spinner />;
  if (error) return <Alert variant="error">{error.message}</Alert>;
  if (!tasks.length) return <EmptyState message="No tasks yet" />;

  return tasks.map(task => <TaskCard key={task.id} {...task} />);
}
```

```tsx
// ❌ BAD: Duplicating server state in local state
const [tasks, setTasks] = useState([]);
useEffect(() => {
  api.getTasks().then(setTasks);
}, []);
```

---

## API Integration

### Use Typed API Client

Generate types from backend schema:

```tsx
// api/client.ts
import type { Task, User, Project } from '@/types/api';

export const api = {
  // GET /api/tasks
  getTasks: async (): Promise<Task[]> => {
    const res = await fetch('/api/tasks');
    if (!res.ok) throw new Error('Failed to fetch tasks');
    return res.json();
  },

  // POST /api/tasks
  createTask: async (data: Partial<Task>): Promise<Task> => {
    const res = await fetch('/api/tasks', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create task');
    return res.json();
  },
};
```

### Error Handling

```tsx
try {
  const task = await api.createTask(data);
  // Success
} catch (error) {
  if (error.status === 401) {
    // Handle unauthorized
  } else if (error.status === 422) {
    // Handle validation errors
  } else {
    // Generic error
  }
}
```

### Optimistic Updates

```tsx
const mutation = useMutation({
  mutationFn: api.updateTask,
  onMutate: async (newTask) => {
    // Cancel ongoing queries
    await queryClient.cancelQueries(['tasks']);

    // Snapshot previous value
    const previousTasks = queryClient.getQueryData(['tasks']);

    // Optimistically update
    queryClient.setQueryData(['tasks'], old =>
      old.map(t => t.id === newTask.id ? newTask : t)
    );

    return { previousTasks };
  },
  onError: (err, newTask, context) => {
    // Rollback on error
    queryClient.setQueryData(['tasks'], context.previousTasks);
  },
  onSettled: () => {
    // Refetch to sync with server
    queryClient.invalidateQueries(['tasks']);
  },
});
```

---

## Testing

### Component Tests

```tsx
// Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const onClick = jest.fn();
    render(<Button onClick={onClick}>Click me</Button>);
    fireEvent.click(screen.getByText('Click me'));
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByText('Click me')).toBeDisabled();
  });

  it('applies correct variant styles', () => {
    const { rerender } = render(<Button variant="primary">Button</Button>);
    expect(screen.getByText('Button')).toHaveClass('bg-primary');

    rerender(<Button variant="secondary">Button</Button>);
    expect(screen.getByText('Button')).toHaveClass('bg-white');
  });
});
```

### Integration Tests

Test user journeys:

```tsx
// Login.test.tsx
it('completes login journey', async () => {
  render(<LoginPage />);

  // User enters credentials
  fireEvent.change(screen.getByLabelText('Email'), {
    target: { value: 'user@example.com' },
  });
  fireEvent.change(screen.getByLabelText('Password'), {
    target: { value: 'password123' },
  });

  // User submits form
  fireEvent.click(screen.getByRole('button', { name: 'Sign In' }));

  // Wait for success
  await waitFor(() => {
    expect(screen.getByText('Welcome back!')).toBeInTheDocument();
  });
});
```

---

## Accessibility

### WCAG Compliance

All components must meet WCAG AA standards:

1. **Color Contrast**
   - Normal text: 4.5:1 minimum
   - Large text: 3:1 minimum
   - (Design system includes compliant colors)

2. **Keyboard Navigation**
   ```tsx
   // Tab order makes sense
   // Enter/Space activate buttons
   // Escape closes modals
   onKeyDown={(e) => {
     if (e.key === 'Escape') closeModal();
   }}
   ```

3. **Screen Readers**
   ```tsx
   // Always provide labels
   <button aria-label="Close modal">
     <XIcon />
   </button>

   // Use semantic HTML
   <nav>, <main>, <article>, <aside>

   // ARIA attributes where needed
   <div role="dialog" aria-modal="true" aria-labelledby="modal-title">
   ```

4. **Focus States**
   ```tsx
   // Always visible (design system includes focus styles)
   focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2
   ```

---

## Performance

### Code Splitting

```tsx
// Lazy load routes
const DashboardPage = lazy(() => import('./pages/Dashboard'));
const SettingsPage = lazy(() => import('./pages/Settings'));

<Route path="/dashboard" element={<DashboardPage />} />
```

### Memoization

```tsx
// Expensive calculations
const sortedTasks = useMemo(
  () => tasks.sort((a, b) => a.priority - b.priority),
  [tasks]
);

// Prevent re-renders
const TaskCard = memo(({ task }) => { /* ... */ });
```

### Virtualization

For long lists:
```tsx
import { useVirtualizer } from '@tanstack/react-virtual';

// Render only visible items
const virtualizer = useVirtualizer({
  count: tasks.length,
  getScrollElement: () => scrollRef.current,
  estimateSize: () => 60,
});
```

---

## Common Patterns

### Form Handling

```tsx
import { useForm } from 'react-hook-form';

function SignupForm() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = async (data) => {
    await api.signup(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Input
        {...register('email', { required: 'Email is required' })}
        error={errors.email?.message}
      />
      <Button type="submit">Sign Up</Button>
    </form>
  );
}
```

### Infinite Scroll

```tsx
const { data, fetchNextPage, hasNextPage } = useInfiniteQuery({
  queryKey: ['tasks'],
  queryFn: ({ pageParam = 0 }) => api.getTasks(pageParam),
  getNextPageParam: (lastPage) => lastPage.nextCursor,
});

const observerTarget = useRef();
useEffect(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting && hasNextPage) {
        fetchNextPage();
      }
    }
  );
  if (observerTarget.current) {
    observer.observe(observerTarget.current);
  }
}, [fetchNextPage, hasNextPage]);
```

---

## Troubleshooting

### Design System Not Followed

**Problem:** Components using arbitrary colors/fonts/spacing

**Solution:**
1. Check if `/docs/ux/design-system.md` exists
2. Verify Tailwind config matches design system
3. Use component library instead of raw styling
4. Review frontend-engineer agent instructions

### Inconsistent UI

**Problem:** Different button/input styles across pages

**Solution:**
1. Create component library FIRST
2. Import components from `@/components/ui`
3. NEVER create inline styled buttons/inputs
4. Run `/review` to check for arbitrary styling

### Colors Don't Match Design

**Problem:** Colors look different than design system

**Solution:**
1. Verify Tailwind config copied from design system
2. Rebuild CSS (`npm run build:css`)
3. Check for inline styles or arbitrary values
4. Use CSS variables instead of hex codes

### Accessibility Issues

**Problem:** Poor contrast, missing focus states

**Solution:**
1. Follow design system (includes WCAG-compliant colors)
2. Use design system focus states
3. Add ARIA labels
4. Test with keyboard navigation
5. Run accessibility audit tools

---

## Summary

### Frontend Development Checklist

Before starting:
- [ ] Design system exists at `/docs/ux/design-system.md`
- [ ] Tailwind config OR CSS variables set up from design system
- [ ] Component library bootstrapped

For each component:
- [ ] Uses design system colors ONLY
- [ ] Uses design system typography ONLY
- [ ] Uses design system spacing ONLY
- [ ] Handles all states (loading, error, empty, success)
- [ ] Accessible (ARIA, keyboard, contrast)
- [ ] TypeScript types (no `any`)
- [ ] Unit tests written

For each page:
- [ ] Uses component library
- [ ] No inline/arbitrary styling
- [ ] Handles all states
- [ ] Responsive (mobile-first)
- [ ] Accessible
- [ ] Integration tests written

### Key Principles

1. **Design system first** - ALWAYS read before coding
2. **Component library** - Create base components BEFORE pages
3. **No arbitrary styling** - ONLY design system values
4. **Handle all states** - Loading, error, empty, success
5. **Accessibility** - WCAG AA minimum
6. **Type safety** - TypeScript, no `any`
7. **Test coverage** - Unit + integration tests
8. **Performance** - Code splitting, memoization, virtualization

---

## More Help

- **Design System:** `/design show` - View current design system
- **Command Reference:** `COMMANDS.md` - All available commands
- **Examples:** `EXAMPLES.md` - Example 8 shows design system workflow
- **Help System:** `/agent-wf-help design` - Design system help

