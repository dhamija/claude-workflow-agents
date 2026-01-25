// Ollama provider implementation
import { LLMProvider, LLMOptions } from '../base-provider';
import { parseJSON } from '../json-parser';
import { z } from 'zod';

export class OllamaProvider implements LLMProvider {
  name = 'Ollama';
  private baseURL: string;
  private model: string;

  constructor(config: { baseURL?: string; model?: string }) {
    this.baseURL = config.baseURL || 'http://localhost:11434';
    this.model = config.model || 'llama3.2';
  }

  async isAvailable(): Promise<boolean> {
    try {
      const response = await fetch(`${this.baseURL}/api/tags`, {
        signal: AbortSignal.timeout(2000), // 2 second timeout
      });
      return response.ok;
    } catch {
      return false;
    }
  }

  async complete(prompt: string, options?: LLMOptions): Promise<string> {
    const response = await fetch(`${this.baseURL}/api/generate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: this.model,
        prompt: this.buildPrompt(prompt, options?.systemPrompt),
        stream: false,
        options: {
          temperature: options?.temperature ?? 0.7,
          num_predict: options?.maxTokens ?? 2000,
          stop: options?.stopSequences,
        },
      }),
    });

    if (!response.ok) {
      throw new Error(`Ollama API error: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();
    return data.response;
  }

  async completeJSON<T>(
    prompt: string,
    schema: z.ZodSchema<T>,
    options?: LLMOptions
  ): Promise<T> {
    // Add JSON instructions to prompt
    const jsonPrompt =
      `${prompt}\n\n` +
      `IMPORTANT: Return ONLY valid JSON matching the requested format. ` +
      `No markdown code blocks, no explanation, no preamble - just the JSON object.`;

    const response = await fetch(`${this.baseURL}/api/generate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: this.model,
        prompt: this.buildPrompt(jsonPrompt, options?.systemPrompt),
        format: 'json', // Ollama's JSON mode
        stream: false,
        options: {
          temperature: options?.temperature ?? 0.3, // Lower temp for structured output
          num_predict: options?.maxTokens ?? 2000,
          stop: options?.stopSequences,
        },
      }),
    });

    if (!response.ok) {
      throw new Error(`Ollama API error: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();

    // Use robust JSON parser (Ollama can still return malformed JSON)
    const parsed = parseJSON(data.response);
    return schema.parse(parsed);
  }

  private buildPrompt(userPrompt: string, systemPrompt?: string): string {
    if (!systemPrompt) return userPrompt;
    return `${systemPrompt}\n\n${userPrompt}`;
  }
}
