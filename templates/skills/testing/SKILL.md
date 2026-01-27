---
name: testing
description: |
  Testing strategies and implementation. Use when writing tests for
  components, APIs, or features. Ensures comprehensive coverage.
---

# Testing Skill

## Testing Strategy

### Test Pyramid
```
       /\
      /E2E\        Few: Full user flows
     /------\
    /  INT   \     Some: Component integration
   /----------\
  /   UNIT     \   Many: Individual functions
 /--------------\
```

## Unit Tests

```typescript
// sum.test.ts
import { sum } from './sum';

describe('sum', () => {
  it('adds two numbers', () => {
    expect(sum(2, 3)).toBe(5);
  });

  it('handles negative numbers', () => {
    expect(sum(-1, 1)).toBe(0);
  });
});
```

## Component Tests (React)

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserForm } from './UserForm';

describe('UserForm', () => {
  it('submits form data', async () => {
    const onSubmit = jest.fn();
    render(<UserForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByLabelText('Name'), {
      target: { value: 'John' }
    });
    fireEvent.click(screen.getByText('Submit'));

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({ name: 'John' });
    });
  });

  it('shows validation errors', async () => {
    render(<UserForm onSubmit={jest.fn()} />);
    fireEvent.click(screen.getByText('Submit'));

    expect(await screen.findByText('Name is required')).toBeInTheDocument();
  });
});
```

## API Tests

```typescript
import request from 'supertest';
import app from '../app';

describe('GET /api/users/:id', () => {
  it('returns user', async () => {
    const response = await request(app)
      .get('/api/users/123')
      .expect(200);

    expect(response.body.user).toMatchObject({
      id: '123',
      name: expect.any(String)
    });
  });

  it('returns 404 for non-existent user', async () => {
    await request(app)
      .get('/api/users/999')
      .expect(404);
  });
});
```

## E2E Tests (Playwright)

```typescript
import { test, expect } from '@playwright/test';

test('user can sign up', async ({ page }) => {
  await page.goto('/signup');

  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('button[type="submit"]');

  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Welcome');
});
```

## Coverage Goals

- Unit tests: >80%
- Integration: Critical paths
- E2E: Happy paths + edge cases
