---
name: llm
description: Manage LLM providers and test AI integrations
---

# /llm Command

Manage LLM providers (Ollama, OpenAI, Anthropic) and test AI component integrations.

## Usage

```bash
/llm                      # Show current provider status
/llm setup               # Set up LLM providers
/llm test                # Test LLM connections
/llm providers           # List available providers
/llm config              # Show current configuration
```

---

## Modes

### `/llm` (default - show status)

Shows current LLM provider configuration and availability.

**Output:**
```
LLM Provider Status
───────────────────

✓ Ollama (http://localhost:11434)
  Model: llama3.2
  Status: Available
  Cost: Free

⚠ OpenAI
  Status: Not configured (missing API key)
  Set: OPENAI_API_KEY in .env

⚠ Anthropic
  Status: Not configured (missing API key)
  Set: ANTHROPIC_API_KEY in .env

Fallback Chain: Ollama → (no fallback configured)

Recommendation: Add OpenAI or Anthropic API key for production reliability
```

---

### `/llm setup`

Interactive setup wizard for LLM providers.

**Flow:**
```
Claude: I'll help you set up LLM providers.

        Current setup:
        ✓ Ollama (available)
        ✗ OpenAI (not configured)
        ✗ Anthropic (not configured)

        Would you like to:
        1. Keep Ollama only (free, local, good for dev)
        2. Add OpenAI fallback (recommended for production)
        3. Add Anthropic fallback (recommended for production)
        4. Configure both OpenAI + Anthropic

User: 2

Claude: Great! To add OpenAI:

        1. Get API key from https://platform.openai.com/api-keys
        2. Add to .env:
           OPENAI_API_KEY=sk-...
           OPENAI_MODEL=gpt-4o-mini  # Or gpt-4o for better quality

        Do you have an API key ready? (paste it or say "later")

User: sk-proj-abc123...

Claude: ✓ API key saved to .env
        ✓ Testing connection...
        ✓ OpenAI working! (model: gpt-4o-mini)

        Your fallback chain is now:
        1. Ollama (local, free)
        2. OpenAI (fallback, ~$0.15/1M tokens)

        Setup complete! Your AI features will:
        - Use Ollama by default (free, fast)
        - Fall back to OpenAI if Ollama unavailable
```

**Actions:**
- Checks current provider status
- Guides user through API key setup
- Adds environment variables to `.env`
- Tests each provider after configuration
- Shows estimated costs

---

### `/llm test`

Tests all configured LLM providers with a simple prompt.

**Flow:**
```
Claude: Testing LLM providers...

        Testing Ollama (http://localhost:11434)...
        Prompt: "Say 'hello' and nothing else"
        ✓ Response: "Hello"
        ✓ Latency: 342ms
        ✓ Working

        Testing OpenAI (gpt-4o-mini)...
        Prompt: "Say 'hello' and nothing else"
        ✓ Response: "Hello"
        ✓ Latency: 1,234ms
        ✓ Working

        Testing Anthropic...
        ✗ Not configured (missing API key)

        Summary:
        ✓ 2/3 providers working
        ✓ Fallback chain functional
```

**With JSON mode test:**
```bash
/llm test --json

Claude: Testing structured JSON output...

        Ollama (llama3.2):
        Prompt: "Return JSON: {\"greeting\": \"hello\", \"count\": 42}"
        ✓ Valid JSON returned
        ✓ Schema validation passed
        ⚠ Needed JSON repair (trailing comma removed)

        OpenAI (gpt-4o-mini):
        Prompt: "Return JSON: {\"greeting\": \"hello\", \"count\": 42}"
        ✓ Valid JSON returned
        ✓ Schema validation passed
        ✓ Native JSON mode working

        Summary:
        ✓ All providers can return valid JSON
        ⚠ Ollama requires robust parser (expected)
```

**Actions:**
- Sends test prompt to each provider
- Measures latency
- Tests JSON mode (if `--json` flag)
- Reports success/failure
- Validates fallback chain

