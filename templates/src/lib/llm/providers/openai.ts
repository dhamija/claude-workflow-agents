// OpenAI provider implementation
import OpenAI from 'openai';
import { LLMProvider, LLMOptions } from '../base-provider';
import { z } from 'zod';

export class OpenAIProvider implements LLMProvider {
  name = 'OpenAI';
  private client: OpenAI | null = null;
  private model: string;

  constructor(config: { apiKey?: string; model?: string }) {
    if (config.apiKey) {
      this.client = new OpenAI({ apiKey: config.apiKey });
    }
    this.model = config.model || 'gpt-4o-mini';
  }

  async isAvailable(): Promise<boolean> {
    return this.client !== null;
  }

  async complete(prompt: string, options?: LLMOptions): Promise<string> {
    if (!this.client) {
      throw new Error('OpenAI not configured (missing API key)');
    }

    const messages: OpenAI.ChatCompletionMessageParam[] = [];

    if (options?.systemPrompt) {
      messages.push({ role: 'system', content: options.systemPrompt });
    }

    messages.push({ role: 'user', content: prompt });

    const response = await this.client.chat.completions.create({
      model: this.model,
      messages,
      temperature: options?.temperature ?? 0.7,
      max_tokens: options?.maxTokens ?? 2000,
      stop: options?.stopSequences,
    });

    return response.choices[0]?.message?.content || '';
  }

  async completeJSON<T>(
    prompt: string,
    schema: z.ZodSchema<T>,
    options?: LLMOptions
  ): Promise<T> {
    if (!this.client) {
      throw new Error('OpenAI not configured (missing API key)');
    }

    const messages: OpenAI.ChatCompletionMessageParam[] = [];

    if (options?.systemPrompt) {
      messages.push({ role: 'system', content: options.systemPrompt });
    }

    messages.push({ role: 'user', content: prompt });

    const response = await this.client.chat.completions.create({
      model: this.model,
      messages,
      temperature: options?.temperature ?? 0.3,
      max_tokens: options?.maxTokens ?? 2000,
      response_format: { type: 'json_object' }, // OpenAI's native JSON mode
    });

    const content = response.choices[0]?.message?.content || '{}';

    // OpenAI's JSON mode should always return valid JSON
    const parsed = JSON.parse(content);
    return schema.parse(parsed);
  }
}
