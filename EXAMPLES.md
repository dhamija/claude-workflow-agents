# Practical Examples

Real-world examples showing how to use the system for different scenarios.

---

## Table of Contents

1. [Example 1: Simple Todo App (Greenfield)](#example-1-simple-todo-app-greenfield)
2. [Example 2: Complex E-Commerce Platform (Greenfield)](#example-2-complex-e-commerce-platform-greenfield)
3. [Example 3: Improving Existing Code (Brownfield)](#example-3-improving-existing-code-brownfield)
4. [Example 4: Adding Features to Existing Project](#example-4-adding-features-to-existing-project)
5. [Example 5: Focused Work (Backend Only)](#example-5-focused-work-backend-only)
6. [Example 6: Debugging Production Issue](#example-6-debugging-production-issue)
7. [Example 7: Pre-Deployment Code Review](#example-7-pre-deployment-code-review)
8. [Example 8: Design System Setup and Usage](#example-8-design-system-setup-and-usage)

---

## Example 1: Simple Todo App (Greenfield)

**Scenario:** You want to build a basic todo app to learn the system.

### Conversation

```
You: Build me a simple todo app where users can create, edit, and delete tasks

Claude: I'll help you build a todo app. Let me start by understanding what we're building...

        [intent-guardian] Defining product intent...
        [ux-architect] Designing user journeys...
        [agentic-architect] Designing architecture...

        Analysis complete. This will be a straightforward CRUD app with:
        - User authentication (secure task ownership)
        - Task management (create, edit, delete, mark done)
        - Simple, clean interface

        What tech stack would you like? I recommend:
        - Backend: Express + TypeScript + PostgreSQL
        - Frontend: React + Vite + Tailwind

        Or specify your preference.

You: That sounds good, let's use those

Claude: [implementation-planner] Creating implementation plans...

        Plans ready. I've identified 3 features:
        1. user-authentication (foundation)
        2. task-management (core feature)
        3. task-filtering (enhancement)

        Starting with feature 1: user-authentication...

        [backend-engineer] Creating auth API...
        - POST /api/auth/signup
        - POST /api/auth/login
        - GET /api/auth/me
        - JWT token-based auth
        ✓ Backend complete

        [frontend-engineer] Creating auth UI...
        - Login page
        - Signup page
        - Auth state management
        ✓ Frontend complete

        [test-engineer] Writing tests...
        - Unit tests: Password hashing, token generation
        - Integration tests: Auth endpoints
        - E2E tests: Login/signup journey
        ✓ Tests complete (coverage: 94%)

        [Verification] All tests passing ✓

        [project-ops] Syncing project state...
        ✓ CLAUDE.md updated - Feature 1 complete
        ✓ Documentation synced

        Feature 1 complete. Starting feature 2: task-management...

        [backend-engineer] Creating task API...
        - POST /api/tasks (create task)
        - GET /api/tasks (list user's tasks)
        - PATCH /api/tasks/:id (edit task)
        - DELETE /api/tasks/:id (delete task)
        ✓ Backend complete

        [frontend-engineer] Creating task UI...
        - Task list page
        - Task form (create/edit)
        - Task item component
        - Loading/error/empty states
        ✓ Frontend complete

        [test-engineer] Writing tests...
        - Unit tests: Task validation
        - Integration tests: Task CRUD endpoints
        - E2E tests: Full task management journey
        ✓ Tests complete (coverage: 91%)

        [Verification] All tests passing ✓

        [project-ops] Syncing project state...
        ✓ CLAUDE.md updated - Feature 2 complete
        ✓ Documentation synced

        Feature 2 complete. Starting feature 3: task-filtering...

        [backend-engineer] Adding filter support...
        - GET /api/tasks?status=active|completed|all
        - GET /api/tasks?sortBy=createdAt|dueDate
        ✓ Backend complete

        [frontend-engineer] Adding filter UI...
        - Filter dropdown (All, Active, Completed)
        - Sort dropdown (Created, Due Date)
        - URL query params for state
        ✓ Frontend complete

        [test-engineer] Writing tests...
        ✓ Tests complete

        [Verification] All tests passing ✓

        [project-ops] Final sync...
        ✓ All features marked complete
        ✓ Test coverage: 93% overall
        ✓ All promises verified as KEPT
        ✓ All journeys marked IMPLEMENTED

        All features complete! Your todo app is ready.

        Summary:
        ✅ user-authentication - complete
        ✅ task-management - complete
        ✅ task-filtering - complete

        Next steps:
        1. Run: npm install && npm run dev
        2. Open: http://localhost:5173
        3. Create account and start using!

You: Looks great! Can you show me what was created?

Claude: Here's what was built:

        Documentation (/docs):
        ├── intent/product-intent.md - Promises about security, data ownership
        ├── ux/user-journeys.md - Login, signup, task management flows
        ├── architecture/agent-design.md - System design (traditional CRUD)
        └── plans/ - Complete implementation plans

        Backend (src/):
        ├── auth/ - Authentication service, JWT tokens
        ├── tasks/ - Task CRUD service
        ├── db/ - Database connection, migrations
        └── server.ts - Express server

        Frontend (client/src/):
        ├── pages/ - Login, Signup, TaskList pages
        ├── components/ - TaskItem, TaskForm, Filters
        ├── hooks/ - useAuth, useTasks (React Query)
        └── App.tsx - Routes and auth guard

        Tests (tests/):
        ├── auth/ - Auth unit and integration tests
        ├── tasks/ - Task unit and integration tests
        └── e2e/ - Full journey tests

        Try it out:
        npm run dev
```

### What Happened

1. **Just talked naturally** - No commands, Claude orchestrated everything
2. **L1 analysis** - Intent, UX, and architecture defined
3. **L2 implementation** - Three features built sequentially
4. **Each feature verified** - Tests written and passing before moving on
5. **Complete app** - Backend, frontend, tests, docs all created

### Time: ~10 minutes (Claude working)

---

## Example 2: Complex E-Commerce Platform (Greenfield)

**Scenario:** You're building a full-featured e-commerce platform with your team.

### Conversation

```
You: Build me an e-commerce platform for selling handmade crafts.
     Requirements:
     - User accounts with seller and buyer roles
     - Sellers can list products with photos
     - Buyers can browse, search, add to cart, checkout
     - Payment processing with Stripe
     - Order tracking
     - Reviews and ratings

Claude: This is a substantial project. Let me analyze the requirements...

        [intent-guardian] Defining product intent...
        - Promise: Secure payment processing (PCI compliance)
        - Promise: Seller payouts within 7 days
        - Anti-promise: Never charge buyers without confirmation
        - Invariant: Order.total must match sum of items + tax + shipping

        [ux-architect] Designing user journeys...
        - Buyer journey: Browse → Search → View product → Add to cart → Checkout
        - Seller journey: List product → Manage inventory → View orders → Get paid
        - 12 total journeys identified

        [agentic-architect] Designing architecture...
        - Traditional: Product catalog, cart, checkout (established patterns)
        - Agent opportunity: Smart product recommendations based on browsing
        - Agent opportunity: Automated fraud detection on orders
        - Agent opportunity: AI-generated product descriptions from photos

        [implementation-planner] Creating plans...

        Analysis complete. I've identified 11 features grouped in 4 batches:

        **Batch 0 (Foundation - Sequential):**
        1. user-authentication (with roles: buyer, seller)
        2. database-setup

        **Batch 1 (Core - Can be Parallel):**
        3. product-catalog (sellers list products)
        4. user-profiles (buyers/sellers manage profiles)
        5. image-upload (product photos)

        **Batch 2 (Shopping - Can be Parallel):**
        6. product-search (browse and search)
        7. shopping-cart (add to cart, manage quantities)

        **Batch 3 (Transactions):**
        8. stripe-integration (payment processing)
        9. checkout-flow (complete purchase)
        10. order-management (track orders, seller fulfillment)
        11. reviews-ratings (buyers rate purchases)

        This is a large project. You have two options:

        **Option 1: Sequential (solo developer)**
        I'll build features one by one in your main project.
        Estimated time: ~40 hours over 2-3 weeks.

        **Option 2: Parallel (team with 3+ developers)**
        I can set up git worktrees for parallel development.
        Batch 1 (3 features) can be built simultaneously by 3 developers.
        Estimated time: ~15 hours with 3 developers.

        Which approach would you like?

You: We have 3 developers. Let's use parallel mode.

Claude: Great! I'll set you up for parallel development.

        First, let me complete Batch 0 (foundation) sequentially...

        [Building user-authentication]
        ✓ Auth with roles (buyer, seller, admin)
        ✓ Role-based access control middleware
        ✓ Tests passing

        [Building database-setup]
        ✓ Schema for users, products, orders, carts, reviews
        ✓ Migrations created
        ✓ Seed data for testing

        Batch 0 complete ✓

        Now setting up worktrees for Batch 1 (parallel development)...

        Worktrees created:
        1. ../ecommerce-product-catalog/
        2. ../ecommerce-user-profiles/
        3. ../ecommerce-image-upload/

        Each worktree has:
        - Feature plan in FEATURE.md
        - Scoped CLAUDE.md (only implementation agents)
        - Branch: feature/[name]

        **Developer 1:** cd ../ecommerce-product-catalog && claude
        **Developer 2:** cd ../ecommerce-user-profiles && claude
        **Developer 3:** cd ../ecommerce-image-upload && claude

        In each worktree, just say "Implement this feature"

# Developer 1's Terminal
cd ../ecommerce-product-catalog
claude

You: Implement this feature

Claude: [Reads FEATURE.md]

        Building product-catalog feature...

        [backend-engineer]
        - Product model (title, description, price, inventory)
        - Seller-only create/edit endpoints
        - Public list/view endpoints
        ✓ Complete

        [frontend-engineer]
        - Seller: Product creation form
        - Seller: Product management page
        - Public: Product listing grid
        ✓ Complete

        [test-engineer]
        - Unit: Price validation
        - Integration: CRUD endpoints
        - E2E: Seller creates product → Buyer views it
        ✓ Complete

        Product-catalog feature complete ✓
        Push: git push origin feature/product-catalog
        Create PR on GitHub for review.

# Meanwhile, Developer 2 and 3 finish their features in parallel...

# Back in main project
You: All 3 features are done and merged. What's next?

Claude: Excellent! All Batch 1 features merged.

        Setting up Batch 2 worktrees...

        Worktrees created:
        1. ../ecommerce-product-search/
        2. ../ecommerce-shopping-cart/

        **Developer 1:** cd ../ecommerce-product-search && claude
        **Developer 2:** cd ../ecommerce-shopping-cart && claude

        (Developer 3 can start work on documentation or help with reviews)

# This pattern continues until all batches complete...

You: All features complete. What's the final status?

Claude: Project: E-Commerce Platform - COMPLETE ✅

        ✅ Batch 0: Foundation (2 features)
        ✅ Batch 1: Core (3 features)
        ✅ Batch 2: Shopping (2 features)
        ✅ Batch 3: Transactions (4 features)

        All features verified ✓
        All tests passing (coverage: 89%)
        All journeys working end-to-end

        Deployment checklist:
        - [ ] Set environment variables (STRIPE_SECRET_KEY, etc.)
        - [ ] Run database migrations in production
        - [ ] Configure CDN for product images
        - [ ] Set up monitoring (error tracking, performance)
        - [ ] Enable HTTPS
        - [ ] Review security checklist in /docs/security.md

        Ready to deploy!
```

### What Happened

1. **Complex requirements** handled with analysis phase
2. **11 features** broken into 4 dependency batches
3. **Parallel development** set up with git worktrees
4. **3 developers** worked simultaneously on Batch 1
5. **Complete platform** delivered in ~15 hours vs ~40 hours sequential

### Time: ~15 hours (with 3 developers in parallel)

---

## Example 3: Improving Existing Code (Brownfield)

**Scenario:** You inherited a messy codebase and need to improve it.

### Conversation

```
You: Analyze this codebase and tell me what's wrong with it

Claude: I'll audit the codebase to understand what exists and identify issues...

        [intent-guardian AUDIT] Inferring product intent from code...
        [ux-architect AUDIT] Mapping existing user journeys...
        [agentic-architect AUDIT] Analyzing current architecture...

        Audit complete. Here's what I found:

        **INFERRED INTENT:**
        This appears to be a project management tool for teams.

        Promises (inferred):
        - PRM-001: Users can only see their team's projects [HIGH confidence]
          Evidence: userId filter in queries (src/projects/service.ts:45)

        - PRM-002: Tasks are never lost [MEDIUM confidence]
          Evidence: Soft delete in code, but trash not in UI (might be incomplete)

        - PRM-003: Real-time collaboration [LOW confidence]
          Evidence: WebSocket code exists but mostly commented out

        **INFERRED UX:**
        Found 8 user journeys:
        - Create project ✅ Complete
        - Add team members ⚠️ Incomplete (can't remove members)
        - Create task ✅ Complete
        - Assign task ❌ Broken (assignment endpoint returns 500)
        - View dashboard ⚠️ Performance issues (20+ seconds load)
        - Search projects ✅ Complete
        - Export data ❌ Not implemented (button exists, does nothing)
        - User settings ✅ Complete

        **INFERRED ARCHITECTURE:**
        - REST API (Express + TypeScript)
        - PostgreSQL database
        - React frontend
        - No AI agents currently (but could benefit from smart task prioritization)

        Is this understanding correct?

You: Yes, that's right. The assignment feature is broken and dashboard is slow.
     We don't need real-time collab - that was an abandoned experiment.
     We DO need the export feature - users keep asking for it.

Claude: Got it. Updating inferred docs...

        Removed: Real-time collaboration promise
        Confirmed broken: Task assignment
        Confirmed issue: Dashboard performance
        Added missing: Export feature

        Running gap analysis...

        [gap-analyzer] Comparing current state vs requirements...

        Found 12 gaps across 4 priority levels:

        **CRITICAL (Fix Immediately) - 2 gaps:**

        GAP-001: Task Assignment Returns 500 Error
        - Current: assignTask endpoint crashes with "Cannot read property 'id'"
        - Expected: Assigns task to user, returns success
        - Risk: Core feature completely broken, users can't collaborate
        - Fix: Add null check for user lookup
        - Effort: 30 minutes

        GAP-002: No Rate Limiting on Login
        - Current: Unlimited login attempts allowed
        - Expected: Rate limit to prevent brute force
        - Risk: Security vulnerability, accounts could be compromised
        - Fix: Add express-rate-limit middleware
        - Effort: 20 minutes

        **HIGH (Phase 1) - 4 gaps:**

        GAP-003: Dashboard Loads in 20+ Seconds (N+1 Query)
        - Current: Fetches projects, then tasks in loop (100+ queries)
        - Expected: Single query with joins, <2 second load
        - Risk: Poor UX, users frustrated
        - Fix: Optimize query with JOIN, add pagination
        - Effort: 2 hours

        GAP-004: Export Feature Not Implemented
        - Current: Button exists but does nothing
        - Expected: Exports projects/tasks to CSV
        - Risk: User frustration, missing promised feature
        - Fix: Implement export endpoint + CSV generation
        - Effort: 3 hours

        GAP-005: Can't Remove Team Members
        - Current: Can add members but not remove
        - Expected: Add/remove team members
        - Risk: Security issue (ex-employees retain access)
        - Fix: Add DELETE /api/teams/:id/members/:userId
        - Effort: 1 hour

        GAP-006: No Error Handling in File Upload
        - Current: Crashes on large files
        - Expected: Validates size, returns friendly error
        - Risk: Server crashes, bad UX
        - Fix: Add file size validation + error handling
        - Effort: 1 hour

        **MEDIUM (Phase 2) - 4 gaps:**
        (Duplicated code, missing tests, no loading states, etc.)

        **LOW (Phase 3/Backlog) - 2 gaps:**
        (Code style inconsistency, outdated dependencies)

        Want me to start fixing? I recommend:
        1. Phase 0: Critical issues (50 min)
        2. Phase 1: High priority (7 hours)
        3. Phase 2: Medium priority (optional)

You: Fix the critical issues first, then the high priority ones

Claude: Starting Phase 0: Critical Fixes

        [Fixing GAP-001: Task assignment error]
        [debugger] Found issue: Missing user existence check
        - Added user lookup validation
        - Returns 404 if user not found
        - Added test for error case
        ✓ Fixed and tested

        [Fixing GAP-002: Rate limiting]
        [backend-engineer] Adding rate limit
        - Added express-rate-limit middleware
        - 5 attempts per 15 minutes
        - Returns 429 on limit exceeded
        - Added test
        ✓ Fixed and tested

        Phase 0 complete ✓
        Critical issues resolved.

        Starting Phase 1: High Priority Fixes

        [Fixing GAP-003: Dashboard performance]
        [backend-engineer] Optimizing query
        - Changed from N+1 queries to single JOIN
        - Added pagination (20 projects per page)
        - Added database index on userId
        Before: 20+ seconds, 100+ queries
        After: 0.8 seconds, 1 query
        ✓ Performance improved 25x

        [Fixing GAP-004: Export feature]
        [backend-engineer] Implementing export
        - GET /api/export/projects (returns CSV)
        - GET /api/export/tasks (returns CSV)
        - Streaming for large datasets
        [frontend-engineer] Connecting export button
        - Download trigger implemented
        - Shows progress spinner
        ✓ Export working

        [Fixing GAP-005: Remove team members]
        [backend-engineer] Adding remove endpoint
        - DELETE /api/teams/:teamId/members/:userId
        - Only team owner can remove
        [frontend-engineer] Adding UI
        - Remove button next to each member
        - Confirmation dialog
        ✓ Can now remove members

        [Fixing GAP-006: File upload error handling]
        [backend-engineer] Adding validation
        - Max file size: 10MB
        - Returns 413 Payload Too Large if exceeded
        - Friendly error message in UI
        ✓ File upload robust

        Phase 1 complete ✓

        Summary of improvements:
        ✅ Fixed broken task assignment
        ✅ Added security rate limiting
        ✅ Dashboard 25x faster (20s → 0.8s)
        ✅ Export feature working
        ✅ Can remove team members
        ✅ File upload error handling

        All critical and high-priority issues resolved.

        Medium priority gaps remain (tech debt, tests, etc.)
        Want to continue with Phase 2 or stop here?

You: This is great, let's stop here. Ship it!

Claude: Excellent! Here's what was fixed:

        Fixed 6 critical/high issues in ~8 hours
        All tests passing ✓
        No regressions ✓

        Updated documentation:
        /docs/intent/product-intent.md - Corrected promises
        /docs/ux/user-journeys.md - Updated with fixes
        /docs/gaps/gap-analysis.md - Full audit report
        /docs/gaps/migration-plan.md - What was done

        Ready to deploy!
```

### What Happened

1. **Audit mode** inferred intent/UX/architecture from code
2. **User confirmed/corrected** inferred understanding
3. **Gap analysis** found 12 issues prioritized by severity
4. **Critical fixes** (2 gaps) done immediately
5. **High priority fixes** (4 gaps) completed next
6. **Tangible improvements** in 8 hours

### Time: ~8 hours (fixing 6 critical/high issues)

---

## Example 4: Adding Features to Existing Project

**Scenario:** You have a working app and want to add new capabilities.

### Conversation

```
You: I have a recipe app. Add a meal planning feature where users can plan meals for the week.

Claude: I'll analyze the impact of adding meal planning...

        [change-analyzer] Analyzing impact on existing system...

        Reading current state:
        - /docs/intent/product-intent.md
        - /docs/ux/user-journeys.md
        - /docs/architecture/agent-design.md
        - Current implementation (recipes, user-profiles, shopping-lists)

        Change Impact Analysis:

        **New Journey:**
        - User selects recipes for each day of the week
        - User can view weekly meal plan
        - User can generate shopping list from meal plan

        **Affected Artifacts:**

        Intent:
        - Add promise: "Meal plans save time and reduce decision fatigue"
        - Add promise: "Shopping list auto-generated from meal plan"

        UX:
        - New journey: Plan weekly meals
        - Modified journey: Generate shopping list (now includes meal plan option)

        Architecture:
        - New entity: MealPlan (userId, weekStartDate, meals[])
        - New service: MealPlanService
        - Modified: ShoppingListService (integrate with meal plans)

        **Implementation Scope:**

        Backend:
        - POST /api/meal-plans (create weekly plan)
        - GET /api/meal-plans/:id
        - PATCH /api/meal-plans/:id (modify plan)
        - GET /api/meal-plans/current (this week's plan)
        - POST /api/meal-plans/:id/shopping-list (generate from plan)

        Frontend:
        - MealPlanPage (calendar view, week selector)
        - MealPlanDayCard (shows day + recipe)
        - RecipePicker (search and add recipe to day)
        - Integration with existing ShoppingListPage

        Tests:
        - Unit: MealPlan validation, date handling
        - Integration: CRUD endpoints
        - E2E: Full meal planning journey

        **Effort Estimate:** ~6 hours

        **Risk:** Low (isolated feature, minimal integration)

        This is a medium-sized addition. Ready to implement?

You: Yes, let's do it

Claude: [change-analyzer] Updating artifacts...

        ✅ Updated product-intent.md with meal planning promises
        ✅ Updated user-journeys.md with new journey
        ✅ Updated agent-design.md with MealPlan entity

        [implementation-planner] Creating feature plan...
        ✅ Created /docs/plans/features/meal-planning.md

        Starting implementation...

        [backend-engineer] Building meal plan API...
        - MealPlan model (weekStartDate, meals: {day, recipeId, mealType})
        - CRUD endpoints
        - Shopping list integration
        ✓ Backend complete

        [frontend-engineer] Building meal plan UI...
        - Weekly calendar view
        - Drag-and-drop recipe assignment
        - "Generate Shopping List" button
        - Mobile-responsive layout
        ✓ Frontend complete

        [test-engineer] Writing tests...
        - Unit tests: Date validation, duplicate detection
        - Integration tests: All endpoints
        - E2E test: Plan meals → Generate shopping list
        ✓ Tests complete (coverage: 92%)

        [Verification]
        ✅ All tests passing
        ✅ Journey working end-to-end
        ✅ No regressions in existing features

        Meal planning feature complete ✓

        What's new:
        - Weekly meal planner calendar
        - Drag recipes to days
        - Auto-generate shopping list from plan
        - Mobile-friendly interface

        Try it: npm run dev → Navigate to /meal-plan
```

### What Happened

1. **Change analyzer** assessed impact of new feature
2. **Existing docs updated** to include meal planning
3. **Feature plan created** with full specification
4. **Implementation** followed standard workflow
5. **No regressions** - existing features still work

### Time: ~6 hours (one new feature)

---

## Example 5: Focused Work (Backend Only)

**Scenario:** You're a backend developer, frontend is handled by someone else.

### Conversation

```
You: Build me the backend API for a movie recommendation app.
     I'll handle the frontend myself.

Claude: I'll focus on backend implementation only.

        [intent-guardian] Defining API requirements...
        [agentic-architect] Designing backend architecture...

        Backend system design:
        - Movie catalog with AI-powered recommendations
        - User preferences and watch history
        - Recommendation agent (uses Claude API)

        [implementation-planner] Creating backend plan...

        API Endpoints to implement:

        **Movies:**
        - GET /api/movies (list with filters: genre, year, rating)
        - GET /api/movies/:id (movie details)
        - GET /api/movies/search?q=query (search by title)

        **User Preferences:**
        - POST /api/preferences (set genre preferences)
        - GET /api/preferences (get current preferences)

        **Recommendations:**
        - GET /api/recommendations (AI-powered based on history + preferences)
        - POST /api/watch-history (record watched movie)

        **Tech Stack:**
        - Express + TypeScript
        - PostgreSQL (movie data, user prefs)
        - Claude API (recommendation agent)

        Starting backend implementation...

        [backend-engineer] Building movie catalog...
        - Movie model (title, genres, year, rating, synopsis)
        - Search with full-text indexing
        - Pagination and filtering
        ✓ Movie endpoints complete

        [backend-engineer] Building user preferences...
        - UserPreference model (userId, favoriteGenres, dislikedGenres)
        - CRUD endpoints
        ✓ Preference endpoints complete

        [backend-engineer] Building recommendation agent...
        - RecommendationAgent class
        - Analyzes watch history + preferences
        - Calls Claude API with movie data
        - Returns ranked recommendations with explanations
        ✓ Recommendation endpoint complete

        [test-engineer] Writing backend tests...
        - Unit tests: Recommendation logic
        - Integration tests: All endpoints
        - Mock Claude API for tests
        ✓ Tests complete (coverage: 88%)

        Backend API complete ✓

        Documentation created:
        - /docs/api/endpoints.md (full API reference)
        - /docs/api/recommendation-agent.md (how it works)
        - Example requests/responses for each endpoint

        API running on: http://localhost:3000

        Test it:
        curl http://localhost:3000/api/movies
        curl http://localhost:3000/api/recommendations

        Frontend developers: See /docs/api/endpoints.md for complete API docs

You: Can you also add a "similar movies" endpoint?

Claude: [change-analyzer] Analyzing addition...

        This is a small addition to existing movie service.

        New endpoint:
        - GET /api/movies/:id/similar
        - Returns movies similar to given movie (by genre, cast, director)

        [backend-engineer] Implementing...
        - Added similarityScore function
        - Ranks movies by multiple factors
        - Returns top 10 similar movies
        ✓ Complete

        [test-engineer] Adding tests...
        ✓ Tests complete

        New endpoint ready:
        GET /api/movies/:id/similar

        Example:
        curl http://localhost:3000/api/movies/123/similar
```

### What Happened

1. **Backend focus** - Only API implementation, no frontend
2. **AI recommendation agent** included in architecture
3. **Complete API** with documentation
4. **Easy to extend** - Added similar movies endpoint quickly
5. **Ready for frontend team** - Clear API docs provided

### Time: ~4 hours (backend only)

---

## Example 6: Debugging Production Issue

**Scenario:** Your app is live and users report an error.

### Conversation

```
You: Users are reporting "Failed to load profile" errors. The profile page shows
     an error message instead of their data.

Claude: I'll investigate this issue...

        [debugger] Analyzing profile loading...

        Checking profile endpoint...
        - GET /api/users/profile
        - Expected: Returns user data
        - Actual: Returns 500 Internal Server Error

        Reading server logs...
        Found error:
        "TypeError: Cannot read property 'avatar' of null
         at ProfileController.getProfile (src/users/profile.controller.ts:23)"

        Root cause identified:
        Line 23 tries to access user.avatar without checking if user exists.

        This happens when:
        - User token is valid (not expired)
        - But user was deleted from database
        - Controller assumes user always exists

        Reviewing codebase...
        Found 3 instances of this pattern:
        1. ProfileController.getProfile (src/users/profile.controller.ts:23)
        2. SettingsController.getSettings (src/users/settings.controller.ts:45)
        3. PostsController.getUserPosts (src/posts/posts.controller.ts:67)

        Fix needed:
        - Add user existence check after token validation
        - Return 401 Unauthorized if user not found
        - Clear token on client side

        Implementing fix...

        [debugger] Fixing profile endpoint...

        Changed:
        ```typescript
        // Before (BROKEN)
        async getProfile(req, res) {
          const userId = req.user.id  // From token
          const user = await db.user.findById(userId)
          return res.json({
            name: user.name,
            avatar: user.avatar  // CRASHES if user null
          })
        }

        // After (FIXED)
        async getProfile(req, res) {
          const userId = req.user.id
          const user = await db.user.findById(userId)

          if (!user) {
            // User deleted but token still valid
            return res.status(401).json({
              error: 'User not found',
              code: 'USER_DELETED'
            })
          }

          return res.json({
            name: user.name,
            avatar: user.avatar
          })
        }
        ```

        Applied same fix to:
        - SettingsController.getSettings
        - PostsController.getUserPosts

        [test-engineer] Adding regression test...
        ```typescript
        it('should return 401 when user deleted but token valid', async () => {
          const token = await createValidToken(deletedUserId)
          const response = await request(app)
            .get('/api/users/profile')
            .set('Authorization', `Bearer ${token}`)

          expect(response.status).toBe(401)
          expect(response.body.code).toBe('USER_DELETED')
        })
        ```

        [frontend-engineer] Updating error handling...
        - Added check for USER_DELETED error code
        - Clears local token
        - Redirects to login
        - Shows "Your account was deleted" message

        Fix complete ✓

        What changed:
        - Backend: Added user existence checks (3 endpoints)
        - Frontend: Handle USER_DELETED error
        - Tests: Added regression test

        Deployed fix to production.
        Users will be redirected to login if their account was deleted.

You: Great! Can we prevent this in the future?

Claude: Yes, I'll add preventive measures...

        [backend-engineer] Adding middleware...

        Created: src/middleware/ensureUserExists.ts
        ```typescript
        export async function ensureUserExists(req, res, next) {
          const user = await db.user.findById(req.user.id)

          if (!user) {
            return res.status(401).json({
              error: 'User not found',
              code: 'USER_DELETED'
            })
          }

          req.user = user  // Attach full user object
          next()
        }
        ```

        Applied to all protected routes:
        ```typescript
        router.get('/profile',
          authenticateToken,
          ensureUserExists,  // New middleware
          ProfileController.getProfile
        )
        ```

        Benefits:
        - Centralized user existence check
        - No more manual checks in controllers
        - Consistent error handling
        - Harder to forget

        All protected routes updated ✓
        Regression tests added ✓

        This pattern is now enforced project-wide.
```

### What Happened

1. **Debugger analyzed** error from user report
2. **Root cause found** in under 1 minute
3. **Fix applied** to all affected endpoints
4. **Regression test** added to prevent recurrence
5. **Preventive measure** implemented (middleware)
6. **Deployed** to production

### Time: ~30 minutes (from report to fix deployed)

---

## Example 7: Pre-Deployment Code Review

**Scenario:** You're about to deploy to production and want a security/quality check.

### Conversation

```
You: Review the entire codebase before we deploy to production

Claude: I'll perform a comprehensive code review focusing on security, bugs, and quality...

        [code-reviewer] Analyzing codebase...

        Scanning 487 files...
        - Backend: 234 files (TypeScript)
        - Frontend: 198 files (React + TypeScript)
        - Tests: 55 files

        SECURITY ANALYSIS
        ═════════════════

        🔴 CRITICAL (Fix before deploy) - 2 issues

        SEC-001: SQL Injection Vulnerability
        File: src/search/search.service.ts:34
        ```typescript
        // DANGEROUS
        const results = await db.query(
          `SELECT * FROM products WHERE title LIKE '%${searchTerm}%'`
        )
        ```
        Risk: Attacker can inject SQL commands
        Fix: Use parameterized queries
        ```typescript
        const results = await db.query(
          'SELECT * FROM products WHERE title LIKE $1',
          [`%${searchTerm}%`]
        )
        ```

        SEC-002: Sensitive Data in Logs
        File: src/auth/auth.service.ts:67
        ```typescript
        logger.info('User logged in', { user })  // Logs password hash!
        ```
        Risk: Password hashes in logs
        Fix: Remove sensitive fields
        ```typescript
        logger.info('User logged in', {
          userId: user.id,
          email: user.email
        })
        ```

        🟠 HIGH (Fix soon) - 5 issues

        SEC-003: No CSRF Protection
        Files: All POST/PUT/DELETE endpoints
        Risk: Cross-site request forgery
        Fix: Add csurf middleware

        SEC-004: Missing Rate Limiting
        File: src/api/server.ts
        Risk: Brute force, DDoS
        Fix: Add express-rate-limit (especially on /login)

        SEC-005: Weak Password Requirements
        File: src/auth/validation.ts:12
        Current: Min 6 chars
        Recommended: Min 12 chars, require complexity
        Risk: Weak passwords easy to crack

        SEC-006: No Helmet Security Headers
        File: src/api/server.ts
        Risk: Missing security headers (XSS, clickjacking)
        Fix: Add helmet middleware

        SEC-007: Unvalidated File Uploads
        File: src/uploads/upload.controller.ts:23
        Risk: Malicious file uploads (XSS, malware)
        Fix: Validate file types, scan for malware

        🟡 MEDIUM - 3 issues
        (API keys in env file not .gitignored, etc.)

        BUGS FOUND
        ══════════

        BUG-001: Race Condition in Checkout
        File: src/checkout/checkout.service.ts:45-67
        ```typescript
        // Check inventory
        const available = await getInventory(productId)
        if (available < quantity) throw new Error('Out of stock')

        // ... other async operations ...

        // Reduce inventory (RACE CONDITION - inventory might have changed!)
        await reduceInventory(productId, quantity)
        ```
        Fix: Use database transaction with row locking

        BUG-002: Memory Leak in WebSocket Handler
        File: src/websocket/handler.ts:89
        Event listeners not cleaned up on disconnect
        Fix: Add cleanup in disconnect handler

        BUG-003: Incorrect Date Handling (Timezone)
        File: src/reports/report.service.ts:34
        Uses Date.now() instead of user's timezone
        Fix: Use user timezone from profile

        CODE QUALITY
        ════════════

        ✅ Good:
        - Test coverage: 87% (target: 80%)
        - TypeScript strict mode enabled
        - Consistent code style (ESLint passing)
        - Good error handling (try/catch)

        ⚠️ Needs improvement:
        - 23 functions over 50 lines (consider refactoring)
        - 12 files over 300 lines (split into smaller modules)
        - 5 TODO comments (address before deploy)

        PERFORMANCE
        ═══════════

        PERF-001: N+1 Query in Dashboard
        File: src/dashboard/dashboard.service.ts:23-45
        Fix: Use JOIN instead of loop

        PERF-002: No Response Caching
        Static API responses not cached
        Fix: Add Redis caching for product catalog

        SUMMARY
        ═══════

        Overall: ⚠️ NOT READY FOR PRODUCTION

        Critical issues: 2 (MUST FIX)
        High priority: 5 (SHOULD FIX)
        Medium: 3 (GOOD TO FIX)
        Bugs: 3 (FIX)

        Estimated fix time: ~4 hours

        RECOMMENDATION:
        1. Fix SEC-001 and SEC-002 immediately (30 min)
        2. Fix BUG-001 (race condition in checkout) (1 hour)
        3. Add rate limiting and CSRF protection (1 hour)
        4. Fix remaining high-priority security issues (1.5 hours)
        5. Re-run review

        Want me to fix these issues?

You: Yes, fix all critical and high-priority issues, plus the bugs

Claude: Starting fixes...

        [Fixing SEC-001: SQL Injection]
        ✅ Replaced string interpolation with parameterized queries (3 files)

        [Fixing SEC-002: Sensitive data in logs]
        ✅ Created sanitizeForLogs() helper
        ✅ Applied to all log statements (12 locations)

        [Fixing BUG-001: Race condition]
        ✅ Wrapped checkout in database transaction
        ✅ Added row-level locking
        ✅ Added test for concurrent checkouts

        [Fixing BUG-002: Memory leak]
        ✅ Added cleanup in WebSocket disconnect handler

        [Fixing BUG-003: Timezone issue]
        ✅ Using user timezone from profile
        ✅ Added timezone to all date displays

        [Fixing SEC-003: CSRF protection]
        ✅ Added csurf middleware
        ✅ Frontend sends CSRF token

        [Fixing SEC-004: Rate limiting]
        ✅ Added express-rate-limit
        ✅ Login: 5 attempts per 15 min
        ✅ API: 100 requests per 15 min

        [Fixing SEC-005: Password requirements]
        ✅ Min 12 chars
        ✅ Require: uppercase, lowercase, number, special char
        ✅ Updated validation + tests

        [Fixing SEC-006: Security headers]
        ✅ Added helmet middleware

        [Fixing SEC-007: File upload validation]
        ✅ Whitelist: jpg, png, pdf only
        ✅ Max size: 10MB
        ✅ Scan for malware with ClamAV

        All critical/high issues + bugs fixed ✓

        Running full test suite...
        ✅ 234 tests passing
        ✅ No regressions

        Re-running security scan...

        SECURITY RE-SCAN
        ════════════════

        🟢 All critical issues resolved ✓
        🟢 All high-priority issues resolved ✓
        🟡 3 medium issues remain (optional)

        Overall: ✅ READY FOR PRODUCTION

        Changes made:
        - 2 critical security fixes
        - 5 high-priority security improvements
        - 3 bug fixes
        - All tests passing

        Deployment checklist:
        - [x] Security review passed
        - [x] All tests passing
        - [x] No critical bugs
        - [ ] Environment variables set in production
        - [ ] Database backed up
        - [ ] Monitoring configured

        Ready to deploy!

You: Perfect! Deploy to production

Claude: Deploying...

        ✅ Built production bundle
        ✅ Ran database migrations
        ✅ Deployed to production servers
        ✅ Smoke tests passed
        ✅ Monitoring active

        Deployment successful ✓

        Production URL: https://your-app.com
        Monitoring: https://dashboard.monitoring.com
```

### What Happened

1. **Comprehensive review** - Security, bugs, quality, performance
2. **Critical issues found** - SQL injection, sensitive logs
3. **All issues fixed** - 2 critical + 5 high + 3 bugs
4. **Re-verified** - Security scan passed
5. **Deployed safely** - No critical issues in production

### Time: ~4 hours (from review to production deploy)

---

## Example 8: Design System Setup and Usage

**Scenario:** You're building a SaaS product and want consistent, professional UI without making arbitrary styling decisions.

### Conversation

```
You: I want to build a project management SaaS. I like Linear's clean design style.

Claude: I'll help you build a project management SaaS. Let me start by analyzing your requirements...

        [intent-guardian] Defining product intent...
        [ux-architect] Designing user journeys...

        I see you mentioned liking Linear's design style. Let me gather design preferences
        before we continue with the architecture.

        For the design system, I have a few options:

        1. Apply a preset:
           - modern-clean (professional SaaS - similar to Linear, Vercel, Stripe)
           - minimal (ultra-clean, content-focused)
           - playful (vibrant, fun, animated)
           - corporate (enterprise-grade, formal)
           - glassmorphism (modern glass effects)

        2. Reference a site I should analyze
        3. Specify custom brand colors and preferences

        Since you mentioned Linear, I can either apply the "modern-clean" preset
        (which is similar) or analyze Linear.app directly to extract their design patterns.

        What would you prefer?

You: Analyze Linear's design and create something similar

Claude: [ux-architect] Analyzing https://linear.app...

        ✓ Design system created at /docs/ux/design-system.md

        Based on Linear's design language:
        • Primary color: #5E6AD2 (purple-blue)
        • Typography: Inter font family
        • Spacing: Tight, efficient layout (8px base unit)
        • Components: Minimal shadows, subtle borders, fast transitions
        • Characteristics: Clean, fast, professional, data-dense

        I've also included:
        • Dark mode support (Linear's dark theme)
        • Accessibility (WCAG AAA contrast ratios)
        • Tailwind configuration
        • CSS variables

        Now continuing with architecture...

        [agentic-architect] Designing architecture...

        Analysis complete. Proceeding to planning phase.

You: Great, plan it out with React and Node

Claude: [implementation-planner] Creating implementation plans...

        Plans ready. I've identified 5 features:
        1. user-authentication (foundation)
        2. project-management (core)
        3. task-tracking (core)
        4. team-collaboration (advanced)
        5. notifications (enhancement)

        Starting with feature 1: user-authentication...

        [backend-engineer] Creating auth API...
        ✓ Backend complete

        [frontend-engineer] Setting up design system...

        CRITICAL: Reading /docs/ux/design-system.md first...

        ✓ Design system loaded:
          - Primary: #5E6AD2
          - Font: Inter
          - Spacing: 8px base unit
          - Components: Minimal, fast

        Setting up Tailwind configuration from design system...

        // tailwind.config.js
        module.exports = {
          theme: {
            extend: {
              colors: {
                primary: {
                  DEFAULT: '#5E6AD2',
                  light: '#7B89DD',
                  dark: '#4C55B0',
                },
              },
              fontFamily: {
                sans: ['Inter', 'system-ui', 'sans-serif'],
              },
              spacing: {
                // 8px base unit
                'unit': '0.5rem',
              },
            },
          },
        }

        Creating base component library...

        ✓ Button.tsx (primary, secondary, ghost variants - using design system)
        ✓ Input.tsx (using design system input styles)
        ✓ Card.tsx (using design system card styles)
        ✓ Modal.tsx (using design system modal styles)

        All components use ONLY design system values:
        ✓ Colors from design system
        ✓ Typography from design system
        ✓ Spacing from design system
        ✓ No arbitrary hex codes or custom fonts

        Now building auth UI...

        ✓ LoginPage.tsx (using Button, Input components)
        ✓ SignupPage.tsx (using Button, Input components)
        ✓ AuthLayout.tsx (consistent with design system)

        Frontend complete.

        [test-engineer] Writing tests...
        ✓ Tests complete

        Feature 1 complete.

        [... continues with other features ...]

You: I want to change the primary color to a darker blue

Claude: I'll update the design system for you.

        Current primary color: #5E6AD2
        New primary color: #4C55B0

        Updating /docs/ux/design-system.md...
        ✓ Updated primary color
        ✓ Updated primary-light (#6A75C8)
        ✓ Updated primary-dark (#3D4490)
        ✓ Updated Tailwind config in design system
        ✓ Updated CSS variables in design system

        ⚠️  This change affects your component library.

        To apply the new color:
        1. Copy the updated Tailwind config from design-system.md
        2. Replace your tailwind.config.js
        3. Rebuild your CSS

        Or I can update the files for you. Would you like me to do that?

You: Yes please update the files

Claude: [frontend-engineer] Applying design system updates...

        ✓ Updated tailwind.config.js with new colors
        ✓ Rebuilt CSS (npm run build:css)
        ✓ All components automatically use new color

        The design system change has been applied. All components using
        'bg-primary' or 'text-primary' now use #4C55B0 automatically.

        No code changes needed - that's the power of design systems!
```

### Files Created

```
/docs/ux/design-system.md         - Complete design specification
tailwind.config.js                 - Configured from design system
src/components/ui/Button.tsx       - Uses design system
src/components/ui/Input.tsx        - Uses design system
src/components/ui/Card.tsx         - Uses design system
src/components/ui/Modal.tsx        - Uses design system
```

### What Happened

1. **UX architect gathered design preferences** - Asked about design style
2. **Analyzed reference site** - Extracted Linear's design patterns
3. **Created design system** - Complete visual specification in `/docs/ux/design-system.md`
4. **Frontend engineer followed strictly** - Read design system first, no arbitrary styling
5. **Component library bootstrapped** - All components use design system values
6. **UI automatically consistent** - All screens/components match design system
7. **Easy design updates** - Change design system once, updates everywhere

### Benefits

**Before design systems:**
```tsx
// Developer makes arbitrary choices
<button className="bg-blue-500 px-4 py-2 rounded-md">
  Click me
</button>

<button className="bg-indigo-600 px-3 py-2.5 rounded-lg">
  Another button (different!)
</button>
```

**With design system:**
```tsx
// All buttons use design system component
<Button variant="primary">Click me</Button>
<Button variant="primary">Another button (consistent!)</Button>

// Button.tsx internally uses design system colors:
// bg-primary (from design-system.md)
```

**Updating colors:**
- Without design system: Find/replace every `bg-blue-500` across hundreds of files
- With design system: Update one value in design-system.md → all components update

### Key Points

1. **Design system created early** - UX architect asks preferences during analysis phase
2. **Frontend reads design system first** - Before writing any code
3. **No arbitrary styling** - All colors/fonts/spacing from design system
4. **Component library** - Reusable components enforcing design system
5. **Easy updates** - Change design system, components update automatically
6. **Accessibility built-in** - WCAG compliance in design system
7. **Multiple options** - Presets, reference sites, or custom

### Using /design Command

```bash
# Quick start with preset
/design preset modern-clean

# Match a competitor
/design reference https://linear.app

# View current design
/design show

# Update brand colors
/design update

# During /ux, design system created automatically
/ux project management SaaS
# (UX architect will ask about design preferences)
```

### Time: 6 hours total
- Analysis + Design system: 1 hour
- Planning: 1 hour
- Implementation (5 features): 4 hours
- All UI consistent from day one
- Design change: 5 minutes (vs hours of find/replace)

---

## Key Takeaways

### Pattern 1: Just Talk
All examples show natural conversation. No commands needed - Claude orchestrates agents automatically.

### Pattern 2: Greenfield = Analyze → Plan → Build
Examples 1 & 2 show this flow. Analysis (L1) before implementation (L2).

### Pattern 3: Brownfield = Audit → Gap → Improve
Example 3 shows inferring from code, finding gaps, prioritized fixing.

### Pattern 4: Changes = Analyze Impact → Update → Continue
Examples 4 & 6 show change management - understand impact before making changes.

### Pattern 5: Verification at Every Step
All examples show tests written and verified before moving on. No "test later".

### Pattern 6: Parallel for Teams, Sequential for Solo
Example 2 shows parallel development for 3-person team. Example 1 shows sequential for solo.

### Pattern 7: Focused Work is Supported
Example 5 shows backend-only development. Frontend done by someone else.

### Pattern 8: Debugging is Systematic
Example 6 shows debugger finding root cause quickly, applying fix, preventing recurrence.

### Pattern 9: Reviews Before Deploy
Example 7 shows comprehensive security/quality review before production.

### Pattern 10: Design System for Consistency
Example 8 shows design system ensuring UI consistency, no arbitrary styling, easy design updates.

---

## More Help

- **README.md** - Progressive disclosure introduction
- **GUIDE.md** - Quick reference card
- **WORKFLOW.md** - Deep dive into how it works
- **/agent-wf-help** - In-app help system
