---
name: brownfield
description: |
  Existing codebase analysis. Use when first encountering a project
  with existing code. Infers structure, features, and tech stack.
---

# Brownfield Analysis Skill

## First Session Protocol

When encountering existing code:

### 1. Project Structure Scan

```bash
# Directory tree
ls -R

# Tech stack indicators
ls package.json    # Node/JS
ls requirements.txt # Python
ls Cargo.toml      # Rust
ls go.mod          # Go
ls pom.xml         # Java

# Count files by type
find . -name "*.ts" | wc -l
find . -name "*.py" | wc -l
```

### 2. Infer Tech Stack

```bash
# Frontend
cat package.json | grep -E "react|vue|angular|svelte"

# Backend
cat package.json | grep -E "express|fastify|nest"

# Database
cat package.json | grep -E "prisma|sequelize|typeorm"
cat requirements.txt | grep -E "psycopg|pymongo|sqlalchemy"
```

### 3. Identify Features

```bash
# Routes/endpoints
find . -name "*route*" -o -name "*controller*"
grep -r "router\." --include="*.ts"

# Components
find src/components -name "*.tsx"

# Database models
find . -name "*model*" -o -name "*schema*"
```

### 4. Check Tests

```bash
# Test files
find . -name "*.test.*" -o -name "*.spec.*"

# Test commands
cat package.json | grep test

# Coverage
npm run test:coverage 2>/dev/null || echo "No coverage command"
```

### 5. Infer Promises

Based on features found, infer user promises:

```markdown
## Inferred Promises

### [INFERRED] User Authentication
- **Evidence:** `auth/` directory, JWT middleware
- **Criticality:** CORE
- **Status:** Implemented

### [INFERRED] Post Creation/Editing
- **Evidence:** Post model, CRUD routes
- **Criticality:** CORE
- **Status:** Implemented

### [INFERRED] Comment System
- **Evidence:** Comment model, nested routes
- **Criticality:** IMPORTANT
- **Status:** Partially implemented (no editing)
```

## Output Format

```markdown
# Brownfield Analysis Report

## Tech Stack
- **Frontend:** React 18 + TypeScript + Vite
- **Backend:** Express.js + TypeScript
- **Database:** PostgreSQL with Prisma ORM
- **Testing:** Jest + Supertest
- **Other:** ESLint, Prettier

## Project Structure
\`\`\`
src/
├── components/     # React components (23 files)
├── pages/          # Page components (8 files)
├── services/       # API clients (5 files)
├── server/
│   ├── routes/     # API routes (12 endpoints)
│   ├── models/     # Database models (6 models)
│   └── middleware/ # Auth, validation (4 files)
└── tests/          # Tests (45 tests, 67% coverage)
\`\`\`

## Features Identified

1. **User Management**
   - Registration, login, profile
   - JWT authentication
   - Tests: 12/12 passing

2. **Post System**
   - CRUD operations
   - Draft/published states
   - Tests: 18/18 passing

3. **Comments**
   - Create/read (no edit/delete)
   - Nested comments
   - Tests: 8/15 passing ⚠️

## Issues Found

### Critical
- [ ] No rate limiting on API
- [ ] Passwords not properly hashed (using weak algorithm)

### High
- [ ] Comment edit/delete missing
- [ ] No input validation on several endpoints
- [ ] Test coverage <70%

### Medium
- [ ] No error logging
- [ ] No API documentation
- [ ] No TypeScript strict mode

## Recommendations

1. Add rate limiting (express-rate-limit)
2. Fix password hashing (use bcrypt with cost 10+)
3. Complete comment CRUD operations
4. Add input validation (zod)
5. Improve test coverage to >80%

## Next Steps

What would you like to do?
- [ ] Add a new feature
- [ ] Fix critical issues
- [ ] Improve test coverage
- [ ] Add missing functionality
- [ ] Something else
```

## Integration

After brownfield analysis:
1. Create [INFERRED] documentation in `/docs/`
2. Update CLAUDE.md state
3. Ask user what they want to work on
4. Load appropriate skills for next task
