---
name: debugging
description: |
  Debugging protocols and strategies. Use when investigating bugs,
  errors, or unexpected behavior.
---

# Debugging Skill

## Systematic Approach

### 1. Understand the Problem
- What is the expected behavior?
- What is the actual behavior?
- When did it start happening?
- Can you reproduce it?

### 2. Gather Information
```bash
# Check logs
tail -f logs/app.log

# Check error stack trace
cat error.log

# Check recent changes
git log --oneline -10
git diff HEAD~5
```

### 3. Isolate the Issue
- Binary search through code
- Add logging at key points
- Use debugger breakpoints
- Simplify test case

### 4. Fix and Verify
- Apply minimal fix
- Add regression test
- Verify fix works
- Check for side effects

## Common Patterns

### Backend Errors

```typescript
// Add detailed logging
console.log('[DEBUG] Input:', { userId, data });

try {
  const result = await service.process(data);
  console.log('[DEBUG] Result:', result);
  return result;
} catch (error) {
  console.error('[ERROR] Failed:', {
    error: error.message,
    stack: error.stack,
    input: data
  });
  throw error;
}
```

### Frontend Issues

```typescript
// React DevTools + console
useEffect(() => {
  console.log('[DEBUG] Component mounted', { props, state });

  return () => {
    console.log('[DEBUG] Component unmounting');
  };
}, [props, state]);
```

### Network Issues

```bash
# Check API response
curl -v http://localhost:3000/api/endpoint

# Check with auth
curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/data
```

## Debugging Checklist

- [ ] Error message understood
- [ ] Stack trace examined
- [ ] Logs checked
- [ ] Inputs validated
- [ ] Recent changes reviewed
- [ ] Tests added for bug
- [ ] Fix verified
- [ ] Side effects checked