---

### `/llm providers`

Lists all available providers with details.

**Output:**
```
Available LLM Providers
───────────────────────

Ollama (Local)
  Base URL: http://localhost:11434
  Model: llama3.2
  Status: ✓ Available
  Cost: Free
  Latency: 0.5-1s
  Best for: Development, fast iteration, privacy
  JSON Mode: ✓ Supported (format: "json")
  Setup: brew install ollama && ollama pull llama3.2

OpenAI (Commercial)
  Model: gpt-4o-mini
  Status: ✓ Configured
  Cost: $0.15/1M input tokens, $0.60/1M output tokens
  Latency: 1-3s
  Best for: Production reliability, complex reasoning
  JSON Mode: ✓ Native (response_format)
  Setup: Get API key from https://platform.openai.com/api-keys

Anthropic (Commercial)
  Model: claude-3-5-sonnet-20241022
  Status: ✗ Not configured
  Cost: $3/1M input tokens, $15/1M output tokens
  Latency: 2-5s
  Best for: Complex reasoning, long context
  JSON Mode: ⚠ Prefill strategy
  Setup: Get API key from https://console.anthropic.com/

Fallback Chain: Ollama → OpenAI

Recommendation:
✓ You have a working fallback chain
✓ Development will use free Ollama
✓ Production will fall back to OpenAI if needed
```

---

### `/llm config`

Shows current LLM configuration from environment variables.

**Output:**
```
LLM Configuration
─────────────────

Environment Variables (.env):

Ollama:
  OLLAMA_BASE_URL=http://localhost:11434
  OLLAMA_MODEL=llama3.2

OpenAI:
  OPENAI_API_KEY=sk-proj-***xyz (set)
  OPENAI_MODEL=gpt-4o-mini

Anthropic:
  ANTHROPIC_API_KEY=(not set)
  ANTHROPIC_MODEL=claude-3-5-sonnet-20241022 (default)

Code Location:
  LLM client: /src/lib/llm/client.ts
  Providers: /src/lib/llm/providers/
  Config: /src/lib/llm/config.ts
  JSON parser: /src/lib/llm/json-parser.ts

To change configuration:
  Edit .env file
  Restart development server
```

---

## Common Scenarios

### Scenario 1: First-time setup (development only)

```bash
# Just use Ollama (free, local)
/llm

Claude: Ollama available ✓
        No commercial APIs configured (that's fine for dev)
        Run /llm setup to add fallback for production
```

**User doesn't need to do anything** - Ollama works out of the box for development.

---

### Scenario 2: Add production reliability

```bash
/llm setup

Claude: Would you like to add a commercial API fallback?
        Recommended: OpenAI (cheaper) or Anthropic (better reasoning)

User: Add OpenAI

Claude: [Guides through API key setup]
        ✓ Setup complete!
        Fallback chain: Ollama → OpenAI
```

---

### Scenario 3: Ollama not working

```bash
/llm test

Claude: ✗ Ollama not available
        ✓ OpenAI working (using as primary)

        To fix Ollama:
        1. Install: brew install ollama
        2. Start: ollama serve
        3. Pull model: ollama pull llama3.2
```

---

### Scenario 4: Check if setup is production-ready

```bash
/llm

Claude: ✓ Ollama (local, free)
        ✓ OpenAI (fallback, configured)

        Production readiness: ✓ READY
        - Development will use Ollama (free)
        - Production will use OpenAI (reliable)
        - Automatic failover configured
```

---

## Integration with Workflow

### Auto-triggered during `/plan`

When implementation-planner creates plans with AI features:

```
implementation-planner: Feature "Auto-tagging" requires LLM.

                        Checking LLM setup...
                        ✓ Ollama available
                        ⚠ No fallback configured

                        Recommendation: Run /llm setup to add production fallback
```

---

### Referenced in backend-plan.md

