#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: LLM Integration Templates and Documentation"

# Define paths
TEMPLATES_DIR="$PROJECT_ROOT/templates"
LLM_LIB_DIR="$TEMPLATES_DIR/src/lib/llm"
LLM_PROVIDERS_DIR="$LLM_LIB_DIR/providers"
LLM_GUIDE="$TEMPLATES_DIR/docs/architecture/llm-integration.md.template"

# Check LLM integration guide exists
assert_file_exists "$LLM_GUIDE"

# Check required sections in guide
assert_file_contains "$LLM_GUIDE" "## Overview"
assert_file_contains "$LLM_GUIDE" "## Architecture Pattern"
assert_file_contains "$LLM_GUIDE" "## Provider Abstraction"
assert_file_contains "$LLM_GUIDE" "## Robust JSON Parsing"
assert_file_contains "$LLM_GUIDE" "## Configuration"
assert_file_contains "$LLM_GUIDE" "## Testing Strategy"

# Check all LLM library template files exist
assert_file_exists "$LLM_LIB_DIR/base-provider.ts"
assert_file_exists "$LLM_LIB_DIR/client.ts"
assert_file_exists "$LLM_LIB_DIR/config.ts"
assert_file_exists "$LLM_LIB_DIR/json-parser.ts"
assert_file_exists "$LLM_LIB_DIR/retry.ts"
assert_file_exists "$LLM_LIB_DIR/README.md"
assert_file_exists "$LLM_LIB_DIR/examples.ts"

# Check all provider implementations exist
assert_file_exists "$LLM_PROVIDERS_DIR/ollama.ts"
assert_file_exists "$LLM_PROVIDERS_DIR/openai.ts"
assert_file_exists "$LLM_PROVIDERS_DIR/anthropic.ts"

# Check provider implementations have required methods
assert_file_contains "$LLM_PROVIDERS_DIR/ollama.ts" "class OllamaProvider"
assert_file_contains "$LLM_PROVIDERS_DIR/ollama.ts" "isAvailable"
assert_file_contains "$LLM_PROVIDERS_DIR/ollama.ts" "complete"
assert_file_contains "$LLM_PROVIDERS_DIR/ollama.ts" "completeJSON"

assert_file_contains "$LLM_PROVIDERS_DIR/openai.ts" "class OpenAIProvider"
assert_file_contains "$LLM_PROVIDERS_DIR/openai.ts" "isAvailable"
assert_file_contains "$LLM_PROVIDERS_DIR/openai.ts" "complete"
assert_file_contains "$LLM_PROVIDERS_DIR/openai.ts" "completeJSON"

assert_file_contains "$LLM_PROVIDERS_DIR/anthropic.ts" "class AnthropicProvider"
assert_file_contains "$LLM_PROVIDERS_DIR/anthropic.ts" "isAvailable"
assert_file_contains "$LLM_PROVIDERS_DIR/anthropic.ts" "complete"
assert_file_contains "$LLM_PROVIDERS_DIR/anthropic.ts" "completeJSON"

# Check JSON parser has robust parsing strategies
assert_file_contains "$LLM_LIB_DIR/json-parser.ts" "parseJSON"
assert_file_contains "$LLM_LIB_DIR/json-parser.ts" "parseJSONWithRetry"
assert_file_contains "$LLM_LIB_DIR/json-parser.ts" "repairJSON"

# Check client has fallback logic
assert_file_contains "$LLM_LIB_DIR/client.ts" "class LLMClient"
assert_file_contains "$LLM_LIB_DIR/client.ts" "OllamaProvider"
assert_file_contains "$LLM_LIB_DIR/client.ts" "OpenAIProvider"
assert_file_contains "$LLM_LIB_DIR/client.ts" "AnthropicProvider"

# Check configuration loading
assert_file_contains "$LLM_LIB_DIR/config.ts" "loadLLMConfig"
assert_file_contains "$LLM_LIB_DIR/config.ts" "OLLAMA_BASE_URL"
assert_file_contains "$LLM_LIB_DIR/config.ts" "OPENAI_API_KEY"
assert_file_contains "$LLM_LIB_DIR/config.ts" "ANTHROPIC_API_KEY"

# Check /llm command exists
assert_file_exists "$PROJECT_ROOT/commands/llm.md"
assert_file_contains "$PROJECT_ROOT/commands/llm.md" "/llm setup"
assert_file_contains "$PROJECT_ROOT/commands/llm.md" "/llm test"
assert_file_contains "$PROJECT_ROOT/commands/llm.md" "/llm providers"

# Check BACKEND.md exists and has LLM patterns
assert_file_exists "$PROJECT_ROOT/BACKEND.md"
assert_file_contains "$PROJECT_ROOT/BACKEND.md" "LLM Integration Patterns"
assert_file_contains "$PROJECT_ROOT/BACKEND.md" "Dual Provider Architecture"
assert_file_contains "$PROJECT_ROOT/BACKEND.md" "Robust JSON Parsing"
assert_file_contains "$PROJECT_ROOT/BACKEND.md" "Schema Validation with Zod"
assert_file_contains "$PROJECT_ROOT/BACKEND.md" "Graceful Degradation"

# Check agents updated for LLM
assert_file_contains "$PROJECT_ROOT/agents/agentic-architect.md" "LLM Integration Pattern"
assert_file_contains "$PROJECT_ROOT/agents/agentic-architect.md" "Dual Provider Strategy"
assert_file_contains "$PROJECT_ROOT/agents/backend-engineer.md" "LLM/AI Components"
assert_file_contains "$PROJECT_ROOT/agents/backend-engineer.md" "LLMClient"

# Check help system includes LLM topic
assert_file_contains "$PROJECT_ROOT/commands/agent-wf-help.md" "/agent-wf-help llm"
assert_file_contains "$PROJECT_ROOT/commands/agent-wf-help.md" "LLM INTEGRATION & AI COMPONENTS"

summary
