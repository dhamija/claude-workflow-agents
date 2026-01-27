---
name: code-quality
description: |
  Code review criteria and quality standards. Use when reviewing code
  or establishing quality gates.
---

# Code Quality Skill

## Review Criteria

### 1. Correctness
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] No obvious bugs
- [ ] Tests pass

### 2. Readability
- [ ] Clear variable/function names
- [ ] Appropriate comments
- [ ] Consistent formatting
- [ ] Reasonable complexity

### 3. Security
- [ ] No SQL injection
- [ ] No XSS vulnerabilities
- [ ] Secrets not in code
- [ ] Input validation present
- [ ] Authentication/authorization correct

### 4. Performance
- [ ] No N+1 queries
- [ ] Appropriate caching
- [ ] No memory leaks
- [ ] Efficient algorithms

### 5. Maintainability
- [ ] DRY (Don't Repeat Yourself)
- [ ] Single Responsibility
- [ ] Appropriate abstraction
- [ ] Tests included

## Common Issues

### Security
```typescript
// ❌ BAD: SQL injection
db.query(`SELECT * FROM users WHERE id = ${req.params.id}`);

// ✅ GOOD: Parameterized query
db.query('SELECT * FROM users WHERE id = $1', [req.params.id]);

// ❌ BAD: XSS
html = `<div>${userInput}</div>`;

// ✅ GOOD: Escaped
html = `<div>${escapeHtml(userInput)}</div>`;
```

### Performance
```typescript
// ❌ BAD: N+1 queries
for (const user of users) {
  user.posts = await db.query('SELECT * FROM posts WHERE user_id = $1', [user.id]);
}

// ✅ GOOD: Single query
const posts = await db.query('SELECT * FROM posts WHERE user_id = ANY($1)', [userIds]);
```

### Readability
```typescript
// ❌ BAD: Unclear names
const d = new Date();
const x = u.map(i => i.n);

// ✅ GOOD: Clear names
const currentDate = new Date();
const userNames = users.map(user => user.name);
```

## Code Review Checklist

- [ ] Code solves the problem
- [ ] No security vulnerabilities
- [ ] Performance is acceptable
- [ ] Code is readable
- [ ] Tests are comprehensive
- [ ] Documentation updated
- [ ] No commented-out code
- [ ] No console.logs in production