```markdown
## AI Components

### Auto-Tagging Service

**LLM Integration:**
- Provider: Dual (Ollama + OpenAI fallback)
- Model: llama3.2 (dev), gpt-4o-mini (prod)
- JSON Schema: `{ tags: string[], confidence: number }`
- Fallback: Keyword extraction if LLM fails

**Implementation:**
- Use `LLMClient` from `/src/lib/llm/client`
- Define Zod schema for validation
- Implement graceful degradation

**Setup:**
Run `/llm setup` to configure providers before implementing.
```

---

## Environment Variables Reference

### Required for Ollama
```bash
OLLAMA_BASE_URL=http://localhost:11434  # Default
OLLAMA_MODEL=llama3.2                    # Or llama3.1, mistral, etc.
```

### Optional for OpenAI
```bash
OPENAI_API_KEY=sk-proj-...               # From platform.openai.com
OPENAI_MODEL=gpt-4o-mini                 # Or gpt-4o
```

### Optional for Anthropic
```bash
ANTHROPIC_API_KEY=sk-ant-...             # From console.anthropic.com
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
```

---

## Cost Estimates

### Development (Ollama only)
```
Cost per 1M tokens: $0 (free)
Typical tag generation: ~200 tokens = $0
1000 tag generations per day: $0/day
```

### Production (OpenAI fallback)
```
Cost per 1M tokens: $0.15 input + $0.60 output = ~$0.75 average
Typical tag generation: ~200 tokens = $0.00015
1000 tag generations per day: $0.15/day = $4.50/month
```

### Production (Anthropic fallback)
```
Cost per 1M tokens: $3 input + $15 output = ~$9 average
Typical tag generation: ~200 tokens = $0.0018
1000 tag generations per day: $1.80/day = $54/month
```

**Recommendation:** Use Ollama for 95% of dev work, OpenAI for production.

---

## Troubleshooting

### "Ollama not available"

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not installed
brew install ollama

# Start Ollama
ollama serve

# Pull model
ollama pull llama3.2

# Test again
/llm test
```

---

### "OpenAI authentication failed"

```bash
# Check API key
echo $OPENAI_API_KEY

# Verify it's in .env
grep OPENAI_API_KEY .env

# Test directly
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# If expired, get new key from platform.openai.com
/llm setup
```

---

### "All providers failed"

```bash
/llm test

Claude: ✗ Ollama: Connection refused
        ✗ OpenAI: Invalid API key
        ✗ Anthropic: Not configured

        Your app will use rule-based fallbacks for all AI features.
        To fix:
        1. Start Ollama: ollama serve
        2. Fix OpenAI key: /llm setup
```

The LLM client automatically falls back to rule-based logic, so the app never crashes.

---

## Best Practices

### Development Workflow

1. **Start with Ollama** - Free, fast, private
   ```bash
   ollama serve
   /llm test
   ```

2. **Add one commercial fallback** - Production reliability
   ```bash
   /llm setup
   # Add OpenAI (cheaper) or Anthropic (better)
   ```

3. **Test both providers** - Ensure fallback works
   ```bash
   /llm test --json
   ```

4. **Deploy with confidence** - Auto-failover configured
   - Dev: Uses Ollama (free)
   - Prod: Uses commercial APIs (reliable)
   - Failures: Graceful rule-based fallback

---

### Production Deployment

**Environment variables to set:**
```bash
# Always set (even if using Ollama in prod)
OPENAI_API_KEY=sk-proj-...
OPENAI_MODEL=gpt-4o-mini

# Optional (for better reasoning)
ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
```

**Cost optimization:**
- Use Ollama for background jobs (not time-sensitive)
- Use OpenAI for user-facing features (fast, reliable)
- Use Anthropic for complex reasoning (when quality matters)

---

## See Also

- `/agent-wf-help llm` - LLM integration help topic
- `BACKEND.md` - Backend LLM integration patterns
- `/docs/architecture/llm-integration.md` - Complete guide
- `/src/lib/llm/README.md` - Code documentation
