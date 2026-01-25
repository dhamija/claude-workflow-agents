// Anthropic (Claude) provider implementation
import Anthropic from '@anthropic-ai/sdk';
import { LLMProvider, LLMOptions } from '../base-provider';
import { parseJSON } from '../json-parser';
import { z } from 'zod';

export class AnthropicProvider implements LLMProvider {
  name = 'Anthropic';
  private client: Anthropic | null = null;
  private model: string;

  constructor(config: { apiKey?: string; model?: string }) {
    if (config.apiKey) {
      this.client = new Anthropic({ apiKey: config.apiKey });
    }
    this.model = config.model || 'claude-3-5-sonnet-20241022';
  }

  async isAvailable(): Promise<boolean> {
    return this.client !== null;
  }

  async complete(prompt: string, options?: LLMOptions): Promise<string> {
    if (!this.client) {
      throw new Error('Anthropic not configured (missing API key)');
    }

    const response = await this.client.messages.create({
      model: this.model,
      max_tokens: options?.maxTokens ?? 2000,
      temperature: options?.temperature ?? 0.7,
      system: options?.systemPrompt,
      messages: [{ role: 'user', content: prompt }],
      stop_sequences: options?.stopSequences,
    });

    const content = response.content[0];
    return content.type === 'text' ? content.text : '';
  }

  async completeJSON<T>(
    prompt: string,
    schema: z.ZodSchema<T>,
    options?: LLMOptions
  ): Promise<T> {
    if (!this.client) {
      throw new Error('Anthropic not configured (missing API key)');
    }

    // Claude doesn't have native JSON mode, but prefilling with { helps
    // Add JSON instructions to system prompt
    const jsonSystemPrompt = options?.systemPrompt
      ? `${options.systemPrompt}\n\nYou must return valid JSON only. No markdown, no explanation.`
      : 'You must return valid JSON only. No markdown, no explanation.';

    const response = await this.client.messages.create({
      model: this.model,
      max_tokens: options?.maxTokens ?? 2000,
      temperature: options?.temperature ?? 0.3,
      system: jsonSystemPrompt,
      messages: [
        { role: 'user', content: prompt },
        { role: 'assistant', content: '{' }, // Prefill to encourage JSON
      ],
    });

    const content = response.content[0];
    const text = content.type === 'text' ? content.text : '{}';

    // Restore prefilled brace
    const fullJSON = '{' + text;

    // Use robust JSON parser (in case Claude still wraps in markdown)
    const parsed = parseJSON(fullJSON);
    return schema.parse(parsed);
  }
}
