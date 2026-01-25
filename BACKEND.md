# Backend Development with LLM Integration

Complete guide to backend development in claude-workflow-agents projects, with emphasis on LLM integration patterns.

---

## Table of Contents

1. [LLM Integration Patterns](#llm-integration-patterns)
2. [Backend Workflow](#backend-workflow)
3. [API Design](#api-design)
4. [Service Layer](#service-layer)
5. [Database Patterns](#database-patterns)
6. [Testing](#testing)
7. [Error Handling](#error-handling)
8. [Performance](#performance)
9. [Common Patterns](#common-patterns)
10. [Troubleshooting](#troubleshooting)

---

## LLM Integration Patterns

### CRITICAL: Read Before Implementing Any AI Feature

**The backend-engineer agent MUST follow the dual provider pattern for ALL LLM integrations.**

This prevents:
- ❌ High development costs (using commercial APIs for every test)
- ❌ Vendor lock-in (tied to single provider)
- ❌ Unreliable production (no fallback if provider down)
- ❌ App crashes on LLM failures

This ensures:
- ✅ Free development (Ollama local models)
- ✅ Reliable production (commercial API fallbacks)
- ✅ Graceful degradation (rule-based fallbacks)
- ✅ Provider independence (easy to swap)

---

### Pattern 1: Dual Provider Architecture

**Every AI component MUST support multiple providers.**

```typescript
// ✅ GOOD: Dual provider with fallback
import { LLMClient } from '@/lib/llm/client';
import { z } from 'zod';

const TagsSchema = z.object({
  tags: z.array(z.string()).min(2).max(5),
});

export async function generateTags(content: string): Promise<string[]> {
  const llm = new LLMClient();  // Auto-configured with fallback chain

  try {
    const result = await llm.completeJSON(
      `Generate 3-5 tags for: "${content}"`,
      TagsSchema,
      { temperature: 0.5 }
    );
    return result.tags;
  } catch (error) {
    // Graceful degradation - NEVER crash
    logger.warn('LLM failed, using keyword extraction', error);
    return extractKeywords(content);
  }
}

// ❌ BAD: Hardcoded provider, no fallback
import OpenAI from 'openai';

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

export async function generateTags(content: string) {
  const response = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [{ role: 'user', content: `Generate tags for: ${content}` }],
  });
  return JSON.parse(response.choices[0].message.content);  // Can crash!
}
```

---

### Pattern 2: Robust JSON Parsing

**Local models (Ollama) often return malformed JSON. Always use the robust parser.**

```typescript
import { parseJSON, parseJSONWithRetry } from '@/lib/llm/json-parser';

// ✅ GOOD: Robust parsing with multiple strategies
const llmResponse = await llm.complete(prompt);
const data = parseJSON(llmResponse);  // Handles markdown, trailing commas, etc.

// ✅ GOOD: With retry and error feedback
const result = await parseJSONWithRetry(
  llmResponse,
  MySchema,
  async (errorFeedback) => {
    // Ask LLM to fix the JSON
    return await llm.complete(`${prompt}\n\n${errorFeedback}`);
  }
);

// ❌ BAD: Direct JSON.parse (will break with local models)
const data = JSON.parse(llmResponse);  // Fails on markdown wrapping, trailing commas, etc.
```

**What the robust parser handles:**
- Markdown code blocks: ` ```json\n{...}\n``` `
- Trailing commas: `{"key": "value",}`
- Single quotes: `{'key': 'value'}`
- Python booleans: `True`, `False`, `None`
- Preamble/postamble: `"Here's the JSON: {...}"`
- Comments: `// comment` or `/* comment */`

---

### Pattern 3: Schema Validation with Zod

**ALWAYS validate LLM output with Zod schemas.**

```typescript
import { z } from 'zod';

// ✅ GOOD: Complete schema with validation
const ProductSchema = z.object({
  name: z.string().min(1).max(100),
  price: z.number().positive(),
  category: z.enum(['electronics', 'books', 'clothing', 'food']),
  tags: z.array(z.string()).min(1).max(10),
  inStock: z.boolean(),
  description: z.string().max(500).optional(),
});

type Product = z.infer<typeof ProductSchema>;

export async function extractProduct(text: string): Promise<Product> {
  const llm = new LLMClient();

  const result = await llm.completeJSON(
    `Extract product information from: "${text}"`,
    ProductSchema,
    { temperature: 0.3 }
  );

  return result;  // Type-safe! Guaranteed to match schema
}

// ❌ BAD: No validation, trusting LLM output
export async function extractProduct(text: string): Promise<any> {
  const result = await llm.complete(`Extract product: ${text}`);
  return JSON.parse(result);  // Could be anything!
}
```

**Advanced validation patterns:**

```typescript
// Permissive parsing for LLM output
const PermissiveSchema = z.object({
  required: z.string(),
  optional: z.string().optional(),
  withDefault: z.string().default('unknown'),
  coerced: z.coerce.number(),  // Converts "123" to 123
  array: z.array(z.string()).default([]),  // Empty array if missing
});

// Custom validators
const EmailSchema = z.object({
  email: z.string().email(),
  verified: z.boolean(),
}).refine(
  (data) => data.verified || data.email.includes('@example.com'),
  { message: 'Unverified emails must be from example.com' }
);
```

---

### Pattern 4: Graceful Degradation

**NEVER let LLM failures crash the application.**

```typescript
// ✅ GOOD: Multi-layer fallback strategy
export async function generateSummary(text: string): Promise<string> {
  // Layer 1: Try LLM
  try {
    const llm = new LLMClient();
    return await llm.complete(
      `Summarize in one sentence: "${text}"`,
      { temperature: 0.3, maxTokens: 100 }
    );
  } catch (error) {
    logger.warn('LLM summary failed, using extractive summary', error);
  }

  // Layer 2: Extractive summary (rule-based)
  try {
    return extractiveSummary(text);
  } catch (error) {
    logger.error('Extractive summary failed, using truncation', error);
  }

  // Layer 3: Simple truncation (always works)
  return text.slice(0, 200) + '...';
}

function extractiveSummary(text: string): string {
  const sentences = text.split(/[.!?]+/).filter(s => s.length > 10);
  return sentences[0] || text.slice(0, 200);
}

// ❌ BAD: No fallback, can crash
export async function generateSummary(text: string): Promise<string> {
  const llm = new LLMClient();
  return await llm.complete(`Summarize: ${text}`);  // Throws on failure
}
```

---

### Pattern 5: Provider Configuration

**Configure providers via environment variables, never hardcode.**

```typescript
// ✅ GOOD: Load from environment
import { loadLLMConfig } from '@/lib/llm/config';

const config = loadLLMConfig();
const llm = new LLMClient(config);

// ✅ GOOD: Override for specific use case
const llm = new LLMClient({
  ...loadLLMConfig(),
  ollama: {
    baseURL: 'http://custom-ollama:11434',
    model: 'mistral',
  },
});

// ❌ BAD: Hardcoded provider
const llm = new OpenAI({ apiKey: 'sk-hardcoded-key' });
```

**Environment variables (.env):**
```bash
# Ollama (local, free)
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2

# OpenAI (commercial fallback)
OPENAI_API_KEY=sk-proj-...
OPENAI_MODEL=gpt-4o-mini

# Anthropic (optional fallback)
ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
```

---

## Backend Workflow

### Step 1: Read the Plan

**backend-engineer MUST read `/docs/plans/backend-plan.md` before implementing.**

```markdown
## Feature: Auto-Tagging

### LLM Integration Required

**Input:** Conversation content (string)
**Output:** Tags (array of strings, 2-5 items)

**LLM Provider:**
- Primary: Ollama (llama3.2)
- Fallback: OpenAI (gpt-4o-mini)
- Fallback on all LLM failure: Keyword extraction

**Implementation:**
- Use `LLMClient` from `/src/lib/llm/client`
- Define Zod schema: `{ tags: string[], confidence?: number }`
- Temperature: 0.5
- Max tokens: 200
- Graceful degradation required
```

### Step 2: Implement Service with LLM

```typescript
// src/services/auto-tagger.service.ts
import { LLMClient } from '@/lib/llm/client';
import { z } from 'zod';
import { logger } from '@/lib/logger';

const TagsSchema = z.object({
  tags: z.array(z.string().min(1).max(30)).min(2).max(5),
  confidence: z.number().min(0).max(1).optional(),
});

export class AutoTaggerService {
  private llm = new LLMClient();

  async generateTags(content: string): Promise<string[]> {
    try {
      const result = await this.llm.completeJSON(
        this.buildPrompt(content),
        TagsSchema,
        {
          temperature: 0.5,
          maxTokens: 200,
        }
      );

      logger.info('LLM tagging successful', {
        tags: result.tags,
        confidence: result.confidence,
        provider: 'auto-selected',
      });

      return result.tags;
    } catch (error) {
      logger.warn('LLM tagging failed, using keyword extraction', {
        error: error.message,
      });

      return this.extractKeywords(content);
    }
  }

  private buildPrompt(content: string): string {
    return `Analyze this content and generate 2-5 relevant tags.

Content:
${content.slice(0, 1000)}

Return JSON with tags array and confidence score.
Tags should be single words or short phrases, lowercase, relevant to the content.`;
  }

  private extractKeywords(content: string): string[] {
    // Simple rule-based fallback
    const words = content.toLowerCase()
      .replace(/[^a-z0-9\s]/g, '')
      .split(/\s+/)
      .filter(w => w.length >= 4);

    const frequency = new Map<string, number>();
    words.forEach(word => {
      frequency.set(word, (frequency.get(word) || 0) + 1);
    });

    return Array.from(frequency.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([word]) => word);
  }
}
```

### Step 3: Create API Endpoint

```typescript
// src/routes/conversations.routes.ts
import { Router } from 'express';
import { AutoTaggerService } from '@/services/auto-tagger.service';

const router = Router();
const taggerService = new AutoTaggerService();

router.post('/conversations/:id/generate-tags', async (req, res) => {
  try {
    const { id } = req.params;

    // Get conversation
    const conversation = await db.conversations.findById(id);
    if (!conversation) {
      return res.status(404).json({
        error: { code: 'NOT_FOUND', message: 'Conversation not found' },
      });
    }

    // Generate tags
    const content = conversation.messages.map(m => m.content).join('\n');
    const tags = await taggerService.generateTags(content);

    // Save tags
    await db.conversations.update(id, { tags });

    res.json({ tags });
  } catch (error) {
    logger.error('Tag generation failed', error);
    res.status(500).json({
      error: { code: 'INTERNAL_ERROR', message: 'Failed to generate tags' },
    });
  }
});
```

### Step 4: Write Tests

```typescript
// tests/services/auto-tagger.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { AutoTaggerService } from '@/services/auto-tagger.service';
import { LLMClient } from '@/lib/llm/client';

vi.mock('@/lib/llm/client');

describe('AutoTaggerService', () => {
  let service: AutoTaggerService;
  let mockLLM: ReturnType<typeof vi.mocked<typeof LLMClient>>;

  beforeEach(() => {
    service = new AutoTaggerService();
    mockLLM = vi.mocked(LLMClient);
  });

  it('generates tags using LLM', async () => {
    mockLLM.prototype.completeJSON.mockResolvedValue({
      tags: ['javascript', 'typescript', 'testing'],
      confidence: 0.9,
    });

    const tags = await service.generateTags('How to test TypeScript code with Vitest');

    expect(tags).toEqual(['javascript', 'typescript', 'testing']);
    expect(mockLLM.prototype.completeJSON).toHaveBeenCalledWith(
      expect.stringContaining('generate 2-5 relevant tags'),
      expect.any(Object),  // Zod schema
      expect.objectContaining({ temperature: 0.5 })
    );
  });

  it('falls back to keyword extraction on LLM failure', async () => {
    mockLLM.prototype.completeJSON.mockRejectedValue(
      new Error('All LLM providers failed')
    );

    const tags = await service.generateTags('testing javascript typescript framework');

    expect(tags.length).toBeGreaterThan(0);
    expect(tags).toContain('testing');
    expect(tags).toContain('javascript');
  });

  it('handles malformed LLM output', async () => {
    mockLLM.prototype.completeJSON.mockRejectedValue(
      new Error('Schema validation failed')
    );

    const tags = await service.generateTags('content');

    // Should fall back gracefully
    expect(Array.isArray(tags)).toBe(true);
  });
});
```

---

## API Design

### RESTful API Patterns

```typescript
// ✅ GOOD: Consistent REST API
router.get('/conversations', listConversations);
router.get('/conversations/:id', getConversation);
router.post('/conversations', createConversation);
router.put('/conversations/:id', updateConversation);
router.delete('/conversations/:id', deleteConversation);

// LLM-powered endpoints (clearly marked)
router.post('/conversations/:id/generate-tags', generateTags);  // AI feature
router.post('/conversations/:id/generate-summary', generateSummary);  // AI feature
```

### Error Response Format

**Always use consistent error format:**

```typescript
// Standard error response
interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: Record<string, any>;
  };
}

// ✅ GOOD: Consistent errors
res.status(404).json({
  error: {
    code: 'NOT_FOUND',
    message: 'Conversation not found',
  },
});

res.status(422).json({
  error: {
    code: 'VALIDATION_ERROR',
    message: 'Invalid input',
    details: {
      content: 'Content is required',
    },
  },
});

res.status(500).json({
  error: {
    code: 'LLM_FAILURE',
    message: 'Failed to generate tags (all providers unavailable)',
    details: {
      fallback: 'Using keyword extraction',
    },
  },
});
```

---

## Service Layer

### Service Structure

```typescript
// ✅ GOOD: Injectable service with dependencies
export class ConversationService {
  constructor(
    private db: Database,
    private tagger: AutoTaggerService,
    private logger: Logger
  ) {}

  async create(data: CreateConversationDTO): Promise<Conversation> {
    // Create conversation
    const conversation = await this.db.conversations.create(data);

    // Auto-generate tags (async, non-blocking)
    this.generateTagsAsync(conversation.id).catch(err => {
      this.logger.warn('Async tag generation failed', err);
    });

    return conversation;
  }

  private async generateTagsAsync(id: string): Promise<void> {
    const conversation = await this.db.conversations.findById(id);
    const content = conversation.messages.map(m => m.content).join('\n');
    const tags = await this.tagger.generateTags(content);
    await this.db.conversations.update(id, { tags });
  }
}
```

---

## Database Patterns

### Storing LLM-Generated Data

```typescript
// Schema for conversations with AI-generated fields
interface Conversation {
  id: string;
  userId: string;
  title: string;
  messages: Message[];

  // AI-generated fields
  tags: string[];  // Generated by LLM
  summary?: string;  // Generated by LLM
  sentiment?: 'positive' | 'negative' | 'neutral';  // Generated by LLM

  // Metadata about AI generation
  aiMetadata?: {
    tagsGeneratedAt?: Date;
    tagsGeneratedBy?: 'llm' | 'user' | 'fallback';
    summaryGeneratedAt?: Date;
  };

  createdAt: Date;
  updatedAt: Date;
}
```

---

## Testing

### Test LLM Integration

```typescript
// Mock LLM client in tests
vi.mock('@/lib/llm/client', () => ({
  LLMClient: vi.fn().mockImplementation(() => ({
    completeJSON: vi.fn(),
    complete: vi.fn(),
  })),
}));

// Test successful LLM call
it('uses LLM when available', async () => {
  mockLLM.prototype.completeJSON.mockResolvedValue({ tags: ['test'] });
  const result = await service.generateTags('content');
  expect(result).toEqual(['test']);
});

// Test LLM failure and fallback
it('falls back on LLM failure', async () => {
  mockLLM.prototype.completeJSON.mockRejectedValue(new Error('LLM failed'));
  const result = await service.generateTags('test content keywords');
  expect(result).toContain('test');  // Keyword extraction
});

// Test malformed JSON
it('handles malformed JSON', async () => {
  mockLLM.prototype.completeJSON.mockRejectedValue(new Error('Parse error'));
  const result = await service.generateTags('content');
  expect(Array.isArray(result)).toBe(true);  // Graceful fallback
});
```

---

## Error Handling

### LLM-Specific Errors

```typescript
// ✅ GOOD: Specific error handling
try {
  return await llm.completeJSON(prompt, schema);
} catch (error) {
  if (error instanceof z.ZodError) {
    logger.error('LLM returned invalid schema', { error: error.errors });
    return fallbackResult();
  }

  if (error.message.includes('rate limit')) {
    logger.warn('Rate limited, queueing for retry');
    await queueForRetry(prompt, schema);
    return fallbackResult();
  }

  if (error.message.includes('All LLM providers failed')) {
    logger.error('Complete LLM failure', { error });
    return fallbackResult();
  }

  throw error;  // Unknown error
}
```

---

## Performance

### Caching LLM Results

```typescript
// ✅ GOOD: Cache expensive LLM calls
export class CachedTaggerService {
  constructor(
    private tagger: AutoTaggerService,
    private cache: Redis
  ) {}

  async generateTags(content: string): Promise<string[]> {
    // Hash content for cache key
    const cacheKey = `tags:${this.hashContent(content)}`;

    // Check cache
    const cached = await this.cache.get(cacheKey);
    if (cached) {
      logger.info('Tag cache hit');
      return JSON.parse(cached);
    }

    // Generate with LLM
    const tags = await this.tagger.generateTags(content);

    // Cache for 7 days
    await this.cache.setex(cacheKey, 60 * 60 * 24 * 7, JSON.stringify(tags));

    return tags;
  }

  private hashContent(content: string): string {
    return crypto.createHash('sha256').update(content).digest('hex');
  }
}
```

---

## Common Patterns

### Pattern: Background Job with LLM

```typescript
// Process tags asynchronously
export async function processConversationTags(conversationId: string) {
  const conversation = await db.conversations.findById(conversationId);
  const content = conversation.messages.map(m => m.content).join('\n');

  try {
    const tags = await taggerService.generateTags(content);
    await db.conversations.update(conversationId, {
      tags,
      aiMetadata: {
        tagsGeneratedAt: new Date(),
        tagsGeneratedBy: 'llm',
      },
    });
  } catch (error) {
    logger.error('Background tag generation failed', { conversationId, error });
  }
}
```

---

## Troubleshooting

### "All LLM providers failed"

**Check provider status:**
```bash
/llm test
```

**Fix Ollama:**
```bash
ollama serve
ollama pull llama3.2
```

**Fix commercial APIs:**
```bash
# Check API keys
echo $OPENAI_API_KEY
echo $ANTHROPIC_API_KEY

# Test directly
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

### "Schema validation failed"

**Debug LLM output:**
```typescript
try {
  const result = await llm.completeJSON(prompt, schema);
} catch (error) {
  if (error instanceof z.ZodError) {
    console.log('Validation errors:', error.errors);
    console.log('Raw LLM output:', /* log from provider */);
  }
}
```

**Fix schema to be more permissive:**
```typescript
// Add defaults and optional fields
const PermissiveSchema = z.object({
  tags: z.array(z.string()).default([]),  // Default to empty array
  confidence: z.number().optional(),  // Make optional
});
```

---

## Best Practices Summary

### LLM Integration Checklist

- [ ] Uses `LLMClient` from `/src/lib/llm/client` (dual provider support)
- [ ] Defines Zod schema for all structured outputs
- [ ] Implements graceful fallback (rule-based or default)
- [ ] Logs provider success/failure with context
- [ ] Never crashes on LLM failure
- [ ] Tests both successful and failed LLM calls
- [ ] Caches results where appropriate
- [ ] Handles malformed JSON from local models
- [ ] Uses environment variables for configuration
- [ ] Documents cost estimates for production

### Code Quality

- [ ] No `any` types (full TypeScript)
- [ ] Dependency injection (testable services)
- [ ] Error handling at all layers
- [ ] Consistent API responses
- [ ] Logging for debugging
- [ ] Unit tests with >80% coverage
- [ ] Integration tests for critical paths

---

## See Also

- `templates/docs/architecture/llm-integration.md` - Complete LLM integration guide
- `templates/src/lib/llm/` - LLM client library implementation
- `FRONTEND.md` - Frontend development guide
- `/llm` command - Manage LLM providers
- `/agent-wf-help llm` - LLM integration help
