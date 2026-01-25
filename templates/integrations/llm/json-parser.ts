/**
 * Robust JSON parser for handling malformed LLM output
 *
 * Local LLMs (Ollama) often produce malformed JSON:
 * - Trailing commas: {"key": "value",}
 * - Markdown wrapping: ```json\n{...}\n```
 * - Preamble/postamble text: "Here's the JSON: {...}"
 * - Single quotes: {'key': 'value'}
 * - Truncated output: {"items": [{"id":
 * - Python-style booleans: True, False, None
 *
 * This parser applies multiple strategies to extract and repair JSON.
 */

import { z } from 'zod';

/**
 * Parse JSON with multiple fallback strategies
 *
 * Strategies (applied in order):
 * 1. Direct parse (valid JSON)
 * 2. Extract from markdown code blocks
 * 3. Extract JSON between first { and last }
 * 4. Repair common syntax errors and retry
 * 5. Extract partial valid JSON
 */
export function parseJSON(text: string): any {
  // Strategy 1: Direct parse (valid JSON)
  try {
    return JSON.parse(text);
  } catch {}

  // Strategy 2: Extract from markdown code blocks
  const markdownMatch = text.match(/```(?:json)?\s*\n([\s\S]*?)\n```/);
  if (markdownMatch) {
    try {
      return JSON.parse(markdownMatch[1]);
    } catch {}
  }

  // Strategy 3: Extract between first { and last }
  const firstBrace = text.indexOf('{');
  const lastBrace = text.lastIndexOf('}');
  if (firstBrace !== -1 && lastBrace !== -1 && lastBrace > firstBrace) {
    const extracted = text.slice(firstBrace, lastBrace + 1);
    try {
      return JSON.parse(extracted);
    } catch {}

    // Strategy 4: Try repairing extracted JSON
    const repaired = repairJSON(extracted);
    try {
      return JSON.parse(repaired);
    } catch {}
  }

  // Strategy 5: Try repairing full text
  const repaired = repairJSON(text);
  try {
    return JSON.parse(repaired);
  } catch (error) {
    throw new Error(
      `Failed to parse JSON after all strategies.\n` +
      `Original text: ${text.slice(0, 200)}...\n` +
      `Error: ${(error as Error).message}`
    );
  }
}

/**
 * Repair common JSON syntax errors
 */
function repairJSON(text: string): string {
  let repaired = text;

  // Fix trailing commas before } or ]
  repaired = repaired.replace(/,(\s*[}\]])/g, '$1');

  // Fix single quotes to double quotes (be careful with apostrophes in content)
  repaired = repaired.replace(/'/g, '"');

  // Fix Python-style booleans
  repaired = repaired.replace(/\bTrue\b/g, 'true');
  repaired = repaired.replace(/\bFalse\b/g, 'false');
  repaired = repaired.replace(/\bNone\b/g, 'null');

  // Remove single-line comments
  repaired = repaired.replace(/\/\/.*$/gm, '');

  // Remove multi-line comments
  repaired = repaired.replace(/\/\*[\s\S]*?\*\//g, '');

  // Fix unquoted keys (simple cases: alphanumeric + underscore)
  repaired = repaired.replace(/(\{|,)\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*:/g, '$1"$2":');

  return repaired;
}

/**
 * Parse JSON with retry - if parsing fails, ask LLM to fix it
 *
 * @param text - LLM response text
 * @param schema - Zod schema for validation
 * @param retryFn - Function to call LLM again with error feedback
 * @param maxRetries - Maximum number of retry attempts
 */
export async function parseJSONWithRetry<T>(
  text: string,
  schema: z.ZodSchema<T>,
  retryFn: (errorFeedback: string) => Promise<string>,
  maxRetries: number = 2
): Promise<T> {
  let currentText = text;
  let lastError: Error | null = null;

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      const parsed = parseJSON(currentText);
      return schema.parse(parsed);
    } catch (error) {
      lastError = error as Error;

      if (attempt < maxRetries) {
        const errorMessage = error instanceof z.ZodError
          ? `Schema validation failed: ${error.errors.map(e => `${e.path.join('.')}: ${e.message}`).join(', ')}`
          : `JSON parse failed: ${(error as Error).message}`;

        // Ask LLM to fix the error
        currentText = await retryFn(
          `Previous response was invalid.\n\n` +
          `Error: ${errorMessage}\n\n` +
          `Please return ONLY valid JSON matching the requested format. ` +
          `No markdown, no explanation, just the JSON object.`
        );
      }
    }
  }

  throw new Error(`Failed after ${maxRetries} retries: ${lastError?.message}`);
}

/**
 * Extract array from JSON even if wrapping object is malformed
 *
 * Useful when LLM returns: {"items": [...]} but items array is valid
 */
export function extractArray(text: string, arrayKey: string = 'items'): any[] {
  try {
    const parsed = parseJSON(text);
    if (Array.isArray(parsed)) return parsed;
    if (parsed[arrayKey] && Array.isArray(parsed[arrayKey])) {
      return parsed[arrayKey];
    }
    return [];
  } catch {
    // Try to find array directly in text
    const arrayMatch = text.match(/\[[\s\S]*\]/);
    if (arrayMatch) {
      try {
        return JSON.parse(arrayMatch[0]);
      } catch {}
    }
    return [];
  }
}
