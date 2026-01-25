/**
 * LLM Usage Examples
 *
 * Demonstrates common patterns for using the LLM client
 */

import { LLMClient } from './client';
import { z } from 'zod';

// Example 1: Simple text completion
export async function example1_SimpleCompletion() {
  const llm = new LLMClient();

  const response = await llm.complete(
    'Explain quantum computing in one sentence',
    { temperature: 0.7 }
  );

  console.log(response);
}

// Example 2: Structured JSON output
export async function example2_StructuredOutput() {
  const llm = new LLMClient();

  const TagsSchema = z.object({
    tags: z.array(z.string().min(1).max(30)).min(2).max(5),
    confidence: z.number().min(0).max(1),
  });

  const result = await llm.completeJSON(
    'Generate 3-5 relevant tags for an article about artificial intelligence and machine learning',
    TagsSchema,
    { temperature: 0.5 }
  );

  console.log('Tags:', result.tags);
  console.log('Confidence:', result.confidence);
}

// Example 3: With system prompt
export async function example3_SystemPrompt() {
  const llm = new LLMClient();

  const response = await llm.complete(
    'Write a haiku about coding',
    {
      systemPrompt: 'You are a creative poet who writes in traditional Japanese haiku format (5-7-5 syllables).',
      temperature: 0.9,
    }
  );

  console.log(response);
}

// Example 4: Complex schema with nested objects
export async function example4_ComplexSchema() {
  const llm = new LLMClient();

  const ProductSchema = z.object({
    id: z.string(),
    name: z.string(),
    price: z.number().positive(),
    category: z.enum(['electronics', 'books', 'clothing', 'food']),
    tags: z.array(z.string()).min(1),
    inStock: z.boolean(),
    reviews: z.object({
      average: z.number().min(0).max(5),
      count: z.number().int().nonnegative(),
    }),
  });

  const product = await llm.completeJSON(
    'Extract product information from this text: ' +
    '"The iPhone 15 Pro (ID: IP15P) costs $999. It\'s an electronics item with tags: phone, apple, premium. ' +
    'Currently in stock. Has 4.5 star rating from 1234 reviews."',
    ProductSchema
  );

  console.log('Product:', product);
}

// Example 5: Array of items
export async function example5_ArrayOutput() {
  const llm = new LLMClient();

  const TodoListSchema = z.object({
    tasks: z.array(
      z.object({
        id: z.number(),
        title: z.string(),
        priority: z.enum(['low', 'medium', 'high']),
        completed: z.boolean(),
      })
    ),
  });

  const result = await llm.completeJSON(
    'Generate a todo list with 3 tasks for a software developer',
    TodoListSchema
  );

  console.log('Tasks:', result.tasks);
}

// Example 6: With graceful fallback
export async function example6_GracefulFallback(input: string) {
  const llm = new LLMClient();

  const SentimentSchema = z.object({
    sentiment: z.enum(['positive', 'negative', 'neutral']),
    score: z.number().min(-1).max(1),
  });

  try {
    const result = await llm.completeJSON(
      `Analyze sentiment: "${input}"`,
      SentimentSchema
    );
    return result;
  } catch (error) {
    console.warn('LLM failed, using rule-based sentiment analysis');
    return {
      sentiment: 'neutral' as const,
      score: 0,
    };
  }
}

// Example 7: Check available providers
export async function example7_CheckProviders() {
  const llm = new LLMClient();

  const available = await llm.getAvailableProviders();
  console.log('Available providers:', available);

  if (available.length === 0) {
    console.warn('No LLM providers available!');
  } else if (available.includes('Ollama')) {
    console.log('✓ Using local Ollama (free)');
  } else {
    console.log('⚠ Using commercial API (costs money)');
  }
}

// Example 8: Batch processing with error handling
export async function example8_BatchProcessing(items: string[]) {
  const llm = new LLMClient();

  const CategorySchema = z.object({
    category: z.string(),
    confidence: z.number(),
  });

  const results = await Promise.allSettled(
    items.map(item =>
      llm.completeJSON(
        `Categorize this item: "${item}"`,
        CategorySchema
      )
    )
  );

  return results.map((result, i) => {
    if (result.status === 'fulfilled') {
      return result.value;
    } else {
      console.error(`Failed to categorize "${items[i]}":`, result.reason);
      return { category: 'unknown', confidence: 0 };
    }
  });
}

// Example 9: Streaming-like behavior with progress
export async function example9_LongRunningTask(items: string[]) {
  const llm = new LLMClient();

  const results: string[] = [];

  for (let i = 0; i < items.length; i++) {
    console.log(`Processing ${i + 1}/${items.length}...`);

    const summary = await llm.complete(
      `Summarize in 10 words: "${items[i]}"`,
      { maxTokens: 50 }
    );

    results.push(summary);
  }

  return results;
}

// Example 10: Custom retry logic
export async function example10_CustomRetry() {
  const llm = new LLMClient();

  const EmailSchema = z.object({
    subject: z.string(),
    body: z.string(),
    tone: z.enum(['formal', 'casual', 'friendly']),
  });

  let attempts = 0;
  const maxAttempts = 3;

  while (attempts < maxAttempts) {
    try {
      return await llm.completeJSON(
        'Generate a professional email to a client about project delay',
        EmailSchema,
        { temperature: 0.7 }
      );
    } catch (error) {
      attempts++;
      if (attempts >= maxAttempts) throw error;

      console.log(`Attempt ${attempts} failed, retrying...`);
      await new Promise(resolve => setTimeout(resolve, 1000 * attempts));
    }
  }
}

// Run examples
if (require.main === module) {
  (async () => {
    console.log('=== Example 1: Simple Completion ===');
    await example1_SimpleCompletion();

    console.log('\n=== Example 2: Structured Output ===');
    await example2_StructuredOutput();

    console.log('\n=== Example 7: Check Providers ===');
    await example7_CheckProviders();
  })();
}
