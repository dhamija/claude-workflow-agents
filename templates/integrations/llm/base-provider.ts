// Base provider interface for LLM providers
import { z } from 'zod';

export interface LLMProvider {
  name: string;
  isAvailable(): Promise<boolean>;
  complete(prompt: string, options?: LLMOptions): Promise<string>;
  completeJSON<T>(prompt: string, schema: z.ZodSchema<T>, options?: LLMOptions): Promise<T>;
}

export interface LLMOptions {
  systemPrompt?: string;
  temperature?: number;
  maxTokens?: number;
  stopSequences?: string[];
}
