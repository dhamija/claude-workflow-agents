// LLM configuration loading from environment variables

export interface LLMConfig {
  ollama: {
    baseURL: string;
    model: string;
  };
  openai: {
    apiKey?: string;
    model: string;
  };
  anthropic: {
    apiKey?: string;
    model: string;
  };
}

export function loadLLMConfig(): LLMConfig {
  return {
    ollama: {
      baseURL: process.env.OLLAMA_BASE_URL || 'http://localhost:11434',
      model: process.env.OLLAMA_MODEL || 'llama3.2',
    },
    openai: {
      apiKey: process.env.OPENAI_API_KEY,
      model: process.env.OPENAI_MODEL || 'gpt-4o-mini',
    },
    anthropic: {
      apiKey: process.env.ANTHROPIC_API_KEY,
      model: process.env.ANTHROPIC_MODEL || 'claude-3-5-sonnet-20241022',
    },
  };
}
