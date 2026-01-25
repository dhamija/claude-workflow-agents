# LLM Library

This directory contains the complete LLM integration library with dual provider support (Ollama + Commercial APIs).

## Quick Start

```typescript
import { LLMClient } from './lib/llm/client';
import { z } from 'zod';

// Initialize client (reads from environment variables)
const llm = new LLMClient();

// Simple text completion
const response = await llm.complete('Explain quantum computing in one sentence');

// Structured JSON output with schema validation
const TagsSchema = z.object({
  tags: z.array(z.string()).min(2).max(5),
});

const result = await llm.completeJSON(
  'Generate 3 tags for this article about AI',
  TagsSchema
);

console.log(result.tags); // ['AI', 'Technology', 'Innovation']
```

## File Structure

```
src/lib/llm/
├── base-provider.ts        # Provider interface definition
├── client.ts               # Unified LLM client with fallback
├── config.ts               # Configuration loading
├── json-parser.ts          # Robust JSON parsing
├── retry.ts                # Retry logic with backoff
├── providers/
│   ├── ollama.ts          # Ollama (local) implementation
│   ├── openai.ts          # OpenAI implementation
│   └── anthropic.ts       # Anthropic (Claude) implementation
└── README.md              # This file
```

## Environment Variables

Create a `.env` file:

```bash
# Ollama (Local - Free)
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2

# OpenAI (Optional - Paid)
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini

# Anthropic (Optional - Paid)
ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
```

## Dependencies

Install required packages:

```bash
npm install zod openai @anthropic-ai/sdk
```

## Fallback Chain

The client tries providers in this order:

1. **Ollama** (local, free) - Default for development
2. **OpenAI** (if API key set) - Fallback if Ollama unavailable
3. **Anthropic** (if API key set) - Final fallback

If a provider fails, the next one is tried automatically.

## JSON Parsing

The `json-parser.ts` handles malformed JSON from local models:

- Extracts JSON from markdown code blocks
- Repairs trailing commas, single quotes, Python booleans
- Handles preamble/postamble text
- Provides retry with error feedback

## Usage Patterns

### Pattern 1: Simple Completion

```typescript
const summary = await llm.complete(
  'Summarize this text in one sentence: ...',
  { temperature: 0.3 }
);
```

### Pattern 2: JSON with Schema

```typescript
const ProductSchema = z.object({
  name: z.string(),
  price: z.number(),
  tags: z.array(z.string()),
});

const product = await llm.completeJSON(
  'Extract product info from: "iPhone 15 Pro - $999, tags: phone, apple, premium"',
  ProductSchema
);
```

### Pattern 3: With Graceful Fallback

```typescript
async function smartFeature(input: string) {
  try {
    return await llm.completeJSON(input, MySchema);
  } catch (error) {
    console.warn('LLM failed, using rule-based approach');
    return ruleBasedApproach(input);
  }
}
```

### Pattern 4: Check Available Providers

```typescript
const available = await llm.getAvailableProviders();
console.log('Available:', available); // ['Ollama', 'OpenAI']
```

### Pattern 5: Retry with Feedback

```typescript
import { parseJSONWithRetry } from './lib/llm/json-parser';

const result = await parseJSONWithRetry(
  llmResponse,
  MySchema,
  async (errorFeedback) => {
    return await llm.complete(`${originalPrompt}\n\n${errorFeedback}`);
  }
);
```

## Testing

All providers can be tested independently:

```typescript
import { OllamaProvider } from './lib/llm/providers/ollama';

const ollama = new OllamaProvider({
  baseURL: 'http://localhost:11434',
  model: 'llama3.2',
});

const isAvailable = await ollama.isAvailable();
console.log('Ollama available:', isAvailable);
```

## Error Handling

The client provides detailed error messages:

```
All LLM providers failed:
  - Ollama: Not available
  - OpenAI: API key not configured
  - Anthropic: Rate limit exceeded
```

## Best Practices

1. **Always use schemas** - Validate LLM output with Zod
2. **Provide fallbacks** - Don't let LLM failures crash your app
3. **Lower temperature for structured output** - Use 0.1-0.3 for JSON
4. **Test with local models** - Ollama is free and good for development
5. **Monitor costs** - Commercial APIs charge per token
6. **Handle malformed JSON** - Use the robust parser, especially with Ollama

## Troubleshooting

### Ollama not available

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Start Ollama
ollama serve

# Pull model
ollama pull llama3.2
```

### Commercial API errors

```typescript
// Check configuration
const config = loadLLMConfig();
console.log('OpenAI configured:', !!config.openai.apiKey);
console.log('Anthropic configured:', !!config.anthropic.apiKey);
```

### JSON parsing fails

Enable debug logging in `json-parser.ts`:

```typescript
const parsed = parseJSON(text);
console.log('Parsed:', parsed);
```

## License

Same as parent project.
