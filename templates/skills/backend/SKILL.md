---
name: backend
description: |
  Backend development expertise for APIs, databases, and services.
  Use when implementing server-side logic, databases, and API endpoints.
---

# Backend Development Skill

## API Implementation

### RESTful Endpoints

```typescript
// routes/users.ts
import { Router } from 'express';
import { z } from 'zod';

const router = Router();

// Validation schema
const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
  password: z.string().min(8)
});

// POST /api/users
router.post('/users', async (req, res) => {
  try {
    // Validate input
    const data = createUserSchema.parse(req.body);

    // Business logic
    const user = await userService.create(data);

    // Response
    res.status(201).json({ user });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: error.errors });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/users/:id
router.get('/users/:id', async (req, res) => {
  const user = await userService.findById(req.params.id);

  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json({ user });
});

export default router;
```

### Error Handling

```typescript
// middleware/errorHandler.ts
export function errorHandler(err, req, res, next) {
  console.error(err);

  if (err instanceof ValidationError) {
    return res.status(400).json({ error: err.message });
  }

  if (err instanceof NotFoundError) {
    return res.status(404).json({ error: err.message });
  }

  if (err instanceof AuthError) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  res.status(500).json({ error: 'Internal server error' });
}
```

## Database

### Schema Design

```sql
-- PostgreSQL schema
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);

CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  content TEXT,
  published BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_published ON posts(published);
```

### ORM (Prisma)

```typescript
// prisma/schema.prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String
  password  String
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        String   @id @default(uuid())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  String
  createdAt DateTime @default(now())
}

// Usage
const user = await prisma.user.create({
  data: {
    email: 'user@example.com',
    name: 'John Doe',
    password: hashedPassword
  }
});
```

## Authentication

### JWT

```typescript
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';

// Hash password
export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, 10);
}

// Verify password
export async function verifyPassword(
  password: string,
  hash: string
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

// Generate JWT
export function generateToken(userId: string): string {
  return jwt.sign({ userId }, process.env.JWT_SECRET!, {
    expiresIn: '7d'
  });
}

// Verify JWT middleware
export function authenticate(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
}
```

## Validation

```typescript
import { z } from 'zod';

// Define schemas
const schemas = {
  createPost: z.object({
    title: z.string().min(5).max(500),
    content: z.string().optional(),
    published: z.boolean().default(false)
  }),

  updatePost: z.object({
    title: z.string().min(5).max(500).optional(),
    content: z.string().optional(),
    published: z.boolean().optional()
  }).refine(data => Object.keys(data).length > 0, {
    message: 'At least one field must be provided'
  })
};

// Validation middleware
export function validate(schema: z.ZodSchema) {
  return (req, res, next) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ errors: error.errors });
      }
      next(error);
    }
  };
}

// Usage
router.post('/posts', validate(schemas.createPost), async (req, res) => {
  // req.body is now typed and validated
  const post = await postService.create(req.body);
  res.status(201).json({ post });
});
```

## Testing

```typescript
import request from 'supertest';
import app from '../app';

describe('POST /api/users', () => {
  it('creates a user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        name: 'Test User',
        password: 'password123'
      });

    expect(response.status).toBe(201);
    expect(response.body.user).toHaveProperty('id');
    expect(response.body.user.email).toBe('test@example.com');
  });

  it('validates email format', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'invalid',
        name: 'Test',
        password: 'password'
      });

    expect(response.status).toBe(400);
  });
});
```

## Quality Checklist

- [ ] Input validation on all endpoints
- [ ] Proper error handling with status codes
- [ ] Authentication/authorization implemented
- [ ] Database indexes on queried fields
- [ ] API tests with >80% coverage
- [ ] Environment variables for secrets
- [ ] SQL injection prevention (use parameterized queries)
- [ ] Rate limiting on public endpoints
- [ ] CORS configured correctly
- [ ] Logging for debugging
