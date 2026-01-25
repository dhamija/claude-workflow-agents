// Unified LLM client with automatic fallback between providers
import { LLMProvider, LLMOptions } from './base-provider';
import { OllamaProvider } from './providers/ollama';
import { OpenAIProvider } from './providers/openai';
import { AnthropicProvider } from './providers/anthropic';
import { loadLLMConfig, LLMConfig } from './config';
import { z } from 'zod';

export class LLMClient {
  private providers: LLMProvider[];

  constructor(config?: LLMConfig) {
    const llmConfig = config || loadLLMConfig();

    this.providers = [
      new OllamaProvider(llmConfig.ollama),
      new OpenAIProvider(llmConfig.openai),
      new AnthropicProvider(llmConfig.anthropic),
    ];
  }

  /**
   * Complete a text prompt using the first available provider
   * Falls back to next provider if current one fails
   */
  async complete(prompt: string, options?: LLMOptions): Promise<string> {
    const errors: Error[] = [];

    for (const provider of this.providers) {
      try {
        const isAvailable = await provider.isAvailable();
        if (!isAvailable) {
          errors.push(new Error(`${provider.name}: Not available`));
          continue;
        }

        return await provider.complete(prompt, options);
      } catch (error) {
        errors.push(new Error(`${provider.name}: ${(error as Error).message}`));
        continue; // Try next provider
      }
    }

    throw new Error(
      `All LLM providers failed:\n${errors.map(e => `  - ${e.message}`).join('\n')}`
    );
  }

  /**
   * Complete a JSON prompt with schema validation
   * Falls back to next provider if current one fails
   */
  async completeJSON<T>(
    prompt: string,
    schema: z.ZodSchema<T>,
    options?: LLMOptions
  ): Promise<T> {
    const errors: Error[] = [];

    for (const provider of this.providers) {
      try {
        const isAvailable = await provider.isAvailable();
        if (!isAvailable) {
          errors.push(new Error(`${provider.name}: Not available`));
          continue;
        }

        return await provider.completeJSON(prompt, schema, options);
      } catch (error) {
        errors.push(new Error(`${provider.name}: ${(error as Error).message}`));
        continue;
      }
    }

    throw new Error(
      `All LLM providers failed:\n${errors.map(e => `  - ${e.message}`).join('\n')}`
    );
  }

  /**
   * Get list of available providers
   */
  async getAvailableProviders(): Promise<string[]> {
    const available: string[] = [];

    for (const provider of this.providers) {
      if (await provider.isAvailable()) {
        available.push(provider.name);
      }
    }

    return available;
  }
}
